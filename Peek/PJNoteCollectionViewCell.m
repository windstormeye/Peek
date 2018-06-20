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
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 8.0;
    self.layer.shadowOffset = CGSizeMake(-5, -5);
    // 背景图
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:pageImageView];
    pageImageView.image = [UIImage imageNamed:self.dataSource[@"itemImageName"]];
    pageImageView.contentMode = UIViewContentModeScaleAspectFill;
    pageImageView.clipsToBounds = YES;
    pageImageView.layer.cornerRadius = 2;
    // 第二张背景图
    UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:pageImageView.frame];
    secondImageView.image = [UIImage imageNamed:self.dataSource[@"itemImageName"]];
    secondImageView.contentMode = UIViewContentModeScaleAspectFill;
    secondImageView.clipsToBounds = YES;
    secondImageView.layer.cornerRadius = 2;
    secondImageView.y += 5;
    [self addSubview:secondImageView];
    [self sendSubviewToBack:secondImageView];
    // 切底右下圆角
    UIBezierPath *secondImageViewPath = [UIBezierPath bezierPathWithRoundedRect:secondImageView.bounds
                                                           byRoundingCorners: UIRectCornerBottomRight
                                                                 cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer *secondImageViewPathMaskLayer = [CAShapeLayer new];
    secondImageViewPathMaskLayer.frame = secondImageView.bounds;
    secondImageViewPathMaskLayer.path = secondImageViewPath.CGPath;
    secondImageView.layer.mask = secondImageViewPathMaskLayer;
    // 底部书本效果线
    UIView *bookLineView = [[UIView alloc] initWithFrame:CGRectMake(4, self.height - 18, self.width - 6, 16)];
    [secondImageView addSubview:bookLineView];
    bookLineView.backgroundColor = [UIColor whiteColor];
    UIBezierPath *bookLineViewPath = [UIBezierPath bezierPathWithRoundedRect:bookLineView.bounds
                                               byRoundingCorners: UIRectCornerBottomRight
                                                     cornerRadii:CGSizeMake(8.0, 8.0)];
    // 切底右下圆角
    CAShapeLayer *bookLineViewPathMaskLayer = [CAShapeLayer new];
    bookLineViewPathMaskLayer.frame = bookLineView.bounds;
    bookLineViewPathMaskLayer.path = bookLineViewPath.CGPath;
    bookLineView.layer.mask = bookLineViewPathMaskLayer;
    // 左部书本效果线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 4, self.height)];
    [pageImageView addSubview:lineView];
    lineView.alpha = 0.55;
    // 左部书本渐变效果
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = lineView.bounds;
    gradientLayer.colors =@[(__bridge id)[UIColor grayColor].CGColor, (__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@0.01];
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    [lineView.layer addSublayer:gradientLayer];
    // 背景图右上、右下圆角
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pageImageView.bounds
                                               byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                     cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer *pathMaskLayer = [CAShapeLayer new];
    pathMaskLayer.frame = pageImageView.bounds;
    pathMaskLayer.path = path.CGPath;
    pageImageView.layer.mask = pathMaskLayer;

    // titleLabelCotentView
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 40, self.width, 45)];
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.3;
    contentView.layer.cornerRadius = 2;
    // 右下圆角
    UIBezierPath *contentViewPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds
                                                         byRoundingCorners: UIRectCornerBottomRight
                                                               cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer *contentViewPathMaskLayer = [CAShapeLayer new];
    contentViewPathMaskLayer.frame = contentView.bounds;
    contentViewPathMaskLayer.path = contentViewPath.CGPath;
    contentView.layer.mask = contentViewPathMaskLayer;
    // titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, contentView.width - 10, contentView.height)];
    titleLabel.bottom = contentView.bottom;
    [self addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.dataSource[@"itemName"];
}

@end
