//
//  L102Language.swift
//  Salamtak_App
//
//  Created by mostafa elsanadidy on 10.11.22.
//

import Foundation

//L102Language.setAppleLAnguageTo(lang: "ar")
      
let APPLE_LANGUAGE_KEY = "AppleLanguages"

class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey:APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }
}
