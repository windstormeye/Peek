//
//  PJPhotoViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/6/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJPhotoViewController.h"

@interface PJPhotoViewController ()

@end

@implementation PJPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImage:) name:@"getImage" object:nil];
}

- (void)getImage:(NSNotification *)notify {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageView.image = notify.userInfo[@"image"];
    [self.view addSubview:imageView];
}

@end
