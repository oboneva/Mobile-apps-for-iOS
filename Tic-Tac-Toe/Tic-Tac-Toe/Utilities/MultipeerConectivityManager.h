//
//  MultipeerConectivityManager.h
//  Tic-Tac-Toe
//
//  Created by Ognyanka Boneva on 27.07.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "Protocols.h"

@interface MultipeerConectivityManager : NSObject <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate>

@property (weak, nonatomic)id<PeerSearchDelegate> peerSearchDelegate;
@property (weak, nonatomic)id<PeerSessionDelegate> peerSessionDelegate;

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)startBrowsing;
-(void)stopBrowsing;
-(void)startAdvertisingWithDiscoveryInfo:(NSDictionary<NSString *,NSString *> *)discoveryInfo;
-(void)stopAdvertising;
-(void)invitePeer:(MCPeerID *)peerID;
-(void)sendData:(NSData *)data toPeer:(MCPeerID *)peerID;

+(instancetype)sharedInstance;

@end
