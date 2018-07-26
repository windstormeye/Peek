//
//  PJNoteHeaderView.h
//  Peek
//
//  Created by pjpjpj on 2018/6/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJNoteHeaderViewDelegate <NSObject>

- (void)PJNoteHeaderViewAvatarBtnClick;

@end

@interface PJNoteHeaderView : UIView

@property (nonatomic, readwrite, weak) id<PJNoteHeaderViewDelegate> viewdelegate;

@end
