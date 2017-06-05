//
//  LeftSliderView.m
//  Peek
//
//  Created by pjpjpj on 2017/6/5.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "LeftSliderView.h"

@implementation LeftSliderView

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(-SCREEN_WIDTH * 0.6, 0, SCREEN_WIDTH * 0.6, SCREEN_HEIGHT);
    
    self.backgroundColor = [UIColor clearColor];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:effectView];
}

- (void)closeView:(UISwipeGestureRecognizer *)ges {
//    [UIView animateWithDuration:0.3 animations:^{
//        CGRect leftframe = self.frame;
//        leftframe.origin.x = -SCREEN_WIDTH * 0.6;
//        self.frame = leftframe;
//    }];
    
    CGPoint p = [ges locationInView:self];
    NSLog(@"%@", NSStringFromCGPoint(p));
    CGRect frame = self.frame;

    if (frame.origin.x == 0) {
        return;
    }
    // 更改adView的x值.当滑动距离超过view宽度时，则把x一直设置为0
    if (p.x > SCREEN_WIDTH * 0.6) {
        frame.origin.x = 0;
    } else {
        CGRect frame = self.frame;
        frame.origin.x = p.x - SCREEN_WIDTH * 0.6;
    }
    
//    if (frame.origin.x == 0) {
//        frame.origin.x = 0;
//    }
//    
//    if (p.x > SCREEN_WIDTH * 0.6) {
//        frame.origin.x = 0;
//    }
    
//    if (p.x > SCREEN_WIDTH * 0.3) {
//        frame.origin.x = 0;
//    } else {
//        frame.origin.x = -SCREEN_WIDTH * 0.6;;
//    }
    self.frame = frame;
}


@end
