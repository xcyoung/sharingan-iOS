//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation
import RxSwift

class BaseViewModel: NSObject {
    public let errorLiveData = LiveData<SharinganError?>.init(defaultValue: nil)
    public let disposeBag = DisposeBag.init()
}
