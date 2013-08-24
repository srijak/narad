//
//  SRINavigationTopViewController.m
//  narad
//
//  Created by srjk on 8/23/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRINavigationTopViewController.h"
#import <ECSlidingViewController/ECSlidingViewController.h>
#import "SRIMenuViewController.h"
#import "SRIRightViewController.h"

@interface SRINavigationTopViewController ()

@end

@implementation SRINavigationTopViewController


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (![self.slidingViewController.underLeftViewController isKindOfClass:[SRIMenuViewController class]]) {
    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  }
  
  if (![self.slidingViewController.underRightViewController isKindOfClass:[SRIRightViewController class]]) {
    self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Right"];
  }
  
  [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
