//
//  PJEditImageBottomColorView.m
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditImageBottomColorView.h"

@implementation PJEditImageBottomColorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initView];
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat btnX = 0;
    CGFloat btnW = 50;
    CGFloat btnH = 50;
    CGFloat marginY = (180 - btnH * 3)/4;
    CGFloat tempY = 0;
    for (int i = 0; i < 3; i ++) {
        UIButton *colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, tempY, btnW, btnH)];
        colorBtn.tag = i;
        tempY = colorBtn.frame.origin.y + colorBtn.frame.size.height + marginY;
        switch (i) {
            case 0:
                colorBtn.backgroundColor = [UIColor redColor]; break;
            case 1:
                colorBtn.backgroundColor = [UIColor blueColor]; break;
            case 2:
                colorBtn.backgroundColor = [UIColor greenColor]; break;
        }
        [self addSubview:colorBtn];
        [colorBtn addTarget:self action:@selector(colorBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)colorBtnClick:(UIButton *)sender {
    switch ((int)sender.tag) {
        case 0:
            [_viewDelegate PJEditImageBottomColorViewSelectedColor:[UIColor redColor]]; break;
        case 1:
            [_viewDelegate PJEditImageBottomColorViewSelectedColor:[UIColor blueColor]]; break;
        case 2:
            [_viewDelegate PJEditImageBottomColorViewSelectedColor:[UIColor greenColor]]; break;
    }
}


@end
