//
//  Card+CoreDataProperties.h
//  Peek
//
//  Created by pjpjpj on 2018/7/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//
//

#import "Card+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest;

@property (nonatomic) int16_t itemId;
@property (nullable, nonatomic, retain) NSData *itemImage;
@property (nullable, nonatomic, retain) NSData *itemTouchImage;
@property (nullable, nonatomic, retain) NSData *itemOpencvImage;
@property (nullable, nonatomic, retain) Note *cardTooneNote;

@end

NS_ASSUME_NONNULL_END
