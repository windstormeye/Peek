//
//  PJUserViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/26.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJUserViewController.h"

@interface PJUserViewController ()

@property (nonatomic, readwrite, strong) UIImageView *userBackImageView;
@property (nonatomic, readwrite, strong) UILabel *userNameLabel;

@end

@implementation PJUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, self.view.width * 0.7, 140)];
    [self.view addSubview:self.userBackImageView];
    self.userBackImageView.image = [PJTool imageWithRoundCorner:[UIImage imageNamed:@"userBackView"] cornerRadius:8.0 size:self.userBackImageView.size];
    self.userBackImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.userBackImageView.layer.shadowRadius = 5;
    self.userBackImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.userBackImageView.layer.shadowOpacity = 0.3;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.userBackImageView.width, self.userBackImageView.height)];
    [self.userBackImageView addSubview:backView];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.3;
    backView.layer.cornerRadius = 8;
    backView.layer.masksToBounds = YES;
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 20)];
    [self.userBackImageView addSubview:self.userNameLabel];
    self.userNameLabel.text = @"培钧";
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.userNameLabel sizeToFit];
    self.userNameLabel.bottom = self.userBackImageView.height - 20 - 15;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userNameLabel.left, self.userNameLabel.bottom + 5, 0, 10)];
    [self.userBackImageView addSubview:tipsLabel];
    tipsLabel.text = @"查看主页";
    [tipsLabel sizeToFit];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    
    UIImageView *editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [self.userBackImageView addSubview:editImageView];
    editImageView.right = self.userBackImageView.width - 10;
    editImageView.image = [UIImage imageNamed:@"user_edit"];
    
    CGFloat messageBtnW = self.view.width - self.userBackImageView.right - 20;
    UIButton *messageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.userBackImageView.right + 10, self.userBackImageView.top, messageBtnW, self.userBackImageView.height * 0.55)];
    [self.view addSubview:messageButton];
    [messageButton setImage:[UIImage imageNamed:@"user_message"] forState:UIControlStateNormal];
    messageButton.backgroundColor = [UIColor whiteColor];
    [PJTool addShadowToView:messageButton withOpacity:0.3 shadowRadius:5 andCornerRadius:8];
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(messageButton.left, messageButton.bottom + 10, messageButton.width, self.userBackImageView.height - messageButton.height - 10)];
    [self.view addSubview:settingBtn];
    [settingBtn setImage:[UIImage imageNamed:@"user_setting"] forState:UIControlStateNormal];
    settingBtn.backgroundColor = [UIColor whiteColor];
    [PJTool addShadowToView:settingBtn withOpacity:0.3 shadowRadius:5 andCornerRadius:8];
    
    UIView *attentionListView = ({
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userBackImageView.bottom + 30, self.view.width, 40)];
        [self.view addSubview:listView];
        
        UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
        tagImageView.image = [UIImage imageNamed:@"user_tag"];
        [listView addSubview:tagImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tagImageView.right + 10, 0, 50, listView.height)];
        [listView addSubview:label];
        label.text = @"关注";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        UIImageView *detailsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(listView.width - 30, tagImageView.y, tagImageView.width, listView.height)];
        detailsImageView.image = [UIImage imageNamed:@"user_details"];
        [listView addSubview:detailsImageView];
        
        listView;
    });
    
    UIView *cardListView = ({
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userBackImageView.bottom + 30 + 40 + 20, self.view.width, 40)];
        [self.view addSubview:listView];
        
        UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
        tagImageView.image = [UIImage imageNamed:@"user_list"];
        [listView addSubview:tagImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tagImageView.right + 10, 0, 50, listView.height)];
        [listView addSubview:label];
        label.text = @"清单";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        UIImageView *detailsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(listView.width - 30, tagImageView.y, tagImageView.width, listView.height)];
        detailsImageView.image = [UIImage imageNamed:@"user_details"];
        [listView addSubview:detailsImageView];
        
        listView;
    });
    
}

@end
