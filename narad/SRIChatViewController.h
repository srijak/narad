//
//  SRIChatViewController.h
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "AMBubbleTableViewController.h"
#import <ECSlidingViewController/ECSlidingViewController.h>

@interface SRIChatViewController : AMBubbleTableViewController

@property (nonatomic, retain) NSNumber * topic_id;

- (IBAction)revealUnderRight:(id)sender;
@end
