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

@interface AJMapViewController ()

@property (nonatomic) BOOL userLocationCentered;

@end

@implementation AJMapViewController

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
	
	[self.cameraOverlayViewController loadPhotoWithID:[(AJPhotoAnnotation *)view.annotation ID]];
	
	[self presentModalViewController:picker animated:YES];
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


@end
