//
//  RNXRPCClient.h
//  RNXRPC
//
//  Created by webee on 16/10/23.
//
//
#import <React/RCTBridge.h>
#import "RNXRPC.h"

@interface RNXRPCClient : NSObject

- (nonnull id)initWithReactBridge:(nonnull RCTBridge *)bridge;

- (nonnull id)initWithReactBridge:(nonnull RCTBridge *)bridge andDefaultContext:(nullable NSDictionary *)context;

- (void)setDefaultContext:(nullable NSDictionary *)context;

- (nullable NSDictionary *)getDefaultContext;

- (void)emit:(nonnull NSString *)event args:(nullable NSArray *)args kwargs:(nullable NSDictionary *)kwargs;

- (void)emit:(nonnull NSString *)event context:(nullable NSDictionary *)context args:(nullable NSArray *)args kwargs:(nullable NSDictionary *)kwargs;

- (nonnull RACSignal<RNXRPCEvent *> *)sub:(nonnull NSString *)event;

/**
 * @return Promise<RNXRPCReply *>
 */
- (nonnull AnyPromise *)call:(nonnull NSString *)proc args:(nullable NSArray *)args kwargs:(nullable NSDictionary *)kwargs;

/**
 * @return Promise<RNXRPCReply *>
 */
- (nonnull AnyPromise *)call:(nonnull NSString *)proc context:(nullable NSDictionary *)context args:(nullable NSArray *)args kwargs:(nullable NSDictionary *)kwargs;

- (RACSignal<RNXRPCReply *> *)subCall:(NSString *)proc args:(NSArray *)args kwargs:(NSDictionary *)kwargs;

- (RACSignal<RNXRPCReply *> *)subCall:(NSString *)proc context:(NSDictionary *)context args:(NSArray *)args kwargs:(NSDictionary *)kwargs;

- (nonnull RACSignal<RNXRPCRequest *> *)register:(nonnull NSString *)proc;
@end
