//
// Created by 肖楚🐑 on 2021/1/1.
//

import Foundation
import AVFoundation

protocol SharinganCaptureProtocol {
    func initCamera() -> Bool
    func startCamera()
    func stopCamera()
    func createPreviewLayer(previewFrame frame: CGRect) -> AVCaptureVideoPreviewLayer
    func capture()
}

class SharinganCaptureBaseImpl: NSObject, SharinganCaptureProtocol {
    weak var captureCallback: SharinganCaptureCallback?
    let config: SharinganCaptureCompat.CaptureConfiguration
    let session = AVCaptureSession.init()
    var currentCaptureInput: AVCaptureDeviceInput?
    var isInit: Bool = true

    init(config: SharinganCaptureCompat.CaptureConfiguration) {
        self.config = config
    }

    func initCamera() -> Bool {
        isInit = true
        return true
    }

    func startCamera() {

    }

    func stopCamera() {

    }

    func validCamera(onValid: () -> Void) {
        guard isInit else {
            return
        }
        onValid()
    }

    func createPreviewLayer(previewFrame frame: CGRect) -> AVCaptureVideoPreviewLayer {
        let layer = AVCaptureVideoPreviewLayer.init(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = frame
        return layer
    }

    func capture() {

    }

    func dispose() {
        stopCamera()
        isInit = false
    }
}

protocol SharinganCaptureCallback: class {
    func onCaptureSuccess(result: SharinganCaptureResult)
    func onCaptureError(error: SharinganError)
    func onError(error: SharinganError)
}