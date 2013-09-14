//
//  SRIContactPickerCell.h
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGMedallionView.h"

@interface SRIContactPickerCell : UITableViewCell

@property (nonatomic, assign) IBOutlet AGMedallionView* avatar;
@property (nonatomic, assign) IBOutlet UIImage* in_network;
@property (nonatomic, assign) IBOutlet UILabel* name;

@end
