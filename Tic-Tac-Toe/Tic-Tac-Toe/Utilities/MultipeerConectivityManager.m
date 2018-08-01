//
//  MultipeerConectivityManager.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 27.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MultipeerConectivityManager.h"
#import "Constants.h"

@implementation MultipeerConectivityManager

+ (instancetype)sharedInstance
{
    static MultipeerConectivityManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MultipeerConectivityManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.peerID = nil;
        self.session = nil;
        self.browser = nil;
        self.advertiser = nil;
    }
    return self;
}

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName {
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

-(void)setupMCBrowser {
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:self.session];
}

-(void)advertiseSelf:(BOOL)shouldAdvertise withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)discoveryInfo {
    if (shouldAdvertise) {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:discoveryInfo session:self.session];
        [self.advertiser start];
    }
    else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSDictionary *userInfo = @{@"peerID" : peerID, @"state" : [NSNumber numberWithInt:state]};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHANGED_STATE object:nil userInfo:userInfo];
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NSDictionary *message = @{@"peerID" : peerID, @"data" : data};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RECEIVE_DATA object:nil userInfo:message];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

@end
