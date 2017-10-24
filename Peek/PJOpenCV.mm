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
    
    std::vector<cv::Mat> hsvSplit;
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
    
    int iLowH = 80;
    int iHighH = 180;
    
    int iLowS = 25;
    int iHighS = 255;
    
    int iLowV = 25;
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
    
    // 轮廓检测并填充轮廓内区域
    std::vector<std::vector<cv::Point>> contours;
    findContours(imgThresholded,contours,CV_RETR_EXTERNAL,CV_CHAIN_APPROX_NONE);
    // 把找到的轮廓再次绘制成黑色
    drawContours(imgThresholded,contours,-1, CV_RGB(255, 255, 255),10);
    // 填充轮廓内区域
    cv::fillPoly(imgThresholded, contours, CV_RGB(255, 255, 255));
    
    // 黑白翻转
    int nrows=imgThresholded.rows;
    int ncols=imgThresholded.cols*imgThresholded.channels();
    if(imgThresholded.isContinuous()) {
        ncols*=nrows;
        nrows=1;
    }
    uchar *data;
    // OpenCV中是BGR
    for(int j=0;j<nrows;j++) {
        data=imgThresholded.ptr<uchar>(j);
        for(int i=0;i<ncols;i+=3) {
            if (data[i] == 0) {
                data[i] = 255;
            } else {
                data[i] = 0;
            }
            
            if (data[i + 1] == 0) {
                data[i + 1] = 255;
            } else {
                data[i + 1] = 0;
            }
            
            if (data[i + 2] == 0) {
                data[i + 2] = 255;
            } else {
                data[i + 2] = 0;
            }
        }
    }
    
    image = MatToUIImage(imgThresholded);
    cv::Mat tempImage;
    UIImageToMat(image, tempImage);
    // 变透明
    cv::Mat three_channel = cv::Mat::zeros(tempImage.rows,tempImage.cols,CV_8UC3);
    std::vector<cv::Mat> channels;
    for (int i=0;i<3;i++) {
        channels.push_back(tempImage);
    }
    merge(channels,three_channel);

    cv::cvtColor(three_channel, three_channel, cv::COLOR_BGR2BGRA);
    for(int j=0;j < three_channel.rows;j++) {
        data = three_channel.ptr<uchar>(j);
        for(int i=0;i<three_channel.cols * three_channel.channels();i+=4) {
            if (data[i] == 255 || data[i + 1] == 255 || data[i + 2] == 255) {
                data[i + 3] = 0;
            }
        }
    }
    
    image = MatToUIImage(three_channel);
    return image;
}










@end
