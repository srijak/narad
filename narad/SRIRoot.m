//
//  SRIRoot.m
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIRoot.h"
#import "SRIAppDelegate.h"

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
  
 
  [self loadApplication];
 /*  UNCOMMENT TO ACTUALLYVERFIFY.
  if ([verification_state isEqualToString:@"verified"]){
    // load add normally
    [self loadApplication];
  }else if ([verification_state isEqualToString:@"step1"]){
    // show the number input screen
    [self performSegueWithIdentifier:@"LoadVerification" sender:self];
    
  }else if ([verification_state isEqualToString:@"step2"]){
    // show the verification code enter screen.
    [self performSegueWithIdentifier:@"LoadVerification" sender:self];
  }else{
    // show the number input screen
    [self performSegueWithIdentifier:@"LoadVerification" sender:self];
  }
  */

}

-(void) loadApplication {
  
  // connect to api and mqtt
  SRIAppDelegate *appDelegate = (SRIAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate initializeApp];
  
  // show main view
  [self performSegueWithIdentifier:@"LoadApplication" sender:self];
}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
