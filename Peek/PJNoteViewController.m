//
//  PJNoteViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJNoteViewController.h"
#import "PJCardImageView.h"
#import "Card+CoreDataProperties.h"


@interface PJNoteViewController ()

@end

@implementation PJNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    for (Card *card in self.dataArray) {
        PJCardImageView *cardImageView = [[PJCardImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        [self.view addSubview:cardImageView];
        cardImageView.image = [UIImage imageWithData:card.itemImage];
        UIImageView *touchImageView = [[UIImageView alloc] initWithFrame:cardImageView.frame];
        touchImageView.image = [UIImage imageWithData:card.itemTouchImage];
        cardImageView.touchImageView = touchImageView;
        UIImageView *opencvImageView = [[UIImageView alloc] initWithFrame:cardImageView.frame];
        opencvImageView.image = [UIImage imageWithData:card.itemOpencvImage];
        cardImageView.openvcImageView = opencvImageView;
    }
}

@end
