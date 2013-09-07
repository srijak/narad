//
//  SRIConversationTopCell.m
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIConversationTopCell.h"
#import "UIColor+FlatUI.h"

@implementation SRIConversationTopCell

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

-(void) setPending{
  [self.leftBorder setBackgroundColor:[UIColor alizarinColor]];
}

-(void) setComplete{
  [self.leftBorder setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
}
@end
