//
//  AJMapViewController.h
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AJMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *mapView;;

@end
