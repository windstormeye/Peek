//
//  Register.h
//  Peek
//
//  Created by pjpjpj on 2017/10/30.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Register : NSObject

// 通过单例调用相关key
+ (void)registerShareSDK:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


@end
