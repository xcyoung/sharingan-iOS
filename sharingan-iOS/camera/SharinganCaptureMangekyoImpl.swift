//
// Created by 肖楚🐑 on 2021/1/1.
//

import Foundation
import AVFoundation

/**
 @class SharinganCaptureMangekyoImpl
 @abstract
    封装iOS10后使用AVCapturePhotoOutput输出静态图的逻辑
 */
@available(iOS 10.0, *)
class SharinganCaptureMangekyoImpl: SharinganCaptureBaseImpl {
    private let photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput.init()

    override func initCamera() -> Bool {
        do {
            let discoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera],
                    mediaType: .video, position: .back)
            let device = discoverySession.devices.first(where: { device in device.position == .back })!

            session.beginConfiguration()
            session.sessionPreset = getSessionPreset()
            let captureInput = try AVCaptureDeviceInput.init(device: device)
            if session.canAddInput(captureInput) {
                session.addInput(captureInput)
            }
            self.currentCaptureInput = captureInput

            if session.canAddOutput(self.photoOutput) {
                session.addOutput(self.photoOutput)
            }
            session.commitConfiguration()
            return super.initCamera()
        } catch {
            print(error.localizedDescription)
            captureCallback?.onError(error: SharinganError.init(code: -1, message: error.localizedDescription))
        }
        return false
    }

    override func createPreviewLayer(previewFrame frame: CGRect) -> AVCaptureVideoPreviewLayer {
        super.createPreviewLayer(previewFrame: frame)
    }

    override func startCamera() {
        super.validCamera { [weak self] in
            guard let weakSelf = self,
                  !weakSelf.session.isRunning else {
                return
            }
            weakSelf.session.startRunning()
        }
    }

    override func stopCamera() {
        super.validCamera { [weak self] in
            guard let weakSelf = self,
                  !weakSelf.session.isRunning else {
                return
            }
            weakSelf.session.stopRunning()
        }
    }

    override func capture() {
        super.validCamera { [weak self] in
            guard let weakSelf = self else {
                return
            }

            let setting = AVCapturePhotoSettings.init(format: [
                AVVideoCodecKey: getImageFormat()
            ])
            weakSelf.photoOutput.capturePhoto(with: setting, delegate: weakSelf)
        }
    }

    private func getSessionPreset() -> AVCaptureSession.Preset {
        let preset: AVCaptureSession.Preset
        switch config.capturePreset {
        case ._640x480:
            preset = .vga640x480
        case ._1280x720:
            preset = .hd1280x720
        case ._1920x1080:
            preset = .hd1920x1080
        case ._3840x2160:
            preset = .hd4K3840x2160
        case ._photo:
            preset = .photo
        }
        return preset
    }

    private func getImageFormat() -> String {
        let videoCodec: String
        switch config.imageFormat {
        case .jpg:
            videoCodec = AVVideoCodecJPEG
        case .heif:
            if #available(iOS 11.0, *) {
                videoCodec = AVVideoCodecHEVC
            } else {
                videoCodec = AVVideoCodecJPEG
            }
        }
        return videoCodec
    }
}

@available(iOS 10.0, *)
extension SharinganCaptureMangekyoImpl: AVCapturePhotoCaptureDelegate {
    @available(iOS, introduced: 10.0, deprecated: 11.0)
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let sampleBuffer = photoSampleBuffer {
            if let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer,
                    previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                let result = SharinganCaptureResult.init(imageData: data)
                captureCallback?.onCaptureSuccess(result: result)
            } else {
                captureCallback?.onCaptureError(error: SharinganError.init(code: -1, message: "AVCapturePhotoOutput.jpegPhotoDataRepresentation return nil"))
            }
        } else {
            captureCallback?.onCaptureError(error: SharinganError.init(code: -1, message: "photoSampleBuffer is nil"))
        }
    }

    @available(iOS 11.0, *)
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation() {
            let result = SharinganCaptureResult.init(imageData: data)
            captureCallback?.onCaptureSuccess(result: result)
        } else {
            captureCallback?.onCaptureError(error: SharinganError.init(code: -1, message: "photo.fileDataRepresentation() return nil"))
        }
    }
}