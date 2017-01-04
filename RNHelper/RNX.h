//
//  RNX.h
//
//  Created by webee on 16/12/23.
//
//

#import <Foundation/Foundation.h>
#import "RNXRPCClient.h"

@interface RNX : NSObject
- (nonnull id)initWithEnv:(nonnull NSString *)env andName:(nonnull NSString *)name launchOptions:(nullable NSDictionary *)launchOptions;

- (nonnull id)initWithEnv:(nonnull NSString *)env andName:(nonnull NSString *)name andExtraModules:(nullable NSArray<id <RCTBridgeModule>> *)extraModules launchOptions:(nullable NSDictionary *)launchOptions;

- (nonnull id)initWithEnv:(nonnull NSString *)env andName:(nonnull NSString *)name andExtraModules:(nullable NSArray<id <RCTBridgeModule>> *)extraModules launchOptions:(nullable NSDictionary *)launchOptions sourceUrl:(nullable NSURL *)url;

- (nonnull NSString *)id;

- (nonnull RCTBridge *)bridge;

- (nonnull RNXRPCClient *)xrpc;

- (nonnull RNXRPCClient *)newXrpc:(nullable NSDictionary *)context;

- (nonnull RNXRPCClient *)newXrpc;
@end
