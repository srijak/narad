//
//  SRIInitialSlidingViewController.m
//  narad
//
//  Created by srjk on 8/23/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIInitialSlidingViewController.h"

@interface SRIInitialSlidingViewController ()

@end

@implementation SRIInitialSlidingViewController

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

  
  
  UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  
  /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
  }*/
  
  self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Messages"];
  NSLog(@"after viewDidLoad in initialSliding");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
