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

@interface SRINewConvoViewController : UIViewController <SRIContactPickerDelegate,
                                                          SRIPickedContacts,
                                                          UITableViewDelegate,
                                                          UITableViewDataSource>

@property (nonatomic, strong) IBOutlet SRIContactPickerView *contactPickerView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSMutableArray *filteredContacts;
@property (nonatomic, strong) NSObject<SRIPickedContacts> * delegate;

@property (nonatomic, strong) UITextView *messageText;
@end
