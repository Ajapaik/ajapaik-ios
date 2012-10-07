//
//  AJDetailViewController.m
//  Ajapaik
//
//  Created by Taavi Hein on 06.10.12.
//
//

#import <CoreLocation/CoreLocation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AJCameraViewController.h"
#import "AJDetailViewController.h"
#import "AJCameraOverlayViewController.h"

#define BOUNDARY @"ASDasofiauoiewruaidpfadskfhjlads"

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
  UIImage *rawFrame = [UIImage imageNamed:@"photo_frame.png"];
  self.oldPhotoFrame.image = [rawFrame resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
//  self.rePhotoFrame.image = [rawFrame resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16)];
}

- (IBAction)takeThePhoto:(id)sender {  
//	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//	picker.delegate = self;
//	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//	picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//	picker.showsCameraControls = YES;
//	picker.wantsFullScreenLayout = YES;
//	picker.allowsEditing = NO;
//	picker.cameraOverlayView = self.cameraOverlayViewController.view;
//	
////	[self.cameraOverlayViewController loadPhotoWithID:[NSNumber numberWithInt:self.oldPhotoObject.ID]];
//	[self.cameraOverlayViewController loadPhoto:self.oldPhoto.image];
//	
//	self.locationManager = [[CLLocationManager alloc] init];
//	[self.locationManager startUpdatingLocation];
//	[self.locationManager startUpdatingHeading];
//
//	[self presentModalViewController:picker animated:YES];
	
	AJCameraViewController *cameraViewController = [[AJCameraViewController alloc] initWithNibName:@"AJCameraViewController" bundle:[NSBundle mainBundle]];
	cameraViewController.image = self.oldPhoto.image;
	[self presentModalViewController:cameraViewController animated:YES];
}

- (void)reloadImages {
	[self view];
	
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
//  [self.rePhoto setImage:image];
	NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
	[imageData writeToFile:[path stringByAppendingPathExtension:@"jpg"] atomically:YES];
	
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
	
	NSString* MultiPartContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    
	NSMutableData *postData = [NSMutableData data];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_file[]\"; filename=\"%d.jpg\"\r\n", 1] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:imageData];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"%.6f", location.coordinate.latitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lon\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"%.6f", location.coordinate.longitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	
    NSString *baseurl = [NSString stringWithFormat:@"http://www.ajapaik.ee/foto/%d/upload/", self.oldPhotoObject.ID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	
    [urlRequest setHTTPMethod: @"POST"];
  	[urlRequest setValue:MultiPartContentType forHTTPHeaderField: @"Content-Type"];
    [urlRequest setHTTPBody:postData];
	
    NSError *error;
    NSURLResponse *response;
	NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
