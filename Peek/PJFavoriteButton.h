//
//  PJFavoriteButton.h
//  Peek
//
//  Created by pjpjpj on 2018/7/25.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface PJFavoriteButton : UIButton

@property (nonatomic, strong) IBInspectable UIImage *image;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *favoredColor;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *defaultColor;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *circleColor;
@property (nonatomic, readwrite, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, readwrite, assign) IBInspectable CGFloat duration;

@end
