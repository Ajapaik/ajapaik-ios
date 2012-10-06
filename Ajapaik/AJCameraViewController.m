//
//  AJCameraOverlayViewController.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import "AJCameraViewController.h"

@interface AJCameraViewController ()

@end

@implementation AJCameraViewController

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
    // Do any additional setup after loading the view from its nib.
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
	self.imageView.image = nil;
	
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
									   self.imageView.image = image;
									   self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
									   self.scrollView.contentSize = image.size;
									   self.scrollView.minimumZoomScale = 0.0f;
									   self.scrollView.maximumZoomScale = 2.0f;
									   [self.scrollView zoomToRect:self.imageView.bounds animated:NO];
								   });
							   }];
							   NSLog(@"%@", photoURL);
						   }];
}

@end
