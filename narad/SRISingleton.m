//
//  SRISingleton.m
//  narad
//
//  Created by srjk on 8/19/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRISingleton.h"

@implementation SRISingleton

#pragma mark Singleton Methods
+ (id) singleton{
  static SRISingleton *shared = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[self alloc] init];
  });
  
  return shared;
}

- (id) init {
  self = [super init];
  return self;
}
@end
