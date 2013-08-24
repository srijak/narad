//
//  SRIRightViewController.m
//  narad
//
//  Created by srjk on 8/23/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIRightViewController.h"
#import <ECSlidingViewController/ECSlidingViewController.h>

@interface SRIRightViewController ()
@property (nonatomic, assign) CGFloat peekLeftAmount;

@end

@implementation SRIRightViewController

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
  self.peekLeftAmount = 40.0f;
  [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
  self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
