//
//  SRIPickContactsViewController.h
//  narad
//
//  Created by srjk on 9/15/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SRIABWrapper.h"

@protocol SRISelectedContacts <NSObject>
- (void)selectedContacts:(NSArray *)contacts;
@end

@interface SRIPickContactsViewController : UIViewController <SRIABDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *contactPickerView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSMutableArray *filteredContacts;
@property (nonatomic, strong) NSObject<SRISelectedContacts> * delegate;

@property (nonatomic, strong) SRIABWrapper* abWrapper;


- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue;
@end