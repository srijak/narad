//
//  SRIChatViewController.m
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIChatViewController.h"
#import "SRIChatInfoViewController.h"
#import "SRIContactPickerViewController.h"
#import "SRIMessage.h"

@interface SRIChatViewController ()<AMBubbleTableDataSource, AMBubbleTableDelegate>

@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation SRIChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)back:(id)sender
{

  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)revealUnderRight:(id)sender
{
  self.slidingViewController.anchorLeftPeekAmount = 29.0f;
  [self.slidingViewController anchorTopViewTo:ECLeft];
}

-(void) showContactsPicker{
  [self performSegueWithIdentifier:@"ContactsPicker" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"ContactsPicker"]) {
    
    // Get destination view
    SRIContactPickerViewController *vc = [segue destinationViewController];
    vc.delegate = self;

  }
}

-(void) showMessages {
  NSArray *messages = [SRIMessage fetchWithPredicate:[NSPredicate predicateWithFormat:@"topic_id=%@", self.topic_id]];
  
  self.data = [[NSMutableArray alloc] init];
  for (id m in messages){
    SRIMessage* t = (SRIMessage *) m;
    [self.data addObject:   @{
     @"text": t.text,
     @"date": t.timestamp,
     @"type": @(AMBubbleCellReceived),
     @"username": [NSString stringWithFormat: @"%@", t.user_id],
     @"color": [UIColor redColor]
     }];
  }
  
  [self reloadTableScrollingToBottom:TRUE];
}

-(void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  if ([self isMovingToParentViewController]){
    NSLog(@"IS MOVING TO PARENT VIEW CONTROLLER");
  }else{
    NSLog(@" ---- IS NOT MOVING TO PARENT VIEW CONTROLLER");

  }
}

- (void)viewDidLoad
{
  // sliding menu setup
  if (![self.slidingViewController.underRightViewController isKindOfClass:[SRIChatInfoViewController class]]) {
    self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatInfoView"];
  }
 
  [self setDataSource:self]; // Weird, uh?
  [self setDelegate:self];

  // Bubble Table setup
   NSLog(@"Loading conversation with topid_id: %@", self.topic_id);
  
    
  self.data = [[NSMutableArray alloc] init];
    
    // Set a style
  [self setOptions:[[self customAMStyle] mutableCopy]];
  
  [self showMessages];
    // Call super after setting up the options
    [super viewDidLoad];

}
- (NSDictionary*)customAMStyle
{
	return @{
           AMOptionsImageIncoming: [[UIImage imageNamed:@"bubbleSquareIncoming"] stretchableImageWithLeftCapWidth:23 topCapHeight:15],
           AMOptionsImageOutgoing: [[UIImage imageNamed:@"bubbleSquareOutgoing"] stretchableImageWithLeftCapWidth:15 topCapHeight:13],
           AMOptionsImageBar: [[UIImage imageNamed:@"imageBar"] resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)],
           AMOptionsImageInput: [[UIImage imageNamed:@"imageInput"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 12.0f, 18.0f, 18.0f)],
           AMOptionsImageButton: [[UIImage imageNamed:@"buttonSend"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f)],
           AMOptionsImageButtonHighlight: [[UIImage imageNamed:@"buttonSendHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 13.0f, 0.0f, 13.0f)],
           AMOptionsTextFieldBackground: [UIColor whiteColor],
           AMOptionsTextFieldFont: [UIFont systemFontOfSize:15],
           AMOptionsTextFieldFontColor: [UIColor blackColor],
           AMOptionsBubbleTableBackground: [UIColor cloudsColor],
           AMOptionsAccessoryPosition: @(AMBubbleAccessoryDown),
           AMOptionsButtonOffset: @8,
           AMOptionsBubbleTextColor: [UIColor blackColor],
           AMOptionsBubbleTextFont: [UIFont systemFontOfSize:15],
           AMOptionsUsernameFont: [UIFont boldSystemFontOfSize:9],
           AMOptionsTimestampEachMessage : @YES,
           AMOptionsAccessoryClass: @"AMBubbleAccessoryView",
           AMOptionsTimestampShortFont: [UIFont boldSystemFontOfSize:10],
           AMOptionsTimestampFont: [UIFont boldSystemFontOfSize:13],
           AMOptionsAvatarSize: @34,
           AMOptionsAccessorySize: @50,
           AMOptionsAccessoryMargin: @5,
           };
}


#pragma mark - SRIPickedContacts
- (void)selectedContacts:(NSArray *)contacts{
  self.addedContacts = contacts;
  NSLog(@" contacts: %@", contacts);
}
#pragma mark - AMBubbleTableDataSource

- (NSInteger)numberOfRows
{
	return self.data.count;
}

- (AMBubbleCellType)cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.data[indexPath.row][@"type"] intValue];
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.data[indexPath.row][@"text"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [NSDate date];
}

- (UIImage*)avatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [UIImage imageNamed:@"sample"];
}

#pragma mark - AMBubbleTableDelegate

- (void)didSendText:(NSString*)text
{
	NSLog(@"User wrote: %@", text);
  
	[self.data addObject:@{ @"text": text,
	 @"date": [NSDate date],
	 @"type": @(AMBubbleCellSent)
	 }];
  
	[super reloadTableScrollingToBottom:YES];
}

- (NSString*)usernameForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.data[indexPath.row][@"username"];
}

- (UIColor*)usernameColorForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.data[indexPath.row][@"color"];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
@end
