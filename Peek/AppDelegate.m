//
//  AppDelegate.m
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"594d2d64717c1901fe0014af"];
    [self configUSharePlatforms];
    
    [Bmob registerWithAppKey:@"91ea310c6307a2cdaaa4a66660b0ea23"];
    
    UIStoryboard *mainStoryborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *root1=[[ViewController alloc]init];
    root1 = [mainStoryborad instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:root1];
    self.window.rootViewController=nav1;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
      
    return YES;
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx458b318a4997b2b1" appSecret:@"5571fa38c7a43e6b06a8fbae84febf41" redirectURL:@"http://mobile.umeng.com/social"];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
