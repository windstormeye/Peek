//
//  PJCameraView.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/27.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

@objc protocol PJCameraViewDelegate {
    func swipeGesture(direction: UISwipeGestureRecognizerDirection)
}

class PJCameraView: UIView, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    private var session: AVCaptureSession?
    private var videoInput: AVCaptureDeviceInput?
    private var imageOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isPhoto: Bool = false
    
    @objc public var viewDelegate: PJCameraViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        initAVCaptureSession()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = UIColor.black
        
        let leftSwipeGes = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeGestuer(swipe:)))
        leftSwipeGes.direction = .left;
        self.addGestureRecognizer(leftSwipeGes)
        
        let rightSwipeGes = UISwipeGestureRecognizer.init(target: self, action: #selector(swipeGestuer(swipe:)))
        rightSwipeGes.direction = .right
        self.addGestureRecognizer(rightSwipeGes)
    }
    
    private func initAVCaptureSession() {
        
        session = AVCaptureSession.init()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        videoInput = try! AVCaptureDeviceInput.init(device: device!)
    
        // init OutPut
        let videoDataOutPut = AVCaptureVideoDataOutput()
        videoDataOutPut.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA
            ] as [String : Any]
        videoDataOutPut.setSampleBufferDelegate(self, queue: .global())
        
        if (session?.canAddOutput(videoDataOutPut))!{
            session?.addOutput(videoDataOutPut)
        }
        
        if (session?.canAddInput(videoInput!))! {
            session?.addInput(videoInput!)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer.init(session: session!)
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer?.frame = self.frame
        self.layer.addSublayer(previewLayer!)
        
        session?.startRunning()
    }

    @objc private func swipeGestuer(swipe: UISwipeGestureRecognizer) {
        viewDelegate?.swipeGesture(direction: swipe.direction)
    }
    
    @objc public func takePhoto() {
        isPhoto = true
    }
    
    /*
     *  get & save image
     */
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        if isPhoto {
            isPhoto = false
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            CVPixelBufferLockBaseAddress(imageBuffer!,
                                         CVPixelBufferLockFlags(rawValue: 0))
            let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!)
            let width = CVPixelBufferGetWidth(imageBuffer!)
            let height = CVPixelBufferGetHeight(imageBuffer!)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
            let context = CGContext.init(data: baseAddress,
                                         width: width,
                                         height: height,
                                         bitsPerComponent: 8,
                                         bytesPerRow: bytesPerRow,
                                         space: colorSpace,
                                         bitmapInfo: bitmapInfo.rawValue)
            let quartzImage = context?.makeImage()
            CVPixelBufferUnlockBaseAddress(imageBuffer!,
                                           CVPixelBufferLockFlags(rawValue: 0))
            // anticlockwise 90°
            let image = UIImage.init(cgImage: quartzImage!,
                                     scale: 1.0,
                                     orientation: .right)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getImage"), object: nil, userInfo: ["image" : image])
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (saved, erroe) in
                if saved {
                }
            }
        }
    }

}
