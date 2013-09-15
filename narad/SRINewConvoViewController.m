//
//  SRINewConvoViewController.m
//  narad
//
//  Created by srjk on 9/8/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRINewConvoViewController.h"
#import "SRIContactPickerViewController.h"
#import "SRIContactPickerCell.h"

/*#define kKeyboardHeight 0.0
#define kTopOffset 44.0
#define kLeftOffset 10.0
#define kRightOffset (kLeftOffset * 6)
#define kTopPadding 15.0
 */


#define kKeyboardHeight 0.0
#define kTopOffset 42.0
#define kLeftOffset 0.0
#define kRightOffset (kLeftOffset * 6)
#define kTopPadding 3.0





@interface SRINewConvoViewController ()

@property (strong, nonatomic) NSMutableArray* autocompleteUrls;
@property (strong, nonatomic) NSArray* pastUrls;


@end

@implementation SRINewConvoViewController
{
  ABAddressBookRef addressBook;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  // Custom initialization
  self.title = @"Compose";
  
  self.selectedContacts = [NSMutableArray array];
  
  [self adjustTableViewFrame];
  [self tableVisible:NO];
  
  addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
  
  // Check whether we are authorized to access the user's address book data
  [self checkAddressBookAccess];
  
}
-(void) tableVisible:(BOOL)v{
  if (v){
    [self.tableView reloadData];
  }

 /* [self.tableView setHidden:!v];
  [self.subjectText setHidden:v];
  [self.messageText setHidden:v];
*/
  [self setViewHidden:!v view:self.tableView];
 
//  [self setViewHidden:v view:self.subjectText];
  [self setViewHidden:v view:self.messageText];
  
  }


-(void) setViewHidden:(BOOL)hidden view:(UIView*)the_view{
  
  [the_view setHidden:hidden];
  
  float alpha = 1.0;
  if (hidden){
    alpha = 0.0;
  }
  
  the_view.alpha = 1-alpha;
  
  [UIView animateWithDuration:0.4 animations:^() {
      the_view.alpha = alpha;
    }];

}
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  //    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(removeAllContacts:)];
 /*
 
  
  self.navigationItem.leftBarButtonItem = cancelButton;
  self.navigationItem.rightBarButtonItem = doneButton;
*/
  UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-(35), 40)];
  /*UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
  UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
   */
  [naviBarObj setBackgroundImage:[UIImage imageNamed:@"navbar_bg_modal"] forBarMetrics:UIBarMetricsDefault];
  
  UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"Compose"];
 
  /*
  UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"ok" style:UIBarButtonItemStylePlain target:self action:@selector(doneSelecting:)];
  navigItem.rightBarButtonItem = doneButton;
  
 // UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelecting:)];
 // navigItem.leftBarButtonItem = cancelButton;
  */
  
  naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
  [naviBarObj setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor blackColor], UITextAttributeTextColor,
                                                         [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2],UITextAttributeTextShadowColor,
                                                         [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                       UITextAttributeTextShadowOffset, [UIFont fontWithName:@"OpenSans" size:21.0], UITextAttributeFont, nil]];

  [self.view addSubview:naviBarObj];
  
  

  // Initialize and add Contact Picker View
  float width = self.view.frame.size.width - kRightOffset;
  
  self.contactPickerView = [[SRIContactPickerView alloc] initWithFrame:CGRectMake(kLeftOffset, kTopOffset, width, 100)];
  self.contactPickerView.delegate = self;
  [self.contactPickerView setPlaceholderString:@"To:"];
  [self.view addSubview:self.contactPickerView];
  
  // Fill the rest of the view with the table view
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftOffset, self.contactPickerView.frame.size.height + self.contactPickerView.frame.origin.y, width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight) style:UITableViewStylePlain];
  /*self.tableView.frame = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight);
   */
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView setAllowsSelection:YES];
  [self.tableView registerNib:[UINib nibWithNibName:@"ContactPickerCell" bundle:nil] forCellReuseIdentifier:@"ContactPickerCell"];
  self.tableView.separatorColor = [UIColor clearColor];

  [self.view insertSubview:self.tableView belowSubview:self.contactPickerView];
  
  /*self.subjectText = [[UITextField alloc] initWithFrame:CGRectMake(kLeftOffset, kTopPadding, width, 40)];
  [self.subjectText setPlaceholder:@"Subject:"];
  self.subjectText.backgroundColor = [UIColor whiteColor];
  [self.subjectText setBorderStyle:UITextBorderStyleNone];
  
  [self.view insertSubview:self.subjectText belowSubview:self.contactPickerView];
*/
  
  
  //TODO make the message text view appear nicely.
  
  // Top border
 
  self.messageText = [[UITextView alloc] initWithFrame:CGRectMake(kLeftOffset, self.contactPickerView.frame.origin.y + self.contactPickerView.frame.size.height+ kTopPadding, width, 100)];
  [self.messageText setText:@"Hi, "];
  [self.messageText setBackgroundColor:[UIColor whiteColor]];
  
  [self.view insertSubview:self.messageText belowSubview:self.contactPickerView];
  [self.view addSubview:self.messageText];
  
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)adjustTableViewFrame {
  CGRect frame = self.tableView.frame;
  frame.origin.y = self.contactPickerView.frame.size.height + self.contactPickerView.frame.origin.y;
  frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
  self.tableView.frame = frame;
  
  /*frame = self.subjectText.frame;
  frame.origin.y = self.contactPickerView.frame.size.height + self.contactPickerView.frame.origin.y;
  self.subjectText.frame = frame;
  */
  
  frame = self.messageText.frame;
  frame.origin.y = self.contactPickerView.frame.size.height + self.contactPickerView.frame.origin.y + kTopPadding;

  frame.size.height = [self.messageText contentSize].height + 40;
  self.messageText.frame = frame;
  
   [self tableVisible:YES];
  
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
    cell.avatar.image= [UIImage imageWithData:CFBridgingRelease(imageData)];
  }else{
    cell.avatar.image= [UIImage imageNamed: @"contact_picker_cell_def_avatar"];
  }
  
  
  UIImage * background = [UIImage imageNamed: @"contact_cell_bg"];
  
  if ([self.selectedContacts containsObject:user]){
    background = [UIImage imageNamed: @"contact_cell_bg_sel"];
    [cell.name setTextColor:[UIColor whiteColor]];
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
  //[self.tableView reloadData];
  [self tableVisible:NO];
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
  if ([self.filteredContacts count] > 0){
    [self tableVisible:YES];
  }else{
    [self tableVisible:NO];
  }
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
  SRINewConvoViewController* __weak weakSelf = self;
  
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
  [self tableVisible:YES];
}


- (void)selectedContacts:(NSArray *)contacts{
  NSLog(@"Selected contacts: %@", contacts);
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
if ([string isEqualToString:@"StackO"]) {
  textField.text=@"StackOverflow";
}
return YES;
}*/

@end
