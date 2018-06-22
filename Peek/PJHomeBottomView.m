//
//  PJHomeBottomView.m
//  Peek
//
//  Created by pjpjpj on 2018/6/20.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJHomeBottomView.h"

@interface PJHomeBottomView()

@property (nonatomic, readwrite, assign) BOOL isTapHomeButton;

@property (nonatomic, readwrite, strong) UIButton *homeButton;
@property (nonatomic, readwrite ,strong) CADisplayLink *link;
@property (nonatomic, readwrite, strong) NSTimer *timer;

@end

@implementation PJHomeBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.isTapHomeButton = NO;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    //设置颜色数组
    gradientLayer.colors =@[(__bridge id)[UIColor colorWithWhite:2.0 alpha:0.01].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    //设定变色位置数组
    gradientLayer.locations = @[@0.1];
    //设置变化范围
    //startPoint&endPoint颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    //添加到根视图控制器的layer上
    [self.layer addSublayer:gradientLayer];
    
    self.homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, (self.height - 70) / 2, 70, 70)];
    [self.homeButton setImage:[UIImage imageNamed:@"home_button"] forState:UIControlStateNormal];
    self.homeButton.centerX = self.centerX;
    self.homeButton.layer.cornerRadius = self.homeButton.width / 2;
    self.homeButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.homeButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.homeButton.layer.shadowOpacity = 0.6;
    self.homeButton.layer.shadowRadius = 5;
    self.homeButton.transform = CGAffineTransformMakeScale(0, 0);
    [self addSubview:self.homeButton];
    [self.homeButton addTarget:self action:@selector(homeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhoneX) {
        self.homeButton.y -= 10;
    }
}

- (void)setIsShowHomeButton:(BOOL)isShowHomeButton {
    _isShowHomeButton = isShowHomeButton;
    if (isShowHomeButton) {
        [self bringSubviewToFront:self.homeButton];
        [UIView animateWithDuration:0.25 animations:^{
            self.homeButton.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            if (finished) {
                [PJTapic tap];
            }
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.homeButton.transform = CGAffineTransformMakeScale(0, 0);
        }];
    }
}

- (void)homeButtonClick:(UIButton *)sender {
    [UIView animateWithDuration:0.1 animations:^{
        [PJTapic tap];
        self.homeButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.homeButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
            [self.viewDelegate homeBottomViewButtonClick];
        }];
    }];
}


@end
