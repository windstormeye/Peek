//  PJEditTableView.m
//  Peek
//
//  Created by pjpjpj on 2017/7/4.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditTableView.h"
#import "PJEditTableViewCell.h"

@implementation PJEditTableView
{
    PJEditHeaderView *_kHeadView;
}

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    
    [self registerNib:[UINib nibWithNibName:@"PJEditTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJEditTableViewCell"];

    self.rowHeight = 60;
    self.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _kHeadView = [[[NSBundle mainBundle] loadNibNamed:@"PJEditHeaderView" owner:self options:nil] firstObject];
    _kHeadView.viewDeleget = self;
    return _kHeadView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_HEIGHT * 0.3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJEditTableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.nameLabel.text = @"昵称";
            if ([[BmobUser currentUser] objectForKey:@"nickname"]) {
                cell.detailLabel.text = [[BmobUser currentUser] objectForKey:@"nickname"];
            } else {
                cell.detailLabel.text = @"还未设置昵称哦~";
            } break;
        case 1:
            cell.nameLabel.text = @"邮箱";
            if ([[BmobUser currentUser] objectForKey:@"email"]) {
                cell.detailLabel.text = [[BmobUser currentUser] objectForKey:@"email"];
            } else {
                cell.detailLabel.text = @"还未设置邮箱哦~";
            } break;
        case 2:
            cell.nameLabel.text = @"手机";
            if ([[BmobUser currentUser] objectForKey:@"username"]) {
                cell.detailLabel.text = [[BmobUser currentUser] objectForKey:@"username"];
            } break;
        case 3:
            cell.nameLabel.text = @"密码";
            cell.detailLabel.font = [UIFont systemFontOfSize:35];
            cell.detailLabel.text = @"········";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableDelegate PJEditTableViewDidSelected:indexPath.row];
}

- (void)PJEditHeaderViewChangeAvatar:(UIImageView *)img {
    [_tableDelegate PJEditTableViewChangeAvater:img];
}

@end
