//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation
import UIKit

class MetaViewController: UIViewController {
    private var items: [SharinganMetaClassField] = []
    private let metaViewModel: MetaViewModel
    private let tableView: UITableView = {
        let tableView = UITableView.init()

        return tableView
    }()

    init(imageUrl: String) {
        self.metaViewModel = MetaViewModel.init(imageUrl: imageUrl)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = CGRect.init(x: self.view.safeAreaLeft, y: self.view.safeAreaTop,
                                      width: self.view.matchWidth, height: self.view.frame.height)
        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(tableView)

        metaViewModel.metaInfoLiveData.asObservable().subscribe { [weak self] event in
            guard let weakSelf = self,
                  let element = event.element else {
                return
            }
            weakSelf.items.removeAll()
            weakSelf.items.append(contentsOf: element)
            weakSelf.tableView.reloadData()
        }

        metaViewModel.errorLiveData.asObservable().subscribe { [weak self] event in
            guard let weakSelf = self,
                  let element = event.element,
                  let error = element else {
                return
            }

        }

        metaViewModel.loadMeta()
    }
}

extension MetaViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
//        var count = 0
//        items.forEach { field in
//            if field.infos.isEmpty {
//                count += 1
//            } else {
//                count += field.infos.count
//            }
//        }
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items[section].infos.isEmpty {
            return 1
        }
        return items[section].infos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        if item.infos.isEmpty {
            print("\(item.className): \(item.detailDescription)")
        } else {
            let subItem = item.infos[indexPath.row]
            print("\(item.className), \(subItem.className): \(subItem.detailDescription)")
        }
        
        return UITableViewCell.init()
    }
}
