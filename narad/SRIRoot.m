//
//  SRIRoot.m
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIRoot.h"

@implementation SRIRoot

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
   
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

-(void) viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  NSString* verification_state = [[NSUserDefaults standardUserDefaults] stringForKey:@"verified_state"];
  
  
  if ([verification_state isEqualToString:@"verified"]){
    // load add normally
    [self performSegueWithIdentifier:@"LoadApplication" sender:self];
  }else if ([verification_state isEqualToString:@"step1"]){
    // show the number input screen
    [self performSegueWithIdentifier:@"LoadVerification" sender:self];
    
  }else if ([verification_state isEqualToString:@"step2"]){
    // show the verification code enter screen.
    [self performSegueWithIdentifier:@"LoadVerification" sender:self];
  }

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
