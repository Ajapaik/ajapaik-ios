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
	  self.wantsFullScreenLayout = YES;
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
									   self.previewView.alpha = 0.5f;
									   self.previewView.zoomScale = 1.0f;
								   });
							   }];
							   NSLog(@"%@", photoURL);
						   }];
}

- (void)loadPhoto:(UIImage *)image
{
  self.previewView.image = image;
  self.previewView.alpha = 0.5f;
  self.previewView.zoomScale = 1.0f;
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
	CGFloat delta = length / 300.0f;
	self.previewView.alpha = MIN(MAX(self.initialAlpha + delta, 0), 1.0f);
}

- (IBAction)tap:(id)sender
{
	[UIView animateWithDuration:0.25f animations:^{
		self.previewView.alpha = self.previewView.alpha == 1.0f ? 0.0f : 1.0f;
	}];
}

@end
