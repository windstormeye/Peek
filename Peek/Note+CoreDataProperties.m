//
//  Note+CoreDataProperties.m
//  Peek
//
//  Created by pjpjpj on 2018/7/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Note"];
}

@dynamic itemId;
@dynamic itemImage;
@dynamic itemImageName;
@dynamic itemName;
@dynamic noteTomanyCard;

@end
