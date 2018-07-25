//
//  PJNoteCollectionViewCell.h
//  Peek
//
//  Created by pjpjpj on 2018/6/18.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note+CoreDataProperties.h"

@class Note;
@interface PJNoteCollectionViewCell : UICollectionViewCell

@property (nonatomic, readwrite, strong) Note *note;

@end
