//
//  SRIContactPickerCell.m
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIContactPickerCell.h"

@implementation SRIContactPickerCell

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
- (void)setFrame:(CGRect)frame {
  float inset = 10;
  frame.origin.x = inset;
  frame.size.width -= 35;
  frame.size.width -= 2 * inset;
  [super setFrame:frame];
}

@end
