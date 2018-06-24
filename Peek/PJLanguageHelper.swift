//
//  PJLanguageHelper.swift
//  DiDiData
//
//  Created by PJ on 2018/4/26.
//  Copyright © 2018年 Didi.Inc. All rights reserved.
//

import UIKit

let UserLanguage = "UserLanguage"
let AppleLanguages = "AppleLanguages"

class PJLanguageHelper: NSObject {
    
    private let def = UserDefaults.standard
    private var bundle : Bundle?
    
    static let shareInstance : PJLanguageHelper = {
        
        let shared = PJLanguageHelper()
        var string:String = shared.def.value(forKey: UserLanguage) as! String? ?? ""
        if string == "" {
            let languages = shared.def.object(forKey: AppleLanguages) as? NSArray
            if languages?.count != 0 {
                let current = languages?.object(at: 0) as? String
                if current != nil {
                    string = current!
                    shared.def.set(current, forKey: UserLanguage)
                    shared.def.synchronize()
                }
            }
        }
        string = string.replacingOccurrences(of: "-CN", with: "")
        string = string.replacingOccurrences(of: "-US", with: "")
        var path = Bundle.main.path(forResource:string , ofType: "lproj")
        if path == nil {
            path = Bundle.main.path(forResource:"en" , ofType: "lproj")
        }
        shared.bundle = Bundle(path: path!)
        return shared
    }()
    
    public class func getString(key:String) -> String{
        let bundle = PJLanguageHelper.shareInstance.bundle
        let str = bundle?.localizedString(forKey: key, value: nil, table: nil)
        return str!
    }
    
    public func setLanguage(langeuage:String) {
        let path = Bundle.main.path(forResource:langeuage , ofType: "lproj")
        bundle = Bundle(path: path!)
        def.set(langeuage, forKey: UserLanguage)
        def.synchronize()
    }
    
    public func getLanguage() -> String {
        return def.object(forKey: UserLanguage) as! String
    }
    
}

