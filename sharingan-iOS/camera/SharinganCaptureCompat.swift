//
// Created by 肖楚🐑 on 2021/1/1.
//

import Foundation

enum CapturePreset: String {
    case _640x480 = "vga640x480"
    case _1280x720 = "hd1280x720"
    case _1920x1080 = "hd1920x1080"
    case _3840x2160 = "hd4K3840x2160"
    case _photo = "photo"
}

enum ImageFormat: String {
    case jpg = "jpg"
    case heif = "heif"
}

class SharinganCaptureCompat {
    static let shared: SharinganCaptureCompat = SharinganCaptureCompat.init()
    private let globalConfig: CaptureConfiguration = CaptureConfiguration.init()
    private init() {

    }

    func createCaptureImpl() -> SharinganCaptureBaseImpl {
        if #available(iOS 10.0, *) {
            return SharinganCaptureMangekyoImpl.init(config: globalConfig)
        } else {
            fatalError("暂不支持iOS10.0以下")
        }
    }

    struct CaptureConfiguration {
        var capturePreset: CapturePreset = ._1920x1080
        var imageFormat: ImageFormat = .jpg
    }
}