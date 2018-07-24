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
#import "PJCardImageView.h"
#import "Note+CoreDataClass.h"
#import "Note+CoreDataProperties.h"
#import "Card+CoreDataClass.h"
#import "Card+CoreDataProperties.h"

@interface PJCoreDateHelper ()

@property (nonatomic, readwrite, strong) AppDelegate *delegate;
@property (nonatomic, readwrite, strong) NSManagedObjectContext *context;

@end

@implementation PJCoreDateHelper

static PJCoreDateHelper *helper = nil;

+ (PJCoreDateHelper *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [PJCoreDateHelper new];
        helper.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        helper.context = helper.delegate.persistentContainer.viewContext;
    });
    return helper;
}

- (void)initNoteDate {
    NSArray *noteDataArray = @[@{@"itemImage" : [UIImage imageNamed:@"backImage"], @"itemName" : @"一个人的旅程"},
                               @{@"itemImage" : [UIImage imageNamed:@"banner"], @"itemName" : @"我的校园时光"},
                               @{@"itemImage" : [UIImage imageNamed:@"banner2"], @"itemName" : @"你要很努力才行啊！"},
                               @{@"itemImage" : [UIImage imageNamed:@"banner3"], @"itemName" : @"加油做自己💪"},
                               @{@"itemImage" : [UIImage imageNamed:@"banner4"], @"itemName" : @"每一天都要过好！"},];
    NSInteger index = 0;
    for (NSDictionary *dic in noteDataArray) {
        Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                                   inManagedObjectContext:self.context];
        UIImage *image = dic[@"itemImage"];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        note.itemName = dic[@"itemName"];
        note.itemImage = imageData;
        note.itemId = index;
        
        index ++;
    }
    
    NSError *error = nil;
    [self.context save:&error];
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"Save succes");
    }
}

- (NSArray *)getNoteData {
    NSManagedObjectContext *context = self.delegate.persistentContainer.viewContext;
    NSError *error = nil;
    NSArray *notes = [context executeFetchRequest:[Note fetchRequest] error:&error];
    
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        return notes;
    }
    return nil;
}

- (Note *)getNoteData:(NSInteger)noteIndex {
    NSFetchRequest *request = [Note fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"itemId=%d", noteIndex];
    NSError *error = nil;
    NSArray *notes = [self.context executeFetchRequest:request error:&error];
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        return notes.lastObject;
    }
    return nil;
}

- (void)updateNoteContentData:(NSArray *)imageViewArray noteIndex:(NSInteger)noteIndex {
    NSInteger index = 0;
    for (PJCardImageView *cardImageView in imageViewArray) {
        Card *card = [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:self.context];
        NSData *itemImageData = UIImagePNGRepresentation(cardImageView.image);
        NSData *itemTouchImageData = UIImagePNGRepresentation(cardImageView.touchImageView.image);
        NSData *itemOpencvImageData = UIImagePNGRepresentation(cardImageView.openvcImageView.image);
        
        card.itemImage = itemImageData;
        card.itemTouchImage = itemTouchImageData;
        card.itemOpencvImage = itemOpencvImageData;
        card.itemId = index;
        card.cardTooneNote = [self getNoteData:noteIndex];
        
        index ++;
    }
    
    NSError *error = nil;
    [self.context save:&error];
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"Save succes");
    }
}

- (NSArray *)getCardData:(NSInteger)noteIndex {
    NSFetchRequest *request = [Note fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"itemId=%d", noteIndex];
    NSError *error = nil;
    NSArray *notes = [self.context executeFetchRequest:request error:&error];
    Note *note = (Note *)notes.lastObject;
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        return [note.noteTomanyCard allObjects];
    }
    return nil;
}

@end
