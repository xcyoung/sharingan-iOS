//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation
import RxSwift

class LiveData<Element>: NSObject {
    private var liveDataValue: Element
    private var variable: PublishSubject<Element>
    //  MARK: - 因为可能存在在一次回调中触发ui联动导致value重新被赋值，造成死锁情况，故改用递归锁解决
    private let lock = NSRecursiveLock.init()
    private var pre_liveDataValue: Element
    private let defaultValue: Element
    private var isOnPost: Bool = false
    public var value: Element {
        get {
            return getValue()
        }
        set {
            postValue(value: newValue)
        }
    }

    public init(defaultValue: Element) {
        self.defaultValue = defaultValue
        liveDataValue = defaultValue
        pre_liveDataValue = defaultValue
        variable = PublishSubject<Element>()
    }

    func asObservable() -> Observable<Element> {
        return variable.asObservable()
                .observe(on: MainScheduler.instance)
                .subscribe(on: ConcurrentMainScheduler.instance)
    }

    private func postValue(value v: Element) {
        if Thread.isMainThread {
            lock.lock()
            setValue(value: v)
            lock.unlock()
        } else {
            lock.lock()
            pre_liveDataValue = v
            if !isOnPost {
                isOnPost = true
            }
            lock.unlock()
            if isOnPost {
                DispatchQueue.main.async { [weak self] in
                    guard let this = self else {
                        return
                    }

                    this.lock.lock()
                    let newValue: Element = this.pre_liveDataValue
                    this.isOnPost = false
                    this.setValue(value: newValue)
                    this.lock.unlock()
                }
            }
        }
    }

    private func setValue(value v: Element) {
        liveDataValue = v
        variable.onNext(v)
    }

    private func getValue() -> Element {
        self.lock.lock()
        defer {
            self.lock.unlock()
        }
        return liveDataValue
    }
}
