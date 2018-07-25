//
//  EditViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/13.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "EditViewController.h"
#import "PJEditTableView.h"
#import "PJModifyViewController.h"

@interface EditViewController () <PJEditTableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation EditViewController
{
    PJEditTableView *_kTableView;
    UIImageView *_kAvatarImageVIew;
    UIView *_kBigImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
//    [self initNavigationBar];
//    self.titleLabel.text = @"我的资料";
//    self.titleLabel.textColor = [UIColor blackColor];
//    [self.leftBarButton setImage:[[UIImage imageNamed:@"back"] imageWithColor:[UIColor blackColor]] forState:0];
//    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    bgImgView.image = [UIImage imageNamed:@"背景"];
//    [self.view addSubview:bgImgView];
//    [self.view sendSubviewToBack:bgImgView];
//    
//    // 开启高斯模糊
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
//    [bgImgView addSubview:effectView];
//    
//    _kTableView = [[PJEditTableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH - 64) style:UITableViewStyleGrouped];
//    _kTableView.tableDelegate = self;
//    [self.view addSubview:_kTableView];
//    
//    _kBigImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [self.view addSubview:_kBigImageView];
////    _kBigImageView.backgroundColor = [UIColor blackColor];
//    UIVisualEffectView *effectBigView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectBigView.frame = CGRectMake(0, 0, _kBigImageView.frame.size.width, _kBigImageView.frame.size.height);
//    [_kBigImageView addSubview:effectBigView];
//    _kBigImageView.alpha = 0;
//    _kBigImageView.hidden = true;
//    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
//    [_kBigImageView addGestureRecognizer:viewTap];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyReload:) name:@"modifyNo"  object:nil];
}

// 收到更新昵称通知
- (void)modifyReload:(NSNotification *)no {
    if (no.userInfo[@"isModify"]) {
        [_kTableView reloadData];
    }
}

- (void)PJEditTableViewChangeAvater:(UIImageView *)img {
    _kAvatarImageVIew = img;
    
    //实例化照片选择控制器
    UIImagePickerController *pickControl=[[UIImagePickerController alloc]init];
    //设置照片源
    [pickControl setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    //设置协议
    [pickControl setDelegate:self];
    //设置编辑
    [pickControl setAllowsEditing:YES];
    //选完图片之后回到的视图界面
    [self presentViewController:pickControl animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //    UIImage *image=info[@"UIImagePickerControllerOriginalImage"];
    
    UIImage *image=info[@"UIImagePickerControllerEditedImage"];
    [_kAvatarImageVIew setImage:image];

    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:^{
        NSData *data = UIImagePNGRepresentation(image);
        BmobFile *file1 = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@_avatar.png", [[BmobUser currentUser] objectForKey:@"username"]] withFileData:data];
        
        [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
            //如果文件保存成功，则把文件添加到filetype列
            if (isSuccessful) {
                BmobUser *bUser = [BmobUser currentUser];
                [bUser setObject:file1.url forKey:@"avatar_url"];
                [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    NSLog(@"error %@",[error description]);
                    NSNotification *notification = [NSNotification notificationWithName:@"changeAvarta" object:nil userInfo:@{@"isChange":@true}];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                }];
            }else{
                //进行处理
            }
        }];
    }];
}

-(void)PJEditTableViewDidSelected:(NSInteger)index {
    PJModifyViewController *vc = [PJModifyViewController new];
    NSString *nameStr = @"";
    if (index == 0) {
        nameStr = @"修改昵称";
        [vc initWithTitleLabelName:nameStr];
        vc.type = nickName;
    } else if (index == 1) {
        nameStr = @"编辑邮箱";
        [vc initWithTitleLabelName:nameStr];
        vc.type = email;
    } else if(index == 2)  {
        nameStr = @"编辑手机";
        [vc initWithTitleLabelName:nameStr];
        vc.type = phone;
    } else {
        nameStr = @"修改密码";
        [vc initWithTitleLabelName:nameStr];
        vc.type = passwd;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

// 点击消失头像大图
- (void)viewTap {
    [UIView animateWithDuration:0.2 animations:^{
        _kBigImageView.alpha = 0;
    } completion:^(BOOL finished) {
        _kBigImageView.hidden = true;
    }];
    for (UIView *view in _kBigImageView.subviews) {
        if (view.tag == 1000) {
            [view removeFromSuperview];
        }
    }
}

// 点击放大头像
- (void)PJEditHeaderViewToLargerImage:(UIImageView *)img {
    UIImageView *bigImg = [[UIImageView alloc] initWithImage:img.image];
    bigImg.tag = 1000;
    [_kBigImageView addSubview:bigImg];
    bigImg.frame = CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH);
    bigImg.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _kBigImageView.hidden = false;
        _kBigImageView.alpha = 1;
        bigImg.alpha = 1;
    }];
}

@end
