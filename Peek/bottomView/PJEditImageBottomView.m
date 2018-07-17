//
//  PJEditImageBottomView.m
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditImageBottomView.h"

#define PJSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PJSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PJEditImageBottomView()


@end

@implementation PJEditImageBottomView

- (instancetype)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50);
    self.backgroundColor = [UIColor colorWithRed:220 green:220 blue:220 alpha:1.0];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 4;
    
    CGFloat btnW = 50;
    CGFloat btnH = 50;
    CGFloat marginX = (PJSCREEN_WIDTH - btnW * 4) / 5;
    
    // 撤回
    UIButton *unDoBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginX, 0, btnW, btnH)];
    [self addSubview:unDoBtn];
    [unDoBtn setImage:[UIImage imageNamed:@"undo"] forState:UIControlStateNormal];
    [unDoBtn addTarget:self action: @selector(undoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 颜色选择
    UIButton *strokeBtn = [[UIButton alloc] initWithFrame:CGRectMake(unDoBtn.frame.origin.x + unDoBtn.frame.size.width + marginX, 0, 50, 50)];
    [self addSubview:strokeBtn];
    [strokeBtn setImage:[UIImage imageNamed:@"stroke"] forState:UIControlStateNormal];
    [strokeBtn addTarget:self action:@selector(strokeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 马赛克
    UIButton *blurBtn = [[UIButton alloc] initWithFrame:CGRectMake(strokeBtn.frame.origin.x + strokeBtn.frame.size.width + marginX, 0, btnW, btnH)];
    [self addSubview:blurBtn];
    [blurBtn setImage:[UIImage imageNamed:@"blur"] forState:UIControlStateNormal];
    [blurBtn addTarget:self action:@selector(blurBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)undoBtnClick {
    [_viewDelegate PJEditImageBottomViewBackBtnClick];
}

- (void)strokeBtnClick {
    [_viewDelegate PJEditImageBottomViewColorViewShow];
}

- (void)blurBtnClick {
    [_viewDelegate PJEditImageBottomViewBlurBtnClick];
}


@end
