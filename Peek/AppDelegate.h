//
//  AppDelegate.h
//  Peek
//
//  Created by pjpjpj on 2017/6/1.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

