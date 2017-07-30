//
//  EditViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/13.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "EditViewController.h"
#import "PJEditTableView.h"

@interface EditViewController () <PJEditTableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation EditViewController
{
    PJEditTableView *_kTableView;
    UIImageView *_kAvatarImageVIew;
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
    [self initNavigationBar];
    self.titleLabel.text = @"我的资料";
    self.titleLabel.textColor = [UIColor blackColor];
    [self.leftBarButton setImage:[[UIImage imageNamed:@"back"] imageWithColor:[UIColor blackColor]] forState:0];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    
    _kTableView = [[PJEditTableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_WIDTH - 64) style:UITableViewStyleGrouped];
    _kTableView.tableDelegate = self;
    [self.view addSubview:_kTableView];
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

@end
