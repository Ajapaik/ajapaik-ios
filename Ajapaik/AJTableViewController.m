//
//  AJTableViewController.m
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import "AJTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AJTableViewController ()

@end

@implementation AJTableViewController
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _userLocation = nil;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy =kCLLocationAccuracyHundredMeters;
    [_locationManager startUpdatingLocation];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
-(void) setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PhotoTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    AJPhoto *photo = [_photos objectAtIndex:indexPath.row];
    
    UILabel* cellNameLabel = (UILabel*)[cell viewWithTag:1];
    cellNameLabel.text = [NSString stringWithFormat:@"%d", photo.ID];
    UILabel* cellAddressLabel = (UILabel*) [cell viewWithTag:2];
    cellAddressLabel.text = photo.description;
    
    /*UILabel* cellLocationLabel = (UILabel*) [cell viewWithTag:3];
     if(_userLocation)
     {
        NSString *distanceString = [[NSString alloc] initWithFormat:@"%gm", [photo.location distanceFromLocation:_userLocation]];
        cellLocationLabel.text  = distanceString;
     }*/
    
    UIImageView *photoImage = (UIImageView*)[cell viewWithTag:3];
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:4];
    [photoImage setImageWithURL: photo.imageURL success:^(UIImage *image, BOOL cached) {
        dispatch_async(dispatch_get_main_queue(), ^{
            photoImage.image = image;
            indicator.hidden = YES;
            [indicator stopAnimating];
        });
    } failure:^(NSError *error) {
        // do nothing right now
    }];
    
    UIImage *image = photoImage.image;
    if(image) {
        indicator.hidden = YES;
        [indicator stopAnimating];
    } else {
        indicator.hidden = NO;
        [indicator startAnimating];
    }
    [photoImage setNeedsDisplay];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJPhoto *photo = [_photos objectAtIndex:indexPath.row];
    [self.delegate photoChoosen: photo];
}

#pragma mark - Location Manager

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _userLocation = newLocation;//[[CLLocation alloc] initWithLatitude:60.07 longitude:30.19];
    [self.tableView reloadData];
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting Location"
                                                    message:errorType
                                                   delegate:nil
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [self.tableView reloadData];
}

@end
