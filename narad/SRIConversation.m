//
//  SRIConversation.m
//  narad
//
//  Created by srjk on 8/11/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIConversation.h"

@implementation SRIConversation

// This returns the name of the Entity it extends (basically the name of the superclass)
+(NSString *)entityName {
  return @"SRIConversationEntity";
}

// This returns the name of your xcdatamodeld model, without the extension
+(NSString *)modelName {
  return @"Narad";
}

@end
