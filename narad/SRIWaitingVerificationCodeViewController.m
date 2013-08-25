//
//  SRIWaitingVerificationCodeViewController.m
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIWaitingVerificationCodeViewController.h"
#import "SRIAppDelegate.h"

@interface SRIWaitingVerificationCodeViewController ()

@property (nonatomic, strong) IBOutlet UITextField *activation_code;
@property (nonatomic, strong) IBOutlet UITextField *username;

@end

@implementation SRIWaitingVerificationCodeViewController


- (IBAction) activateRegistration:(id)sender{
  
  SRIAppDelegate *appDelegate = (SRIAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  NSLog(@"Trying to activate %@  with code %@", self.login, self.activation_code.text);
  
  int res = [appDelegate.napi activate:self.username.text activation_payload:self.activation_code.text];
  //TODO: Generate and send the client's public key to the server here for SSL communications for here on out?
  
  NSLog(@"Result from trying to activate: %d ", res);
  if (res == 1){
    // successfull verification
    // store the verification code and username
    // store state => verified
    NSLog(@"Verfified.");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"verified" forKey:@"verified_state"];

    //TODO: user keychain for this.
    [userDefaults setObject:self.username.text forKey:@"username"];
    [userDefaults setObject:self.activation_code.text forKey:@"passwd"];
    
    [userDefaults synchronize];
    
    [self performSegueWithIdentifier:@"FinishedVerification" sender:self];

  }else{
    // error with verification
    // TODO: handle
    NSLog(@"NOT Verfified.");
  }
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
  self.username.text = self.login;

  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleBack:)];
  
  self.navigationItem.leftBarButtonItem = backButton;
  
}
- (void) handleBack:(id)sender
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:@"step1" forKey:@"verified_state"];
  [userDefaults synchronize];
  
  // pop to root view controller
  [self.navigationController popToRootViewControllerAnimated:YES];
  
}
  
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
