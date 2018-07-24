//
//  Note+CoreDataProperties.h
//  Peek
//
//  Created by pjpjpj on 2018/7/23.
//  Copyright © 2018年 #incloud. All rights reserved.
//
//

#import "Note+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *itemImage;
@property (nullable, nonatomic, copy) NSString *itemImageName;
@property (nullable, nonatomic, copy) NSString *itemName;

@end

NS_ASSUME_NONNULL_END
