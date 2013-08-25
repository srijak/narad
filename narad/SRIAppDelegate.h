//
//  SRIAppDelegate.h
//  narad
//
//  Created by srjk on 8/10/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosquittoClient.h"

#import <TSocketClient.h>
#import <TBinaryProtocol.h>
#import "services.h"
#import "SRIMessage.h"

@interface SRIAppDelegate : UIResponder <UIApplicationDelegate,MosquittoClientDelegate>

@property (nonatomic, strong) MosquittoClient *mosquittoClient;

@property (nonatomic, strong) ApiClient *napi;

@property (strong, nonatomic) UIWindow *window;

-(void) connectToApi;
-(void) initializeApp;

@end
