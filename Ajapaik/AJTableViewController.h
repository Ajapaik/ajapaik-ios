//
//  AJTableViewController.h
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AJMainSubViewDelegate.h"

@interface AJTableViewController : UITableViewController<CLLocationManagerDelegate>
{
    @private
    id<AJMainSubViewDelegate> delegate;
    CLLocationManager *_locationManager;
    CLLocation *_userLocation;
    NSArray *_photos;
}

@property (nonatomic, assign) id<AJMainSubViewDelegate> delegate;
-(void) setPhotos:(NSArray *) photos;
@end
