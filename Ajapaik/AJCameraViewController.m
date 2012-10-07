//
//  AJCameraViewController.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.07.
//
//

#import <ImageIO/ImageIO.h>
#import "AJCameraViewController.h"
#import "AJPhotoPreviewView.h"

@interface AJCameraViewController ()

@property (nonatomic) CGFloat initialAlpha;
@property (nonatomic) CGFloat initialZoomScale;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

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
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
	
	self.reviewView.hidden = YES;
	
	[self startScanning];
}

- (void)startScanning
{
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
		
		NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
		UIImage *image = [[UIImage alloc] initWithData:imageData];
		self.reviewView.image = image;
		
		[UIView animateWithDuration:0.25f animations:^{
			self.reviewView.hidden = NO;
			self.cameraView.hidden = YES;
		}];
	}];	
}

- (IBAction)cancel:(id)sender
{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
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
