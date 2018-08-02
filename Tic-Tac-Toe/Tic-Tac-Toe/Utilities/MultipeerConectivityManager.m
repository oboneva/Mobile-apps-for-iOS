//
//  MultipeerConectivityManager.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 27.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MultipeerConectivityManager.h"
#import "Constants.h"

@interface MultipeerConectivityManager () <MCNearbyServiceBrowserDelegate>

@property(strong, nonatomic) NSDictionary *tempInfo;

@end

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
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID serviceType:SERVICE_TYPE];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
}

- (void)stopBrowsing {
    [self.browser stopBrowsingForPeers];
}

-(void)advertiseSelf:(BOOL)shouldAdvertise withDiscoveryInfo:(NSDictionary<NSString *, NSString *> *)discoveryInfo {
    if (shouldAdvertise) {
        self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID discoveryInfo:discoveryInfo serviceType:SERVICE_TYPE];
        self.advertiser.delegate = self;
        [self.advertiser startAdvertisingPeer];
    }
    else {
        [self.advertiser stopAdvertisingPeer];
        self.advertiser = nil;
    }
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state == MCSessionStateConnected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PEER_WILL_JOIN object:nil userInfo:self.tempInfo];
    }
}

//browser delegate
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info {
    NSDictionary *foundPeerInfo = @{@"peerID" : peerID, @"discoveryInfo" : info};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PEER_FOUND object:nil userInfo:foundPeerInfo];

}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSDictionary *lostPeer = @{@"peerID" : peerID};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PEER_LOST object:nil userInfo:lostPeer];
}

//accept
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    invitationHandler(YES, self.session);
    self.tempInfo = @{@"peerID" : peerID, @"playerName" : context};
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
