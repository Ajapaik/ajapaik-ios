//
//  AJCameraOverlayViewController.h
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import <UIKit/UIKit.h>

@interface AJCameraOverlayViewController : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

- (IBAction)pitch:(id)sender;
- (IBAction)pan:(id)sender;
- (void)loadPhotoWithID:(NSNumber *)ID;

@end
