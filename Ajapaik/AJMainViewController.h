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

@interface AJMainViewController : UIViewController<AJMainSubViewDelegate>
{
    @private
    NSArray *_oldPhotos;
}
@property (nonatomic,retain) AJMapViewController* mapViewController;
@property (nonatomic,retain) AJTableViewController* tableViewController;

@end
