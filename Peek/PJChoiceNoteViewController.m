//
//  PJChoiceNoteViewController.m
//  Peek
//
//  Created by pjpjpj on 2018/7/23.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import "PJChoiceNoteViewController.h"
#import "PJNoteCollectionView.h"
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
@property (nonatomic, readwrite, strong) NSMutableArray *tempCardImageViewCenterXArray;
@property (nonatomic, readwrite, assign) CGPoint previous_point;
@property (nonatomic, readwrite, assign) CGPoint next_point;
@property (nonatomic, readwrite, assign) CGPoint current_point;
@property (nonatomic, readwrite, assign) NSInteger currentImageIndex;

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
    tipsLabel.text = @"拖拽照片进行归档";
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
        [self.tempCardImageViewCenterXArray addObject:[NSNumber numberWithFloat:tempCard.centerX]];
        
        index ++;
    }
    self.bottomScrollView.contentSize = CGSizeMake(marginX + self.cardImageViewArray.count * (self.view.width * 0.17 + marginX), 0);
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
}

- (void)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick {
    
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
    if (self.moveImageView) {
        CGPoint point = [presser locationInView:self.view];
        self.moveImageView.center = point;
        
        // 获取前后index
        NSInteger p_index, n_index;
        if (self.currentImageIndex == 0) {
            p_index = 0;
            n_index = 1;
        } else if (self.currentImageIndex == self.tempCardImageViewArray.count - 1) {
            p_index = self.currentImageIndex - 1;
            n_index = self.tempCardImageViewArray.count - 1;
        } else {
            p_index = self.currentImageIndex - 1;
            n_index = self.currentImageIndex + 1;
        }
        
        // 有问题
        NSNumber *p_Number = self.tempCardImageViewCenterXArray[p_index];
        CGFloat p_centerX = p_Number.floatValue;
        NSNumber *n_Number = self.tempCardImageViewCenterXArray[n_index];
        CGFloat n_centerX = n_Number.floatValue;
        
        NSInteger cardIndex;
        if (fabs(point.x - p_centerX) > fabs(point.x - n_centerX)) {
            cardIndex = n_index;
        } else {
            cardIndex = p_index;
        }
        PJCardImageView *card = self.tempCardImageViewArray[cardIndex];
        CGFloat cardCenterX = card.centerX;
        PJCardImageView *currentCard = self.tempCardImageViewArray[self.currentImageIndex];
        [UIView animateWithDuration:0.25 animations:^{
            card.centerX = currentCard.centerX;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    currentCard.centerX = cardCenterX;
                }];
            }
        }];
        
    }
}

- (void)dragEnd:(UILongPressGestureRecognizer *)presser {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.moveImageView.center = self.current_point;
    } completion:^(BOOL finished) {
        if (finished) {
            PJCardImageView *card = self.tempCardImageViewArray[self.currentImageIndex];
            card.alpha = 1.0;
            [self.moveImageView removeFromSuperview];
            self.moveImageView = nil;
        }
    }];
}

@end
