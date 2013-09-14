//
//  SRIContactPickerViewController.m
//  narad
//
//  Created by srjk on 8/26/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//


#import "SRIContactPickerViewController.h"
#import "SRIContactPickerCell.h"

@interface SRIContactPickerViewController ()

@end

#define kKeyboardHeight 0.0

@implementation SRIContactPickerViewController
{
  ABAddressBookRef addressBook;
 }

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
    // Custom initialization
    self.title = @"Select Contact(s)";
  
    self.selectedContacts = [NSMutableArray array];
  
    [self adjustTableViewFrame];
  
  
  addressBook = ABAddressBookCreateWithOptions(NULL, NULL);

  // Check whether we are authorized to access the user's address book data
  [self checkAddressBookAccess];

}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  //    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(removeAllContacts:)];
  
  UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneSelecting:)];
  
  UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelecting:)];
  
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationItem.rightBarButtonItem = doneButton;
  
  // Initialize and add Contact Picker View
  self.contactPickerView = [[SRIContactPickerView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 100)];
  self.contactPickerView.delegate = self;
  [self.contactPickerView setPlaceholderString:@"Enter name or number"];
  [self.view addSubview:self.contactPickerView];
  
  // Fill the rest of the view with the table view
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight) style:UITableViewStylePlain];
  /*self.tableView.frame = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight);
    */               
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView setAllowsSelection:YES];
  [self.tableView registerNib:[UINib nibWithNibName:@"ContactPickerCell" bundle:nil] forCellReuseIdentifier:@"ContactPickerCell"];
  [self.view insertSubview:self.tableView belowSubview:self.contactPickerView];

}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)adjustTableViewFrame {
  CGRect frame = self.tableView.frame;
  frame.origin.y = self.contactPickerView.frame.size.height;
  frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
  self.tableView.frame = frame;
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
    [cell.avatar setImage:[UIImage imageNamed: @"contact_picker_cell_def_avatar.png"]];
  }
  
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  NSNumber * user = [self.filteredContacts objectAtIndex:indexPath.row] ;
  
  if ([self.selectedContacts containsObject:user]){ // contact is already selected so remove it from ContactPickerView
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self.selectedContacts removeObject:user];
    [self.contactPickerView removeContact:user];
  } else {
    // Contact has not been selected, add it to SRIContactPickerView
    [self.selectedContacts addObject:user];
    
    ABRecordID abRecordID = [user intValue];
    
    ABRecordRef abPerson = ABAddressBookGetPersonWithRecordID(addressBook, abRecordID);
    
    NSString * username = (__bridge_transfer NSString *)ABRecordCopyCompositeName(abPerson);
    [self.contactPickerView addContact:user withName:username];
  }
  
  [self copyContactsToFiltered];
  [self.tableView reloadData];
}

#pragma mark - SRIContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
  [self.filteredContacts removeAllObjects];
  if ([textViewText isEqualToString:@""]){
    [self copyContactsToFiltered];
  } else {
    
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains[cd] %@", textViewText];
    
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

- (void)contactPickerDidResize:(SRIContactPickerView *)contactPickerView {
  [self adjustTableViewFrame];
}

- (void)contactPickerDidRemoveContact:(id)contact {
  [self.selectedContacts removeObject:contact];
  
  int index = [self.contacts indexOfObject:contact];
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
  cell.accessoryType = UITableViewCellAccessoryNone;
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
  [self.view endEditing:YES];
  [self.navigationController popViewControllerAnimated:YES];
  if ([self.delegate respondsToSelector:@selector(selectedContacts:)])
  {
    NSLog(@"CALLING DELEGATE SELECTING");
    [self.delegate selectedContacts:self.selectedContacts];
  }

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
  SRIContactPickerViewController* __weak weakSelf = self;
  
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
