//
//  RNXRPCEvent.m
//  RNXRPC
//
//  Created by webee on 16/10/23.
//
//
#import "RNXRPCEvent.h"

@implementation RNXRPCEvent

- (id)initWithArgs:(RCTBridge *)bridge event:(NSString *)event args:(NSArray *)args kwargs:(NSDictionary *)kwargs {
    if (self = [super init]) {
        _bridge = bridge;
        _event = event;
        _args = args;
        _kwargs = kwargs;
    }
    return self;
}

@end
