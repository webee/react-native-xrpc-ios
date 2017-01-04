//
//  RNBridgeDelegate.h
//
//  Created by webee on 16/10/23.
//  Copyright © 2016年 qqwj.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeDelegate.h>

@interface RNBridgeDelegate : NSObject <RCTBridgeDelegate>
- (instancetype)initWithEnv:(NSString *)env andName:(NSString *)name;

- (instancetype)initWithEnv:(NSString *)env andName:(NSString *)name andExtraModules:(NSArray<id <RCTBridgeModule>> *)extranModules;

- (instancetype)initWithEnv:(NSString *)env andName:(NSString *)name andExtraModules:(NSArray<id <RCTBridgeModule>> *)extranModules sourceUrl:(NSURL *)url;
@end
