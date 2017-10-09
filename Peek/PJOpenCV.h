//
//  PJOpenCV.h
//  Peek
//
//  Created by pjpjpj on 2017/10/8.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PJOpenCV : NSObject

// 原图 TO 灰度图加描边
+ (UIImage *)imageToGary:(UIImage *)image;
// 识别原图中的蓝色区域
+ (UIImage *)imageToDiscernBlue:(UIImage *)image;
// 识别原图中的红色区域
+ (UIImage *)imageToDiscernRed:(UIImage *)image;
@end
