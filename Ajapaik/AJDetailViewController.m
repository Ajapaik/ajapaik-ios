//
//  AJDetailViewController.m
//  Ajapaik
//
//  Created by Taavi Hein on 06.10.12.
//
//

#import "AJDetailViewController.h"
#import "AJCameraOverlayViewController.h"

@interface AJDetailViewController ()

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

- (IBAction)takeThePhoto:(id)sender {
  
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
	picker.showsCameraControls = YES;
	picker.wantsFullScreenLayout = YES;
	picker.allowsEditing = NO;
	picker.cameraOverlayView = self.cameraOverlayViewController.view;
	
//	[self.cameraOverlayViewController loadPhotoWithID:[(AJPhotoAnnotation *)view.annotation ID]];
	
  //	[self presentModalViewController:picker animated:YES];
	
//	self.locationManager = [[CLLocationManager alloc] init];
//	[self.locationManager startUpdatingLocation];
//	[self.locationManager startUpdatingHeading];
}

- (void)reloadImages {
  if (self.oldPhotoObject != nil) {
//    self.oldPhoto setImage:[[UIImage alloc] initwith]
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
