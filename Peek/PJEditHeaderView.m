//
//  PJEditHeaderView.m
//  Peek
//
//  Created by pjpjpj on 2017/7/4.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditHeaderView.h"

@implementation PJEditHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self showBGViewWithAnimate];
}

- (void)initView {
    _avatarImgView.layer.cornerRadius = _avatarImgView.frame.size.width / 2;
    _avatarImgView.layer.masksToBounds = true;
    _avatarImgView.userInteractionEnabled = YES;
    _avatarImgView.hidden = YES;
    _avatarImgView.alpha = 0;
    
    _bgView.layer.cornerRadius = 5;
    _bgView.layer.masksToBounds = true;
    _bgView.hidden = YES;
    _bgView.alpha = 0;
    
    _EditBtn.hidden = YES;
    _EditBtn.alpha = 0;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_avatarImgView addGestureRecognizer:singleTap];
    [_EditBtn addTarget:self action:@selector(changeAvatar) forControlEvents:UIControlEventTouchUpInside];

    [self setViewDate];
}

- (void)setViewDate {
    if ([[BmobUser currentUser] objectForKey:@"avatar_url"]) {
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"avatar_url"]]];
    }
}

- (void)showBGViewWithAnimate {
    [UIView animateWithDuration:1.0 animations:^{
        _bgView.hidden = NO;
        _bgView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            _avatarImgView.hidden = NO;
            _avatarImgView.alpha = 1.0;
            CGRect frame = _avatarImgView.frame;
            frame.origin.y -= 20;
            _avatarImgView.frame = frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _EditBtn.hidden = NO;
                _EditBtn.alpha = 1;
            }];
        }];
    }];
}

- (void)changeAvatar {
    [_viewDeleget PJEditHeaderViewChangeAvatar:_avatarImgView];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    [_viewDeleget PJEditHeaderViewChangeAvatar:_avatarImgView];
}

@end
