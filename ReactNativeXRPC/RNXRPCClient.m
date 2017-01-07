//
//  RNXRPCClient.m
//  RNXRPC
//
//  Created by webee on 16/10/23.
//
//
#import <ReactiveObjC/RACDisposable.h>
#import <React/RCTEventDispatcher.h>
#import "RNXDeferred.h"
#import "RNXRPCClient.h"
#import "RNXRPCEventEmitter.h"

@implementation RNXRPCClient {
    RCTBridge *_bridge;
    NSDictionary *_defaultContext;
}

- (id)initWithReactBridge:(RCTBridge *)bridge {
    return [self initWithReactBridge:bridge andDefaultContext:nil];
}

- (id)initWithReactBridge:(RCTBridge *)bridge andDefaultContext:(NSDictionary *)context {
    if (self = [super init]) {
        _bridge = bridge;
        _defaultContext = context;
    }
    return self;
}

- (void)setDefaultContext:(NSDictionary *)context {
    _defaultContext = context;
}

- (NSDictionary *)getDefaultContext {
    return _defaultContext;
}

- (void)emit:(nonnull NSString *)event args:(nullable NSArray *)args kwargs:(nullable NSDictionary *)kwargs {
    [self emit:event context:_defaultContext args:args kwargs:kwargs];
}

- (void)emit:(nonnull NSString *)event
     context:(nullable NSDictionary *)context
        args:(nullable NSArray *)args
      kwargs:(nullable NSDictionary *)kwargs {
    context = context == nil ? @{} : context;
    args = args == nil ? @[] : args;
    kwargs = kwargs == nil ? @{} : kwargs;
    NSArray *data = @[@(XRPC_EVENT_EVENT), event, context, args, kwargs];
    [[_bridge moduleForClass:[RNXRPCEventEmitter class]] sendEvent:data];
}

- (nonnull RACSignal<RNXRPCEvent *> *)sub:(nonnull NSString *)event {
    return [[RNXRPC event] filter:^(RNXRPCEvent *e) {
        return [e.event isEqualToString:event];
    }];
}

/**
 * @return Promise<RNXRPCReply *>
 */
- (AnyPromise *)call:(NSString *)proc args:(NSArray *)args kwargs:(NSDictionary *)kwargs {
    return [self call:proc context:_defaultContext args:args kwargs:kwargs];
}

/**
 * @return Promise<RNXRPCReply *>
 */
- (AnyPromise *)call:(NSString *)proc context:(NSDictionary *)context args:(NSArray *)args kwargs:(NSDictionary *)kwargs {
    RNXDeferred<RNXRPCReply *> *deferred = [[RNXDeferred alloc] init];
    NSString *rid = [RNXRPC request:deferred];

    [self doCall:rid proc:proc context:context args:args kwargs:kwargs];

    return deferred.promise;
}

- (RACSignal<RNXRPCReply *> *)subCall:(NSString *)proc args:(NSArray *)args kwargs:(NSDictionary *)kwargs {
    return [self subCall:proc context:_defaultContext args:args kwargs:kwargs];
}

- (RACSignal<RNXRPCReply *> *)subCall:(NSString *)proc context:(NSDictionary *)context args:(NSArray *)args kwargs:(NSDictionary *)kwargs {
    return [RACSignal createSignal:^(id <RACSubscriber> subscriber) {
        NSString * rid = [RNXRPC subRequest:subscriber];
        [self doCall:rid proc:proc context:context args:args kwargs:kwargs];
        return [RACDisposable disposableWithBlock:^{
            [RNXRPC cancelSubRequest:rid];
        }];
    }];
}

- (void)doCall:(NSString *)rid proc:(NSString *)proc context:(NSDictionary *)context args:(NSArray *)args kwargs:(NSDictionary *)kwargs {
    context = context == nil ? @{} : context;
    args = args == nil ? @[] : args;
    kwargs = kwargs == nil ? @{} : kwargs;
    NSArray *data = @[@(XRPC_EVENT_CALL), rid, proc, context, args, kwargs];
    [[_bridge moduleForClass:[RNXRPCEventEmitter class]] sendEvent:data];
}

- (nonnull RACSignal<RNXRPCRequest *> *)register:(nonnull NSString *)proc {
    return [RNXRPC register:proc];
}
@end
