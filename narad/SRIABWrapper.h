//
//  SRIABWrapper.h
//  narad
//
//  Created by srjk on 9/17/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol SRIABDelegate <NSObject>
- (void)ABRequestGranted;
- (void)ABRequestDenied;

@end


@interface SRIABWrapper : NSObject
@property (nonatomic, strong) NSArray *contacts;

-(void) requestAccess:(id) delegate;
-(NSArray*) getContacts;
-(ABRecordRef) getContact:(ABRecordID) pid;
@end
