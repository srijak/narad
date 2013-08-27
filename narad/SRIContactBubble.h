//
//  SRIContactBubble.h
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SRIBubbleColor.h"

@class SRIContactBubble;

@protocol SRIContactBubbleDelegate <NSObject>

- (void)contactBubbleWasSelected:(SRIContactBubble *)contactBubble;
- (void)contactBubbleWasUnSelected:(SRIContactBubble *)contactBubble;
- (void)contactBubbleShouldBeRemoved:(SRIContactBubble *)contactBubble;

@end

@interface SRIContactBubble : UIView <UITextViewDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextView *textView; // used to capture keyboard touches when view is selected
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) id <SRIContactBubbleDelegate>delegate;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) SRIBubbleColor *color;
@property (nonatomic, strong) SRIBubbleColor *selectedColor;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name
             color:(SRIBubbleColor *)color
     selectedColor:(SRIBubbleColor *)selectedColor;

- (void)select;
- (void)unSelect;
- (void)setFont:(UIFont *)font;

@end
