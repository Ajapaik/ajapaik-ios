//
//  AJPhoto.m
//  Ajapaik
//
//  Created by Dmitry Manayev on 10/6/12.
//
//

#import "AJPhoto.h"

@implementation AJPhoto
@synthesize ID =_ID;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize cityID = _cityID;
@synthesize description = _description;
@synthesize imageURL = _imageURL;
@synthesize thumnailURL = _thumnailURL;

-(id)initWithNSDictionary:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _ID = [self intForElemName:@"id" inData: data];
        _latitude = [self doubleForElemName:@"lat" inData:data];
        _longitude = [self doubleForElemName:@"lon" inData:data];
        _cityID = [self intForElemName:@"city_id" inData:data];
        _description = [self stringForElemName:@"description" inData:data];
        _imageURL = [NSURL URLWithString:[self stringForElemName:@"image_url" inData:data]];
//        _thumnailURL = 
    }
    return self;
}

-(int)intForElemName:(NSString*)elemName inData:(NSDictionary *)elem{
    @autoreleasepool {
        NSString *element = [elem objectForKey:elemName];
        if (element) {
            return [element intValue];
        } else {
            NSLog(@"Error while decoding value for key: %@", elemName);
            return 0;
        }
    }
}

-(double)doubleForElemName:(NSString*)elemName inData:(NSDictionary *)elem{
    @autoreleasepool {
        NSString *element = [elem objectForKey:elemName];
        if (element) {
            return [element doubleValue];
        } else {
            NSLog(@"Error while decoding value for key: %@", elemName);
            return 0;
        }
    }
}

-(NSString*)stringForElemName:(NSString*)elemName inData:(NSDictionary *)elem{
    @autoreleasepool {
        NSString *element = [elem objectForKey:elemName];
        if (element) {
            return element;
        } else {
            NSLog(@"Error while decoding value for key: %@", elemName);
            return nil;
        }
    }
}
@end
