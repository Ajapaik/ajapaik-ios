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

@interface AJMainViewController : UIViewController
{
    @private
    NSMutableArray *imageUrls;
}
@property (nonatomic,retain) AJMapViewController* mapViewController;
@property (nonatomic,retain) AJTableViewController* tableViewController;

@end
