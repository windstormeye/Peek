//
//  PJHomeBottomView.m
//  Peek
//
//  Created by pjpjpj on 2018/6/20.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJHomeBottomView.h"

@interface PJHomeBottomView()

@property (nonatomic, readwrite, strong) UIImageView *homeImageView;
@property (nonatomic, readwrite, strong) UIButton *homeButton;
@property (nonatomic, readwrite ,strong) CADisplayLink *link;

@property (nonatomic, readwrite, assign) BOOL isTapHomeButton;
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
    self.isNeedRotationButton = YES;
    
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
    
    self.homeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height - 70) / 2, 70, 70)];
    self.homeImageView.centerX = self.centerX;
    [self addSubview:self.homeImageView];
    self.homeImageView.image = [UIImage imageNamed:@"home_button"];
    self.homeImageView.layer.cornerRadius = self.homeButton.width / 2;
    self.homeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.homeImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.homeImageView.layer.shadowOpacity = 0.6;
    self.homeImageView.layer.shadowRadius = 5;
    
    self.homeButton = [[UIButton alloc] initWithFrame:self.homeImageView.frame];
    [self addSubview:self.homeButton];
    [self.homeButton addTarget:self action:@selector(homeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhoneX) {
        self.homeImageView.y -= 10;
        self.homeButton.y -= 10;
    }
    
    self.timer = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:0.05 target:self selector:@selector(angleChange) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)homeButtonClick:(UIButton *)sender {
    if (!self.isNeedRotationButton) {
        [UIView animateWithDuration:0.1 animations:^{
            self.homeImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [PJTapic tap];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.homeImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                [PJTapic tipsTap];
                [self.viewDelegate homeBottomViewButtonClick];
            }];
        }];
        return;
    }
    if (self.isTapHomeButton) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.isTapHomeButton = !self.isTapHomeButton;
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            // 放大
            self.homeImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [PJTapic tap];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.homeImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                [PJTapic tipsTap];
                [self.timer setFireDate:[NSDate date]];
                self.isTapHomeButton = !self.isTapHomeButton;
            }];
        }];
    }
}

- (void)angleChange {
    CGFloat angle = 3 * M_PI / 180.0;
    self.homeImageView.transform = CGAffineTransformRotate(self.homeImageView.transform, angle);
}

@end
