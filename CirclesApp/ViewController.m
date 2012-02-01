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
@synthesize imagePickerController;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Circles";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIBarButtonItem *barItem1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(loadNewImageButtonPressed)] autorelease];
    self.navigationItem.leftBarButtonItem = barItem1;
    UIBarButtonItem *barItem2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(resetButtonPressed)] autorelease];
    self.navigationItem.rightBarButtonItem = barItem2;
    self.touchView.sourceImage = [UIImage imageNamed:@"SonOfMan.png"];
    self.imagePickerController = [[[UIImagePickerController alloc] init] autorelease];
    self.imagePickerController.navigationBar.barStyle = UIBarStyleBlack;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
}

- (void)viewDidUnload {
    [self setTouchView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)loadNewImageButtonPressed {
    [self presentModalViewController:self.imagePickerController animated:YES];
}

- (void)resetButtonPressed {
    [self.touchView resetView];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    self.touchView.sourceImage = img;
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return IS_IPHONE ? (interfaceOrientation == UIInterfaceOrientationPortrait) : YES;
}

- (void)dealloc {
    [touchView release];
    [imagePickerController release];
    [super dealloc];
}
@end
