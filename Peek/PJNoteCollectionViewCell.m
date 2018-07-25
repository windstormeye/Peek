//
//  PJNoteCollectionViewCell.m
//  Peek
//
//  Created by pjpjpj on 2018/6/18.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJNoteCollectionViewCell.h"

@implementation PJNoteCollectionViewCell

- (void)setNote:(Note *)note {
    _note = note;
    [self initView];
}

- (void)initView {
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(-5, -5);
    // 背景图
    UIImageView *pageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:pageImageView];
    pageImageView.image = [UIImage imageWithData:self.note.itemImage];
    pageImageView.contentMode = UIViewContentModeScaleAspectFill;
    pageImageView.clipsToBounds = YES;
    pageImageView.layer.cornerRadius = 2;
    // 背景图底部书本效果线
    UIView *pageImageBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(4, pageImageView.bottom - 1, pageImageView.width - 4, 1)];
    pageImageBottomLineView.backgroundColor = [UIColor grayColor];
    [pageImageView addSubview:pageImageBottomLineView];
    
    // 第二张背景图
    UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:pageImageView.frame];
    secondImageView.width -= 3;
    secondImageView.y += 3;
    secondImageView.image = [UIImage imageWithData:self.note.itemImage];
    secondImageView.contentMode = UIViewContentModeScaleAspectFill;
    secondImageView.clipsToBounds = YES;
    secondImageView.layer.cornerRadius = 2;
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
    UIView *bookLineView = [[UIView alloc] initWithFrame:CGRectMake(4, self.height - 17, secondImageView.width - 3, 16)];
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
    
    UIView *secondImageCoverView = [[UIView alloc] initWithFrame:secondImageView.frame];
    [secondImageView addSubview:secondImageCoverView];
    secondImageCoverView.backgroundColor = [UIColor blackColor];
    secondImageCoverView.alpha = 0.3;
    
    // 背景图右上、右下圆角
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:pageImageView.bounds
                                               byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight
                                                     cornerRadii:CGSizeMake(8.0, 8.0)];
    CAShapeLayer *pathMaskLayer = [CAShapeLayer new];
    pathMaskLayer.frame = pageImageView.bounds;
    pathMaskLayer.path = path.CGPath;
    pageImageView.layer.mask = pathMaskLayer;

    // titleLabelCotentView
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 45, self.width, 45)];
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
    titleLabel.text = self.note.itemName;
}

@end
