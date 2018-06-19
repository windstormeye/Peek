//
//  PJNoteCollectionView.m
//  Peek
//
//  Created by pjpjpj on 2018/6/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJNoteCollectionView.h"
#import "PJNoteCollectionViewCell.h"

static NSString * const resureIdentifier = @"PJNoteCollectioview";

@interface PJNoteCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation PJNoteCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
    
    self.dataArray = [@[] mutableCopy];
    
    [self registerClass:[PJNoteCollectionViewCell class] forCellWithReuseIdentifier:@"PJNoteCollectioview"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PJNoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PJNoteCollectioview" forIndexPath:indexPath];
    cell.dataSource = @{@"" : @""};
    return cell;
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

@end
