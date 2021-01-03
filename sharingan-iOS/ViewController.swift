//
//  ViewController.swift
//  sharingan-iOS
//
//  Created by 肖楚🐑 on 2021/1/1.
//
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private let captureImpl = SharinganCaptureCompat.shared.createCaptureImpl()
    private let preview: UIView = UIView.init(frame: UIScreen.main.bounds)
    private let btn: UIButton = UIButton.init(frame: CGRect(x: (UIScreen.main.bounds.width - 100) / 2,
            y: UIScreen.main.bounds.height - 100, width: 100, height: 50))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btn.backgroundColor = UIColor.systemBlue
        btn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        self.view.addSubview(preview)
        self.view.addSubview(btn)
        if captureImpl.initCamera() {
            captureImpl.captureCallback = self
            preview.layer.addSublayer(captureImpl.createPreviewLayer(previewFrame: preview.frame))
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

    @objc private func onClick() {
        captureImpl.capture()
    }
}

extension ViewController: SharinganCaptureCallback {
    func onCaptureSuccess(result: SharinganCaptureResult) {
        print("")
    }

    func onCaptureError(error: SharinganError) {
        print(error.localizedDescription)
    }

    func onError(error: SharinganError) {
        print(error.localizedDescription)
    }
}
