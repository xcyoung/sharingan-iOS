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
                width: self.view.matchWidth, height: self.view.matchHeight)
        tableView.dataSource = self
        tableView.delegate = self

        self.view.addSubview(tableView)

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].infos.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}
