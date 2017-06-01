

#import <UIKit/UIKit.h>

@interface UIImage(Extension)

- (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  压缩图片
 *
 *  @return 返回压缩后的图片
 */
-(UIImage *)imageCompress:(CGFloat)targetWidth;
/**
 *  返回一张模糊处理过后的图片  输入模糊半径
 *
 *  @return 返回模糊图片
 */
-(UIImage *)returnBlurObject:(NSNumber *)value;
/*
 *  返回指定大小图片
 */
-(UIImage *)returnSizeImage:(CGSize)size;
@end
