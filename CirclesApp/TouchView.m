//
//  TouchView.m
//  Circles3
//
//  Created by Kurt Spindler on 7/23/11.
//  Copyright 2011 Brown University. All rights reserved.
//

#import "TouchView.h"

#define BITS_PER_COMPONENT 8
#define BYTES_PER_PIXEL 4
#define MIN_CIRCLE_DIAMETER 3

@implementation CircleObject

@end

@implementation TouchView

@synthesize sourceImage = _sourceImage;

- (CircleObject *)initCircleForFrame:(CGRect)frame {
    int xx = frame.origin.x;
    int yy = frame.origin.y;
    int imageWidth = self.sourceImage.size.width;
    NSUInteger bytesPerRow = BYTES_PER_PIXEL * imageWidth;
    int byteIndex = (bytesPerRow * yy) + xx * BYTES_PER_PIXEL;
    CircleObject *obj = [[CircleObject alloc] init];
    for (int i = 0; i < 4; i++) {
        obj->rgba[i] = (rawData[byteIndex + i] * 1.0) / 255.0;
    }
    obj->rect = frame;
    return obj;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lastTime = CFAbsoluteTimeGetCurrent();
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(ctx, rgba[0], rgba[1], rgba[2], rgba[3]);
//    CGContextFillEllipseInRect(ctx, rect);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (CircleObject *c in circleArray) {
        if (CGRectContainsRect(rect, c->rect)) {
            CGContextSetRGBFillColor(ctx, (c->rgba)[0], (c->rgba)[1], (c->rgba)[2], (c->rgba)[3]);
            CGContextFillEllipseInRect(ctx, c->rect);
        }
    }
//    CGImageRef imageRef = self.sourceImage.CGImage;
//    NSUInteger width = CGImageGetWidth(imageRef);
//    NSUInteger height = CGImageGetHeight(imageRef);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    NSUInteger bytesPerRow = BYTES_PER_PIXEL * width;
//    // Now your rawData contains the image data in the RGBA8888 pixel format.
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGColorSpaceRelease(colorSpace);
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
}

- (void)resetView {
    if (!circleArray) circleArray = [[NSMutableArray alloc] initWithCapacity:1000];
    [circleArray removeAllObjects];
    CircleObject *firstCircle = [self initCircleForFrame:self.bounds];
    [circleArray addObject:firstCircle];
    [firstCircle release];
    [self setNeedsDisplay];
}

- (void)setSourceImage:(UIImage *)sourceImage {
    if (_sourceImage == sourceImage) return;
    [_sourceImage release];
    _sourceImage = [sourceImage retain];
    
    CGImageRef imageRef = self.sourceImage.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    width = self.frame.size.width;
    height = self.frame.size.height * 2;
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
    if (CFAbsoluteTimeGetCurrent() - lastTime < 0.3f) {
        NSLog(@"returning");
        return;
    }
    CGPoint touchLocation = [touch locationInView:self];
    CircleObject *hitCircle = nil;
    for (CircleObject *c in circleArray) {
        if (CGRectContainsPoint(c->rect, touchLocation)) {
            hitCircle = c;
            break;
        }
    }
    if (!hitCircle) return;
    CGRect frame = hitCircle->rect;
    int halfWidth = frame.size.width / 2;
    int halfHeight = frame.size.height / 2;
    if (halfHeight < MIN_CIRCLE_DIAMETER || halfWidth < MIN_CIRCLE_DIAMETER) return;
    CGRect newFrame;
    newFrame.size.width = halfWidth;
    newFrame.size.height = halfHeight;
    [hitCircle retain];
    [circleArray removeObject:hitCircle];
    CircleObject *addCircle = nil;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            newFrame.origin.x = frame.origin.x + halfWidth * i;
            newFrame.origin.y = frame.origin.y + halfHeight * j;
            addCircle = [self initCircleForFrame:newFrame];
            [circleArray addObject:addCircle];
            [addCircle release];
            [self setNeedsDisplayInRect:hitCircle->rect];
        }
    }
    lastTime = CFAbsoluteTimeGetCurrent(); 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self performTouchBehaviorForTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self performTouchBehaviorForTouch:[touches anyObject]];
}

- (void)dealloc {
    [super dealloc];
}

@end
