//
//  Reply.m
//  RNXRPC
//
//  Created by webee on 16/10/23.
//
//

#import "RNXRPCReply.h"

@implementation RNXRPCReply

- (id)initWithArgs:(NSArray*)args kwargs:(NSDictionary*)kwargs {
    if (self = [super init]) {
        _args = args;
        _kwargs = kwargs;
    }
    return self;
}

@end
