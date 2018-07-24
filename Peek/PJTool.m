//
//  PJTool.m
//  Peek
//
//  Created by pjpjpj on 2018/6/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJTool.h"

@implementation PJTool

+ (UIImageView *)convertCreateImageWithUIView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.frame];
    imageView.image = newImage;
    
    return imageView;
}

@end
