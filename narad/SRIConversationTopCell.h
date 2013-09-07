//
//  SRIConversationTopCell.h
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"

@interface SRIConversationTopCell : UITableViewCell

@property (nonatomic) NSInteger conversation_id;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastMessageSentLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastMessageTextLabel;
@property (nonatomic, strong) IBOutlet AGMedallionView *groupImg;
@property (nonatomic, strong) IBOutlet UIView *leftBorder;

-(void) setPending;
-(void) setComplete;
@end
