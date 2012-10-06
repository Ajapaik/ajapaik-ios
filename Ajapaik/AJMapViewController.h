//
//  AJMapViewController.h
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AJMainSubViewDelegate.h"


@interface AJMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, assign) IBOutlet id<AJMainSubViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

-(void) setPhotos:(NSArray *) photos;
@end
