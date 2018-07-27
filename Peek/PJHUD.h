//
//  PJHUD.h
//  Peek
//
//  Created by pjpjpj on 2018/7/27.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HUDType) {
    warning = 0,
    error,
};

@interface PJHUD : UIView

@property (nonatomic, readwrite, assign) HUDType type;
@property (nonatomic, readwrite, copy) void (^coverButtonBlock)(void);

+ (PJHUD *)shareInstance;

- (void)warningString:(NSString *)warningString coverHidden:(BOOL)hidden;
- (void)errorString:(NSString *)errorString coverHidden:(BOOL)hidden;


@end
