//
//  AJPhotoAnnotation.h
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "AJPhoto.h"

@interface AJPhotoAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *title;
@property (nonatomic, retain) NSNumber *ID;
@property (nonatomic, retain) AJPhoto *photo;

- (id)initWithString:(NSString *)string;

@end
