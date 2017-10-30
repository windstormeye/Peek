//
//  Register.m
//  Peek
//
//  Created by pjpjpj on 2017/10/30.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "Register.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation Register

+ (void)registerShareSDK:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"594d2d64717c1901fe0014af"];
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx458b318a4997b2b1" appSecret:@"5571fa38c7a43e6b06a8fbae84febf41" redirectURL:@"http://mobile.umeng.com/social"];
    
    [Bmob registerWithAppKey:@"91ea310c6307a2cdaaa4a66660b0ea23"];
}

@end
