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
    self.backgroundColor = [UIColor clearColor];
    [self registerNib:[UINib nibWithNibName:@"PJFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"PJFriendTableViewCell"];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableViewDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PJFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PJFriendTableViewCell" forIndexPath:indexPath];
    return cell;
}

@end
