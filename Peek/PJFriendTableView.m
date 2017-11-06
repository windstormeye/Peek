//
//  PJFriendTableView.m
//  Peek
//
//  Created by pjpjpj on 2017/11/4.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJFriendTableView.h"
#import "PJFriendTableViewCell.h"

@implementation PJFriendTableView

- (instancetype)init {
    self = [super init];
    [self initView];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    [self initView];
    return self;
}

- (void)initView {
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    [self registerNib:[UINib nibWithNibName:@"PJFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJFriendTableViewCell"];
    self.separatorStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setTableViewDict:(NSDictionary *)tableViewDict {
    _tableViewDict = tableViewDict;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width, 30)];
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, (sectionHeadView.frame.size.height - 15)/2, self.frame.size.width, 15)];
    [sectionHeadView addSubview:headLabel];
    headLabel.text = @"我的好友";
    headLabel.textColor = [UIColor whiteColor];
    headLabel.font = [UIFont systemFontOfSize:12];
    return sectionHeadView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewDict.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJFriendTableViewCell" forIndexPath:indexPath];
    return cell;
}

@end
