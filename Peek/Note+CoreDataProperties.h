//
//  Note+CoreDataProperties.h
//  Peek
//
//  Created by pjpjpj on 2018/7/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//
//

#import "Note+CoreDataClass.h"

@class Card;

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest;

@property (nonatomic) int16_t itemId;
@property (nullable, nonatomic, retain) NSData *itemImage;
@property (nullable, nonatomic, copy) NSString *itemImageName;
@property (nullable, nonatomic, copy) NSString *itemName;
@property (nullable, nonatomic, retain) NSSet<Card *> *noteTomanyCard;

@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addNoteTomanyCardObject:(Card *)value;
- (void)removeNoteTomanyCardObject:(Card *)value;
- (void)addNoteTomanyCard:(NSSet<Card *> *)values;
- (void)removeNoteTomanyCard:(NSSet<Card *> *)values;

@end

NS_ASSUME_NONNULL_END
