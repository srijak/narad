//
//  SRISwipableTableViewCell.m
//  narad
//
//  Created by srjk on 9/23/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRISwipableTableViewCell.h"

@implementation SRISwipableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
