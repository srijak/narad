//
//  SRIMessagesViewController.m
//  narad
//
//  Created by srjk on 8/23/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIMessagesViewController.h"
#import "SRIMenuViewController.h"
#import "SRIRightViewController.h"
#import "SRIConversation.h"
#import "SRIConversationTopCell.h"
#import "RHCoreDataTableViewController.h"
#import "SRIChatViewController.h"
#import "RNFrostedSidebar.h"
#import "MZFormSheetController.h"

@interface SRIMessagesViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic) NSInteger selected_convo;

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation SRIMessagesViewController

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
 
  self.selected_convo = -1;
  [self.tableView setContentOffset:CGPointMake(0, 44)];

  NSLog(@"Messages view will appear");
  // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
  // You just need to set the opacity, radius, and color.
  self.view.layer.shadowOpacity = 0.75f;
  self.view.layer.shadowRadius = 10.0f;
  self.view.layer.shadowColor = [UIColor blackColor].CGColor;
  
  /*if (![self.slidingViewController.underLeftViewController isKindOfClass:[SRIMenuViewController class]]) {
    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  }*/
 
  self.slidingViewController.underLeftViewController  = nil;
  self.slidingViewController.underRightViewController = nil;
  
  //[self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)startNewMessage:(id)sender{
  
  UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NewConvoView"];
  
  //[self.navigationController pushViewController:vc animated:YES];

  
  MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
  
  formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
  formSheet.shadowRadius = 2.0;
  formSheet.shadowOpacity = 0.3;
  formSheet.shouldDismissOnBackgroundViewTap = YES;
  formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
  formSheet.portraitTopInset = 50.0;
  formSheet.formSheetWindow.transparentTouchEnabled = NO;
  [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    
  }];
  
}

- (IBAction)revealMenu:(id)sender
{
  
  //self.slidingViewController.anchorRightRevealAmount = 100.0f;
  //[self.slidingViewController anchorTopViewTo:ECRight];

  NSArray *images = @[
                      [UIImage imageNamed:@"profile"],
                      [UIImage imageNamed:@"star"],
                      [UIImage imageNamed:@"globe"],
                      [UIImage imageNamed:@"gear"],
                      ];
  NSArray *colors = @[
                      [UIColor peterRiverColor],
                      [UIColor alizarinColor],
                      [UIColor nephritisColor],
                      [UIColor concreteColor],
                      ];
  
  RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
  //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
  callout.delegate = self;
  //    callout.showFromRight = YES;
  [callout show];
}


- (IBAction)revealUnderRight:(id)sender
{
  
  NSLog(@"HHIIII");
 /* self.slidingViewController.anchorRightRevealAmount = 100.0f;
  [self.slidingViewController anchorTopViewTo:ECLeft];
*/
  
  
}





-(NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController == nil) {
		NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"lastMessageSent" ascending:YES];
    
		NSPredicate *predicate;
    
    if (self.searchString) {
      predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ", self.searchString];
    } else {
      predicate = [NSPredicate predicateWithFormat:@"1==1"];
    }
    
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:[SRIConversation entityDescription]];
    
		[fetchRequest setPredicate:predicate];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1, nil]];
		[fetchRequest setFetchBatchSize:20];
    
		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[SRIConversation managedObjectContextForCurrentThread]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
		fetchedResultsController.delegate = self;
    
    
    
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error]) {
			NSLog(@"Unresolved error: %@", [error localizedDescription]);
		}
  }
  
	return fetchedResultsController;
}

-(void)configureCell:(SRIConversationTopCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  
	SRIConversation *conv = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.groupImg.image =[UIImage imageNamed:@"sample"];
  cell.titleLabel.text = conv.title;
  cell.lastMessageSentLabel.text = [NSString stringWithFormat:@"%@",conv.lastMessageSent];
  cell.lastMessageTextLabel.text = conv.lastMessageText;
  cell.conversation_id = [conv.topic_id integerValue];
  if ([conv.topic_id intValue] % 2){
    [cell setComplete ];
  }else{
    [cell setPending];
  }
  
}

-(UIImage *)imageFromText:(NSString *)text
{
  // set the font type and size
  UIFont *font = [UIFont systemFontOfSize:20.0];
  CGSize size  = [text sizeWithFont:font];
  
  // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
  if (UIGraphicsBeginImageContextWithOptions != NULL)
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
  else
    // iOS is < 4.0
    UIGraphicsBeginImageContext(size);
  
  // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
  //
  // CGContextRef ctx = UIGraphicsGetCurrentContext();
  // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
  
  // draw in context, you can use also drawInRect:withFont:
  [text drawAtPoint:CGPointMake(0.0, 0.0) withFont:font];
  
  // transfer image
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
	SRIConversationTopCell *cell = (SRIConversationTopCell *)[self.tableView
                                    dequeueReusableCellWithIdentifier:@"ConversationTopCell"];
  
	[self configureCell:cell atIndexPath:indexPath];
  
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SRIConversationTopCell *cell = (SRIConversationTopCell*)[tableView cellForRowAtIndexPath:indexPath];
  self.selected_convo = cell.conversation_id;
  
  [self performSegueWithIdentifier:@"ChatView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"ChatView"]) {
    
    // Get destination view
    SRIChatViewController *vc = [segue destinationViewController];
    vc.topic_id = [NSNumber numberWithInteger:self.selected_convo];

    self.selected_convo = -1;
  }
}

-(void) viewDidLoad{
  [super viewDidLoad];
  
  [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
  [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
  [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
      self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
  [self addSearchBarWithPlaceHolder:@"Search conversation names"];
}


@end
