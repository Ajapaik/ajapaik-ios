//
//  AJPhotoPreview.m
//  Ajapaik
//
//  Created by Aleksejs Mjaliks on 12.10.06.
//
//

#import "AJPhotoPreviewView.h"

@interface AJPhotoPreviewView ()

@property (nonatomic) BOOL landscapeImage;

@end

@implementation AJPhotoPreviewView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.zoomScale = 1.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
//	CGContextFillRect (context, self.frame);
	
	CGSize viewSize = self.bounds.size;
	CGSize imageSize = self.image.size;
	
	if (self.landscapeImage) {
		CGFloat scale = MIN(viewSize.width / imageSize.height, viewSize.height / imageSize.width) * self.zoomScale;
		CGSize renderSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);
		
		CGContextSaveGState(context);
		CGContextRotateCTM(context, M_PI_2);
		CGContextTranslateCTM(context, 0, - viewSize.width);//renderSize.height);
		
		[self.image drawInRect:CGRectMake((viewSize.height - renderSize.width) / 2.0f,
										  (viewSize.width - renderSize.height) / 2.0f,
										  renderSize.width, renderSize.height)];
		
		CGContextRestoreGState(context);
	} else {
		CGFloat scale = MIN(viewSize.width / imageSize.width, viewSize.height / imageSize.height) * self.zoomScale;
		CGSize renderSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);
		
		[self.image drawInRect:CGRectMake((viewSize.width - renderSize.width) / 2.0f,
										  (viewSize.height - renderSize.height) / 2.0f,
										  renderSize.width, renderSize.height)];
	}
}

- (void)setImage:(UIImage *)image
{
	_image = image;
	
	CGSize size = image.size;
	self.landscapeImage = size.width > size.height;
	
	[self setNeedsDisplay];
}

- (void)setZoomScale:(CGFloat)zoomScale
{
	_zoomScale = zoomScale;
	[self setNeedsDisplay];
}

@end
