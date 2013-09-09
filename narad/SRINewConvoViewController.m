//
//  SRINewConvoViewController.m
//  narad
//
//  Created by srjk on 9/8/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRINewConvoViewController.h"

@interface SRINewConvoViewController ()

@end

@implementation SRINewConvoViewController

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
	// Do any additional setup after loading the view.
  self.contactPickerView.delegate = self;
  [self.contactPickerView setPlaceholderString:@"To: "];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor blackColor],UITextAttributeTextColor, nil];
  
  //                                           [UIColor blackColor], UITextAttributeTextShadowColor,
  //                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset, nil];
  
  [self.navigationController.navigationBar  setTitleTextAttributes:navbarTitleTextAttributes];
  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
  
 
 }


-(IBAction)showContactPicker:(id)sender{
  [self performSegueWithIdentifier:@"AddContactToNewConvo" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"AddContactToNewConvo"]) {
    
    // Get destination view
    SRIContactPickerViewController *vc = [segue destinationViewController];
    vc.delegate = self;
    
  }
}

-(IBAction) cancel:(id)sender{
  
}
-(IBAction) start:(id)sender{
  
}

#pragma mark - SRIPickedContacts
- (void)selectedContacts:(NSArray *)contacts{
  NSLog(@"selectedContacts called.");
  NSLog(@" contacts: %@", contacts);
  for (int i=0; i < [contacts count]; i++) {
    [self.contactPickerView addContact:contacts[i] withName:@"Srijak Rijal"];
    NSLog(@" added: %@", contacts[i]);
    
  }

}

#pragma mark - SRIContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
  NSLog(@"textViewText: %@", textViewText );
}

- (void)contactPickerDidResize:(SRIContactPickerView *)contactPickerView {
  NSLog(@"Adjust other views since this one resized.");
}

- (void)contactPickerDidRemoveContact:(id)contact {
  /*[self.selectedContacts removeObject:contact];
  
  int index = [self.contacts indexOfObject:contact];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
  cell.accessoryType = UITableViewCellAccessoryNone;*/
  NSLog(@"Removed contact.");
}

- (void)cancelSelecting:(id)sender
{
  [self doneSelecting:sender];
}
- (void)doneSelecting:(id)sender
{
  /*[self.contactPickerView removeAllContacts];
   [self.selectedContacts removeAllObjects];
   [self copyContactsToFiltered];
   [self.tableView reloadData];
   */
  
  NSLog(@"DONE SELECTING");
  
}

@end
