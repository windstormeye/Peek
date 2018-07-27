//
//  PJHUD.m
//  Peek
//
//  Created by pjpjpj on 2018/7/27.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJHUD.h"

@interface PJHUD ()

@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UIButton *coverButton;

@end

@implementation PJHUD

static PJHUD *instance = nil;

+ (PJHUD *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PJHUD new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
    if (iPhoneX) {
        self.y -= 20;
        self.height += 20;
    }
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    self.titleLabel = ({
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.height - 20)/2 + 10, 0, 20)];
        [self addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightLight];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel;
    });
    
    self.coverButton = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self addSubview:button];
        button.hidden = YES;
        [button addTarget:self
                   action:@selector(coverButtonClick)
         forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
}

- (void)warningString:(NSString *)warningString coverHidden:(BOOL)hidden{
    if (hidden) {
        self.coverButton.hidden = NO;
        [self bringSubviewToFront:self.coverButton];
    }
    self.titleLabel.text = warningString;
    self.type = warning;
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.centerX;
    self.type = warning;
    
    [PJTapic warning];
    [self show];
}

- (void)errorString:(NSString *)errorString coverHidden:(BOOL)hidden{
    if (hidden) {
        self.coverButton.hidden = NO;
        [self bringSubviewToFront:self.coverButton];
    }
    self.titleLabel.text = errorString;
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.centerX;
    self.type = error;
    
    [PJTapic error];
    [self show];
}

- (void)show {
    if (self.top == 0) {
        return;
    }
    [[PJTool TopWindow] addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.top = 0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.bottom = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)coverButtonClick {
    if (self.coverButtonBlock) {
        self.coverButtonBlock();
    }
}

# pragma mark setter and getter

- (void)setType:(HUDType)type {
    switch (type) {
        case 0:
            self.backgroundColor = RGB(218, 165, 32);
            break;
        case 1:
            self.backgroundColor = RGB(178, 34, 34);
        default:
            break;
    }
}

@end
