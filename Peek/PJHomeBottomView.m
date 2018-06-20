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
@property (nonatomic, readwrite, assign) CGFloat homeImageViewAngle;

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
    self.homeImageViewAngle = 1;
    
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
    
    self.homeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height - 90, 70, 70)];
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
    
    [self homeButtonStartAnimation];
}

- (void)homeButtonClick:(UIButton *)sender {
    NSLog(@"2333");
}

- (void)homeButtonStartAnimation {
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.homeImageViewAngle * (M_PI / 180.0f));
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.homeImageView.transform = endAngle;
    } completion:^(BOOL finished) {
        self.homeImageViewAngle += 10;
        [self homeButtonStartAnimation];
    }];
}

@end
