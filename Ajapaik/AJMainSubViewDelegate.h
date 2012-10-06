//
//  AJMainSubViewDelegate.h
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import <Foundation/Foundation.h>
#import "AJPhoto.h"

@protocol AJMainSubViewDelegate
-(void) photoChoosen:(AJPhoto*) photo;
@end
