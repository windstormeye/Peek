//
//  leftHomeView.m
//  Peek
//
//  Created by pjpjpj on 2017/6/13.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "leftHomeView.h"

@implementation leftHomeView
{
    LeftSliderView *_leftView;
}

- (id)init {
    self = [super init];
    [self initView];
    return self;
}

- (void)initView {
    self.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH * 0.6, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:effectView];
    
    _leftView = [[[NSBundle mainBundle] loadNibNamed:@"LeftSliderView" owner:self options:nil] firstObject];
    _leftView.viewDelegate = self;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [scrollView addSubview:_leftView];
    scrollView.contentSize = CGSizeMake(0, self.frame.size.height + 0.5);
    scrollView.showsHorizontalScrollIndicator = false;
    [self addSubview:scrollView];
}

- (void)myPublishAction {
    [_viewDelega myPublishAction];
}

- (void)editAction {
    [_viewDelega editAction];
}

- (void)messageAction {
    [_viewDelega messageAction];
}

@end
