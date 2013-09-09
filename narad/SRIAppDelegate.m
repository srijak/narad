//
//  SRIAppDelegate.m
//  narad
//
//  Created by srjk on 8/10/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIAppDelegate.h"
#import "SRIConversation.h"
#import "MZFormSheetBackgroundWindow.h"

@implementation SRIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

  
  [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
  [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
  [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
  
  //[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
  UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar_bg"];
  [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];

  
  [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], UITextAttributeTextColor,
                                                         [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
                                                         [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                                         UITextAttributeTextShadowOffset,
                                                         [UIFont fontWithName:@"OpenSans" size:21.0], UITextAttributeFont, nil]];
  
  UIImage *backButtonImage = [[UIImage imageNamed:@"back_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, -1000) forBarMetrics:UIBarMetricsDefault];
  [self initializeApp];
  
  [self connectToApi];
  
  
  // Connect to mqtt only after we login to the main server.
  //[self connectToMqtt];
  
  return YES;
}

-(void) connectToApi{
  NSLog(@"Would try to connect to api");
  if (self.napi){
    self.napi = nil;
  }
  // Talk to a server via socket, using a binary protocol
  TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"localhost" port:19900];
  TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
  self.napi = [[ApiClient alloc] initWithProtocol:protocol];
  NSLog(@"Initialized thrift client.");
}

-(void) connectToMqtt{
  NSLog(@"Would try to connect to mqtt");
  if ([self mosquittoClient]){
    [self.mosquittoClient disconnect];
    self.mosquittoClient = nil;
  }
  
  self.mosquittoClient = [[MosquittoClient alloc] initWithClientId:@"testIos"];
  
  [self.mosquittoClient setDelegate:self];
  self.mosquittoClient.username = @"5405536232";
  self.mosquittoClient.password = @"a";
  self.mosquittoClient.port = 11883;
  [self.mosquittoClient connectToHost:@"localhost"];
}


-(void) initializeApp{
  // this needs to show the messages view.
  //  login to various things.
  // Note that logging in shouldn't block viewing current messages/groups.
  
  // FOR DEBUGGING. Create a bunch of messages in groups.
 
  
  for ( int i = 0; i < 40; i++){
    SRIMessage *s = [SRIMessage newEntity];
    [s setTimestamp:@123];
    [s setText:@"John"];
    [s setMessage_id:@"123:234:12312"];
    s.user_id = [NSNumber numberWithInt:(i%5)];
    s.topic_id = [NSNumber numberWithInt:(i%12)];
    
    [SRIMessage commit];
  }
  
  
  for ( int i = 0; i < 200; i++){
    SRIConversation *s = [SRIConversation newEntity];
    s.topic_id = [NSNumber numberWithInt:(i%12)];
    s.title = [NSString stringWithFormat:@"Convo %@", s.topic_id];
    s.lastMessageText = @"When an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum";
    s.lastMessageSent = [NSNumber numberWithInt:(1231231233 + (1000 * i))];
    
    [SRIConversation commit];
  }
  

  // END OF DEBUG LOAD
  
  // Now get initial data from server.
  // -- prolly will get:
  //         state: login failure? waiting on activation? etcs.
  //         subscription topics for groups
  //         subscription topics for users

  
  
  // Connect to mqtt and
  //   subscribe to the topics we care about.
  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





//---------MOsquittoClientDelegate -------

- (void) didConnect: (NSUInteger)code{
  NSLog(@"MQTT: didConnect: %d", code);
}
- (void) didDisconnect {
  NSLog(@"MQTT: DISCONNECTED");
}
- (void) didPublish: (NSUInteger)messageId{
  NSLog(@"MQTT: PUBLISHED: %d", messageId);
}


- (void) didReceiveMessage: (MosquittoMessage*)mosq_msg{
  NSLog(@"MQTT: RECV: %@\t%@", mosq_msg.topic, mosq_msg.payload);
}

- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos{
  NSLog(@"MQTT: SUBSCRIBED");
}
- (void) didUnsubscribe: (NSUInteger)messageId{
  NSLog(@"MQTT: UNSUBSCRIBED");
}

@end
