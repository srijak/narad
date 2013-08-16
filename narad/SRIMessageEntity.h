//
//  SRIMessageEntity.h
//  narad
//
//  Created by srjk on 8/15/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SRIMessageEntity : RHManagedObject

@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * message_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * topic_id;

@end
