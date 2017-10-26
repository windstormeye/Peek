//
//  PJTapic.m
//  Peek
//
//  Created by pjpjpj on 2017/10/26.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJTapic.h"

@implementation PJTapic

+ (void)selection {
    UISelectionFeedbackGenerator *generator = [UISelectionFeedbackGenerator new];
    [generator selectionChanged];
    [generator prepare];
}

+ (void)succee {
    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
    [generator prepare];
}

+ (void)warning {
    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    [generator notificationOccurred:UINotificationFeedbackTypeWarning];
    [generator prepare];
}

+ (void)error {
    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    [generator notificationOccurred:UINotificationFeedbackTypeError];
    [generator prepare];
}

@end
