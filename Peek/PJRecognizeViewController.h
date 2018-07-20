//
//  PJRecognizeViewController.h
//  Peek
//
//  Created by pjpjpj on 2018/7/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJBaseViewController.h"

UIKIT_EXTERN NSNotificationName const PJRecognizeViewControllerRecaptrueNotification;
UIKIT_EXTERN NSNotificationName const PJRecognizeViewControllerImageViewArrayNotification;

@interface PJRecognizeViewController : UIViewController

// 必传参数
@property (nonatomic, readwrite, strong) NSArray *imageArray;
@property (nonatomic, readwrite, assign) NSInteger photoIndex;

@end
