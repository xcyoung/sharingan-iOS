//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation

class SharinganMetaClassField: NSObject {
    let className: String
    let infos: [SharinganMetaInfoField]

    init(className: String, infos: [SharinganMetaInfoField]) {
        self.className = className
        self.infos = infos
        super.init()
    }
}

class SharinganMetaInfoField: NSObject {
    let title: String
    let detail: String

    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
        super.init()
    }
}