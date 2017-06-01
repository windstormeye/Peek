
#import "PJUIImage+Extension.h"

@implementation UIImage(Extension)

/**
 *  压缩图片
 *
 *  @return 返回压缩后的图片
 */
-(UIImage *) imageCompress:(CGFloat)targetWidth
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)returnBlurObject:(NSNumber *)value{
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}];
    CIImage *ciImage = [[CIImage alloc]initWithImage:self];
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    [blurFilter setValue:value forKey:@"inputRadius"];
    return [self imageFromCIImage:[blurFilter outputImage] context:context];
}
- (UIImage *)imageFromCIImage:(CIImage *)ciImage context:(CIContext *)context{
    UIImage *image = nil;
    if (context) {
        CGImageRef imageRef = [context createCGImage:ciImage fromRect:[ciImage extent]];
        image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }else{
        image = [UIImage imageWithCIImage:ciImage];
    }
    return image;
}


-(UIImage *)returnSizeImage:(CGSize)size{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [self drawInRect:CGRectMake(0,0,size.width,  size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}
@end
