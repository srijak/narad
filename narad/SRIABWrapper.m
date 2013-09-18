//
//  SRIABWrapper.m
//  narad
//
//  Created by srjk on 9/17/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIABWrapper.h"

@implementation SRIABWrapper
{
  ABAddressBookRef addressBook;
}
- (id)init
{
  self = [super init]; //calls init because UIResponder has no custom init methods
  if (self){
    [self setup];
  }
  return self;
}

-(void) setup{
  addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
}
// Prompt the user for access to their Address Book data
- (void)requestAddressBookAccess
{
  SRIABWrapper* __weak weakSelf = self;
  
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

// This method is called when the user has granted access to their address book data.
- (void)accessGrantedForAddressBook
{
	self.contacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
}

-(NSArray*) getContacts{
  if (self.contacts == nil){
    [self accessGrantedForAddressBook];
  }
  
  return [NSArray arrayWithArray:self.contacts];
}

-(ABRecordRef) getContact:(ABRecordID) pid{
  return ABAddressBookGetPersonWithRecordID(addressBook, pid);
}
-(void) requestAccess:(id) requester {
  switch (ABAddressBookGetAuthorizationStatus())
  {
      // Update our UI if the user has granted access to their Contacts
    case kABAuthorizationStatusAuthorized:
      if ([requester respondsToSelector:@selector(ABRequestGranted)]){
        [requester ABRequestGranted];
      }
      break;
      // Prompt the user for access to Contacts if there is no definitive answer
    case kABAuthorizationStatusNotDetermined :
      {
        // Prompt the user for access to their Address Book data
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                   if (granted)
                                                   {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                       if ([requester respondsToSelector:@selector(ABRequestGranted)]){
                                                         [requester ABRequestGranted];
                                                       }
                                                     });
                                                   }
                                                 });
      }
      break;      
      // Display a message if the user has denied or restricted access to Contacts
    case kABAuthorizationStatusDenied:
    case kABAuthorizationStatusRestricted:
      if ([requester respondsToSelector:@selector(ABRequestDenied)]){
        [requester ABRequestDenied];
      }
      break;
    default:
      break;

  }
}
@end
