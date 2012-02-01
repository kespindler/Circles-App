//
//  ViewController.m
//  CirclesApp
//
//  Created by Kurt Spindler on 1/31/12.
//  Copyright (c) 2012 Brown University. All rights reserved.
//

#import "ViewController.h"
#import "TouchView.h"

@implementation ViewController

@synthesize touchView;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(loadNewImageButtonPressed)] autorelease];
    self.navigationItem.leftBarButtonItem = barItem1;
    UIBarButtonItem *barItem2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(resetButtonPressed)] autorelease];
    self.navigationItem.rightBarButtonItem = barItem2;
    self.touchView.sourceImage = [UIImage imageNamed:@"SonOfMan.png"];
}

- (void)viewDidUnload {
    [self setTouchView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)loadNewImageButtonPressed {
    
}

- (void)resetButtonPressed {
    [self.touchView resetView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return IS_IPHONE ? (interfaceOrientation == UIInterfaceOrientationPortrait) : YES;
}

- (void)dealloc {
    [touchView release];
    [super dealloc];
}
@end
