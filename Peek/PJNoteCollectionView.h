//
//  PJNoteCollectionView.h
//  Peek
//
//  Created by pjpjpj on 2018/6/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJNoteCollectionViewDelegate <NSObject>

- (void)PJNoteCollectionViewdidSelectedIndex:(NSInteger)index;

@end

@interface PJNoteCollectionView : UICollectionView

@property (nonatomic, readwrite, strong) NSArray *dataArray;
@property (nonatomic, readwrite, assign) BOOL isUserHeader;

@property (nonatomic, readwrite, weak) id<PJNoteCollectionViewDelegate> viewDelegate;

@end
