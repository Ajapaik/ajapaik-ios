//
//  AJCameraOverlayViewController.h
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import <UIKit/UIKit.h>

@interface AJCameraViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (void)loadPhotoWithID:(NSNumber *)ID;

@end
