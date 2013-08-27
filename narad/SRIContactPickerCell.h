//
//  SRIContactPickerCell.h
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRIContactPickerCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UIImageView* selected_image;
@property (nonatomic, assign) IBOutlet UIImageView* avatar;
@property (nonatomic, assign) IBOutlet UIImageView* in_network;
@property (nonatomic, assign) IBOutlet UILabel* name;

@end
