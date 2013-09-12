//
//  SRIContactPicketView.h
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRIContactBubble.h"

@class SRIContactPickerView;

@protocol SRIContactPickerDelegate <NSObject>

- (void)contactPickerTextViewDidChange:(NSString *)textViewText;
- (void)contactPickerDidRemoveContact:(id)contact;
- (void)contactPickerDidResize:(SRIContactPickerView *)contactPickerView;
- (NSArray *)completionsForString:(NSString *)myString;

@end

@interface SRIContactPickerView : UIView <UITextFieldDelegate, SRIContactBubbleDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) SRIContactBubble *selectedContactBubble;
@property (nonatomic, assign) IBOutlet id <SRIContactPickerDelegate> delegate;
@property (nonatomic, assign) BOOL limitToOne;
@property (nonatomic, assign) CGFloat viewPadding;
@property (nonatomic, strong) UIFont *font;

- (void)addContact:(id)contact withName:(NSString *)name;
- (void)removeContact:(id)contact;
- (void)removeAllContacts;
- (void)setPlaceholderString:(NSString *)placeholderString;
- (void)disableDropShadow;
- (void)resignKeyboard;
- (void)setBubbleColor:(SRIBubbleColor *)color selectedColor:(SRIBubbleColor *)selectedColor;

@end