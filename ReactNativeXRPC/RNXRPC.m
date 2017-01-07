//
//  XRPC.m
//  RNXRPC
//
//  Created by webee on 16/10/20.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <ReactiveObjC/RACDisposable.h>
#import "RNXRPC.h"

NSString *const XRPC_EVENT = @"__XRPC__";
NSInteger const XRPC_EVENT_CALL = 0;
NSInteger const XRPC_EVENT_REPLY = 1;
NSInteger const XRPC_EVENT_REPLY_ERROR = 2;
NSInteger const XRPC_EVENT_EVENT = 3;

@implementation RNXRPC {
    NSDictionary *_extraConstants;
}
static RACSubject *__eventSubject;
static NSMutableDictionary<NSString *, RNXDeferred<RNXRPCReply *> *> *__requests;
static NSMutableDictionary<NSString *, id <RACSubscriber>> *__observable_requests;
static NSLock *__reqLock;
static NSMutableDictionary<NSString *, id <RACSubscriber>> *__procedures;
static NSLock *__procLock;

@synthesize bridge = _bridge;

+ (void)initialize {
    __eventSubject = [RACSubject subject];
    __requests = [NSMutableDictionary new];
    __observable_requests = [NSMutableDictionary new];
    __reqLock = [[NSLock alloc] init];
    __procedures = [NSMutableDictionary new];
    __procLock = [[NSLock alloc] init];
}

- (id)init {
    return [self initWithExtraConstants:nil];
}

- (id)initWithExtraConstants:(NSDictionary *)constants {
    if (self = [super init]) {
        if (constants != nil) {
            _extraConstants = constants;
        } else {
            _extraConstants = @{};
        }
    }
    return self;
}

RCT_EXPORT_MODULE(XRPC);

- (dispatch_queue_t)methodQueue {
    return dispatch_queue_create("com.webee.react.XRPCStorageQueue", DISPATCH_QUEUE_SERIAL);
}

- (NSDictionary *)constantsToExport {
    return @{@"_XRPC_EVENT": XRPC_EVENT,
            @"_EVENT_CALL": @(XRPC_EVENT_CALL),
            @"_EVENT_REPLY": @(XRPC_EVENT_REPLY),
            @"_EVENT_REPLY_ERROR": @(XRPC_EVENT_REPLY_ERROR),
            @"_EVENT_EVENT": @(XRPC_EVENT_EVENT),
            @"C": _extraConstants
    };
}

RCT_EXPORT_METHOD(emit:
    (NSInteger) event
            args:
            (NSArray *) args) {
    switch (event) {
        case XRPC_EVENT_REPLY:
            [self handleCallReply:args];
            break;
        case XRPC_EVENT_REPLY_ERROR:
            [self handleCallReplyError:args];
            break;
        case XRPC_EVENT_EVENT:
            [self handleEvent:args];
            break;
        default:
            break;
    }
}

RCT_EXPORT_METHOD(call:
    (NSString *) proc
            args:
            (NSArray *) args
            kwargs:
            (NSDictionary *) kwargs
            resolver:
            (RCTPromiseResolveBlock) resolve
            rejecter:
            (RCTPromiseRejectBlock) reject) {
    [__procLock lock];
    id <RACSubscriber> subscriber = __procedures[proc];
    [__procLock unlock];

    if (subscriber) {
        [subscriber sendNext:[[RNXRPCRequest alloc] initWithArgs:_bridge args:args kwargs:kwargs resolver:resolve rejecter:reject]];
    } else {
        reject(@"XRPC_ERROR", @"PROCEDURE NOT REGISTERED", nil);
    }
}

- (void)handleEvent:(NSArray *)xargs {
    NSString *event = xargs[0];
    NSArray *args = xargs[1];
    NSDictionary *kwargs = xargs[2];
    [__eventSubject sendNext:[[RNXRPCEvent alloc] initWithArgs:_bridge event:event args:args kwargs:kwargs]];
}

- (void)handleCallReply:(NSArray *)xargs {
    NSString *rid = xargs[0];
    BOOL hasNext = NO;
    if (xargs.count >= 4) {
        hasNext = [(NSNumber *)xargs[3] boolValue];
    }

    [__reqLock lock];
    // promise
    RNXDeferred<RNXRPCReply *> *deferred = __requests[rid];
    [__requests removeObjectForKey:rid];

    // observable.
    id <RACSubscriber> subscriber = __observable_requests[rid];
    if (!hasNext) {
        [__observable_requests removeObjectForKey:rid];
    }
    [__reqLock unlock];

    if (deferred != nil && !hasNext) {
        NSArray *args = xargs[1];
        NSDictionary *kwargs = xargs[2];

        [deferred fulfil:[[RNXRPCReply alloc] initWithArgs:args kwargs:kwargs]];
    }

    if (subscriber != nil) {
        NSArray *args = xargs[1];
        NSDictionary *kwargs = xargs[2];

        [subscriber sendNext:[[RNXRPCReply alloc] initWithArgs:args kwargs:kwargs]];
        if (!hasNext) {
            [subscriber sendCompleted];
        }
    }
}

- (void)handleCallReplyError:(NSArray *)xargs {
    NSString *rid = xargs[0];

    [__reqLock lock];
    // promise
    RNXDeferred<RNXRPCReply *> *deferred = __requests[rid];
    [__requests removeObjectForKey:rid];

    // observable.
    id <RACSubscriber> subscriber = __observable_requests[rid];
    [__observable_requests removeObjectForKey:rid];
    [__reqLock unlock];

    if (deferred != nil) {
        NSString *err = xargs[1];
        NSArray *args = xargs[2];
        NSDictionary *kwargs = xargs[3];

        [deferred reject:[[RNXRPCError alloc] initWithArgs:err args:args kwargs:kwargs]];
    }

    if (subscriber != nil) {
        NSString *err = xargs[1];
        NSArray *args = xargs[2];
        NSDictionary *kwargs = xargs[3];

        [subscriber sendError:[[RNXRPCError alloc] initWithArgs:err args:args kwargs:kwargs]];
    }
}

+ (nonnull RACSignal<RNXRPCEvent *> *)event {
    return __eventSubject;
}

+ (NSString *)request:(RNXDeferred<RNXRPCReply *> *)deferred {
    NSString *rid = [[NSUUID UUID] UUIDString];
    [__reqLock lock];
    __requests[rid] = deferred;
    [__reqLock unlock];
    return rid;
}

+ (NSString *)subRequest:(id <RACSubscriber>)subscriber {
    NSString *rid = [[NSUUID UUID] UUIDString];
    [__reqLock lock];
    __observable_requests[rid] = subscriber;
    [__reqLock unlock];
    return rid;
}

+ (void)cancelSubRequest:(NSString *)rid {
    [__reqLock lock];
    [__observable_requests removeObjectForKey:rid];
    [__reqLock unlock];
}

+ (RACSignal<RNXRPCRequest *> *)register:(NSString *)proc {
    return [RACSignal createSignal:^(id <RACSubscriber> subscriber) {
        [__procLock lock];
        __procedures[proc] = subscriber;
        [__procLock unlock];
        return [RACDisposable disposableWithBlock:^{
            // FIXME: impossible.
            [__procLock lock];
            [__procedures removeObjectForKey:proc];
            [__procLock unlock];
        }];
    }];
}
@end
