//
//  AJMainViewController.h
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import <UIKit/UIKit.h>
#import "AJMapViewController.h"
#import "AJTableViewController.h"
#import "AJMainSubViewDelegate.h"

@class AJCameraOverlayViewController;

@interface AJMainViewController : UIViewController <AJMainSubViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    @private
    NSMutableArray *imageUrls;
}
@property (nonatomic, retain) IBOutlet AJMapViewController* mapViewController;
@property (nonatomic, retain) IBOutlet AJCameraOverlayViewController *cameraOverlayViewController;
@property (nonatomic,retain) AJTableViewController* tableViewController;


@end
