//
//  PJModifyNameViewController.h
//  Peek
//
//  Created by pjpjpj on 2017/8/18.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    nickName,
    email,
    phone,
    passwd
} ModifyType;

@interface PJModifyViewController : UIViewController

// 提供外部传入的titleName方法
- (void)initWithTitleLabelName:(NSString *)name;

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, assign) ModifyType type;

@end
