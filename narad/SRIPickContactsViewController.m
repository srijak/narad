//
//  SRIPickContactsViewController.m
//  narad
//
//  Created by srjk on 9/15/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIPickContactsViewController.h"
#import "SRIContactPickerCell.h"
#import "NSString+FontAwesome.h"

@interface SRIPickContactsViewController ()

@end

#define kKeyboardHeight 0.0

@implementation SRIPickContactsViewController
{
  ABAddressBookRef addressBook;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Custom initialization
  self.title = @"Select Recipient(s)";
  
  self.selectedContacts = [NSMutableArray array];
  
  [self adjustTableViewFrame];
  
  
  addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
  
  // Check whether we are authorized to access the user's address book data
  [self checkAddressBookAccess];
  
}

-(void) setNavItemFontToAwesome:(UIBarButtonItem*) v size:(float)sz{
  [v  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"FontAwesome" size:sz], UITextAttributeFont,
    [UIColor whiteColor], UITextAttributeTextColor,  nil] forState:UIControlStateNormal];
}
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  //    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(removeAllContacts:)];
  
  self.view.backgroundColor = [UIColor cloudsColor];


  //Navigation bar
  UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForEnum:FAIconOk] style:UIBarButtonItemStylePlain target:self action:@selector(doneSelecting:)];
  [self setNavItemFontToAwesome:doneButton size:20];
  
  UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForEnum:FAIconDoubleAngleLeft] style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelecting:)];
  [self setNavItemFontToAwesome:cancelButton size:24];
  
  UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
  [self.view addSubview:naviBarObj];

  UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"Add Recipient(s)"];


  navigItem.rightBarButtonItem = doneButton;
  navigItem.leftBarButtonItem = cancelButton;
  naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
  [naviBarObj setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
  [naviBarObj setBackgroundColor:[UIColor peterRiverColor]];

  
  // Initialize and add Contact Picker View
  self.contactPickerView = [[UILabel alloc] initWithFrame:CGRectMake(0, naviBarObj.frame.size.height+naviBarObj.frame.origin.y, self.view.frame.size.width, 0)];
  [self.view addSubview:self.contactPickerView];
  
  // Fill the rest of the view with the table view
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height+self.contactPickerView.frame.origin.y , self.view.frame.size.width+36, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight) style:UITableViewStylePlain];
  
  //self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight) style:UITableViewStylePlain];
  /*self.tableView.frame = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight);
   */
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView setAllowsSelection:YES];
  self.tableView.separatorColor = [UIColor clearColor];
  self.tableView.backgroundColor = [UIColor cloudsColor];
  [self.tableView registerNib:[UINib nibWithNibName:@"ContactPickerCell" bundle:nil] forCellReuseIdentifier:@"ContactPickerCell"];
  [self.view insertSubview:self.tableView belowSubview:self.contactPickerView];
  
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)adjustTableViewFrame {
  /*
   CGRect frame = self.tableView.frame;
  frame.origin.y = self.contactPickerView.frame.size.height;
  frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
  self.tableView.frame = frame;
   */
}

#pragma mark - UITableView Delegate and Datasource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.filteredContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
  SRIContactPickerCell *cell = (SRIContactPickerCell *)[self.tableView
                                                        dequeueReusableCellWithIdentifier:@"ContactPickerCell"];
  
	
  
  NSNumber * user = [self.filteredContacts objectAtIndex:indexPath.row] ;
  
  ABRecordID abRecordID = [user intValue];
  
  ABRecordRef abPerson = ABAddressBookGetPersonWithRecordID(addressBook, abRecordID);
  CFDataRef imageData = ABPersonCopyImageData(abPerson);
  //  CFRelease(imageData); <<-- TODO: is this required?
  
  cell.name.text = (__bridge_transfer NSString *)ABRecordCopyCompositeName(abPerson);
  // TODO: VERIFY IMAGE SETTING WORKS.
  if (imageData != nil){
    [cell.avatar setImage: [UIImage imageWithData:CFBridgingRelease(imageData)]];
  }else{
    [cell.avatar setImage:[UIImage imageNamed: @"contact_picker_cell_def_avatar"]];
  }
  
  UIImage * background = [UIImage imageNamed: @"contact_cell_bg"];
  
  if ([self.selectedContacts containsObject:user]){
    background = [UIImage imageNamed: @"contact_cell_bg_sel"];
    [cell.name setTextColor:[UIColor blackColor]];
  }else{
    [cell.name setTextColor:[UIColor blackColor]];
    
  }
  CGRect frame = cell.frame;
  frame.size.width = self.tableView.frame.size.width - 60;
  cell.frame = frame;
  
  
  
  UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
  cellBackgroundView.image = background;
  cell.backgroundView = cellBackgroundView;
  

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  NSNumber * user = [self.filteredContacts objectAtIndex:indexPath.row] ;
  
  if ([self.selectedContacts containsObject:user]){ // contact is already selected so remove it from ContactPickerView
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self.selectedContacts removeObject:user];
    [self removeContact:user];
  } else {
    // Contact has not been selected, add it to SRIContactPickerView
    [self.selectedContacts addObject:user];
    
    ABRecordID abRecordID = [user intValue];
    
    ABRecordRef abPerson = ABAddressBookGetPersonWithRecordID(addressBook, abRecordID);
    
    NSString * username = (__bridge_transfer NSString *)ABRecordCopyCompositeName(abPerson);
    [self addContact:user withName:username];
  }
  
  [self copyContactsToFiltered];
  [self.tableView reloadData];
}
-(void) removeContact:(id)c{
  
  NSLog(@"Remove contact.");
}
-(void) addContact:(id)c withName:(NSString*) name {
 
  NSLog(@"Add contact.");
}

#pragma mark - SRIContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
  [self.filteredContacts removeAllObjects];
  if ([textViewText isEqualToString:@""]){
    [self copyContactsToFiltered];
  } else {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF beginswith[cd] %@)", textViewText];
    
    for (id record in self.contacts)
    {
      ABRecordRef person = (__bridge ABRecordRef)record;
      
      NSString *compositeName = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
      NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
      NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
      NSString *phone = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonOrganizationProperty);
      
      // Match by name or organization
      if ([predicate evaluateWithObject:compositeName] ||
          [predicate evaluateWithObject:firstName] ||
          [predicate evaluateWithObject:lastName] ||
          [predicate evaluateWithObject:phone])
      {
        ABRecordID abRecordID = ABRecordGetRecordID(person);
        
        // Add the matching abRecordID to filteredPeople
        [self.filteredContacts addObject:[NSNumber numberWithInt:abRecordID]];
      }
    }
    
    
  }
  [self.tableView reloadData];
}


- (void)contactPickerDidRemoveContact:(id)contact {
  [self.selectedContacts removeObject:contact];
  
  int index = [self.contacts indexOfObject:contact];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
  cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)cancelSelecting:(id)sender
{
  [self.selectedContacts removeAllObjects];
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
  NSLog(@"Selected contacts: %@", self.selectedContacts);
  [self.view endEditing:YES];
  
  if ([self.delegate respondsToSelector:@selector(selectedContacts:)])
  {
    NSLog(@"CALLING DELEGATE SELECTING");
    [self.delegate selectedContacts:self.selectedContacts];
  }
  
  //[[self.presentingViewController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
  //[self performSegueWithIdentifier:@"unwindPickContact" sender:self];
  [self dismissViewControllerAnimated:YES completion: nil];
  
}

- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue{
  
  //unwindPickContact

}




#pragma mark - Address Book access

// Check the authorization status of our application for Address Book
- (void)checkAddressBookAccess
{
  switch (ABAddressBookGetAuthorizationStatus())
  {
      // Update our UI if the user has granted access to their Contacts
    case kABAuthorizationStatusAuthorized:
      [self accessGrantedForAddressBook];
      break;
      // Prompt the user for access to Contacts if there is no definitive answer
    case kABAuthorizationStatusNotDetermined :
      [self requestAddressBookAccess];
      break;
      // Display a message if the user has denied or restricted access to Contacts
    case kABAuthorizationStatusDenied:
    case kABAuthorizationStatusRestricted:
    {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Privacy Warning", @"Privacy Warning")
                                                      message:NSLocalizedString(@"Permission was not granted for Contacts.", @"Permission was not granted for Contacts.")
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
      [alert show];
    }
      break;
    default:
      break;
  }
}

// Prompt the user for access to their Address Book data
- (void)requestAddressBookAccess
{
  SRIPickContactsViewController* __weak weakSelf = self;
  
  ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                           {
                                             if (granted)
                                             {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakSelf accessGrantedForAddressBook];
                                                 
                                               });
                                             }
                                           });
}

-(void) copyContactsToFiltered{
  if (self.filteredContacts){
    [self.filteredContacts removeAllObjects];
  }else{
	  self.filteredContacts = [NSMutableArray array];
  }
  for (id record in self.contacts)
  {
    ABRecordRef person = (__bridge ABRecordRef)record;
    ABRecordID abRecordID = ABRecordGetRecordID(person);
    [self.filteredContacts addObject:[NSNumber numberWithInt:abRecordID]];
  }
  
}
// This method is called when the user has granted access to their address book data.
- (void)accessGrantedForAddressBook
{
	self.contacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
  // Create a filtered list that will contain people for the search results table.
  [self copyContactsToFiltered];
}

@end
