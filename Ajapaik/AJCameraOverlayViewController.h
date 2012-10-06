//
//  AJCameraOverlayViewController.h
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import <UIKit/UIKit.h>

@class AJPhotoPreviewView;

@interface AJCameraOverlayViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet AJPhotoPreviewView *previewView;

- (IBAction)pitch:(id)sender;
- (IBAction)pan:(id)sender;
- (IBAction)tap:(id)sender;
- (void)loadPhotoWithID:(NSNumber *)ID;
- (void)loadPhoto:(UIImage *)image;

@end
