//
//  AJMainViewController.m
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import "AJMainViewController.h"
#import "AJPhoto.h"
#import "JSONKit.h"

@interface AJMainViewController ()
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
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"LIST", @"List")style: UIBarButtonItemStyleBordered target:self action:@selector(mapButtonClicked)];
    [self.navigationItem setRightBarButtonItem:mapButton animated:YES];
    [self loadImages];
    
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
        [_mapViewController setPhotos:_oldPhotos];
        [self.view insertSubview:_mapViewController.view atIndex:0];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"LIST", @"list");
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
                                   NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
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
        if (self.mapViewController == nil) {
            self.mapViewController = [[AJMapViewController alloc] initWithNibName:@"AJMapViewController"                                                      bundle:nil];
            self.mapViewController.delegate = self;
        }
        [_mapViewController setPhotos: photos];
    }
}


#pragma mark - AJMainSubViewDelegate

-(void) photoChoosen:(AJPhoto *)photo
{
    //TODO: Here should be started photo view
}

@end
