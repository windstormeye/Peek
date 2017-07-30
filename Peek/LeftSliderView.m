//
//  LeftSliderView.m
//  Peek
//
//  Created by pjpjpj on 2017/6/5.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "LeftSliderView.h"

@implementation LeftSliderView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.6, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    _heighConstraint.constant = SCREEN_HEIGHT * 0.4;
    
    _avatarImgView.layer.cornerRadius = _avatarImgView.frame.size.width / 2;
    _avatarImgView.layer.masksToBounds = YES;
    _avatarImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    _usernameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    [_usernameLabel addGestureRecognizer:labelTapGestureRecognizer];
    
    UITapGestureRecognizer *labelTapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    _useridLabel.userInteractionEnabled = YES;
    [_useridLabel addGestureRecognizer:labelTapGestureRecognizer2];
    
    [_avatarImgView addGestureRecognizer:singleTap];
    
    [self setViewDate];
}

- (void)setViewDate {
    if ([[BmobUser currentUser] objectForKey:@"username"]) {
        _useridLabel.text = [[BmobUser currentUser] objectForKey:@"username"];
    } else {
        _useridLabel.text = @"";
    }
    
    if ([[BmobUser currentUser] objectForKey:@"nickname"]) {
        _usernameLabel.text = [[BmobUser currentUser] objectForKey:@"nickname"];
    } else {
        _usernameLabel.text = @"还未设置昵称哦~";
    }
    
    if ([[BmobUser currentUser] objectForKey:@"avatar_url"]) {
        [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"avatar_url"]]];
    }
}

- (void)labelClick {
    [_viewDelegate tapAvatar];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    [_viewDelegate tapAvatar];
}

- (IBAction)moreAction:(id)sender {
}
- (IBAction)publishAction:(id)sender {
    [_viewDelegate myPublishAction];
}
- (IBAction)messageCenterAction:(id)sender {
    [_viewDelegate messageAction];
}
- (IBAction)editAction:(id)sender {
    [_viewDelegate editAction];
}
- (IBAction)logoutAction:(id)sender {
    [_viewDelegate logoutAction];
}

@end
