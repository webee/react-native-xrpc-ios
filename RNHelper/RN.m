//
//  RN.m
//
//  Created by webee on 16/10/23.
//  Copyright © 2016年 qqwj.com. All rights reserved.
//
#import "RN.h"

@implementation RN
static RNX *__rnx;


+ (void)setupWithEnv:(NSString *)env launchOptions:(NSDictionary *)launchOptions {
    __rnx = [[RNX alloc] initWithEnv:env andName:@"" launchOptions:launchOptions];
}

+ (void)setupWithEnv:(NSString *)env andExtraModules:(NSArray<id <RCTBridgeModule>> *)extraModules launchOptions:(NSDictionary *)launchOptions {
    __rnx = [[RNX alloc] initWithEnv:env andName:@"" andExtraModules:extraModules launchOptions:launchOptions];
}

+ (void)setupWithEnv:(NSString *)env andExtraModules:(NSArray<id <RCTBridgeModule>> *)extraModules launchOptions:(NSDictionary *)launchOptions sourceUrl:(NSURL *)url {
    __rnx = [[RNX alloc] initWithEnv:env andName:@"" andExtraModules:extraModules launchOptions:launchOptions sourceUrl:url];
}

+ (RNX *)rnx {
    return __rnx;
}

+ (RCTBridge *)bridge {
    return [__rnx bridge];
}

+ (RNXRPCClient *)xrpc {
    return [__rnx xrpc];
}

+ (RNXRPCClient *)newXrpc:(NSDictionary *)context {
    return [__rnx newXrpc:context];
}

+ (RNXRPCClient *)newXrpc {
    return [__rnx newXrpc];
}
@end
