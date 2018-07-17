//
//  PJEditImageTouchView.h
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface PJEditImageTouchView : UIView

// 是否为马赛克
@property (nonatomic, assign) BOOL isBlur;
// 图片
@property (nonatomic, strong) UIImage *image;
// 一键清屏
- (void)clearScreen;
// 撤回
- (void)revokeScreen;
// 橡皮擦
- (void)eraseSreen;
// 设置画笔颜色
- (void)setStrokeColor:(UIColor *)lineColor;

@end
