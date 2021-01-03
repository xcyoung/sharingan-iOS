//
// Created by 肖楚🐑 on 2021/1/2.
//

import Foundation
import UIKit

class CameraViewController: UIViewController {
    private let captureImpl = SharinganCaptureCompat.shared.createCaptureImpl()
    private var tempAlbumViewCenterPoint: CGPoint?
    private let albumViewModel = AlbumViewModel.init()
    private lazy var albumViewController = AlbumViewController.init(albumViewModel: albumViewModel)
    private let previewView: UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor.gray
        return view
    }()

    private let captureBtn: UIButton = {
        let btn = UIButton.init()
        btn.layer.cornerRadius = 40
        btn.clipsToBounds = true
        btn.layer.backgroundColor = UIColor.init(white: 0.8, alpha: 1).cgColor
        btn.layer.borderWidth = 6
        btn.layer.borderColor = UIColor.init(white: 1, alpha: 1).cgColor
        return btn
    }()

    private let albumView: UIView = {
        let view = UIView.init()

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        previewView.frame = CGRect.init(x: self.view.safeAreaLeft, y: self.view.safeAreaTop,
                width: self.view.matchWidth, height: self.view.matchWidth * CGFloat(4 / 3))
        captureBtn.frame = CGRect.init(x: (self.view.matchWidth - 80) / 2, y: self.view.frame.maxY - 200,
                width: 80, height: 80)
        captureBtn.addTarget(self, action: #selector(onCapture), for: .touchUpInside)
        albumView.frame = CGRect.init(x: self.view.safeAreaLeft, y: captureBtn.frame.maxY + 20,
                width: self.view.matchWidth, height: self.view.frame.maxY - (captureBtn.frame.maxY + 20))

        albumViewController.view.frame = CGRect.init(x: 0, y: 0,
                width: albumView.frame.width, height: albumView.frame.height)
        albumView.addSubview(albumViewController.view)
        self.addChild(albumViewController)

        let panR = UIPanGestureRecognizer.init(target: self, action: #selector(onAlbumViewPan(sender: )))
        panR.maximumNumberOfTouches = 1
        albumView.addGestureRecognizer(panR)
        
        self.view.addSubview(previewView)
        self.view.addSubview(captureBtn)
        self.view.addSubview(albumView)

        albumViewModel.onPhotoClickLiveData.asObservable().subscribe { [weak self] event in
            guard let weakSelf = self,
                  let element = event.element else { return }

            let metaVC = MetaViewController.init(imageUrl: element)
            weakSelf.navigationController?.pushViewController(metaVC, animated: true)
        }

        if captureImpl.initCamera() {
            captureImpl.captureCallback = self
            previewView.layer.addSublayer(captureImpl.createPreviewLayer(previewFrame: CGRect.init(x: 0, y: 0,
                    width: previewView.frame.width, height: previewView.frame.height)))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureImpl.startCamera()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureImpl.stopCamera()
    }

    @objc private func onCapture() {
        captureImpl.capture()
    }
    
    @objc private func onAlbumViewPan(sender: UIPanGestureRecognizer) {
        if sender.view == albumView {
            if sender.state == .began {
                self.tempAlbumViewCenterPoint = albumView.center
            } else if sender.state == .changed, let temp = self.tempAlbumViewCenterPoint {
                let translation = sender.translation(in: self.view)
                let location = CGPoint.init(x: temp.x + translation.x, y: temp.y + translation.y)
                let centerMinX = albumView.frame.width / 2
                let centerMaxX = self.view.frame.width - albumView.frame.width / 2
                let centerMinY = albumView.frame.height / 2
                let centerMaxY = self.view.frame.height - albumView.frame.height / 2

                albumView.center = CGPoint.init(x: min(max(centerMinX, location.x), centerMaxX),
                        y: min(max(centerMinY, location.y), centerMaxY))
            }
        }
    }
}

extension CameraViewController: SharinganCaptureCallback {
    func onCaptureSuccess(result: SharinganCaptureResult) {
        do {
            let albumUrl = try UIApplication.shared.getPhotoAlbumPath(subAlbum: "Default")
            let imageUrl = albumUrl.appendingPathComponent("/IMG_\(Int64(Date().timeIntervalSince1970 * 1000)).jpg")

            try result.imageData.write(to: imageUrl, options: Data.WritingOptions.atomic)
            albumViewController.reload()
        } catch {
            print(error.localizedDescription)
        }
    }

    func onCaptureError(error: SharinganError) {
        print(error.localizedDescription)
    }

    func onError(error: SharinganError) {
        print(error.localizedDescription)
    }
}
