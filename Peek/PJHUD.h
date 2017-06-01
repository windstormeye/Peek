

#import <Foundation/Foundation.h>

@interface PJHUD : NSObject

+(void)showSuccessWithStatus:(NSString *)message;

+(void)showErrorWithStatus:(NSString *)message;

+(void)showWithStatus:(NSString *)message;

+(void)dismiss;
@end
