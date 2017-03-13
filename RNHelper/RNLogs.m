//
// Created by webee on 17/3/13.
//

#import "RNLogs.h"
#import "RN.h"


@implementation RNLogs
+ (void)setLog:(BOOL)enable {
    [[RN xrpc] emit:@"xrpc.log.set" args:@[@(enable)] kwargs:nil];
}
@end