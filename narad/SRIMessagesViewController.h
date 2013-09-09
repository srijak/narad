//
//  SRIMessagesViewController.h
//  narad
//
//  Created by srjk on 8/23/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <ECSlidingViewController/ECSlidingViewController.h>
#import "RHCoreDataTableViewController.h"
#import "RNFrostedSidebar.h"

@interface SRIMessagesViewController : RHCoreDataTableViewController <RNFrostedSidebarDelegate>

@property (nonatomic, strong) NSArray *groups;

@property (nonatomic, strong) IBOutlet UITableView* tableView;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;
- (IBAction)startNewMessage:(id)sender;
@end
