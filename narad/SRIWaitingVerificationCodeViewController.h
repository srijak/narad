//
//  SRIWaitingVerificationCodeViewController.h
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRIWaitingVerificationCodeViewController : UIViewController

@property (nonatomic, strong) NSString* login;

- (IBAction) activateRegistration:(id)sender;

@end
