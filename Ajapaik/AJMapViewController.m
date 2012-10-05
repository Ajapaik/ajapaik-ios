//
//  AJMapViewController.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import "AJMapViewController.h"

@interface AJMapViewController ()

@property (nonatomic) BOOL userLocationCentered;

@end

@implementation AJMapViewController

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
    
	self.mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	if (!self.userLocationCentered) {
		[self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
	}
}

@end
