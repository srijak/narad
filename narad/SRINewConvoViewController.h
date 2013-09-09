//
//  SRINewConvoViewController.h
//  narad
//
//  Created by srjk on 9/8/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRIContactPickerView.h"
#import "SRIContactPickerViewController.h"

@interface SRINewConvoViewController : UIViewController <SRIContactPickerDelegate,SRIPickedContacts>

@property (nonatomic, strong) IBOutlet SRIContactPickerView *contactPickerView;
@property (nonatomic, strong) IBOutlet UIButton *addContact;
@property (nonatomic, strong) IBOutlet UITextField  *name;
@property (nonatomic, strong) IBOutlet UITextView  *message;

-(IBAction)showContactPicker:(id)sender;
-(IBAction) cancel:(id)sender;
-(IBAction) start:(id)sender;

@end
