//
//  AJDetailViewController.m
//  Ajapaik
//
//  Created by Taavi Hein on 06.10.12.
//
//

#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AJDetailViewController.h"
#import "AJCameraOverlayViewController.h"

@interface AJDetailViewController ()

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation AJDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reloadImages];
}

- (IBAction)takeThePhoto:(id)sender {
  
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
	picker.showsCameraControls = YES;
	picker.wantsFullScreenLayout = YES;
	picker.allowsEditing = NO;
	picker.cameraOverlayView = self.cameraOverlayViewController.view;
	
//	[self.cameraOverlayViewController loadPhotoWithID:[NSNumber numberWithInt:self.oldPhotoObject.ID]];
  [self.cameraOverlayViewController loadPhoto:self.oldPhoto.image];
	
	self.locationManager = [[CLLocationManager alloc] init];
	[self.locationManager startUpdatingLocation];
	[self.locationManager startUpdatingHeading];

	[self presentModalViewController:picker animated:YES];
}

- (void)reloadImages {
  if (self.oldPhotoObject != nil) {
    [self.headline setText:self.oldPhotoObject.description];
    [self.oldPhoto setImageWithURL:self.oldPhotoObject.imageURL success:^(UIImage *image, BOOL cached) {
      self.oldPhoto.image = image;
    } failure:^(NSError *error) {
      //do nothing right now
    }];
  }
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
                    self.oldPhotoObject.ID,
                    location.coordinate.latitude,
                    location.coordinate.longitude,
                    heading.trueHeading];
	[text writeToFile:[path stringByAppendingPathExtension:@"txt"]
         atomically:YES
           encoding:NSUTF8StringEncoding
              error:nil];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
