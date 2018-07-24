//
//  PJCardImageView.h
//  Peek
//
//  Created by pjpjpj on 2018/7/23.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJEditImageTouchView.h"

@interface PJCardImageView : UIImageView<NSCopying>

@property (nonatomic, readwrite, strong) UIImageView *openvcImageView;
@property (nonatomic, readwrite, strong) PJEditImageTouchView *touchView;
// 最终只需要这个
@property (nonatomic, readwrite, strong) UIImageView *touchImageView;

@end
