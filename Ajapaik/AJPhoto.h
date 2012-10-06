//
//  AJPhoto.h
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import <Foundation/Foundation.h>

@interface AJPhoto : NSObject

- (id)initWithNSDictionary:(NSDictionary *) data;

@property (nonatomic) int ID;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int cityID;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, retain) NSURL *thumbnailURL;

@end
