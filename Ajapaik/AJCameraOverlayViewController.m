//
//  AJCameraOverlayViewController.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import "AJCameraOverlayViewController.h"
#import "AJPhotoPreviewView.h"

@interface AJCameraOverlayViewController ()

@property (nonatomic) CGFloat initialAlpha;
@property (nonatomic) CGFloat initialZoomScale;

@end

@implementation AJCameraOverlayViewController

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
	self.wantsFullScreenLayout = YES;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (void)loadPhotoWithID:(NSNumber *)ID
{
	self.previewView.image = nil;
	
	NSURL *popupURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ajapaik.ee/foto/%@/", ID]];
	NSURLRequest *popupRequest = [NSURLRequest requestWithURL:popupURL];
	[NSURLConnection sendAsynchronousRequest:popupRequest
									   queue:[[NSOperationQueue alloc] init]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
							   NSString *popupData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
							   NSRange range = [popupData rangeOfString:@"<img src=\""];
							   NSString *photoURL = [popupData substringWithRange:NSMakeRange(range.location + range.length, 55)];
							   
							   NSURLRequest *photoRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:photoURL relativeToURL:[NSURL URLWithString:@"http://www.ajapaik.ee"]]];
							   [NSURLConnection sendAsynchronousRequest:photoRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
								   UIImage *image = [UIImage imageWithData:data];
								   dispatch_async(dispatch_get_main_queue(), ^{
									   self.previewView.image = image;
								   });
							   }];
							   NSLog(@"%@", photoURL);
						   }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
}

- (IBAction)pitch:(id)sender
{
	UIPinchGestureRecognizer *pinchGestureRecognizer = (UIPinchGestureRecognizer *)sender;
	if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) self.initialZoomScale = self.previewView.zoomScale;
	
	self.previewView.zoomScale = self.initialZoomScale * pinchGestureRecognizer.scale;
}

- (IBAction)pan:(id)sender
{
	UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)sender;
	if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) self.initialAlpha = self.previewView.alpha;
	
	CGPoint translation = [panGestureRecognizer translationInView:self.previewView];
	CGFloat length = translation.y;// sqrtf(translation.x * translation.x + translation.y * translation.y);
	CGFloat delta = length / 150.0f;
	self.previewView.alpha = MIN(MAX(self.initialAlpha + delta, 0), 1.0f);
}

@end
