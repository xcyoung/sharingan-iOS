//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation

class SharinganMetaClassField: NSObject {
    let className: String
    let detail: String
    let infos: [SharinganMetaClassField]

    init(className: String, detail: String, infos: [SharinganMetaClassField]) {
        self.className = className
        self.detail = detail
        self.infos = infos
        super.init()
    }

    var detailDescription: String {
        if infos.isEmpty {
            return detail
        } else {
            var str = ""
            for i in 0..<infos.count {
                if i != 0 {
                    str += ",\(infos[i].detailDescription)"
                } else {
                    str += "\(infos[i].detailDescription)"
                }
            }
            return str
        }
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