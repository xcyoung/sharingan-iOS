//
// Created by 肖楚🐑 on 2021/1/1.
//

import Foundation

class SharinganError: NSError {
    var message: String = ""

    override var localizedDescription: String {
        get {
            #if DEBUG
            return "[\(code)]\(message)"
            #else
            return message
            #endif

        }
    }

    convenience init(code: Int, message: String) {
        self.init(domain: "SharinganError", code: code, userInfo: nil)
        self.message = message
    }
}