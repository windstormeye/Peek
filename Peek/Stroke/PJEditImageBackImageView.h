//
//  PJEditImageBackImageView.h
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJEditImageBackImageView : UIImageView

@property (nonatomic, assign) BOOL isBlur;

+ (PJEditImageBackImageView *)initWithImage:(UIImage *)image frame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;
// 一键清空
- (void)clearScreen;
// 撤销
- (void)revokeScreen;
// 橡皮擦
- (void)eraseSreen;
// 设置画笔颜色
- (void)setStrokeColor:(UIColor *)lineColor;
// 获取传入图片的马赛克图片
- (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level;
@end
