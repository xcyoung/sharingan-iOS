//
// Created by 肖楚🐑 on 2021/1/3.
//

import Foundation

class AlbumViewModel: BaseViewModel {
    let onPhotoClickLiveData = LiveData<String>.init(defaultValue: "")

    func onPhotoClick(imageUrl: String) {
        onPhotoClickLiveData.value = imageUrl
    }
}
