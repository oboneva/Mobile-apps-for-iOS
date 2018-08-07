//
//  MultipeerConectivityManager.m
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 27.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import "MultipeerConectivityManager.h"
#import "Constants.h"
#import "Protocols.h"

@interface MultipeerConectivityManager () <MCNearbyServiceBrowserDelegate>

@property(strong, nonatomic) NSDictionary *tempInfo;

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceBrowser *browser;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

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

-(void)startBrowsing {
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID serviceType:SERVICE_TYPE];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
}

- (void)stopBrowsing {
    [self.browser stopBrowsingForPeers];
}

- (void)stopAdvertising {
    [self.advertiser stopAdvertisingPeer];
    self.advertiser = nil;
}

-(void)startAdvertisingWithDiscoveryInfo:(NSDictionary<NSString *, NSString *> *)discoveryInfo {
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID discoveryInfo:discoveryInfo serviceType:SERVICE_TYPE];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];
}

-(void)invitePeer:(MCPeerID *)peerID {
    [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:30];
}

- (void)sendData:(NSData *)data toPeer:(MCPeerID *)peerID {
    NSError *error;
    [self.session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:&error];
}

- (void)disconnectPeer {
    [self.session disconnect];
}

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    if (state != MCSessionStateConnecting) {
            [self.peerSessionDelegate peer:(peerID) changedState:state];
    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)info {
    [self.peerSearchDelegate didFoundPeer:peerID withInfo:info];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    [self.peerSearchDelegate didLostPeer:peerID];
}

//accept
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    invitationHandler(YES, self.session);
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    [self.peerSessionDelegate didReceiveData:data fromPeer:peerID];
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

@end
