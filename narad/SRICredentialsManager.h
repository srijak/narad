//
//  SRICredentialsManager.h
//  narad
//
//  Created by srjk on 8/19/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRISingleton.h"

@interface SRICredentialsManager : SRISingleton


+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error;
+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
@end
