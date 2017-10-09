//
//  PJOpenCV.m
//  Peek
//
//  Created by pjpjpj on 2017/10/8.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "PJOpenCV.h"

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#include "opencv2/imgproc/imgproc.hpp"

@implementation PJOpenCV

+ (UIImage *)imageToGary:(UIImage *)image {
    cv::Mat cvImage;
    UIImageToMat(image, cvImage);
    cv::Mat gray;
    // 将图像转换为灰度显示
    cv::cvtColor(cvImage,gray,CV_RGB2GRAY);
    // 应用高斯滤波器去除小的边缘
    cv::GaussianBlur(gray, gray, cv::Size(5,5), 1.2,1.2);
    // 计算与画布边缘
    cv::Mat edges;
    cv::Canny(gray, edges, 0, 50);
    // 使用白色填充
    cvImage.setTo(cv::Scalar::all(225));
    // 修改边缘颜色
    cvImage.setTo(cv::Scalar(0,128,255,255),edges);
    // 将Mat转换为Xcode的UIImageView显示
    image = MatToUIImage(cvImage);
    
    return image;
}

+ (UIImage *)imageToDiscernBlue:(UIImage *)image {
    cv::Mat imgOriginal;
    cv::Mat imgHSV;
    
    std::vector<cv::Mat> hsvSplit;
    UIImageToMat(image, imgOriginal);
    
    switch (image.imageOrientation) {
            // 竖屏
        case UIImageOrientationRight:
            // 先转置然后再翻转（矩阵）
            transpose(imgOriginal, imgOriginal);
            cv::flip(imgOriginal, imgOriginal, 1);
            break;
            // home键在右手
        case UIImageOrientationUp:
            break;
            // home键在左手
        case UIImageOrientationDown:
            break;
        default:
            break;
    }
    
    int iLowH = 0;
    int iHighH = 40;

    int iLowS = 90;
    int iHighS = 255;

    int iLowV = 90;
    int iHighV = 255;

    cv::cvtColor(imgOriginal, imgHSV, cv::COLOR_BGR2HSV);
    cv::split(imgHSV, hsvSplit);
    cv::equalizeHist(hsvSplit[2],hsvSplit[2]);
    cv::merge(hsvSplit,imgHSV);

    cv::Mat imgThresholded;

    inRange(imgHSV, cv::Scalar(iLowH, iLowS, iLowV), cv::Scalar(iHighH, iHighS, iHighV), imgThresholded);

    //开操作 (去除一些噪点)
    cv::Mat element = getStructuringElement(cv::MORPH_RECT, cv::Size(5, 5));
    cv::morphologyEx(imgThresholded, imgThresholded, cv::MORPH_OPEN, element);

    //闭操作 (连接一些连通域)
    morphologyEx(imgThresholded, imgThresholded, cv::MORPH_CLOSE, element);
    
    image = MatToUIImage(imgThresholded);
    return image;
}

+ (UIImage *)imageToDiscernRed:(UIImage *)image {
    cv::Mat imgOriginal;
    cv::Mat imgHSV;
    
    std::vector<cv::Mat> hsvSplit;
    UIImageToMat(image, imgOriginal);
    
    switch (image.imageOrientation) {
            // 竖屏
        case UIImageOrientationRight:
            // 先转置然后再翻转（矩阵）
            transpose(imgOriginal, imgOriginal);
            cv::flip(imgOriginal, imgOriginal, 1);
            break;
            // home键在右手
        case UIImageOrientationUp:
            break;
            // home键在左手
        case UIImageOrientationDown:
            break;
        default:
            break;
    }
    
    int iLowH = 120;
    int iHighH = 180;
    
    int iLowS = 90;
    int iHighS = 255;
    
    int iLowV = 90;
    int iHighV = 255;
    
    cv::cvtColor(imgOriginal, imgHSV, cv::COLOR_BGR2HSV);
    cv::split(imgHSV, hsvSplit);
    cv::equalizeHist(hsvSplit[2],hsvSplit[2]);
    cv::merge(hsvSplit,imgHSV);
    
    cv::Mat imgThresholded;
    
    inRange(imgHSV, cv::Scalar(iLowH, iLowS, iLowV), cv::Scalar(iHighH, iHighS, iHighV), imgThresholded);
    
    //开操作 (去除一些噪点)
    cv::Mat element = getStructuringElement(cv::MORPH_RECT, cv::Size(5, 5));
    cv::morphologyEx(imgThresholded, imgThresholded, cv::MORPH_OPEN, element);
    
    //闭操作 (连接一些连通域)
    morphologyEx(imgThresholded, imgThresholded, cv::MORPH_CLOSE, element);
    
    image = MatToUIImage(imgThresholded);
    return image;
}










@end
