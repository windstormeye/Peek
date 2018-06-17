//
//  PJBaseViewController.m
//  DiDiData
//
//  Created by PJ on 2018/4/4.
//  Copyright © 2018年 Didi.Inc. All rights reserved.
//

#import "PJBaseViewController.h"

@interface PJBaseViewController ()

@end

@implementation PJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isLargeTitle = YES;

    self.navigationController.navigationBar.translucent = false;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
}

- (UINavigationBar *)navBar {
    return self.navigationController.navigationBar;
}

- (UINavigationItem *)navItem {
    return self.navigationItem;
}

- (void)setIsLargeTitle:(BOOL)isLargeTitle {
    _isLargeTitle = isLargeTitle;
    if (isLargeTitle) {
        self.navBar.prefersLargeTitles = isLargeTitle;
    }
}

- (void)leftBarButtonItemAction:(SEL)action {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [leftButton setImage:[[UIImage imageNamed:@"back"] imageWithColor:[UIColor blackColor]]
                forState:UIControlStateNormal];
    [leftButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)leftBarBtuttonItemAction:(SEL)action imageName:(NSString *)imageName {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void)rightBarBtuttonItemAction:(SEL)action imageName:(NSString *)imageName{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void)rightBarButtonItemTitle:(NSString *)title Action:(SEL)action {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

@end
