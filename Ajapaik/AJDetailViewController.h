//
//  AJDetailViewController.h
//  Ajapaik
//
//  Created by Taavi Hein on 06.10.12.
//
//

#import <UIKit/UIKit.h>
#import "AJPhoto.h"
#import "AJMainSubViewDelegate.h"

@class AJCameraOverlayViewController;

@interface AJDetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,assign) id<AJMainSubViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet AJCameraOverlayViewController *cameraOverlayViewController;
@property (nonatomic,retain) AJPhoto *oldPhotoObject;
@property (nonatomic,retain) AJPhoto *rePhotoObject;
@property (nonatomic,retain) AJPhoto *takenPhotoObject;
//@property (nonatomic,assign) id<CLLocationManager> *locationManager;
@property (nonatomic,retain) IBOutlet UIImageView *oldPhoto;
//@property (nonatomic,retain) IBOutlet UIImageView *rePhoto;
@property (nonatomic,retain) IBOutlet UIImageView *oldPhotoFrame;
//@property (nonatomic,retain) IBOutlet UIImageView *rePhotoFrame;
@property (nonatomic,retain) IBOutlet UILabel *headline;
//@property (nonatomic,retain) IBOutlet UILabel *description;
@property (nonatomic,retain) IBOutlet UIButton *takePhoto;

-(IBAction)takeThePhoto:(id)sender;
-(void)reloadImages;

@end
