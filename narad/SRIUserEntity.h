//
//  SRIUserEntity.h
//  narad
//
//  Created by srjk on 8/11/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRIConversationEntity, SRIMessageEntity;

@interface SRIUserEntity : RHManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSSet *conversations;
@property (nonatomic, retain) SRIMessageEntity *messages;
@end

@interface SRIUserEntity (CoreDataGeneratedAccessors)

- (void)addConversationsObject:(SRIConversationEntity *)value;
- (void)removeConversationsObject:(SRIConversationEntity *)value;
- (void)addConversations:(NSSet *)values;
- (void)removeConversations:(NSSet *)values;

@end
