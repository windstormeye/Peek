//
//  PJSegmentView.swift
//  DiDiData
//
//  Created by PJ on 2018/4/26.
//  Copyright © 2018年 Didi.Inc. All rights reserved.
//

import UIKit

@objc protocol PJSegmentViewDelegate: class {
    @objc optional func segmentView(
        segmentView: PJSegmentView,
        didEndingScroll offsetX: CGFloat
    );
}


class PJSegmentView: UIView {
    
    private var menuHeight: CGFloat?
    private var scrollView: UIScrollView?
    private var tipView: UIView?
    private var menuWidth: CGFloat?
    private var btnArray: Array<UIButton>?
    
    @objc public var delegate: PJSegmentViewDelegate?
    @objc public var segmentIndex: NSNumber?
    public var menuTempArray: Array<String>?
    @objc public var menuArray: Array<String> {
        get {
            return self.menuTempArray!
        }
        set(newTempArray) {
            self.menuTempArray = newTempArray
            menuWidth = CGFloat(self.width / CGFloat(newTempArray.count))
            self.initScrollView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.menuHeight = self.height
        self.backgroundColor = UIColor.clear
        segmentIndex = NSNumber.init(integerLiteral: 0)
    }
    
    private func initScrollView() {
        if self.scrollView == nil {
            self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0,
                                                                   y: 0,
                                                                   width: self.width,
                                                                   height: self.height))
            self.scrollView?.showsVerticalScrollIndicator = false
            self.scrollView?.showsHorizontalScrollIndicator = false
            self.addSubview(self.scrollView!)
        }
        
        if self.menuArray.isEmpty || self.menuArray.count < 4 {
            self.scrollView!.contentSize = CGSize.init(
                width: self.scrollView!.width,
                height: self.scrollView!.height
            )
        } else {
            self.scrollView!.contentSize = CGSize.init(
                width: CGFloat(Int(self.scrollView!.width) * self.menuArray.count) ,
                height: self.scrollView!.height
            )
        }
        
        self.btnArray = []
        
        // 初始化segmentButton
        for i in 0..<self.menuArray.count {
            let btn = UIButton.init(frame: CGRect.init(x: CGFloat(Int(menuWidth!) * i), y: 0, width: menuWidth!, height: self.scrollView!.height))
            btn.setTitle(PJLanguageHelper.getString(key: self.menuArray[i]), for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            if i == 0 {
                btn.setTitleColor(UIColor.orange, for: .normal)
            } else {
                btn.setTitleColor(UIColor.lightGray, for: .normal)
            }
            btn.tag = i
            btn.addTarget(self, action: #selector(tipButtonClick(button:)), for: .touchUpInside)
            self.btnArray?.append(btn)
            self.scrollView?.addSubview(btn)
        }
        
        if self.tipView == nil {
            self.tipView = UIView.init(frame: CGRect.init(
                x: 0,
                y: self.height - 3,
                width: getStringLength(string: PJLanguageHelper.getString(key: self.menuArray[0])),
                height: 3)
            )
            let firstBtn = self.btnArray![0]
            self.tipView?.centerX = firstBtn.centerX
            self.tipView?.layer.cornerRadius = (self.tipView?.height)! / 2
            self.tipView?.layer.masksToBounds = true
            self.tipView?.backgroundColor = UIColor.orange
            self.scrollView?.addSubview(self.tipView!)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeLanguage),
                                               name: NSNotification.Name(rawValue: PJNotificationName_changeLanguage),
                                               object: nil)
        
    }
    
    @objc private func changeLanguage() {
        for i in 0..<btnArray!.count {
            let btn = btnArray![i]
            btn.setTitle(PJLanguageHelper.getString(key: self.menuArray[i]), for: .normal)
        }
        let firstBtn = self.btnArray![0]
        tipView?.width = getStringLength(string: (firstBtn.titleLabel?.text)!)
        tipView?.centerX = firstBtn.centerX
    }
    
    @objc private func tipButtonClick(button: UIButton) {
        tipViewChange(button: button)
        self.delegate?.segmentView!(segmentView: self, didEndingScroll: self.width * CGFloat(button.tag))
    }
    
    @objc private func tipViewChange(button: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.tipView?.width = getStringLength(string: (button.titleLabel?.text)!)
            self.tipView?.centerX = button.centerX
            for btn in self.btnArray! {
                btn.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }) { (_) in
            self.moveScrollView()
            button.setTitleColor(UIColor.orange, for: .normal)
        }
    }
    
    private func moveScrollView() {
        let point = self.scrollView?.convert((self.tipView?.frame.origin)!, to: self)
        let tipCenterX = (point?.x)! + (self.tipView?.width)! * 0.5
        let xValue = (tipCenterX - self.centerX)
        if fabs(xValue) != 0.0 &&
            (xValue < 0 ? (self.scrollView?.contentOffset.x)! > CGFloat(0) :
                (self.scrollView?.contentOffset.x)! < (self.scrollView?.contentSize.width)! - (self.scrollView?.width)!) {
            UIView.animate(withDuration: 0.25, animations: {() -> Void in
                var offsetX: CGFloat = self.scrollView!.contentOffset.x + xValue
                //防止过度偏移
                if offsetX > (self.self.scrollView?.contentSize.width)! - (self.scrollView?.width)! {
                    offsetX = (self.scrollView?.contentSize.width)! - (self.scrollView?.width)!
                }
                if offsetX < 0 {
                    offsetX = 0
                }
                self.scrollView?.contentOffset = CGPoint(x: offsetX, y: (self.scrollView?.contentOffset.y)!)
            })
        }    }
    
    public func menuMoveByOffset(offset: CGPoint) {
        self.tipView?.x = (offset.x / CGFloat(self.width)) * menuWidth!
        //判断是否是移动完毕
        if Int((self.tipView?.x)!) % Int(menuWidth!) == 0 {
            moveScrollView()
        }

    }
    
    @objc public func menuMoveByIndex(Index: Int) {
        var index = Index
        if index < 0 {
            index = 0
        }
        if index >= menuArray.count {
            index = menuArray.count - 1
        }
        segmentIndex = NSNumber.init(integerLiteral: index)
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            let button = self.btnArray![index]
            self.tipViewChange(button: button)
        }, completion: {(_ finished: Bool) -> Void in
            self.moveScrollView()
        })
    }
    
}
