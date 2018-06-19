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
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowRadius = 10.0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:pageImageView];
    pageImageView.image = [UIImage imageNamed:self.dataSource[@"itemImageName"]];
    pageImageView.contentMode = UIViewContentModeScaleAspectFill;
    pageImageView.clipsToBounds = YES;
    //通过贝塞尔曲线生成圆角
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:pageImageView.bounds cornerRadius:8.0].CGPath;
    pageImageView.layer.mask = maskLayer;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 40, self.width, 40)];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.3;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer *pathMaskLayer = [CAShapeLayer new];
    pathMaskLayer.frame = contentView.bounds;
    pathMaskLayer.path = path.CGPath;
    contentView.layer.mask = pathMaskLayer;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, contentView.width - 10, contentView.height)];
    titleLabel.bottom = contentView.bottom;
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.dataSource[@"itemName"];
}

@end
