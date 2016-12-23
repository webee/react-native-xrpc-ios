//
// Created by webee on 16/12/23.
//

#import "SafeMutableDictionary.h"


@implementation SafeMutableDictionary {
    NSLock *lock;
    NSMutableDictionary *underlyingDictionary;
}

- (id)init {
    if (self = [super init]) {
        lock = [[NSLock alloc] init];
        underlyingDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// forward all the calls with the lock held
- (retval_t) forward: (SEL) sel : (arglist_t) args
{
    [lock lock];
    @try {
        return [underlyingDictionary performv:sel : args];
    }
    @finally {
        [lock unlock];
    }
}
@end