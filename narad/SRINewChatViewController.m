//
//  SRINewChatViewController.m
//  narad
//
//  Created by srjk on 9/14/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRINewChatViewController.h"
#import "MZFormSheetController.h"
#import "SRIABWrapper.h"
#import "TITokenField.h"

@interface SRINewChatViewController (Private)
- (void)resizeViews;

@end

@implementation SRINewChatViewController {
TITokenFieldView * _tokenFieldView;
UITextView * _messageView;
  UIButton * cancelBtn;
  UIButton * postBtn;
  
  SRIABWrapper* abWrapper;

CGFloat _keyboardHeight;
}

- (void)viewDidLoad {
	
	[self.view setBackgroundColor:[UIColor clearColor]];
  
  
  CGRect frame = self.view.bounds;
	_tokenFieldView = [[TITokenFieldView alloc] initWithFrame:frame];
  [_tokenFieldView setSourceArray:@[]];
  abWrapper = [[SRIABWrapper alloc] init];
  [abWrapper requestAccess:self];
	
  
	[self.view addSubview:_tokenFieldView];
	//[_tokenFieldView setForcePickSearchResult:YES];
  
	[_tokenFieldView.tokenField setDelegate:self];
  
	[_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:TITokenFieldControlEventFrameDidChange];
	[_tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",."]]; // Default is a comma
  [_tokenFieldView.tokenField setPromptText:@"To:"];
	[_tokenFieldView.tokenField setPlaceholder:@"Type a name..."];
	
	UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
	[_tokenFieldView.tokenField setRightView:addButton];
	[_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidBegin];
	[_tokenFieldView.tokenField addTarget:self action:@selector(tokenFieldChangedEditing:) forControlEvents:UIControlEventEditingDidEnd];
	
  CGRect messageViewFrame = _tokenFieldView.contentView.bounds;
  messageViewFrame.size.width -= 30;
	_messageView = [[UITextView alloc] initWithFrame:messageViewFrame];
	[_messageView setScrollEnabled:YES];
	[_messageView setAutoresizingMask:UIViewAutoresizingNone];
	[_messageView setDelegate:self];
	[_messageView setFont:[UIFont systemFontOfSize:15]];
	[_messageView setText:@""];
	[_tokenFieldView.contentView addSubview:_messageView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	// You can call this on either the view on the field.
	// They both do the same thing.
  float btnWidth = _tokenFieldView.bounds.size.width/2 -16;
  
  float bottomY = 200;//self.view.frame.size.height - 40;
 
	cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
  [cancelBtn setBackgroundColor:[UIColor colorFromHexCode:@"FF5B37"]];
  [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  cancelBtn.frame=CGRectMake(0, bottomY , btnWidth, 40);
  [cancelBtn setTitle:@"Discard" forState:UIControlStateNormal];
  [cancelBtn addTarget:self
             action:@selector(discardClicked:)
   forControlEvents:UIControlEventTouchUpInside];
  
  
  postBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
  [postBtn setBackgroundColor:[UIColor colorFromHexCode:@"5AD427"]];
  [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  postBtn.frame=CGRectMake(btnWidth, bottomY , btnWidth, 40);
  [postBtn setTitle:@"Send" forState:UIControlStateNormal];
  [cancelBtn addTarget:self
                action:@selector(sendClicked:)
      forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:cancelBtn];
  [self.view addSubview:postBtn];
  [self resizeViews];

  
}
-(void) discardClicked:(id) obj{
  [self dismissFormSheetControllerAnimated:YES completionHandler:nil];
}
-(void) sendClicked:(id) obj{
  
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{[self resizeViews];}]; // Make it pweeetty.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self resizeViews];
}

- (void)showContactsPicker:(id)sender {
	
	// Show some kind of contacts picker in here.
	SRIPickContactsViewController *modal = [self.storyboard instantiateViewControllerWithIdentifier:@"PickContacts"];
  modal.delegate = self;
  [self.formSheetController presentViewController:modal animated:YES completion:^{
    
  }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"AddRecipientsSeque"]) {
    
    // Get destination view
    SRIPickContactsViewController *vc = [segue destinationViewController];
    vc.delegate = self;
    
  }
}

- (void)selectedContacts:(NSArray *)contacts{
  NSLog(@"Selected contacts: %@", contacts);
  for (id object in contacts){
    ABRecordID abRecordID = [object intValue];
    ABRecordRef abPerson = [abWrapper getContact:abRecordID];
    NSString* name =  (__bridge_transfer NSString *)ABRecordCopyCompositeName((ABRecordRef)(abPerson));
    [_tokenFieldView.tokenField addTokenWithTitle:name representedObject:(__bridge id)(abPerson)];
  }
  
}


  /*
	NSArray * names = [Names listOfNames];
	
	TIToken * token = [_tokenFieldView.tokenField addTokenWithTitle:[names objectAtIndex:(arc4random() % names.count)]];
	[token setAccessoryType:TITokenAccessoryTypeDisclosureIndicator];
	// If the size of the token might change, it's a good idea to layout again.
	[_tokenFieldView.tokenField layoutTokensAnimated:YES];
	
	NSUInteger tokenCount = _tokenFieldView.tokenField.tokens.count;
	[token setTintColor:((tokenCount % 3) == 0 ? [TIToken redTintColor] : ((tokenCount % 2) == 0 ? [TIToken greenTintColor] : [TIToken blueTintColor]))];
   */


- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	_keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	_keyboardHeight = 0;
	[self resizeViews];
}

- (void)resizeViews {
  int tabBarOffset = self.tabBarController == nil ?  0 : self.tabBarController.tabBar.frame.size.height;
  NSLog(@"tabBarOffset: %d", tabBarOffset);
  CGRect frame = _tokenFieldView.frame;
  frame.size.width = self.view.frame.size.width;
  frame.size.height = 200; //- _keyboardHeight;
  _tokenFieldView.frame = frame;
  /*
  CGRect buttonFrame = postBtn.frame;
  postBtn.frame = buttonFrame;
  //cancelBtn.frame = buttonFrame;
  */
	/*[_tokenFieldView setFrame:((CGRect){_tokenFieldView.frame.origin, {self.view.bounds.size.width, self.view.bounds.size.height + tabBarOffset - _keyboardHeight}})];
  [_messageView setFrame:_tokenFieldView.contentView.bounds];
   */
	
}


- (BOOL)tokenField:(TITokenField *)tokenField willRemoveToken:(TIToken *)token {
	return YES;
}

- (void)tokenFieldChangedEditing:(TITokenField *)tokenField {
	// There's some kind of annoying bug where UITextFieldViewModeWhile/UnlessEditing doesn't do anything.
	[tokenField setRightViewMode:(tokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}

- (void)tokenFieldFrameDidChange:(TITokenField *)tokenField {
	[self textViewDidChange:_messageView];
}

- (void)textViewDidChange:(UITextView *)textView {
	
	CGFloat oldHeight = _tokenFieldView.frame.size.height - _tokenFieldView.tokenField.frame.size.height;
	CGFloat newHeight = textView.contentSize.height + textView.font.lineHeight;
	
	CGRect newTextFrame = textView.frame;
	newTextFrame.size = textView.contentSize;
	newTextFrame.size.height = newHeight;
	
	CGRect newFrame = _tokenFieldView.contentView.frame;
	newFrame.size.height = newHeight;
	
	if (newHeight < oldHeight){
		newTextFrame.size.height = oldHeight;
		newFrame.size.height = oldHeight;
	}
  
	[_tokenFieldView.contentView setFrame:newFrame];
	[textView setFrame:newTextFrame];
	[_tokenFieldView updateContentSize];
}


-(void) ABRequestGranted {
  self.contacts = [abWrapper getContacts];
 // [_tokenFieldView setSourceArray:arr];
  [_tokenFieldView setSourceArray:self.contacts];
  
}

#pragma mark - TIToken Searching
- (NSString *)tokenField:(TITokenField *)tokenField displayStringForRepresentedObject:(id)object{
  //ABRecordID abRecordID = [object intValue];
  
  //ABRecordRef abPerson = [abWrapper getContact:abRecordID];
  return (__bridge_transfer NSString *)ABRecordCopyCompositeName((__bridge ABRecordRef)(object));
}

- (NSString *)tokenField:(TITokenField *)tokenField searchResultStringForRepresentedObject:(id)object{
  //ABRecordID abRecordID = [object intValue];
  
  //ABRecordRef abPerson = [abWrapper getContact:abRecordID];
  return (__bridge_transfer NSString *)ABRecordCopyCompositeName((__bridge ABRecordRef)(object));}
- (NSString *)tokenField:(TITokenField *)tokenField searchResultSubtitleForRepresentedObject:(id)object{
  return nil;
}

- (BOOL)tokenField:(TITokenField *)tokenField willAddToken:(TIToken *)token{
  
  return [self.contacts containsObject:token.representedObject];
}

@end