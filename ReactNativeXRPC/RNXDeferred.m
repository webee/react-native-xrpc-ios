//
// Created by webee on 16/12/23.
//

#import "RNXDeferred.h"

@interface RNXDeferred ()
@property(atomic, strong, readwrite) AnyPromise *promise;
@end

@implementation RNXDeferred {
    PMKResolver _resolver;
}

- (id)init {
    if (self = [super init]) {
        _promise = [AnyPromise promiseWithResolverBlock:^(PMKResolver resolver) {
            _resolver = resolver;
        }];
    }
    return self;
}

- (void)fulfil:(id)val {
    _resolver(val);
}

- (void)reject:(NSError *)err {
    _resolver(err);
}
@end