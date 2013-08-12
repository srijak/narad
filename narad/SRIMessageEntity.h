//
//  SRIMessageEntity.h
//  narad
//
//  Created by srjk on 8/11/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SRIConversationEntity, SRIUserEntity;

@interface SRIMessageEntity : RHManagedObject

@property (nonatomic) NSTimeInterval sentDate;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) SRIUserEntity *author;
@property (nonatomic, retain) SRIConversationEntity *conversation;

@end
