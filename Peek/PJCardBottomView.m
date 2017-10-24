//
//  PJCardBottomView.m
//  Peek
//
//  Created by pjpjpj on 2017/10/24.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJCardBottomView.h"

@implementation PJCardBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
    
}

- (IBAction)yesBtnClick:(id)sender {
    
    [_viewDelegate PJCardBottomViewYesBtnClick];
}

- (IBAction)noBtnClick:(id)sender {
    
    [_viewDelegate PJCardBottomViewNoBtnClick];
}

@end
