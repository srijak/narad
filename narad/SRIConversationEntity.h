//
//  SRIConversationEntity.h
//  narad
//
//  Created by srjk on 8/15/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SRIConversationEntity : RHManagedObject

@property (nonatomic, retain) NSString * draft;
@property (nonatomic, retain) NSNumber * lastMessageSent;
@property (nonatomic, retain) NSString * lastMessageText;
@property (nonatomic, retain) NSNumber * messagesLength;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * topic_id;
@property (nonatomic, retain) NSNumber * unreadMessagesCount;

@end
