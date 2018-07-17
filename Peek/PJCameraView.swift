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
    func cameraView(_ takePhotoImage: UIImage)
}

class PJCameraView: UIView, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {

    private var device: AVCaptureDevice?
    private var session: AVCaptureSession?
    private var videoInput: AVCaptureDeviceInput?
    private var imageOutput: AVCapturePhotoOutput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var isPhoto: Bool = false
    
    @objc public var viewDelegate: PJCameraViewDelegate?
    
    lazy var focusView: UIView? = {
        let focusView = UIView.init(frame: .zero)
        self.addSubview(focusView)
        focusView.center = self.center
        focusView.width = 70
        focusView.height = 70
        focusView.backgroundColor = .clear
        // 对焦框
        let boder = CAShapeLayer.init()
        boder.strokeColor = UIColor.init(red: 238/255.0, green: 173/255.0, blue: 14/255.0, alpha: 1.0).cgColor
        boder.path = UIBezierPath.init(roundedRect: focusView.bounds, cornerRadius: 0).cgPath
        boder.frame = focusView.bounds
        boder.lineWidth = 1.0
        boder.fillColor = UIColor.clear.cgColor
        boder.lineCap = "square"
        boder.lineDashPattern = [10, 5]
        focusView.layer .addSublayer(boder)
        
        return focusView
    }()
    
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
        
        device = AVCaptureDevice.default(for: AVMediaType.video)
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
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(ges:)))
        self.addGestureRecognizer(tap)
        
    }

    deinit {
        
    }
    
    @objc private func tapClick(ges: UITapGestureRecognizer) {
        focus(at: ges.location(in: self))
    }
    
    private func focus(at point: CGPoint) {
        let size: CGSize = self.bounds.size
        let focusPoint = CGPoint(x: point.y / size.height, y: 1 - point.x / size.width)
        if try! device?.lockForConfiguration() != nil {
            //对焦模式和对焦点
            if (device?.isFocusModeSupported(.autoFocus))! {
                device?.focusPointOfInterest = focusPoint
                device?.focusMode = .autoFocus
            }
            if (device?.isExposureModeSupported(.autoExpose))! {
                device?.exposurePointOfInterest = focusPoint
                device?.exposureMode = .autoExpose
            }
            device?.unlockForConfiguration()
            //设置对焦动画
            focusView?.center = point
            focusView?.isHidden = false
            self.focusView?.transform = CGAffineTransform(scaleX: 2, y: 2)
            UIView.animate(withDuration: 0.25, animations: {
                self.focusView?.transform = .identity
            }) { finished in
                if finished {
                    self.perform(#selector(PJCameraView.hiddenFocusView), with: nil, afterDelay: 0.5)
                }
            }
        }
    }

    @objc private func hiddenFocusView() {
        self.focusView?.isHidden = true
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
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { (saved, erroe) in
                if saved {
                    DispatchQueue.main.async(){
                        self.viewDelegate?.cameraView(image)
                    }
                }
            }
        }
    }

}
