//
//  AJTableViewController.h
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AJMainSubViewDelegate.h"

@interface AJTableViewController : UITableViewController
{
    id<AJMainSubViewDelegate> delegate;
}

@property (nonatomic, assign) id<AJMainSubViewDelegate> delegate;
@end
