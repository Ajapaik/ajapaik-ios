//
//  AJMainViewController.m
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import "AJMainViewController.h"

@interface AJMainViewController ()
-(void) mapButtonClicked;
-(void) loadImages;
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
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LIST", @"List")style: UIBarButtonItemStyleBordered target:self action:@selector(mapButtonClicked)];
    [self.navigationItem setRightBarButtonItem:mapButton animated:YES];
    
    if (self.mapViewController == nil) {
        self.mapViewController = [[AJMapViewController alloc] initWithNibName:@"AJMapViewController"                                                      bundle:nil];
    }
    [self.view insertSubview:_mapViewController.view atIndex:0];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        [self.view insertSubview:_tableViewController.view atIndex:0];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"MAP", @"Map");
        [_mapViewController viewDidDisappear:YES];
        [_tableViewController viewDidAppear:YES];
    }
    else {
        if (self.mapViewController == nil) {
            self.mapViewController = [[AJMapViewController alloc] initWithNibName:@"AJMapViewController"                                                      bundle:nil];
            self.mapViewController.delegate = self;
        }
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft
                               forView:self.view cache:YES];
        [_mapViewController viewWillAppear:YES];
        [_tableViewController viewWillDisappear:YES];
        [_tableViewController.view removeFromSuperview];
        [self.view insertSubview:_mapViewController.view atIndex:0];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"LIST", @"list");
        [_tableViewController viewDidDisappear:YES];
        [_mapViewController viewDidAppear:YES];
    }
    [UIView commitAnimations];
}


-(void) loadImages
{
//    NSURL *mapURL = [NSURL URLWithString:@"http://www.ajapaik.ee/kaart/?city=2"];
//	NSURLRequest *request = [NSURLRequest requestWithURL:mapURL];
//	[NSURLConnection sendAsynchronousRequest:request
//                                       queue:[[NSOperationQueue alloc] init]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               if (data) {
//                                   NSString *mapData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                   NSRange start = [mapData rangeOfString:@"[["];
//                                   NSRange end = [mapData rangeOfString:@"]]"];
//                                   NSString *photos = [mapData substringWithRange:NSMakeRange(start.location + 2, end.location - start.location - 2)];
//                                   
//                                   dispatch_async(dispatch_get_main_queue(), ^{
//                                       for (NSString *photo in [photos componentsSeparatedByString:@"], ["]) {
//                                           NSLog(@"photo: %@", photo);
//                                           [self.mapView addAnnotation:[[AJPhotoAnnotation alloc] initWithString:photo]];
//                                       }
//                                   });
//                               }
//                           }];
}

#pragma mark - AJMainSubViewDelegate

-(void) photoChoosen:(AJPhoto *)photo
{
    //TODO: Here should be started photo view
}

@end
