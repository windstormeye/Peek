//
//  PJUserLoginViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/27.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJUserLoginViewController.h"

@interface PJUserLoginViewController () <UITextFieldDelegate>

@property (nonatomic, readwrite, strong) UITextField *phoneTextField;
@property (nonatomic, readwrite, strong) UITextField *verityTextField;
@property (nonatomic, readwrite, strong) UIButton *verityButton;
@property (nonatomic, readwrite, strong) UIButton *loginButton;

@end

@implementation PJUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageView];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:effectView];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, self.view.height * 0.1, self.view.width - 20, self.view.height * 0.7)];
    [self.view addSubview:backView];
    [PJTool addShadowToView:backView withOpacity:0.3 shadowRadius:5 andCornerRadius:8];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, backView.bottom + 10, self.view.width - 20, self.view.height * 0.1 - 10)];
    [self.view addSubview:cancleBtn];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleBtn.backgroundColor = [UIColor whiteColor];
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [PJTool addShadowToView:cancleBtn withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 20)];
    [backView addSubview:tipsLabel];
    tipsLabel.text = @"手 机 号 直 接 登 录";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor blackColor];
    tipsLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.phoneTextField = ({
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(0, tipsLabel.bottom + 20, backView.width * 0.8, 45)];
        [backView addSubview:textfield];
        textfield.centerX = backView.centerX - 10;
        textfield.layer.cornerRadius = 8;
        textfield.layer.masksToBounds = YES;
        textfield.layer.borderColor = RGB(230, 230, 230).CGColor;
        textfield.layer.borderWidth = 1;
        textfield.placeholder = @"手机号码";
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.backgroundColor = RGB(240, 240, 240);
        textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.tintColor = [UIColor blackColor];
        textfield.tag = 1000;
        textfield.delegate = self;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textfield;
    });
    
    self.verityTextField = ({
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(self.phoneTextField.left, self.phoneTextField.bottom + 30, backView.width * 0.5, 45)];
        [backView addSubview:textfield];
        textfield.placeholder = @"验证码";
        textfield.layer.cornerRadius = 8;
        textfield.layer.masksToBounds = YES;
        textfield.layer.borderColor = RGB(230, 230, 230).CGColor;
        textfield.layer.borderWidth = 1;
        textfield.font = [UIFont systemFontOfSize:15];
        textfield.backgroundColor = RGB(240, 240, 240);
        textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.tintColor = [UIColor blackColor];
        textfield.tag = 2000;
        textfield.delegate = self;
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        textfield;
    });
    
    self.verityButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.verityTextField.right + 10, self.verityTextField.top, self.phoneTextField.width - self.verityTextField.width - 10, self.verityTextField.height)];
        [backView addSubview:button];
        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
        button.backgroundColor = RGB(200, 200, 200);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [PJTool addShadowToView:button withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
        
        button;
    });
    
    self.loginButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.verityTextField.left, self.verityTextField.bottom + 30, self.phoneTextField.width, self.phoneTextField.height)];
        [backView addSubview:button];
        [button setTitle:@"登 录" forState:UIControlStateNormal];
        button.backgroundColor = RGB(200, 200, 200);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [PJTool addShadowToView:button withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
        
        button;
    });
    
    UILabel *attentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.loginButton.bottom + 20, 0, 0)];
    attentionLabel.text = @"点击登录即表示您同意";
    attentionLabel.textColor = [UIColor blackColor];
    attentionLabel.font = [UIFont systemFontOfSize:11];
    attentionLabel.textColor = RGB(150, 150, 150);
    [backView addSubview:attentionLabel];
    [attentionLabel sizeToFit];
    attentionLabel.centerX = backView.centerX - 40;
    
    UIButton *protocolButton = [[UIButton alloc] initWithFrame:CGRectMake(0, attentionLabel.y, 0, 0)];
    [backView addSubview:protocolButton];
    [protocolButton setTitle:@"用户协议" forState:UIControlStateNormal];
    [protocolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    protocolButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [protocolButton sizeToFit];
    protocolButton.left = attentionLabel.right + 2;
    protocolButton.centerY = attentionLabel.centerY;
    [protocolButton addTarget:self action:@selector(protocolButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(backView.width * 0.15, attentionLabel.bottom + 30, backView.width * 0.7, 1)];
    lineView.backgroundColor = RGB(230, 230, 230);
    [backView addSubview:lineView];
    
    UILabel *otherLogin = [[UILabel alloc] initWithFrame:CGRectMake(0, lineView.bottom + 30, 0, 0)];
    [backView addSubview:otherLogin];
    otherLogin.font = [UIFont boldSystemFontOfSize:15];
    otherLogin.text = @"其 它 方 式 登 录";
    otherLogin.textColor = [UIColor blackColor];
    [otherLogin sizeToFit];
    otherLogin.centerX = backView.centerX;
    
    UIButton *wechatButton = [[UIButton alloc] initWithFrame:CGRectMake(self.phoneTextField.left, otherLogin.bottom + 20, self.phoneTextField.width / 2 - 10, self.loginButton.height + 10)];
    [backView addSubview:wechatButton];
    [wechatButton setImage:[UIImage imageNamed:@"user_wechat"] forState:UIControlStateNormal];
    wechatButton.backgroundColor = RGB(60, 179, 113);
    [PJTool addShadowToView:wechatButton withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
    
    UIButton *xinlangButton = [[UIButton alloc] initWithFrame:CGRectMake(wechatButton.right + 20, otherLogin.bottom + 20, self.phoneTextField.width / 2 - 10, self.loginButton.height + 10)];
    [backView addSubview:xinlangButton];
    [xinlangButton setImage:[UIImage imageNamed:@"user_xinlang"] forState:UIControlStateNormal];
    xinlangButton.backgroundColor = RGB(255, 165, 0);
    [PJTool addShadowToView:xinlangButton withOpacity:0.2 shadowRadius:5 andCornerRadius:8];
    
}

- (void)cancleBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)protocolButtonClick {
    
}

# pragma mark: delegate



@end
