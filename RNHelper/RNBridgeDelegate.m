//
//  RNBridgeDelegate.m
//  XChatDemo
//
//  Created by webee on 16/10/23.
//  Copyright © 2016年 qqwj.com. All rights reserved.
//

#import "RNBridgeDelegate.h"
#import <React/RCTBundleURLProvider.h>

@implementation RNBridgeDelegate {
    NSString *_env;
    NSString *_name;
    NSURL *_sourceUrl;
    NSArray<id<RCTBridgeModule>>* _extraModules;
}

- (instancetype)initWithEnv:(NSString *)env andName:(NSString*)name {
    return [self initWithEnv:env andName:name andExtraModules:nil];
}

- (instancetype)initWithEnv:(NSString*)env andName:(NSString*)name sourceUrl:(NSURL *)url
{
    return [self initWithEnv:env andName:name andExtraModules:nil sourceUrl:url];
}

- (instancetype)initWithEnv:(NSString*)env andName:(NSString*)name andExtraModules:(NSArray<id<RCTBridgeModule>>*)extranModules
{
    return [self initWithEnv:env andName:name andExtraModules:nil sourceUrl:nil];
}

- (instancetype)initWithEnv:(NSString*)env andName:(NSString*)name andExtraModules:(NSArray<id<RCTBridgeModule>>*)extranModules  sourceUrl:(NSURL *)url
{
    if (self = [super init]) {
        _env = env;
        _name = name;
        _sourceUrl = url;
        if (extranModules != nil) {
            _extraModules = extranModules;
        } else {
            _extraModules = @[];
        }
    }
    return self;
    
}
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    if (_sourceUrl) {
        return _sourceUrl;
    }else{
        if ([_env  isEqual: @"dev"]) {
            return [[RCTBundleURLProvider sharedSettings]
                    jsBundleURLForBundleRoot:[@"index.ios" stringByAppendingString:_name]
                    fallbackResource:[@"rnbundle/index.ios" stringByAppendingString:_name]];
        } else {
            return [[NSBundle mainBundle]
                    URLForResource:[@"./rnbundle/index.ios" stringByAppendingString:_name]
                    withExtension:@"jsbundle"];
        }
    }
    
}

- (NSArray<id<RCTBridgeModule>> *)extraModulesForBridge:(RCTBridge *)bridge {
    return _extraModules;
}
@end
