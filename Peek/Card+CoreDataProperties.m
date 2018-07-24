//
//  Card+CoreDataProperties.m
//  Peek
//
//  Created by pjpjpj on 2018/7/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//
//

#import "Card+CoreDataProperties.h"

@implementation Card (CoreDataProperties)

+ (NSFetchRequest<Card *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Card"];
}

@dynamic itemId;
@dynamic itemImage;
@dynamic itemTouchImage;
@dynamic itemOpencvImage;
@dynamic cardTooneNote;

@end
