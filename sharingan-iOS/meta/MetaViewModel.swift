//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation
import UIKit

class MetaViewModel: BaseViewModel {
    private let imageUrl: String

    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init()
    }

    func loadMeta() {
        DispatchQueue.global().async { [weak self] in
            guard let weakSelf = self else {
                return
            }

            do {
                let imageData = try Data.init(contentsOf: URL.init(fileURLWithPath: weakSelf.imageUrl))
                guard let cgResource = CGImageSourceCreateWithData(imageData as CFData, nil),
                      let cfProps = CGImageSourceCopyPropertiesAtIndex(cgResource, 0, nil) as? Dictionary<AnyHashable, Any> else {
                    weakSelf.errorLiveData.value = SharinganError.init(code: -1, message: "can not load meta, MetaViewModel: \(#line)")
                    return
                }
                
            } catch {
                DispatchQueue.main.async {
                    weakSelf.errorLiveData.value = SharinganError.init(code: -1, message: error.localizedDescription)
                }
            }
        }
    }
}
