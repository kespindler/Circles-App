//
//  ViewController.h
//  CirclesApp
//
//  Created by Kurt Spindler on 1/31/12.
//  Copyright (c) 2012 Brown University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"

@class TouchView;

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ADBannerViewDelegate>

@property (retain, nonatomic) IBOutlet TouchView *touchView;
@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@end
