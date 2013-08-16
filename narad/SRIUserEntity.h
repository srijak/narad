//
//  SRIUserEntity.h
//  narad
//
//  Created by srjk on 8/15/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SRIUserEntity : RHManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * topic_id;

@end
