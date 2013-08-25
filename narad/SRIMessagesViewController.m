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

@interface SRIMessagesViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic) NSInteger selected_convo;
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
  
  if (![self.slidingViewController.underLeftViewController isKindOfClass:[SRIMenuViewController class]]) {
    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  }
  
/*  if (![self.slidingViewController.underRightViewController isKindOfClass:[SRIRightViewController class]]) {
    self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Right"];
  }
  */
  [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (IBAction)revealMenu:(id)sender
{
  [self.slidingViewController anchorTopViewTo:ECRight];
}


- (IBAction)revealUnderRight:(id)sender
{

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
  
  cell.titleLabel.text = conv.title;
  cell.lastMessageSentLabel.text = [NSString stringWithFormat:@"%@",conv.lastMessageSent];
  cell.lastMessageTextLabel.text = conv.lastMessageText;
  cell.conversation_id = [conv.topic_id integerValue];
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
  [self addSearchBarWithPlaceHolder:@"Search conversation names"];
}



/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/
@end
