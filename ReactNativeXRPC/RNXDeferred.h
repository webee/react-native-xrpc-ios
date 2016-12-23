//
// Created by webee on 16/12/23.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/AnyPromise.h>


@interface RNXDeferred<T> : NSObject
@property (atomic, strong, readonly) AnyPromise *promise;

- (void)fulfil:(T)val;

- (void)reject:(NSError *)err;
@end