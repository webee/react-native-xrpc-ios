//
//  RNViewController.h
//  XChatDemo
//
//  Created by webee on 16/10/23.
//  Copyright © 2016年 qqwj.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNX.h"

@interface RNViewController : UIViewController

-(id) initWithModule:(NSString*)moduleName initialProperties:(NSDictionary*)initialProperties;
-(id) initWithModule:(NSString*)moduleName andRNX:(RNX*)rnx initialProperties:(NSDictionary*)initialProperties;

@end
