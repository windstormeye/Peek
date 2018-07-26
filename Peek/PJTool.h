//
//  PJTool.h
//  Peek
//
//  Created by pjpjpj on 2018/6/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJTool : NSObject

+ (UIImageView *)convertCreateImageWithUIView:(UIView *)view;
+ (UIImage *)imageWithRoundCorner:(UIImage *)sourceImage
                     cornerRadius:(CGFloat)cornerRadius
                             size:(CGSize)size;
+ (void)addShadowToView:(UIView *)view
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius;
@end
