//
//  PJCardImageView.m
//  Peek
//
//  Created by pjpjpj on 2018/7/23.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJCardImageView.h"

@class PJEditImageTouchView;
@implementation PJCardImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

/*
 *  @description: 注意！实现的该copy协议并不是存粹的copy，而是都转为了UIImageView！！！
 */
- (id)copyWithZone:(NSZone *)zone {
    PJCardImageView *card = [[[self class] allocWithZone:zone] init];
    card.image = self.image;
    UIImageView *touchImageView = [[UIImageView alloc] initWithFrame:self.touchImageView.frame];
    touchImageView.image = self.touchImageView.image;
    card.touchImageView = touchImageView;
    UIImageView *opencvImageView = [[UIImageView alloc] initWithFrame:self.openvcImageView.frame];
    opencvImageView.image = self.openvcImageView.image;
    card.openvcImageView = opencvImageView;
    return card;
}

- (void)initView {
    
}

- (void)setTouchView:(PJEditImageTouchView *)touchView {
    _touchView = touchView;
    [self addSubview:touchView];
}

- (void)setOpenvcImageView:(UIImageView *)openvcImageView {
    _openvcImageView = openvcImageView;
    [self addSubview:openvcImageView];
}

- (void)setTouchImageView:(UIImageView *)touchImageView {
    _touchImageView = touchImageView;
    [self addSubview:touchImageView];
}

@end
