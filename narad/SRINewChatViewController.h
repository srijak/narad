//
//  SRINewChatViewController.h
//  narad
//
//  Created by srjk on 9/14/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TITokenField.h"
#import "SRIPickContactsViewController.h"

@interface SRINewChatViewController : UIViewController <TITokenFieldDelegate,SRISelectedContacts,  UITextViewDelegate>


@property (strong, nonatomic) NSArray* contacts;

- (void)selectedContacts:(NSArray *)contacts;

@end
