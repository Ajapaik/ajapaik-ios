//
//  AJMapViewController.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import "AJMapViewController.h"
#import "AJPhotoAnnotation.h"
#import "AJCameraOverlayViewController.h"

#define MINIMUM_ZOOM_ARC 0.0142
#define ANNOTATION_REGION_PAD_FACTOR 1.11

@interface AJMapViewController ()

@property (nonatomic) BOOL userLocationCentered;

@end

@implementation AJMapViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	self.mapView.showsUserLocation = YES;
	
	NSURL *mapURL = [NSURL URLWithString:@"http://www.ajapaik.ee/kaart/?city=2"];
	NSURLRequest *request = [NSURLRequest requestWithURL:mapURL];
	[NSURLConnection sendAsynchronousRequest:request
                                     queue:[[NSOperationQueue alloc] init]
                         completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                           if (data) {
                             NSString *mapData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                             NSRange start = [mapData rangeOfString:@"[["];
                             NSRange end = [mapData rangeOfString:@"]]"];
                             NSString *photos = [mapData substringWithRange:NSMakeRange(start.location + 2, end.location - start.location - 2)];
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                               for (NSString *photo in [photos componentsSeparatedByString:@"], ["]) {
                                 NSLog(@"photo: %@", photo);
                                 [self.mapView addAnnotation:[[AJPhotoAnnotation alloc] initWithString:photo]];
                               }
                               [self zoomToFitMapAnnotations];
                             });
                           }
                         }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	if (!self.userLocationCentered) {
		[self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
		self.userLocationCentered = YES;
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
	picker.showsCameraControls = YES;
	picker.wantsFullScreenLayout = YES;
	picker.allowsEditing = NO;
	picker.cameraOverlayView = self.cameraOverlayViewController.view;
	
	[self.cameraOverlayViewController setImagePickerController:picker];
	[self.cameraOverlayViewController loadPhotoWithID:[(AJPhotoAnnotation *)view.annotation ID]];
	
	[self presentModalViewController:picker animated:YES];
    
    //TODO: put here this code to load photo view 
    //[self.delegate photoChoosen:[(AJPhotoAnnotation *) view.annotation photo]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if (annotation == mapView.userLocation) return nil;
	
	MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"photo"];
	if (!view) {
		view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"photo"];
		view.canShowCallout = YES;
		view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	} else {
		view.annotation = annotation;
	}
	return view;
}

-(void)zoomToFitMapAnnotations
{
    if([_mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(AJPhotoAnnotation* annotation in _mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * ANNOTATION_REGION_PAD_FACTOR; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * ANNOTATION_REGION_PAD_FACTOR; // Add a little extra space on the sides
    
    region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}


@end
