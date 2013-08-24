//
//  SRIMessagesViewController.m
//  narad
//
//  Created by srjk on 8/23/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIMessagesViewController.h"
#import "SRIMenuViewController.h"
#import "SRIRightViewController.h"

@interface SRIMessagesViewController ()

@end

@implementation SRIMessagesViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
 
  NSLog(@"Messages view will appear");
  // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
  // You just need to set the opacity, radius, and color.
  self.view.layer.shadowOpacity = 0.75f;
  self.view.layer.shadowRadius = 10.0f;
  self.view.layer.shadowColor = [UIColor blackColor].CGColor;
  
  if (![self.slidingViewController.underLeftViewController isKindOfClass:[SRIMenuViewController class]]) {
    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  }
  
  if (![self.slidingViewController.underRightViewController isKindOfClass:[SRIRightViewController class]]) {
    self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Right"];
  }
  
  [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)revealMenu:(id)sender
{
  [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
  self.slidingViewController.anchorRightRevealAmount = 100.0f;
  
  [self.slidingViewController anchorTopViewTo:ECLeft];
}


/*
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
*/
@end
