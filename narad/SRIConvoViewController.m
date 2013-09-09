//
//  SRIConvoViewController.m
//  narad
//
//  Created by srjk on 9/7/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIConvoViewController.h"
#import "SRIMessage.h"
#import "SRIConvoMessageCell.h"

@interface SRIConvoViewController ()
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic) NSInteger selected_convo;

@end

@implementation SRIConvoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.tableView.separatorColor =[UIColor clearColor];
  self.topic_id = @10;
    [self addSearchBarWithPlaceHolder:@"Search messages"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - RHCoreDataTableViewController

-(NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController == nil) {
		NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    
		NSPredicate *predicate;
    
    if (self.searchString) {
      predicate = [NSPredicate predicateWithFormat:@"text CONTAINS[cd] %@ AND topic_id=%@", self.searchString, self.topic_id];
    } else {
      predicate = [NSPredicate predicateWithFormat:@"topic_id=%@", self.topic_id];
    }
    
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:[SRIMessage entityDescription]];
    
		[fetchRequest setPredicate:predicate];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sort1, nil]];
		[fetchRequest setFetchBatchSize:20];
    
		self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[SRIMessage managedObjectContextForCurrentThread]
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

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
	SRIConvoMessageCell *cell = (SRIConvoMessageCell *)[self.tableView
                                                            dequeueReusableCellWithIdentifier:@"ConvoMessageCell"];
  
	[self configureCell:cell atIndexPath:indexPath];
  
	return cell;
}

-(void)configureCell:(SRIConvoMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  
	SRIMessage *msg = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.avatar.image = [UIImage imageNamed:@"sample"];
  cell.name.text = [NSString stringWithFormat:@"%@",msg.user_id];
  cell.message.text = msg.text;
  cell.timestamp.text =[NSString stringWithFormat:@"%@", msg.timestamp];
  cell.message_id = msg.message_id;
  
  /*cell.groupImg.image =[UIImage imageNamed:@"sample"];

  if ([conv.topic_id intValue] % 2){
    [cell setComplete ];
  }else{
    [cell setPending];
  }
   
   */
  
}
@end
