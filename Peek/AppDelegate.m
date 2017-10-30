//
//  AppDelegate.m
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Register.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Register registerShareSDK:application didFinishLaunchingWithOptions:launchOptions];
    
    UIStoryboard *mainStoryborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *root1=[[ViewController alloc]init];
    root1 = [mainStoryborad instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:root1];
    self.window.rootViewController=nav1;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
      
    return YES;
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
