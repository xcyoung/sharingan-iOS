//
// Created by 肖楚🐑 on 2021/1/1.
//

import Foundation

class SharinganCaptureResult: NSObject {
    let imageData: Data

    init(imageData data: Data) {
        self.imageData = data
        super.init()
    }
}
