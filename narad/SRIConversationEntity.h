//
//  SRIConversationEntity.h
//  narad
//
//  Created by srjk on 8/11/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRIMessageEntity, SRIUserEntity;

@interface SRIConversationEntity : RHManagedObject

@property (nonatomic, retain) NSString * draft;
@property (nonatomic) NSTimeInterval lastMessageSentDate;
@property (nonatomic, retain) NSString * lastMessageText;
@property (nonatomic) int32_t messagesLength;
@property (nonatomic, retain) NSString * title;
@property (nonatomic) int64_t topic_id;
@property (nonatomic) int16_t unreadMessagesCount;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) NSSet *users;
@end

@interface SRIConversationEntity (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(SRIMessageEntity *)value;
- (void)removeMessagesObject:(SRIMessageEntity *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

- (void)addUsersObject:(SRIUserEntity *)value;
- (void)removeUsersObject:(SRIUserEntity *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
