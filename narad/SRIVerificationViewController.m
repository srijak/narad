//
//  SRIVerificationViewController.m
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIVerificationViewController.h"
#import "SRIWaitingVerificationCodeViewController.h"
#import "SRIAppDelegate.h"

@interface SRIVerificationViewController ()

@property (nonatomic, strong) IBOutlet UITextField *phone_number_text;
@property (nonatomic) BOOL  created_client;
@end

@implementation SRIVerificationViewController

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
  
  if ([verification_state isEqualToString:@"step2"]){
    // go to next step.
    NSString* phone_number = [[NSUserDefaults standardUserDefaults] stringForKey:@"step1.data"];
    [self gotoWaiting:phone_number sendVerification:FALSE];
    self.created_client = TRUE;
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) sendVerificationAndGotoWaiting:(id)sender{
  [self gotoWaiting:self.phone_number_text.text sendVerification:TRUE];
}

- (void) gotoWaiting:(NSString*) phone_number sendVerification:(BOOL)send_verification{
  self.phone_number_text.text = phone_number;
  
  NSLog(@"Phone number: %@", phone_number);
  // ok, make request to send verification by smsm to this number
  SRIAppDelegate *appDelegate = (SRIAppDelegate *)[[UIApplication sharedApplication] delegate];
  if (send_verification){
    if (self.created_client){
      [appDelegate.napi sendActivationToPhone:phone_number];
    }else{
      [appDelegate.napi createClientByPhone:phone_number auth:@"" user_id:-1];
    }
  }
  
  [self storeSentVerification:phone_number];
  [self performSegueWithIdentifier:@"enterVerificationCode" sender:self];
  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"enterVerificationCode"]) {
    SRIWaitingVerificationCodeViewController *destViewController = segue.destinationViewController;
    destViewController.login = self.phone_number_text.text;
  }
}

-(void) storeSentVerification:(NSString*) phone_number {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:@"step2" forKey:@"verified_state"];
  [userDefaults setObject:phone_number forKey:@"step1.data"];
  self.created_client = TRUE;
  
  [userDefaults synchronize];
}

-(void) getStoredVerification {
  
}
@end
