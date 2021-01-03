//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation
import UIKit

class AlbumViewController: UIViewController {
    private var items: [String] = []
    private let albumViewModel: AlbumViewModel
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.scrollsToTop = false
//        collectionView.allowsSelection = true
//        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AlbumCollectionViewCell.self,
                forCellWithReuseIdentifier: AlbumCollectionViewCell.description())
        return collectionView
    }()

    init(albumViewModel: AlbumViewModel) {
        self.albumViewModel = albumViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)

        reload()
    }

    func reload() {
        DispatchQueue.global().async { [weak self] in
            do {
                let albumUrl = try UIApplication.shared.getPhotoAlbumPath(subAlbum: "Default")
                let array = try FileManager.default.contentsOfDirectory(atPath: albumUrl.path)
                let imageArray = array.compactMap { fileName -> String in
                    "\(albumUrl.path)/\(fileName)"
                }

                self?.items.removeAll()
                self?.items.append(contentsOf: imageArray)
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.description(),
                for: indexPath) as! AlbumCollectionViewCell
        cell.imageUrl = self.items[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        albumViewModel.onPhotoClick(imageUrl: self.items[indexPath.row])
    }
}

class AlbumCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView.init()

        return imageView
    }()

    var imageUrl: String = "" {
        didSet {
            imageView.image = UIImage.init(contentsOfFile: self.imageUrl)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}