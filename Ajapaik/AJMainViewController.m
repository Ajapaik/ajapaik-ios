//
//  AJMainViewController.m
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import "AJMainViewController.h"
#import "AJCameraOverlayViewController.h"
#import "AJPhoto.h"

@interface AJMainViewController ()

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) AJPhoto *photo;

-(void) mapButtonClicked;
-(void) loadImages;
-(void) photosArrived:(NSArray *) photos;
@end

@implementation AJMainViewController
@synthesize tableViewController = _tableViewController;
@synthesize mapViewController = _mapViewController;

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
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"List", @"List")style: UIBarButtonItemStyleBordered target:self action:@selector(mapButtonClicked)];
    self.navigationItem.rightBarButtonItem = mapButton;
	
	UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ajapaik_logo"]];
	UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, logoView.frame.size.width + 180.0f, logoView.frame.size.height)];
	[titleView addSubview:logoView];
	
	self.navigationItem.titleView = titleView;
    [self loadImages];
    
	self.mapViewController.view.frame = self.view.bounds;
    [self.view insertSubview:_mapViewController.view atIndex:0];
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)mapButtonClicked
{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (self.tableViewController.view.superview == nil) {
        if (self.tableViewController == nil) {
            self.tableViewController = [[AJTableViewController alloc] initWithNibName:@"AJTableViewController" bundle:nil];
            self.tableViewController.delegate = self;
        }
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        [_tableViewController viewWillAppear:YES];
        [_mapViewController viewWillDisappear:YES];
        [_mapViewController.view removeFromSuperview];
        [_tableViewController setPhotos:_oldPhotos];
        [self.view insertSubview:_tableViewController.view atIndex:0];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Map", @"Map");
		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:nil];

        [_mapViewController viewDidDisappear:YES];
        [_tableViewController viewDidAppear:YES];
    }
    else {
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft
                               forView:self.view cache:YES];
        [_mapViewController viewWillAppear:YES];
        [_tableViewController viewWillDisappear:YES];
        [_tableViewController.view removeFromSuperview];
        [_mapViewController setPhotos:_oldPhotos];
        [self.view insertSubview:_mapViewController.view atIndex:0];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"List", @"list");
		self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:nil];

        [_tableViewController viewDidDisappear:YES];
        [_mapViewController viewDidAppear:YES];
    }
    [UIView commitAnimations];
}


-(void) loadImages
{
    NSURL *mapURL = [NSURL URLWithString:@"http://api.ajapaik.ee/?action=photo&city_id=2"];
	NSURLRequest *request = [NSURLRequest requestWithURL:mapURL];
    [NSURLConnection sendAsynchronousRequest:request
									   queue:[[NSOperationQueue alloc] init]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (data) {
                                   NSError *e = nil;
                                   NSString *dataString = [[NSString alloc] initWithData:data
                                                                             encoding:NSUTF8StringEncoding];
                                   data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                                   NSDictionary *jsonDictionary = [NSJSONSerialization  JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &e];
                                   NSMutableArray* photos = [[NSMutableArray alloc] init];
                                   if (!jsonDictionary) {
                                       NSLog(@"Error parsing JSON: %@", e);
                                   } else {
                                       NSArray* oldPhotos = [jsonDictionary objectForKey:@"result"];
                                       if (oldPhotos) {
                                           for (NSDictionary* photoData in oldPhotos) {
                                               [photos addObject:[[AJPhoto alloc] initWithNSDictionary:photoData]];
                                           }
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [self photosArrived:photos];
                                       });
                                   }
                               }
                           }];

}

-(void) photosArrived:(NSArray*) photos
{
    _oldPhotos = photos;
    if (self.tableViewController.view.superview != nil) {
        if (self.tableViewController == nil) {
            self.tableViewController = [[AJTableViewController alloc] initWithNibName:@"AJTableViewController" bundle:nil];
            self.tableViewController.delegate = self;
        }
        [_tableViewController setPhotos: photos];
    }
    else {
        [self.mapViewController setPhotos:photos];
    }
}


#pragma mark - AJMainSubViewDelegate

- (void)photoChoosen:(AJPhoto *)photo {
  //TODO: Here should be started photo view
  if (self.detailViewController == nil) {
    self.detailViewController = [[AJDetailViewController alloc] initWithNibName:@"AJDetailViewController" bundle:nil];
    self.detailViewController.delegate = self;
  }
  [self.detailViewController setOldPhotoObject:photo];
  [self.detailViewController reloadImages];
  [self.navigationController pushViewController:self.detailViewController animated:YES];
}

-(void)photoChoosen2:(AJPhoto *)photo
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
	picker.showsCameraControls = YES;
	picker.wantsFullScreenLayout = YES;
	picker.allowsEditing = NO;
	picker.cameraOverlayView = self.cameraOverlayViewController.view;
	
	[self.cameraOverlayViewController loadPhotoWithID:[NSNumber numberWithInt:photo.ID]];
	
	self.locationManager = [[CLLocationManager alloc] init];
	[self.locationManager startUpdatingLocation];
	[self.locationManager startUpdatingHeading];
	
	self.photo = photo;
	
	[self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSString *filename = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
	
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	[UIImageJPEGRepresentation(image, 1.0) writeToFile:[path stringByAppendingPathExtension:@"jpg"] atomically:YES];
	
	CLLocation *location = self.locationManager.location;
	CLHeading *heading = self.locationManager.heading;
	
	NSString *text = [NSString stringWithFormat:@"ID: %d, lat: %.6f, lon: %.6f, heading: %.2f",
					  self.photo.ID,
					  location.coordinate.latitude,
					  location.coordinate.longitude,
					  heading.trueHeading];
	[text writeToFile:[path stringByAppendingPathExtension:@"txt"]
		   atomically:YES
			 encoding:NSUTF8StringEncoding
				error:nil];
	
	[self dismissModalViewControllerAnimated:YES];
}

@end
