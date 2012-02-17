//
//  TouchView.h
//  Circles3
//
//  Created by Kurt Spindler on 7/23/11.
//  Copyright 2011 Brown University. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct {
    CGRect rect;
    float rgba[4];
} CircleStruct;

@interface CircleObject : NSObject {
    @public
    CGRect rect;
    CGFloat rgba[4];
}

@end

@interface TouchView : UIView {
    TimeValue lastTime;
    unsigned char *rawData;
    NSMutableArray *circleArray;
}

@property (nonatomic, retain) UIImage *sourceImage;

- (void)resetView;

@end
