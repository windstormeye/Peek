//
//  PJUserViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/26.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJUserViewController.h"
#import "PJUserFavoriteView.h"

@interface PJUserViewController ()

@property (nonatomic, readwrite, strong) UIImageView *userBackImageView;
@property (nonatomic, readwrite, strong) UILabel *userNameLabel;
@property (nonatomic, readwrite, assign) NSInteger attentionNum;
@property (nonatomic, readwrite, assign) NSInteger listNum;

@property (nonatomic, readwrite, strong) PJUserFavoriteView *favoriteView;
@property (nonatomic, readwrite, strong) UIScrollView *backScrollView;


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
    self.attentionNum = 0;
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 50, 20)];
    [self.view addSubview:cancleBtn];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    [self.view addSubview:self.backScrollView];
    self.backScrollView.showsVerticalScrollIndicator = NO;
    
    self.userBackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, self.view.width * 0.7, 140)];
    [self.backScrollView addSubview:self.userBackImageView];
    self.userBackImageView.image = [PJTool imageWithRoundCorner:[UIImage imageNamed:@"userBackView"] cornerRadius:8.0 size:self.userBackImageView.size];
    self.userBackImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.userBackImageView.layer.shadowRadius = 5;
    self.userBackImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.userBackImageView.layer.shadowOpacity = 0.2;
    
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
    [self.backScrollView addSubview:messageButton];
    [messageButton setImage:[UIImage imageNamed:@"user_message"] forState:UIControlStateNormal];
    messageButton.backgroundColor = [UIColor whiteColor];
    [PJTool addShadowToView:messageButton withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(messageButton.left, messageButton.bottom + 10, messageButton.width, self.userBackImageView.height - messageButton.height - 10)];
    [self.backScrollView addSubview:settingBtn];
    [settingBtn setImage:[UIImage imageNamed:@"user_setting"] forState:UIControlStateNormal];
    settingBtn.backgroundColor = [UIColor whiteColor];
    [PJTool addShadowToView:settingBtn withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
    
    UIView *attentionListView = ({
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userBackImageView.bottom + 30, self.view.width, 40)];
        [self.backScrollView addSubview:listView];
        
        UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
        tagImageView.image = [UIImage imageNamed:@"user_tag"];
        [listView addSubview:tagImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tagImageView.right + 10, 0, 50, listView.height)];
        [listView addSubview:label];
        label.text = @"关注";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        UIImageView *detailsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(listView.width - 30, (listView.height - listView.height * 0.7 * 0.7)/2, 15 * 0.7, listView.height * 0.7 * 0.7)];
        detailsImageView.image = [UIImage imageNamed:@"user_details"];
        [listView addSubview:detailsImageView];
        
        UILabel *attentionNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listView.width - label.right - detailsImageView.width - 10, listView.height)];
        attentionNumLabel.right = detailsImageView.left - 10;
        [listView addSubview:attentionNumLabel];
        attentionNumLabel.text = [NSString stringWithFormat:@"你现在有 %ld 个关注", (long)self.attentionNum];
        attentionNumLabel.textAlignment = NSTextAlignmentRight;
        attentionNumLabel.textColor = RGB(150, 150, 150);
        attentionNumLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        listView;
    });
    
    UIView *cardListView = ({
        UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userBackImageView.bottom + 30 + 40 + 20, self.view.width, 40)];
        [self.backScrollView addSubview:listView];
        
        UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
        tagImageView.image = [UIImage imageNamed:@"user_list"];
        [listView addSubview:tagImageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tagImageView.right + 10, 0, 50, listView.height)];
        [listView addSubview:label];
        label.text = @"清单";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        UIImageView *detailsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(listView.width - 30, (listView.height - listView.height * 0.7 * 0.7)/2, 15 * 0.7, listView.height * 0.7 * 0.7)];
        detailsImageView.image = [UIImage imageNamed:@"user_details"];
        [listView addSubview:detailsImageView];
        
        UILabel *listNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listView.width - label.right - detailsImageView.width - 10, listView.height)];
        listNumLabel.right = detailsImageView.left - 10;
        [listView addSubview:listNumLabel];
        listNumLabel.text = [NSString stringWithFormat:@"%ld 个清单正在进行", (long)self.attentionNum];
        listNumLabel.textAlignment = NSTextAlignmentRight;
        listNumLabel.textColor = RGB(150, 150, 150);
        listNumLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        listView;
    });
    
    self.favoriteView = ({
        PJUserFavoriteView *favoriteView = [[PJUserFavoriteView alloc] initWithFrame:CGRectMake(10, cardListView.bottom + 30, self.view.width - 20, 250)];
        [self.backScrollView addSubview:favoriteView];
        favoriteView;
    });

    if (self.favoriteView.bottom + 10 < self.view.height) {
        self.backScrollView.contentSize = CGSizeMake(0, self.view.height + 1);
    } else {
        self.backScrollView.contentSize = CGSizeMake(0, self.favoriteView.bottom + 20);
    }
}

- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
