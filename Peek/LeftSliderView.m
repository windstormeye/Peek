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
    _avatarImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImgView.layer.borderWidth = 2;
    _avatarImgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_avatarImgView addGestureRecognizer:singleTap];
    
    if ([[BmobUser currentUser] objectForKey:@"nickname"]) {
        _useridLabel.text = [[BmobUser currentUser] objectForKey:@"nickname"];
    } else {
        _useridLabel.text = @"";
    }
    
    if ([[BmobUser currentUser] objectForKey:@"username"]) {
        _usernameLabel.text = [[BmobUser currentUser] objectForKey:@"username"];
    } else {
        _usernameLabel.text = @"还未登录噢~";
    }
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
