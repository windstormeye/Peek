//
//  PJNoteCollectionViewCell.m
//  Peek
//
//  Created by pjpjpj on 2018/6/18.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJNoteCollectionViewCell.h"

@implementation PJNoteCollectionViewCell

- (void)setDataSource:(NSDictionary *)dataSource {
    _dataSource = dataSource;
    [self initView];
}

- (void)initView {
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 15.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:pageImageView];
    pageImageView.image = [UIImage imageNamed:@"backImage"];
    //通过贝塞尔曲线生成圆角
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:pageImageView.bounds cornerRadius:8.0].CGPath;
    pageImageView.layer.mask = maskLayer;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width, 30)];
    [self addSubview:titleLabel];
    titleLabel.text = @"一个人的旅程";
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.height - 100, self.width, 100)];
    descLabel.text = @"一个的旅程，一个人的朝圣，一个人永远在路上，不忘初心，砥砺前行";
    [self addSubview:descLabel];
}

@end
