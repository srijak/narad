//
//  SRIContactPickerViewController.h
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SRIContactPickerView.h"


@protocol SRIPickedContacts <NSObject>
- (void)selectedContacts:(NSArray *)contacts;
@end

@interface SRIContactPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,SRIContactPickerDelegate>

@property (nonatomic, strong) IBOutlet SRIContactPickerView *contactPickerView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSMutableArray *filteredContacts;
@property (nonatomic, strong) NSObject<SRIPickedContacts> * delegate;

@end
