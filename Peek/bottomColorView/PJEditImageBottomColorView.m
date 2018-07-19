//
//  PJEditImageBottomColorView.m
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditImageBottomColorView.h"

@interface PJEditImageBottomColorView ()

@property (nonatomic, readwrite, strong) NSMutableArray *btnArray;

@end

@implementation PJEditImageBottomColorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initView];
    return self;
}

- (void)initView {
    self.btnArray = [NSMutableArray new];
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnW = 30;
    CGFloat btnH = 30;
    CGFloat marginX = (SCREEN_WIDTH - 5 * btnW) / 6;
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(marginX + i * (btnW + marginX), (self.height - btnH) / 2 , btnW, btnH)];
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                [btn setImage:[UIImage imageNamed:@"btn_black"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btn_black_s"] forState:UIControlStateSelected];
                break;
            case 1:
                [btn setImage:[UIImage imageNamed:@"btn_blue"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btn_blue_s"] forState:UIControlStateSelected];
                break;
            case 2:
                [btn setImage:[UIImage imageNamed:@"btn_green"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btn_green_s"] forState:UIControlStateSelected];
                break;
            case 3:
                [btn setImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btn_red_s"] forState:UIControlStateSelected];
                break;
            case 4:
                [btn setImage:[UIImage imageNamed:@"btn_yellow"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btn_yellow_s"] forState:UIControlStateSelected];
                break;
        }
        
        // 默认选中黑色
        if (i == 0) {
            btn.selected = YES;
        }
        [self.btnArray addObject:btn];
    }
    
}

- (void)colorBtnClick:(UIButton *)sender {
    for (UIButton *btn in self.btnArray) {
        btn.selected = NO;
    }
    sender.selected = !sender.selected;
    switch ((int)sender.tag) {
        case 0:
            [_viewDelegate PJEditImageBottomColorViewSelectedColor:RGB(50, 50, 50)]; break;
        case 1:
            [_viewDelegate PJEditImageBottomColorViewSelectedColor:RGB(34, 126, 183)]; break;
        case 2:
            [_viewDelegate PJEditImageBottomColorViewSelectedColor:RGB(81, 185, 195)]; break;
        case 3:
            [_viewDelegate PJEditImageBottomColorViewSelectedColor:RGB(240, 90, 74)]; break;
        case 4:
            [_viewDelegate PJEditImageBottomColorViewSelectedColor:RGB(244, 240, 163)]; break;
    }
    
    
    
}


@end
