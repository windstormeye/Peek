//
//  PJLoginViewController.m
//  Peek
//
//  Created by pjpjpj on 2017/6/22.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJLoginViewController.h"
#import <JVFloatLabeledTextField/JVFloatLabeledTextField.h>
#import "FUIButton.h"


@interface PJLoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (nonatomic, strong) UITextField *nameTxt;
@property (nonatomic, strong) UITextField *passwdTxt;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *signUpBtn;
@property (nonatomic, strong) UIButton *signUpBtn_small;
@property (nonatomic, strong) UIButton *loginBtn_small;
@end

@implementation PJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    [self initNavigationBar];
    self.leftBarButton.hidden = true;
    self.titleLabel.text = @"登录";
    
    UIButton *leftBarButton = [[UIButton alloc]initWithFrame:CGRectMake(25, 35, 28, 28)];
    [leftBarButton setImage:[[UIImage imageNamed:@"back"] imageWithColor:[UIColor whiteColor]] forState:0];
    leftBarButton.tintColor = [UIColor whiteColor];
    [leftBarButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBarButton];

    UIVisualEffectView *effectView =[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [_bgView addSubview:effectView];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.5)/2, 90, SCREEN_WIDTH * 0.5, SCREEN_WIDTH * 0.5)];
    logoImg.layer.cornerRadius = logoImg.frame.size.width * 0.2;
    logoImg.layer.masksToBounds = YES;
    logoImg.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImg];
    
    JVFloatLabeledTextField *nameTxt = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH * 0.6) / 2, CGRectGetMaxY(logoImg.frame) + 30, SCREEN_WIDTH * 0.6, 40)];
    [self.view addSubview:nameTxt];
    self.nameTxt = nameTxt;
    nameTxt.textColor = [UIColor whiteColor];
    nameTxt.font = [UIFont systemFontOfSize:16];
    nameTxt.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"用户名", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    nameTxt.floatingLabelFont = [UIFont boldSystemFontOfSize:11];
    nameTxt.floatingLabelTextColor = [UIColor lightGrayColor];
    nameTxt.floatingLabelActiveTextColor = mainDeepSkyBlue;
    nameTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTxt.keepBaseline = YES;
    // 用户名输入框下划线
    UIView *nameLineView = [[UIView alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(nameTxt.frame) + 1, nameTxt.frame.size.width, 1)];
    [self.view addSubview:nameLineView];
    nameLineView.backgroundColor = [UIColor lightGrayColor];
    // 密码输入框
    JVFloatLabeledTextField *passwdTxt = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(nameTxt.frame) + 5, nameTxt.frame.size.width, 40)];
    [self.view addSubview:passwdTxt];
    self.passwdTxt = passwdTxt;
    passwdTxt.textColor = [UIColor whiteColor];
    passwdTxt.floatingLabelActiveTextColor = mainDeepSkyBlue;
    passwdTxt.secureTextEntry = YES;
    passwdTxt.font = [UIFont systemFontOfSize:16];
    passwdTxt.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"密码", @"")
                                    attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    passwdTxt.floatingLabelFont = [UIFont boldSystemFontOfSize:11];
    passwdTxt.floatingLabelTextColor = [UIColor lightGrayColor];
    passwdTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwdTxt.keepBaseline = YES;
    // 密码输入框下划线
    UIView *passwdLineView = [[UIView alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(passwdTxt.frame) + 1, nameTxt.frame.size.width, 1)];
    [self.view addSubview:passwdLineView];
    passwdLineView.backgroundColor = [UIColor lightGrayColor];
    // 登录按钮
    FUIButton *loginBtn = [[FUIButton alloc] initWithFrame:CGRectMake(nameTxt.frame.origin.x, CGRectGetMaxY(passwdLineView.frame) + 50, nameTxt.frame.size.width, 40)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.buttonColor = mainDeepSkyBlue;
    loginBtn.shadowColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
    loginBtn.shadowHeight = 3.0f;
    loginBtn.cornerRadius = 5.0f;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    FUIButton *signUpBtn = [[FUIButton alloc] initWithFrame:CGRectMake(loginBtn.frame.origin.x, loginBtn.frame.origin.y, loginBtn.frame.size.width, loginBtn.frame.size.height)];
    [signUpBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:signUpBtn];
    self.signUpBtn = signUpBtn;
    signUpBtn.hidden = YES;
    [signUpBtn addTarget:self action:@selector(signUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    signUpBtn.buttonColor = [UIColor orangeColor];
    signUpBtn.shadowColor = [UIColor colorWithRed:139/255.0 green:90/255.0 blue:43/255.0 alpha:1];
    signUpBtn.shadowHeight = 3.0f;
    signUpBtn.cornerRadius = 5.0f;
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // 前往注册按钮
    UIButton *signUpBtn_small = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame) - 115, CGRectGetMaxY(loginBtn.frame) + 10, 115, 20)];
    [self.view addSubview:signUpBtn_small];
    self.signUpBtn_small = signUpBtn_small;
    signUpBtn_small.titleLabel.textAlignment = NSTextAlignmentCenter;
    signUpBtn_small.font = [UIFont systemFontOfSize:12];
    [signUpBtn_small setTitle:@"没有账号？前往注册" forState:UIControlStateNormal];
    [signUpBtn_small addTarget:self action:@selector(signUpBtn_smallClick) forControlEvents:UIControlEventTouchUpInside];
    // 前往登录按钮
    UIButton *loginBtn_small = [[UIButton alloc] initWithFrame:CGRectMake(signUpBtn_small.frame.origin.x, signUpBtn_small.frame.origin.y, signUpBtn_small.frame.size.width, signUpBtn_small.frame.size.height)];
    [self.view addSubview:loginBtn_small];
    loginBtn_small.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginBtn_small.font = [UIFont systemFontOfSize:12];
    [loginBtn_small setTintColor:[UIColor greenColor]];
    loginBtn_small.hidden = YES;
    self.loginBtn_small = loginBtn_small;
    [loginBtn_small setTitle:@"已有账号？前往登录" forState:UIControlStateNormal];
    [loginBtn_small addTarget:self action:@selector(loginBtn_smallClick) forControlEvents:UIControlEventTouchUpInside];
}

// 注册
- (void)signUpBtnClick {
    [PJHUD showErrorWithStatus:@"未开放注册"];
}

// 点击前往登录
- (void)signUpBtn_smallClick {
    self.loginBtn.hidden = YES;
    self.loginBtn_small.hidden = NO;
    self.signUpBtn_small.hidden = YES;
    self.signUpBtn.hidden = NO;
}

// 点击前往注册
- (void)loginBtn_smallClick {
    self.loginBtn.hidden = NO;
    self.loginBtn_small.hidden = YES;
    self.signUpBtn_small.hidden = NO;
    self.signUpBtn.hidden = YES;
}

// 登录
- (void)loginBtnClick {
    NSString *nameStr = [NSString stringWithString:self.nameTxt.text];
    NSString *passwdStr = [NSString stringWithString:self.passwdTxt.text];
    // 请在此与服务器进行用户登录及注册的交互
    if ([nameStr  isEqual: @"test"] && [passwdStr  isEqual: @"test"]) {
        [[NSUserDefaults standardUserDefaults] setObject:nameStr forKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults] setObject:passwdStr forKey:@"user_passwd"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [PJHUD showErrorWithStatus:@"请检查账号和密码"];
    }
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
