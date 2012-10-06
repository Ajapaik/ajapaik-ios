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
		
		AJPhoto *photo = [[AJPhoto alloc] init];
		photo.ID = [NSNumber numberWithInteger:[[components objectAtIndex:0] integerValue]];
		
		self.title = [components objectAtIndex:0];
		self.photo = photo;
        
		self.coordinate = CLLocationCoordinate2DMake([[components objectAtIndex:2] doubleValue],
                                                 [[components objectAtIndex:1] doubleValue]);
	}
	return self;
}

@end
