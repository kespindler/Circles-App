//
//  TouchView.m
//  Circles3
//
//  Created by Kurt Spindler on 7/23/11.
//  Copyright 2011 Brown University. All rights reserved.
//

#import "TouchView.h"
#import "Circle.h"

#define BITS_PER_COMPONENT 8
#define BYTES_PER_PIXEL 4
#define MIN_CIRCLE_DIAMETER 2

@implementation TouchView

@synthesize sourceImage = _sourceImage;

- (Circle *)circleForFrame:(CGRect)frame {
    int xx = frame.origin.x;
    int yy = frame.origin.y;
    int imageWidth = self.sourceImage.size.width;
    NSUInteger bytesPerRow = BYTES_PER_PIXEL * imageWidth;
    int byteIndex = (bytesPerRow * yy) + xx * BYTES_PER_PIXEL;
    CGFloat rgba[4];
    for (int i = 0; i < 4; i++) {
        rgba[i] = (rawData[byteIndex + i] * 1.0) / 255.0;
    }
    return [[[Circle alloc] initWithFrame:frame rbga:rgba] autorelease];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lastTime = CFAbsoluteTimeGetCurrent();
    }
    return self;
}

- (void)resetView {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addSubview:[self circleForFrame:self.bounds]];
}

- (void)setSourceImage:(UIImage *)sourceImage {
    if (_sourceImage == sourceImage) return;
    [_sourceImage release];
    _sourceImage = [sourceImage retain];
    
    CGImageRef imageRef = self.sourceImage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    free(rawData);
    rawData = malloc(height * width * BYTES_PER_PIXEL);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerRow = BYTES_PER_PIXEL * width;
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 BITS_PER_COMPONENT, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    [self resetView];
}

- (void)performTouchBehaviorForTouch:(UITouch *)touch {
    if (CFAbsoluteTimeGetCurrent() - lastTime < 0.5f) return;
    CGPoint touchLocation = [touch locationInView:self];
    UIView *hitView = nil;
    for (UIView *v in self.subviews) {
        if (CGRectContainsPoint(v.frame, touchLocation)) {
            hitView = v;
            break;
        }
    }
    if (!hitView) return;
    CGRect frame = hitView.frame;
    CGFloat halfWidth = frame.size.width / 2;
    CGFloat halfHeight = frame.size.height / 2;
    if (halfHeight < MIN_CIRCLE_DIAMETER || halfWidth < MIN_CIRCLE_DIAMETER) return;
    CGRect newFrame;
    newFrame.size.width = halfWidth;
    newFrame.size.height = halfHeight;
    if (hitView != self) [hitView removeFromSuperview];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            newFrame.origin.x = frame.origin.x + halfWidth * i;
            newFrame.origin.y = frame.origin.y + halfHeight * j;
            [self addSubview:[self circleForFrame:newFrame]];
        }
    }
    lastTime = CFAbsoluteTimeGetCurrent(); 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
    [self performTouchBehaviorForTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesMoved:touches withEvent:event];
    [self performTouchBehaviorForTouch:[touches anyObject]];
}

- (void)dealloc {
    [super dealloc];
}

@end
