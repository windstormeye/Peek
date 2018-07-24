//
//  PJCoreDateHelper.h
//  Peek
//
//  Created by pjpjpj on 2018/7/23.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJCoreDateHelper : NSObject

+ (PJCoreDateHelper *)shareInstance;

- (void)initNoteDate;
- (NSArray *)getNoteData;

@end
