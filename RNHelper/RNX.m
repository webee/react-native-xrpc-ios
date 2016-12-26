//
//  RNX.m
//  Pods
//
//  Created by webee on 16/12/23.
//
//

#import "RNX.h"
#import "RNBridgeDelegate.h"

@implementation RNX {
    NSString *_id;
    RCTBridge* _bridge;
    RNXRPCClient* _xrpc;
}

- (id)initWithEnv:(NSString*) env andName:(NSString*)name launchOptions:(NSDictionary *)launchOptions {
    return [self initWithEnv:env andName:name andExtraModules:nil launchOptions:launchOptions];
}

- (id)initWithEnv:(NSString*) env andName:(NSString*)name andExtraModules:(NSArray<id<RCTBridgeModule>>*)extraModules launchOptions:(NSDictionary *)launchOptions {
    if (self = [super init]) {
        _bridge = [[RCTBridge alloc]
                initWithDelegate:[[RNBridgeDelegate alloc] initWithEnv:env andName:name andExtraModules:extraModules]
                   launchOptions: launchOptions];
        _xrpc = [[RNXRPCClient alloc] initWithReactBridge:_bridge];
    }
    _id = [[NSUUID UUID] UUIDString];
    return self;
}

- (RCTBridge*) bridge {
    return _bridge;
}

- (RNXRPCClient*) xrpc{
    return _xrpc;
}

- (RNXRPCClient*) newXrpc:(NSDictionary*)context {
    return [[RNXRPCClient alloc] initWithReactBridge:_bridge andDefaultContext:context];
}

- (RNXRPCClient*) newXrpc {
    return [[RNXRPCClient alloc] initWithReactBridge:_bridge];
}

- (NSString *)id {
    return _id;
}

@end
