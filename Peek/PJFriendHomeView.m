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
    UIView *_kScoreLineView;
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
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 100)];
    UIButton *addFriendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
    [headView addSubview:addFriendBtn];
    [self addSubview:headView];
    [addFriendBtn addTarget:self action:@selector(addFriendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addFriendBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    addFriendBtn.titleLabel.textColor = [UIColor whiteColor];
    addFriendBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    UIView *backScoreLineView = [[UIView alloc] initWithFrame:CGRectMake(0, addFriendBtn.frame.origin.y + addFriendBtn.frame.size.height, headView.frame.size.width, 3)];
    [headView addSubview:backScoreLineView];
    backScoreLineView.backgroundColor =RGB(100, 100, 100);

    // 好友个数背景
    _kScoreLineView = [[UIView alloc] initWithFrame:CGRectMake(backScoreLineView.frame.origin.x, backScoreLineView.frame.origin.y, backScoreLineView.frame.size.width - 100, 3)];
    [headView addSubview:_kScoreLineView];
    _kScoreLineView.backgroundColor = RGB(76, 154, 234);
    
    // 好友个数
    UILabel *friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, backScoreLineView.frame.origin.y + backScoreLineView.frame.size.height + 5, self.frame.size.width, 30)];
    [headView addSubview:friendLabel];
    friendLabel.text = @"2/30";
    friendLabel.textColor = [UIColor whiteColor];
    friendLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat tableViewY = headView.frame.origin.y + headView.frame.size.height;
    _kTableView = [[PJFriendTableView alloc] initWithFrame:CGRectMake(0, tableViewY, self.frame.size.width, self.frame.size.height - tableViewY) style:UITableViewStyleGrouped];
    NSDictionary *dict = @{@"1":@"1",
                           @"2":@"2",
                           @"3":@"3"};
    _kTableView.tableViewDict = [dict mutableCopy];
    [self addSubview:_kTableView];
    
    
    
}

- (void)addFriendBtnClick {
    
}

@end
