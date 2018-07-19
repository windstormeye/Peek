//
//  PJEditImageStroke.m
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditImageStroke.h"

@implementation PJEditImageStroke

// 使用CoreGraphics绘图
- (void)strokeWithContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [_lineColor CGColor]);
    CGContextSetFillColorWithColor(context, [_lineColor CGColor]);
    CGContextSetLineWidth(context, 10);
    CGContextSetBlendMode(context, _blendMode);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextBeginPath(context);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextAddPath(context, _path);
    CGContextStrokePath(context);
}

@end
