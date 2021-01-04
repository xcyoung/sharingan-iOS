//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation
import UIKit

class MetaViewModel: BaseViewModel {
    private let imageUrl: String
    let metaInfoLiveData: LiveData<[SharinganMetaClassField]> = LiveData.init(defaultValue: [])

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

                let meta = weakSelf.transformMeta(meta: cfProps)
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.metaInfoLiveData.value = meta
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.errorLiveData.value = SharinganError.init(code: -1, message: error.localizedDescription)
                }
            }
        }
    }

    private func transformMeta(meta: Dictionary<AnyHashable, Any>) -> [SharinganMetaClassField] {
        var fields = [SharinganMetaClassField]()
        meta.forEach { key, value in
            if let stringKey = key as? String, stringKey != "{MakerApple}" {
                if let stringValue = value as? String {
                    let field = SharinganMetaClassField.init(className: stringKey, detail: stringValue, infos: [])
                    fields.append(field)
                } else if let intValue = value as? Int {
                    let field = SharinganMetaClassField.init(className: stringKey, detail: String.init(intValue), infos: [])
                    fields.append(field)
                } else if let mapValue = value as? Dictionary<AnyHashable, Any> {
                    let fs = transformMeta(meta: mapValue)
                    let field = SharinganMetaClassField.init(className: stringKey, detail: "", infos: fs)
                    fields.append(field)
                }
            }
        }
        return fields
    }
}
