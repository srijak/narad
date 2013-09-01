//
//  SRIChatViewController.m
//  narad
//
//  Created by srjk on 8/25/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIChatViewController.h"
#import "SRIRightViewController.h"
#import "SRIContactPickerViewController.h"

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
- (IBAction)revealUnderRight:(id)sender
{
 /* self.slidingViewController.anchorRightRevealAmount = 100.0f;
  [self.slidingViewController anchorTopViewTo:ECLeft];
  */
  
  [self performSegueWithIdentifier:@"ContactsPicker" sender:self];

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

-(void) viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  if (self.needsToShowContactPicker){
    NSLog(@"SHOW CONtACTS PICKER");
    [self showContactsPicker];
  }else{
    NSLog(@" --- DONT SHOW CONTACTS PICKER");
  }
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
  // cliding menu setup
 if (![self.slidingViewController.underRightViewController isKindOfClass:[SRIRightViewController class]]) {
   self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Right"];
   }
  
  if ([self.topic_id isEqualToNumber:@-1]){
    NSLog(@"SHOW CONtACTS PICKER");
    self.needsToShowContactPicker = TRUE;
  }else{
    NSLog(@" --- DONT SHOW CONTACTS PICKER");
  }

  [self setDataSource:self]; // Weird, uh?
  [self setDelegate:self];

  // Bubble Table setup
   NSLog(@"Loading conversation with topid_id: %@", self.topic_id);
  
    //TODO: Load conversation from id. If id == -1, that means it's a new conversation.

    
    NSLog(@"--- DONT SHOW CONtACTS PICKER");
    
    // Dummy data
    self.data = [[NSMutableArray alloc] initWithArray:@[
                 @{
                 @"text": @"He felt that his whole life was some kind of dream and he sometimes wondered whose it was and whether they were enjoying it.",
                 @"date": [NSDate date],
                 @"type": @(AMBubbleCellReceived),
                 @"username": @"Stevie",
                 @"color": [UIColor redColor]
                 },
                 @{
                 @"text": @"My dad isn’t famous. My dad plays jazz. You can’t get famous playing jazz",
                 @"date": [NSDate date],
                 @"type": @(AMBubbleCellSent)
                 },
                 @{
                 @"date": [NSDate date],
                 @"type": @(AMBubbleCellTimestamp)
                 },
                 @{
                 @"text": @"I'd far rather be happy than right any day.",
                 @"date": [NSDate date],
                 @"type": @(AMBubbleCellReceived),
                 @"username": @"John",
                 @"color": [UIColor orangeColor]
                 },
                 @{
                 @"text": @"The only reason for walking into the jaws of Death is so's you can steal His gold teeth.",
                 @"date": [NSDate date],
                 @"type": @(AMBubbleCellSent)
                 },
                 @{
                 @"text": @"The gods had a habit of going round to atheists' houses and smashing their windows.",
                 @"date": [NSDate date],
                 @"type": @(AMBubbleCellReceived),
                 @"username": @"Jimi",
                 @"color": [UIColor blueColor]
                 },
                 @{
                 @"text": @"you are lucky. Your friend is going to meet Bel-Shamharoth. You will only die.",
                 @"date": [NSDate date],
                 @"type": @(AMBubbleCellSent)
                 },
                 @{
                 @"text": @"Guess the quotes!",
                 @"date": [NSDate date],
                 @"type": @(AMBubbleCellSent)
                 },
                 ]
                 ];
  
    // Set a style
    [self setTableStyle:AMBubbleTableStyleFlat];
    
    // Call super after setting up the options
    [super viewDidLoad];

}

#pragma mark - SRIPickedContacts
- (void)selectedContacts:(NSArray *)contacts{
  self.needsToShowContactPicker = FALSE;
  NSLog(@"selectedContacts called.");
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
	return [UIImage imageNamed:@"avatar"];
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
