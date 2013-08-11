//
//  SRIViewController.m
//  narad
//
//  Created by srjk on 8/10/13.
//  Copyright (c) 2013 srjk. All rights reserved.
//

#import "SRIViewController.h"
#import "MosquittoClient.h"

#import <TSocketClient.h>
#import <TBinaryProtocol.h>
#import "services.h"

@interface SRIViewController ()<MosquittoClientDelegate>
@property (nonatomic, strong) UITextField IBOutlet  *username;
@property (nonatomic, strong) IBOutlet UITextField *passwd;
@property (nonatomic, strong) IBOutlet UITextField *topics;

@property (nonatomic, strong) IBOutlet UITextField *activation_code;
@property (nonatomic, strong) IBOutlet UITextField *toPublish;


@property (nonatomic, strong) MosquittoClient *mosquittoClient;

@property (nonatomic, strong) ApiClient *napi;
@end

@implementation SRIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectButton:(id)sender{
  NSLog(@"Connect tapped.");
  if ([self mosquittoClient]){
    [self.mosquittoClient disconnect];
    self.mosquittoClient = nil;
  }
  
  self.mosquittoClient = [[MosquittoClient alloc] initWithClientId:@"testIos"];
  
  [self.mosquittoClient setDelegate:self];
  self.mosquittoClient.username = self.username.text;
  self.mosquittoClient.password = self.passwd.text;
  self.mosquittoClient.port = 11883;
  [self.mosquittoClient connectToHost:@"localhost"];
}

- (IBAction)subscribe:(id)sender{
  [self.mosquittoClient subscribe:self.topics.text withQos:0];
}
- (IBAction)publish:(id)sender{
  [self.mosquittoClient publishString:self.toPublish.text toTopic:self.topics.text withQos:0 retain:FALSE];
}

- (IBAction)connectToThrift:(id)sender{
  if (self.napi){
    self.napi = nil;
  }
  // Talk to a server via socket, using a binary protocol
  TSocketClient *transport = [[TSocketClient alloc] initWithHostname:@"localhost" port:19900];
  TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
  self.napi = [[ApiClient alloc] initWithProtocol:protocol];
  NSLog(@"Initialized thrift client.");
}
- (IBAction) activateRegistration:(id)sender{
 
  if (self.napi == nil){
    [self connectToThrift:nil];
  }
  
  int res = [self.napi activate:self.username.text activation_code:self.activation_code.text];
 //TODO: Generate and send the client's public key to the server here for SSL communications for here on out?
  
  NSLog(@"Result from trying to activate: %d ", res);
}



//---------MOsquittoClientDelegate -------

- (void) didConnect: (NSUInteger)code{
  NSLog(@"didConnect: %d", code);
}
- (void) didDisconnect {
    NSLog(@"DISCONNECTED");
}
- (void) didPublish: (NSUInteger)messageId{
  NSLog(@"PUBLISHED: %d", messageId);
}


- (void) didReceiveMessage: (MosquittoMessage*)mosq_msg{
  NSLog(@"RECV: %@\t%@", mosq_msg.topic, mosq_msg.payload);
}

- (void) didSubscribe: (NSUInteger)messageId grantedQos:(NSArray*)qos{
  NSLog(@"SUBSCRIBED");
}
- (void) didUnsubscribe: (NSUInteger)messageId{
    NSLog(@"UNSUBSCRIBED");
}
@end
