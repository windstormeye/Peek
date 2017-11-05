//
//  PJFriendHomeView.m
//  Peek
//
//  Created by pjpjpj on 2017/11/4.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJFriendHomeView.h"
#import "PJFriendTableView.h"

@implementation PJFriendHomeView {
    PJFriendTableView *_kTableView;
}

- (instancetype)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH * 0.6, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:effectView];
}

@end
