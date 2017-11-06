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
    _userImgView.layer.cornerRadius = _userImgView.frame.size.height / 2;
    _userImgView.layer.masksToBounds = true;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = RGB(50, 50, 50);
}

- (void)setCellDict:(NSDictionary *)cellDict {
    _cellDict = cellDict;
    
}

@end
