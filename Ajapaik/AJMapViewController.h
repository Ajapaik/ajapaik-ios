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

@class AJCameraOverlayViewController;

@interface AJMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, assign) id<AJMainSubViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet AJCameraOverlayViewController *cameraOverlayViewController;

@end
