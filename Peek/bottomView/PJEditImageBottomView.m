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

@property (nonatomic, readwrite, strong) UIButton *unDoBtn;
@property (nonatomic, readwrite, strong) UIButton *strokeBtn;
@property (nonatomic, readwrite, strong) UIButton *blurBtn;

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
    self.unDoBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginX, 0, btnW, btnH)];
    [self addSubview:self.unDoBtn];
    self.unDoBtn.tag = 1000;
    [self.unDoBtn setImage:[UIImage imageNamed:@"btn_revoke"] forState:UIControlStateNormal];
    [self.unDoBtn addTarget:self action: @selector(undoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 颜色选择
    self.strokeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.strokeBtn.centerX = self.centerX;
    [self addSubview:self.strokeBtn];
    self.strokeBtn.tag = 1001;
    [self.strokeBtn setImage:[UIImage imageNamed:@"btn_pen"] forState:UIControlStateNormal];
    [self.strokeBtn setImage:[UIImage imageNamed:@"btn_pen"] forState:UIControlStateHighlighted];
    [self.strokeBtn setImage:[UIImage imageNamed:@"btn_pen_h"] forState:UIControlStateSelected];
    [self.strokeBtn setImage:[UIImage imageNamed:@"btn_pen_h"]
                    forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.strokeBtn addTarget:self action:@selector(strokeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 马赛克
    self.blurBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - marginX - btnW, 0, btnW, btnH)];
    [self addSubview:self.blurBtn];
    self.blurBtn.tag = 1002;
    [self.blurBtn setImage:[UIImage imageNamed:@"btn_mosaic"] forState:UIControlStateNormal];
    [self.blurBtn setImage:[UIImage imageNamed:@"btn_mosaic"] forState:UIControlStateHighlighted];
    [self.blurBtn setImage:[UIImage imageNamed:@"btn_mosaic_h"] forState:UIControlStateSelected];
    [self.blurBtn setImage:[UIImage imageNamed:@"btn_mosaic_h"]
                  forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.blurBtn addTarget:self action:@selector(blurBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)undoBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self changeState:sender.tag];
    [_viewDelegate PJEditImageBottomViewBackBtnClick];
}

- (void)strokeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self changeState:sender.tag];
    [_viewDelegate PJEditImageBottomViewColorViewShow];
}

- (void)blurBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self changeState:sender.tag];
    [_viewDelegate PJEditImageBottomViewBlurBtnClick];
}

- (void)changeState:(NSInteger)buttonTag {
    switch (buttonTag) {
        case 1000:
            self.strokeBtn.selected = NO;
            self.blurBtn.selected = NO;
            break;
        case 1001:
            self.blurBtn.selected = NO;
        case 1002:
            self.strokeBtn.selected = NO;
    }
}

@end
