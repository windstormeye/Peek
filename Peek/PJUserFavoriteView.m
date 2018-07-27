//
//  PJUserFavoriteView.m
//  Peek
//
//  Created by pjpjpj on 2018/7/27.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJUserFavoriteView.h"

@interface PJUserFavoriteView ()

@property (nonatomic, readwrite, strong) UIView *backView;

@end

@implementation PJUserFavoriteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    titleLabel.text = @"收藏夹";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [titleLabel sizeToFit];
    titleLabel.left = 10;
    [self addSubview:titleLabel];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 60, 0, 30, 15)];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.centerY = titleLabel.centerY;
    [self addSubview:editBtn];
    [editBtn setTitleColor:RGB(0, 85, 255) forState:UIControlStateNormal];
    
    UIImageView *penImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 15 - 10, 0, 15, 15)];
    penImageView.centerY = editBtn.centerY;
    penImageView.image = [UIImage imageNamed:@"user_edit_pen"];
    [self addSubview:penImageView];
    
    self.backView = ({
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, titleLabel.bottom + 20, self.width - 20, self.height - titleLabel.height - 20)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [PJTool addShadowToView:backView withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
        backView.layer.shadowColor = [UIColor blackColor].CGColor;
        backView.layer.shadowRadius = 5;
        backView.layer.shadowOpacity = 0.3;
        backView.layer.shadowOffset = CGSizeMake(0, 0);
        backView;
    });
    
    [self initFavoriteBtn];
    
}

- (void)initFavoriteBtn {
    UIImageView *favoriteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.backView.width - 20, self.backView.height - 20)];
    [self.backView addSubview:favoriteImageView];
    favoriteImageView.image = [UIImage imageNamed:@"user_favorite_backView"];
    favoriteImageView.contentMode = UIViewContentModeScaleAspectFill;
    favoriteImageView.layer.cornerRadius = 8;
    favoriteImageView.layer.masksToBounds = YES;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, favoriteImageView.width, favoriteImageView.height)];
    [favoriteImageView addSubview:backView];
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.3;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 0, 0)];
    [favoriteImageView addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    titleLabel.text = @"我的\n成长手册";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [titleLabel sizeToFit];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:favoriteImageView.frame];
    [self.backView addSubview:btn];
    btn.layer.cornerRadius = 8;
    btn.tag = 0;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(favoriteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)favoriteBtnClick:(UIButton *)sender {
    NSLog(@"%ld", (long)sender.tag);
}

@end
