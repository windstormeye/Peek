//
//  PJChoiceNoteViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/23.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJChoiceNoteViewController.h"
#import "PJNoteCollectionView.h"
#import "PJNoteCollectionViewCell.h"
#import "PJCoreDateHelper.h"
#import "PJCardImageView.h"
#import "PJTool.h"

@interface PJChoiceNoteViewController ()

@property (nonatomic, readwrite, strong) PJNoteCollectionView *collectionView;

@property (nonatomic, readwrite, strong) UIButton *cancleBtn;
@property (nonatomic, readwrite, strong) UIButton *finishBtn;
@property (nonatomic, readwrite, strong) UIImageView *moveImageView;
@property (nonatomic, readwrite, strong) UIScrollView *bottomScrollView;

@property (nonatomic, readwrite, strong) NSMutableArray *tempCardImageViewArray;
// 存放在小册里的照片数组
@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray *> *noteCellArray;
@property (nonatomic, readwrite, assign) CGPoint previous_point;
@property (nonatomic, readwrite, assign) CGPoint next_point;
@property (nonatomic, readwrite, assign) CGPoint current_point;
@property (nonatomic, readwrite, assign) NSInteger currentImageIndex;
@property (nonatomic, readwrite, assign) NSIndexPath *previousIndexPath;

@end

@implementation PJChoiceNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tempCardImageViewArray = [NSMutableArray new];
    self.noteCellArray = [NSMutableArray new];
    
    self.cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 50, 20)];
    [self.view addSubview:self.cancleBtn];
    [self.cancleBtn addTarget:self action:@selector(cancleBtnClick)
             forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn setImage:[UIImage imageNamed:@"back_black"]
                    forState:UIControlStateNormal];
    [self.cancleBtn setTitleColor:[UIColor blackColor]
                         forState:UIControlStateNormal];
    
    self.finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 5 - 80, 30, 80, 20)];
    [self.view addSubview:self.finishBtn];
    [self.finishBtn addTarget:self action:@selector(rightBtnClick)
             forControlEvents:UIControlEventTouchUpInside];
    [self.finishBtn setTitle:@"完成"
                    forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor blackColor]
                         forState:UIControlStateNormal];
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel.text = @"长按拖拽照片进行归档";
    tipsLabel.font = [UIFont boldSystemFontOfSize:14];
    [tipsLabel sizeToFit];
    tipsLabel.textColor = [UIColor blackColor];
    tipsLabel.centerX = self.view.centerX;
    tipsLabel.centerY = self.finishBtn.centerY;
    [self.view addSubview:tipsLabel];
    
    CGFloat bottomViewHeigh = SCREEN_HEIGHT * 0.2;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH * 0.4, SCREEN_WIDTH * 0.4 * 1.3);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 25;
    layout.minimumInteritemSpacing = 25;
    layout.sectionInset = UIEdgeInsetsMake(25, 25, 25, 25);
    CGRect collectionViewFrame = CGRectMake(0, self.finishBtn.bottom + 10, self.view.width, self.view.height - self.finishBtn.bottom - 10 - bottomViewHeigh);
    self.collectionView = [[PJNoteCollectionView alloc] initWithFrame:collectionViewFrame
                                                 collectionViewLayout:layout];
    self.collectionView.isUserHeader = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.dataArray = [[PJCoreDateHelper shareInstance] getNoteData];
    [self.collectionView reloadData];
    
    for (int i = 0; i < self.self.collectionView.dataArray.count; i++) {
        NSMutableArray *arr = [NSMutableArray new];
        [self.noteCellArray addObject: arr];
    }
    
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.height - bottomViewHeigh, self.view.width, bottomViewHeigh + 20)];
    [self.view addSubview:self.bottomScrollView];
    self.bottomScrollView.backgroundColor = [UIColor whiteColor];
    
    NSInteger index = 0;
    CGFloat marginX = 20;
    for (PJCardImageView *card in self.cardImageViewArray) {
        PJCardImageView *tempCard = [PJCardImageView new];
        tempCard.x = marginX + index * (self.view.width * 0.17 + marginX);
        tempCard.y = 10;
        tempCard.width = self.view.width * 0.17;
        tempCard.height = self.view.height * 0.17;
        tempCard.image = card.image;
        tempCard.layer.shadowColor = [UIColor blackColor].CGColor;
        tempCard.layer.shadowOpacity = 0.5;
        tempCard.layer.shadowOffset = CGSizeMake(0, 0);
        tempCard.layer.shadowRadius = 5;
        tempCard.userInteractionEnabled = YES;
        tempCard.tag = index;
        
        // 长按手势
        UILongPressGestureRecognizer *presser = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cardImageViewLongPress:)];
        [tempCard addGestureRecognizer:presser];
        
        UIImageView *opencvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tempCard.width, tempCard.height)];
        opencvImageView.image = card.openvcImageView.image;
        tempCard.openvcImageView = opencvImageView;
        
        UIImageView *touchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tempCard.width, tempCard.height)];
        touchImageView.image = card.touchImageView.image;
        tempCard.touchImageView = touchImageView;
        
        [self.bottomScrollView addSubview:tempCard];
        [self.tempCardImageViewArray addObject:tempCard];
        
        index ++;
    }
    self.bottomScrollView.contentSize = CGSizeMake(marginX + self.cardImageViewArray.count * (self.view.width * 0.17 + marginX), 0);
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick {
    NSInteger index = 0;
    for (NSArray* cards in self.noteCellArray) {
        if (cards.count != 0) {
            [[PJCoreDateHelper shareInstance] updateNoteContentData:cards noteIndex:index];
        }
        index ++;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cardImageViewLongPress:(UILongPressGestureRecognizer *)presser {
    switch (presser.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:presser];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:presser];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd:presser];
        default:
            break;
    }
}

- (void)dragBegin:(UILongPressGestureRecognizer *)presser {
    CGPoint point = [presser locationInView:self.bottomScrollView];

    for (PJCardImageView *card in self.tempCardImageViewArray) {
        if (point.x >= card.left && point.x <= card.right && point.y >= card.top && point.y < card.bottom) {
            self.currentImageIndex = card.tag;
            self.moveImageView = [PJTool convertCreateImageWithUIView:card];
            self.moveImageView.layer.shadowColor = [UIColor blackColor].CGColor;
            self.moveImageView.layer.shadowOpacity = 0.5;
            self.moveImageView.layer.shadowOffset = CGSizeMake(0, 0);
            self.moveImageView.layer.shadowRadius = 5;
            self.current_point = [presser locationInView:self.view];
            [UIView animateWithDuration:0.25 animations:^{
                self.moveImageView.center = self.current_point;
                self.moveImageView.transform = CGAffineTransformMakeScale(1.025, 1.025);
            } completion:^(BOOL finished) {
                [PJTapic tipsTap];
                card.alpha = 0.3;
                [self.view addSubview:self.moveImageView];
            }];
        }
    }
}

- (void)dragChanged:(UILongPressGestureRecognizer *)presser{
    CGPoint point = [presser locationInView:self.view];
    if (self.moveImageView) {
        self.moveImageView.center = point;
        if (point.y < self.bottomScrollView.top) {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[presser locationInView:self.collectionView]];
            if (!indexPath || indexPath == self.previousIndexPath) {
                if (!indexPath) {
                    self.previousIndexPath = nil;
                }
                return;
            }
            PJNoteCollectionViewCell *cell = (PJNoteCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            if (cell) {
                // 动画没开始之前就要赋值了，反之用户未等待动画进行完就撒手
                self.previousIndexPath = indexPath;
                [UIView animateWithDuration:0.25 animations:^{
                    cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:0.25 animations:^{
                            cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        }];
                    }
                }];
            }
        }
    }
}

- (void)dragEnd:(UILongPressGestureRecognizer *)presser {
    PJCardImageView *card = self.tempCardImageViewArray[self.currentImageIndex];
    if (!self.previousIndexPath) {
        [UIView animateWithDuration:0.25 animations:^{
            self.moveImageView.center = self.current_point;
        }completion:^(BOOL finished) {
            if (finished) {
                card.alpha = 1.0;
                [self.moveImageView removeFromSuperview];
                self.moveImageView = nil;
                self.previousIndexPath = nil;
            }
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            card.alpha = 0;
            [card removeFromSuperview];
            [self.tempCardImageViewArray removeObject:card];
            
            self.moveImageView.transform = CGAffineTransformMakeScale(2, 2);
            self.moveImageView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                
                if (self.tempCardImageViewArray.count == 0) {
                    self.collectionView.height += self.bottomScrollView.height;
                    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        self.bottomScrollView.alpha = 0;
                        self.bottomScrollView.top = self.self.view.height;
                    } completion:^(BOOL finished) {
                        [self.bottomScrollView removeFromSuperview];
                    }];
                }
                
                NSMutableArray *array = self.noteCellArray[self.previousIndexPath.row];
                [array addObject:card];
            
                NSInteger index = 0;
                CGFloat marginX = 20;
                for (PJCardImageView *tempCard in self.bottomScrollView.subviews) {
                    [UIView animateWithDuration:0.25 animations:^{
                        tempCard.x = marginX + index * (self.view.width * 0.17 + marginX);
                    }];
                    tempCard.tag = index;
                    index ++;
                }
            }
        }];
    }
}

@end
