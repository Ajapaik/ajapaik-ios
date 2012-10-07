//
//  AJCameraViewController.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.07.
//
//

#import <ImageIO/ImageIO.h>
#import <CoreLocation/CoreLocation.h>
#import "AJCameraViewController.h"
#import "AJPhotoPreviewView.h"

#define BOUNDARY @"ASDasofiauoiewruaidpfadskfhjlads"

@interface AJCameraViewController ()

@property (nonatomic) CGFloat initialAlpha;
@property (nonatomic) CGFloat initialZoomScale;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation AJCameraViewController

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
    
	self.retakeButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f].CGColor;
	self.retakeButton.layer.borderWidth = 1.0f;
	self.retakeButton.layer.cornerRadius = 8.0f;
	
	self.useButton.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f].CGColor;
	self.useButton.layer.borderWidth = 1.0f;
	self.useButton.layer.cornerRadius = 8.0f;
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	if (deviceOrientation == UIDeviceOrientationPortrait) {
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
	} else if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
	} else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
	}
}

- (BOOL)shouldAutorotate
{
	return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImage:(UIImage *)image
{
	[self view];
	
	_image = image;

	self.previewView.image = image;
	self.previewView.alpha = 0.5f;
	self.previewView.zoomScale = 1.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	
	self.reviewView.hidden = YES;
	
	[self startScanning];
}

- (void)startScanning
{
	self.retakeButton.hidden = YES;
	self.useButton.hidden = YES;
	
	self.locationManager = [[CLLocationManager alloc] init];
	[self.locationManager startUpdatingLocation];
	[self.locationManager startUpdatingHeading];

	// seting
	AVCaptureSession *session = [[AVCaptureSession alloc] init];
	
	// using highest available quality
	session.sessionPreset = AVCaptureSessionPresetPhoto;
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	AVCaptureInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
	[session addInput:input];
	
	AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
	[session addOutput:output];
	output.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
													   forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
	[output setSampleBufferDelegate:self queue:queue];
	
	[session startRunning];
	
	// setup preview
	CALayer *layer = self.cameraView.layer;
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	captureVideoPreviewLayer.frame = layer.bounds;
	[layer addSublayer:captureVideoPreviewLayer];
	
	self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
	self.stillImageOutput.outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
	
	[session addOutput:self.stillImageOutput];
}

- (IBAction)takePhoto:(id)sender
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
	
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
		
		self.imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
		UIImage *image = [[UIImage alloc] initWithData:self.imageData];
		self.reviewView.image = image;
		
		[UIView animateWithDuration:0.25f animations:^{
			self.reviewView.hidden = NO;
			self.cameraView.hidden = YES;
			
			self.retakeButton.hidden = NO;
			self.useButton.hidden = NO;
			self.cancelButton.hidden = YES;
			self.takePhotoButton.hidden = YES;
		}];
	}];	
}

- (IBAction)usePhoto:(id)sender
{
	CLLocation *location = self.locationManager.location;
	CLHeading *heading = self.locationManager.heading;
	
	[self.locationManager stopUpdatingHeading];
	[self.locationManager stopUpdatingLocation];
	self.locationManager = nil;

	NSString* MultiPartContentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY];
    
	NSMutableData *postData = [NSMutableData data];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_file[]\"; filename=\"%d.jpg\"\r\n", 1] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:self.imageData];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lat\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"%.6f", location.coordinate.latitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lon\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"%.6f", location.coordinate.longitude] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
	
    NSString *baseurl = [NSString stringWithFormat:@"http://www.ajapaik.ee/foto/%@/upload/", self.photoID];
    NSURL *url = [NSURL URLWithString:baseurl];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	
    [urlRequest setHTTPMethod: @"POST"];
  	[urlRequest setValue:MultiPartContentType forHTTPHeaderField: @"Content-Type"];
    [urlRequest setHTTPBody:postData];
	
	NSString *filename = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
	[postData writeToFile:path atomically:YES];
	
    NSError *error;
    NSURLResponse *response;
	NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
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
