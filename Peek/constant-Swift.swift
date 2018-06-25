//
//  constant-Swift.swift
//  Peek
//
//  Created by pjpjpj on 2018/6/24.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import Foundation
import UIKit

// 屏幕宽高
let PJSCREEN_HEIGHT = CGFloat(UIScreen.main.bounds.height)
let PJSCREEN_WIDTH = CGFloat(UIScreen.main.bounds.width)

// 颜色相关
func PJRGB(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}

// 计算字符串长度
func getStringLength(string: String) -> CGFloat {
    let count = string.count;
    if inputLetterAndSpace(string) {
        return CGFloat(9 * count)
    }
    return CGFloat(16 * count)
}

func inputLetterAndSpace(_ string: String) -> Bool {
    let regex = "[ a-zA-Z]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}

// 通知
let PJNotificationName_changeLanguage = "PJNotificationNameChangeLanguage"
