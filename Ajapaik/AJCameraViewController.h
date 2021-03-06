//
//  AJCameraViewController.h
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.07.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AJPhotoPreviewView;

@interface AJCameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSNumber *photoID;
@property (nonatomic, retain) IBOutlet UIView *cameraView;
@property (nonatomic, retain) IBOutlet UIImageView *reviewView;
@property (nonatomic, retain) IBOutlet AJPhotoPreviewView *previewView;

@property (nonatomic, retain) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *retakeButton;
@property (nonatomic, retain) IBOutlet UIButton *useButton;

- (IBAction)takePhoto:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)pitch:(id)sender;
- (IBAction)pan:(id)sender;
- (IBAction)tap:(id)sender;

@end
