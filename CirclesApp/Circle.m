//
//  Circle.m
//  Circles3
//
//  Created by Kurt Spindler on 7/23/11.
//  Copyright 2011 Brown University. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (id)initWithFrame:(CGRect)frame {
    CGFloat rgbaArary[4] = {0};
    return [self initWithFrame:frame rbga:rgbaArary];
}

- (id)initWithFrame:(CGRect)frame rbga:(CGFloat[])rgbaArray {
    self = [super initWithFrame:frame];
    if (self) {
        memcpy(rgba, rgbaArray, 4 * sizeof(CGFloat));
        self.userInteractionEnabled = NO;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextClearRect(ctx, rect);
    CGContextSetRGBFillColor(ctx, rgba[0], rgba[1], rgba[2], rgba[3]);
    CGContextFillEllipseInRect(ctx, rect);
}

- (void)dealloc {
    [super dealloc];
}

@end
