//
//  PJEditImageScrollView.swift
//  Peek
//
//  Created by pjpjpj on 2018/7/18.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJEditImageScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if ((view?.isKind(of: PJEditImageTouchView.self))! || (view?.isKind(of: UIImageView.self))!) {
            self.isScrollEnabled = false
        } else {
            self.isScrollEnabled = true
        }
        return view
    }
    
}
