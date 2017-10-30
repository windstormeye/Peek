//
//  PJCardViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/10/23.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJCardViewController.h"
#import "PJOpenCV.h"
#import "PJCardBottomView.h"

#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface PJCardViewController () <PJCardBottomViewDelegate>

@end

@implementation PJCardViewController {
    PJCardBottomView *_kBottomView;
    UIView *_kImgContentView;
    UIImageView *_kAnswerImageView;
    UIImageView *_kOldImageView;
    UIImageView *_kTagImageView;
    BOOL isTapic;
}

-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self showBottomView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    isTapic = false;
    
    [self initNavigationBar];
    self.titleLabel.text = @"卡片编辑";
    self.titleLabel.textColor = [UIColor blackColor];
    CGRect frame = self.titleLabel.frame;
    frame.origin.y -= 10;
    self.titleLabel.frame = frame;
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.25, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8, SCREEN_WIDTH * 0.5, 10)];
    [self.navigationBar addSubview:tipsLabel];
    tipsLabel.text = @"压按图片触发显示效果";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:12];
    
    [self.rightBarButton setImage:[UIImage imageNamed:@"card_share"] forState:UIControlStateNormal];
    [self.rightBarButton addTarget:self action:@selector(rightbarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.leftBarButton.hidden = true;
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImgView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:bgImgView];
    [self.view sendSubviewToBack:bgImgView];
    // 开启高斯模糊
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    
    _kBottomView = [[NSBundle mainBundle] loadNibNamed:@"PJCardBottomView" owner:self options:nil].firstObject;
    // 设置初始坐标
    _kBottomView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60);
    _kBottomView.viewDelegate = self;
    [self.view addSubview:_kBottomView];
    
    _kTagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 40, 40)];
    [self.navigationBar addSubview:_kTagImageView];
}

- (void)setDealImageView:(UIImage *)dealImageView {
    [PJHUD showWithStatus:@""];
    _dealImageView = dealImageView;
    [self dealImageWithOpenCV:dealImageView];
    if (_isRed) {
        _kTagImageView.image = [UIImage imageNamed:@"red_circle"];
    } else {
        _kTagImageView.image = [UIImage imageNamed:@"blue_circle"];
    }
}

// 右键分享按钮点击事件
- (void)rightbarButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"您要分享的方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"保存且分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImageWriteToSavedPhotosAlbum(_kOldImageView.image,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [self shareWebPageToPlatformType:platformType withImage:_kOldImageView.image];
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //显示分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [self shareWebPageToPlatformType:platformType withImage:_kOldImageView.image];
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        [PJHUD showErrorWithStatus:@"保存失败"];
    }else{
        [PJHUD showSuccessWithStatus:@"保存成功，可进入相册查看"];
    }
}

- (void)setIsRed:(BOOL)isRed {
    _isRed = isRed;
}

- (void)dealImageWithOpenCV:(UIImage *)image {
    _kImgContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT - 74 - 60)];
    _kImgContentView.userInteractionEnabled = true;
    [self.view addSubview:_kImgContentView];
    CGFloat imgW = 0;
    CGFloat imgH = 0;
    CGFloat lwScale = 0;
    NSInteger imgOri = image.imageOrientation;
    if (imgOri == 3) {
        lwScale = image.size.width / image.size.height;
        imgH = SCREEN_HEIGHT - 74 - 60;
        imgW = lwScale * imgH;
    }
    // 注意考虑照片大小、方向、缩放问题
    
    UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
    UIImage *newImage = [UIImage new];
    if (_isRed) {
        newImage = [PJOpenCV imageToDiscernRed:image];
        _kAnswerImageView = newImageView;
        newImageView.image = newImage;
        UIImageView *oldImageView = [[UIImageView alloc] initWithFrame:newImageView.frame];
        oldImageView.image = image;
        _kOldImageView = oldImageView;
        [_kImgContentView addSubview:oldImageView];
        [_kImgContentView addSubview:newImageView];
    } else {
        newImage = [PJOpenCV imageToDiscernBlue:image];
        newImageView.image = newImage;
        _kAnswerImageView = newImageView;
        [_kImgContentView addSubview:newImageView];
    }

    [PJHUD dismiss];
}

- (void)showBottomView {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _kBottomView.frame;
        frame.origin.y -= 60;
        _kBottomView.frame = frame;
    }];
}

// 3D-Touch
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_isRed) {
        return;
    }
    NSArray *arrayTouch = [touches allObjects];
    UITouch *touch = (UITouch *)[arrayTouch lastObject];
    _kAnswerImageView.alpha = 1 - touch.force / 6;
    if (_kAnswerImageView.alpha < 0.15 && !isTapic) {
        AudioServicesPlaySystemSound(1519);
        isTapic = true;
    }
    if (_kAnswerImageView.alpha > 0.9) {
        isTapic = false;
    }
    if (_kAnswerImageView.alpha > 0.65) {
        _kAnswerImageView.alpha  = 1.0;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _kAnswerImageView.alpha = 1;
}

// 图片上传
-(void)PJCardBottomViewYesBtnClick {
//    [PJHUD showWithStatus:@"图片上传中..."];
//    NSData *data = UIImagePNGRepresentation([_kOldImageView.image imageCompress:500]);
//    BmobFile *file = [[BmobFile alloc]initWithFileName:[NSString stringWithFormat:@"%@%@.png", [[BmobUser currentUser] objectForKey:@"username"], [self getCurrentTimes]] withFileData:data];
//    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
//        if (isSuccessful) {
//            BmobObject  *post = [BmobObject objectWithClassName:@"User_image"];
//            [post setObject:file.url forKey:@"image_url"];
//            [post setObject:[BmobUser currentUser] forKey:@"author"];
//            [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                if (isSuccessful) {
//                    AudioServicesPlaySystemSound(1521);
//                    [self.navigationController popViewControllerAnimated:true];
//                    [PJHUD showSuccessWithStatus:@"上传成功!"];
//                }else{
//                    if (error) {
//                        NSLog(@"%@",error);
//                    }
//                }
//            }];
//        }else{
//            //进行处理
//        }
//    }];
    
    [PJTapic succee];
    
}

- (void)PJCardBottomViewNoBtnClick {
    [self.navigationController popViewControllerAnimated:true];
}

// 获取当前系统时间戳
- (NSString*)getCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

// 调用分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withImage:(UIImage *)image{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:image];
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *testPath = [documentPath stringByAppendingPathComponent:@"gameOver.png"];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:testPath error:nil];
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end
