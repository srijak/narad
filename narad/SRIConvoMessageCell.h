//
//  SRIConvoMessageCell.h
//  narad
//
//  Created by srjk on 9/7/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"

@interface SRIConvoMessageCell : UITableViewCell


@property (nonatomic) NSString* message_id;

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *timestamp;
@property (nonatomic, strong) IBOutlet UILabel *message;
@property (nonatomic, strong) IBOutlet AGMedallionView *avatar;
@property (nonatomic, strong) IBOutlet UIView *righttBorder;
@end
