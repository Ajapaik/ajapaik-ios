//
//  AJPhotoAnnotation.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import "AJPhotoAnnotation.h"

@implementation AJPhotoAnnotation

- (id)initWithPhoto:(AJPhoto *)photo
{
	if ((self = [self init])) {
		self.title = [NSString stringWithFormat:@"%d", photo.ID];
		self.ID = [NSNumber numberWithInteger:photo.ID];
        
		self.coordinate = CLLocationCoordinate2DMake(photo.latitude, photo.longitude);
	}
	return self;
}

@end
