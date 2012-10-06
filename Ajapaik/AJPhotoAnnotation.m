//
//  AJPhotoAnnotation.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import "AJPhotoAnnotation.h"

@implementation AJPhotoAnnotation

- (id)initWithString:(NSString *)string
{
	if ((self = [self init])) {
		NSArray *components = [string componentsSeparatedByString:@", "];
		self.title = [components objectAtIndex:0];
		self.ID = [NSNumber numberWithInteger:[self.title integerValue]];
		self.coordinate = CLLocationCoordinate2DMake([[components objectAtIndex:2] doubleValue],
                                                 [[components objectAtIndex:1] doubleValue]);
	}
	return self;
}

@end
