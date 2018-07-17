//
//  PJEditImageStroke.h
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct CGPath *CGMutablePathRef;
typedef enum CGBlendMode CGBlendMode;

@interface PJEditImageStroke : NSObject

@property (nonatomic) CGMutablePathRef path;
@property (nonatomic, assign) CGBlendMode blendMode;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *lineColor;
- (void)strokeWithContext:(CGContextRef)context;

@end
