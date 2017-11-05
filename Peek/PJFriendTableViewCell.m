//
//  PJFriendTableViewCell.m
//  Peek
//
//  Created by pjpjpj on 2017/11/4.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJFriendTableViewCell.h"

@implementation PJFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
    
}

- (void)setCellDict:(NSDictionary *)cellDict {
    _cellDict = cellDict;
    
}

@end
