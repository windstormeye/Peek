//
//  PJCoreDateHelper.m
//  Peek
//
//  Created by pjpjpj on 2018/7/23.
//  Copyright © 2018年 #incloud. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "PJCoreDateHelper.h"
#import "AppDelegate.h"
#import "PJNoteCollectionViewCell.h"
#import "Note+CoreDataClass.h"
#import "Note+CoreDataProperties.h"

@implementation PJCoreDateHelper

static PJCoreDateHelper *helper = nil;

+ (PJCoreDateHelper *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [PJCoreDateHelper new];
    });
    return helper;
}

- (void)initNoteDate {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    
    NSArray *noteDataArray = @[@{@"itemImage" : [UIImage imageNamed:@"backImage"], @"itemName" : @"一个人的旅程"},
                               @{@"itemImage" : [UIImage imageNamed:@"banner"], @"itemName" : @"我的校园时光"},
                               @{@"itemImage" : [UIImage imageNamed:@"banner2"], @"itemName" : @"你要很努力才行啊！"},
                               @{@"itemImage" : [UIImage imageNamed:@"banner3"], @"itemName" : @"加油做自己💪"},
                               @{@"itemImage" : [UIImage imageNamed:@"banner4"], @"itemName" : @"每一天都要过好！"},];
    for (NSDictionary *dic in noteDataArray) {
        Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                                   inManagedObjectContext:context];
        note.itemName = dic[@"itemName"];
        UIImage *image = dic[@"itemImage"];
        NSData *imageData = UIImagePNGRepresentation(image);
        note.itemImage = imageData;
    }
    
    NSError *error = nil;
    [context save:&error];
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"Save succes");
    }
}

- (NSArray *)getNoteData {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSError *error = nil;
    NSArray *notes = [context executeFetchRequest:[Note fetchRequest] error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        return notes;
    }
    return nil;
}

@end
