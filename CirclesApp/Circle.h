//
//  Circle.h
//  Circles3
//
//  Created by Kurt Spindler on 7/23/11.
//  Copyright 2011 Brown University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Circle : UIView {
    CGFloat rgba[4];
}

- (id)initWithFrame:(CGRect)frame rbga:(CGFloat[])rgbaArray;

@end
