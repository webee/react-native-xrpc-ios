//
//  RNXRPCError.m
//  RNXRPC
//
//  Created by webee on 16/10/23.
//
//

#import "RNXRPCError.h"

@implementation RNXRPCError

- (id)initWithArgs:(NSString *)error args:(NSArray *)args kwargs:(NSDictionary *)kwargs {
    if (self = [super initWithDomain:@"RNXRPC" code:1 userInfo:@{@"error": error, @"args": args, @"kwargs": kwargs}]) {
        _error = error;
        _args = args;
        _kwargs = kwargs;
    }
    return self;
}

@end
