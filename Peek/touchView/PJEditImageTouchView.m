//
//  PJEditImageTouchView.m
//  editImageTest
//
//  Created by pjpjpj on 2017/11/21.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJEditImageTouchView.h"
#import "PJEditImageStroke.h"
#import <QuartzCore/QuartzCore.h>

#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)

@interface PJEditImageTouchView()

// 是否擦除（橡皮擦功能）
@property (nonatomic, assign) BOOL isEarse;
// 存储所有的画笔路径
@property (nonatomic, strong) NSMutableArray *stroks;
// 画笔颜色
@property (nonatomic, strong) UIColor *lineColor;
// 线条宽度
@property (nonatomic, assign) CGFloat lineWidth;
// 马赛克显示层
@property (nonatomic, strong) CALayer *imageLayer;
// 马赛克显示层的遮罩
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
// 当前手指的路径点集合
@property (nonatomic,assign)CGMutablePathRef blurPath;
// 存储每次手指移动过的路径点
@property(nonatomic,strong)NSMutableArray * appendPaths;
// 储存所有的路径点
@property(nonatomic,strong)NSMutableArray * allPaths;
@property (nonatomic, strong) NSMutableArray* fingerTouchArr;

@end

@implementation PJEditImageTouchView {
    CGMutablePathRef currentPath;//路径
}

- (NSMutableArray *)fingerTouchArr {
    if (!_fingerTouchArr) {
        _fingerTouchArr = [NSMutableArray array];
    }
    return _fingerTouchArr;
}

- (NSMutableArray *)allPaths {
    if (!_allPaths) {
        _allPaths = [NSMutableArray array];
    }
    return _allPaths;
}

- (NSMutableArray *)appendPaths {
    if (!_appendPaths) {
        _appendPaths = [NSMutableArray array];
    }
    return _appendPaths;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _stroks = [[NSMutableArray alloc] initWithCapacity:1];
        self.blurPath = CGPathCreateMutable();
        self.backgroundColor = [UIColor clearColor];

        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.layer addSublayer:self.imageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        self.shapeLayer.lineWidth = 10.f;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;
        [self.layer addSublayer:self.shapeLayer];
        self.imageLayer.mask = self.shapeLayer;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image {
    self = [self initWithFrame:frame];
    self.image = [self transToMosaicImage:image blockLevel:20];
    
    long double rotate =0.0;
    CGRect rect;
    float translateX =0;
    float translateY =0;
    float scaleX =1.0;
    float scaleY =1.0;
    rotate = 3 *M_PI_2;
    rect = CGRectMake(0,0, self.image.size.height, self.image.size.width);
    translateX = -rect.size.height;
    translateY = 0;
    scaleY = rect.size.width/rect.size.height;
    scaleX = rect.size.height/rect.size.width;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context,0.0, rect.size.height);
    CGContextScaleCTM(context,1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context,CGRectMake(0,0, rect.size.width, rect.size.height), self.image.CGImage);
    self.image =UIGraphicsGetImageFromCurrentImageContext();
    
    return self;
}

- (void)setImage:(UIImage *)image {
    //底图
    _image = image;
    self.imageLayer.contents = (id)image.CGImage;
}

// drawRect是内存杀手，后续解决这个问题
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (PJEditImageStroke *stroke in _stroks) {
        [stroke strokeWithContext:context];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (_isBlur) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGPathMoveToPoint(self.blurPath, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.blurPath);
        self.shapeLayer.path = path;
        CGPathRelease(path);
        self.appendPaths = [NSMutableArray array];
        [self.appendPaths addObject:[NSValue valueWithCGPoint:point]];
        [self.fingerTouchArr addObject:@(true)];
    } else {
        currentPath = CGPathCreateMutable();
        PJEditImageStroke *stroke = [[PJEditImageStroke alloc] init];
        stroke.path = currentPath;
        stroke.blendMode = _isEarse ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
        stroke.strokeWidth = _isEarse ? 20.0 : _lineWidth;
        stroke.lineColor = _isEarse ? [UIColor clearColor] : _lineColor;
        [_stroks addObject:stroke];
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGPathMoveToPoint(currentPath, NULL, point.x, point.y);
        [self.fingerTouchArr addObject:@(false)];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (_isBlur) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGPathAddLineToPoint(self.blurPath, NULL, point.x, point.y);
        CGMutablePathRef path = CGPathCreateMutableCopy(self.blurPath);
        self.shapeLayer.path = path;
        CGPathRelease(path);
        [self.appendPaths addObject:[NSValue valueWithCGPoint:point]];
    } else {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGPathAddLineToPoint(currentPath, NULL, point.x, point.y);
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (_isBlur) {
        [self.allPaths addObject:self.appendPaths];
    }
}

//清除
- (void)clear{
    [self.allPaths removeAllObjects];
    self.blurPath = CGPathCreateMutable();
    CGPathMoveToPoint(self.blurPath, NULL, 0, 0);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.blurPath);
    self.shapeLayer.path = path;
    CGPathRelease(path);
}

//撤回
- (void)back{
    [self.allPaths removeLastObject];
    self.blurPath = CGPathCreateMutable();
    //如果撤回步骤大于0次执行撤回 否则执行清除操作
    if (self.allPaths.count>0) {
        for (int i=0; i<self.allPaths.count; i++) {
            NSArray * array = self.allPaths[i];
            for (int j =0 ; j<array.count; j++) {
                CGPoint point = [array[j] CGPointValue];
                if (j==0) {
                    CGPathMoveToPoint(self.blurPath, NULL, point.x, point.y);
                    CGMutablePathRef path = CGPathCreateMutableCopy(self.blurPath);
                    self.shapeLayer.path = path;
                    CGPathRelease(path);
                }else{
                    CGPathAddLineToPoint(self.blurPath, NULL, point.x, point.y);
                    CGMutablePathRef path = CGPathCreateMutableCopy(self.blurPath);
                    self.shapeLayer.path = path;
                    CGPathRelease(path);
                }
            }
        }
    }else{
        [self clear];
    }
}

// 一键清屏
- (void)clearScreen {
    _isEarse = NO;
    [self clear];
    [_stroks removeAllObjects];
    [self setNeedsDisplay];
}

// 撤回
- (void)revokeScreen {
    _isEarse = NO;
    NSInteger revokeJudge = [[self.fingerTouchArr lastObject] integerValue];
    if (revokeJudge) {
        [self back];
    } else {
        [self.stroks removeLastObject];
        [self setNeedsDisplay];
    }
    [self.fingerTouchArr removeLastObject];
}

// 橡皮擦
- (void)eraseSreen {
    self.isEarse = YES;
}

// 设置画笔颜色
- (void)setStrokeColor:(UIColor *)lineColor {
    _isEarse = NO;
    self.lineColor = lineColor;
}

// 因为不支持ARC，需要手动释放
- (void)dealloc {
    if (currentPath) {
        CGPathRelease(currentPath);
    }
    if (self.blurPath) {
        CGPathRelease(self.blurPath);
    }
}

- (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level {
    //获取BitmapData
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imgRef = orginImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  kBitsPerComponent,        // 每个颜色值8bit
                                                  width*kPixelChannelCount, // 每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    unsigned char *bitmapData = CGBitmapContextGetData (context);
    
    // 这里把BitmapData进行马赛克转换,就是用一个点的颜色填充一个level*level的正方形
    unsigned char pixel[kPixelChannelCount] = {0};
    NSUInteger index,preIndex;
    for (NSUInteger i = 0; i < height - 1 ; i++) {
        for (NSUInteger j = 0; j < width - 1; j++) {
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    memcpy(pixel, bitmapData + kPixelChannelCount*index, kPixelChannelCount);
                }else{
                    memcpy(bitmapData + kPixelChannelCount*index, pixel, kPixelChannelCount);
                }
            } else {
                preIndex = (i-1)*width +j;
                memcpy(bitmapData + kPixelChannelCount*index, bitmapData + kPixelChannelCount*preIndex, kPixelChannelCount);
            }
        }
    }
    
    NSInteger dataLength = width*height* kPixelChannelCount;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    // 创建要输出的图像
    CGImageRef mosaicImageRef = CGImageCreate(width, height,
                                              kBitsPerComponent,
                                              kBitsPerPixel,
                                              width*kPixelChannelCount ,
                                              colorSpace,
                                              kCGImageAlphaPremultipliedLast,
                                              provider,
                                              NULL, NO,
                                              kCGRenderingIntentDefault);
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       kBitsPerComponent,
                                                       width*kPixelChannelCount,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    // 释放
    if(resultImageRef){
        CFRelease(resultImageRef);
    }
    if(mosaicImageRef){
        CFRelease(mosaicImageRef);
    }
    if(colorSpace){
        CGColorSpaceRelease(colorSpace);
    }
    if(provider){
        CGDataProviderRelease(provider);
    }
    if(context){
        CGContextRelease(context);
    }
    if(outputContext){
        CGContextRelease(outputContext);
    }
    return resultImage;
}


@end
