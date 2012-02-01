//
//  TouchView.h
//  Circles3
//
//  Created by Kurt Spindler on 7/23/11.
//  Copyright 2011 Brown University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchView : UIView {
    TimeValue lastTime;
    unsigned char *rawData;
}

@property (nonatomic, retain) UIImage *sourceImage;

- (void)resetView;

@end
