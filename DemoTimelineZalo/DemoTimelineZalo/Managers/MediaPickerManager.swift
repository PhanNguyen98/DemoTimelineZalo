//
//  MediaPickerManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 23/8/25.
//

import UIKit
import YPImagePicker
import AVFoundation

protocol MediaPickerManagerDelegate: AnyObject {
    func mediaPickerManager(_ manager: MediaPickerManager, didPickImages images: [UIImage])
    func mediaPickerManager(_ manager: MediaPickerManager, didPickVideo url: URL)
}

class MediaPickerManager: NSObject {
    weak var delegate: MediaPickerManagerDelegate?
    private var previouslySelectedItems: [YPMediaItem] = []

    // Present image picker allowing multiple images
    func presentImagePicker(from viewController: UIViewController) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 99 // allow multiple selection
        config.library.defaultMultipleSelection = true
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.showsPhotoFilters = false
        config.library.preSelectItemOnMultipleSelection = false
        config.onlySquareImagesFromCamera = false
        config.shouldSaveNewPicturesToAlbum = false
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = previouslySelectedItems
        config.library.itemOverlayType = .none

        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [weak self, weak picker] items, _ in
            let photoItems = items.filter {
                if case .photo = $0 { return true }
                return false
            }
            self?.previouslySelectedItems = photoItems
            var images: [UIImage] = []
            for item in photoItems {
                if case .photo(let photo) = item {
                    images.append(photo.image)
                }
            }
            DispatchQueue.main.async {
                picker?.dismiss(animated: true, completion: nil)
            }
            if !images.isEmpty {
                self?.delegate?.mediaPickerManager(self!, didPickImages: images)
            }
        }
        DispatchQueue.main.async {
            viewController.present(picker, animated: true, completion: nil)
        }
    }

    // Present video picker allowing one video
    func presentVideoPicker(from viewController: UIViewController) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .video
        config.library.maxNumberOfItems = 1
        config.screens = [.library, .video]
        config.startOnScreen = .library
        config.showsPhotoFilters = false
        config.library.defaultMultipleSelection = false
        config.library.skipSelectionsGallery = true
        config.library.preselectedItems = []
        config.library.itemOverlayType = .none
        config.video.compression = AVAssetExportPresetHighestQuality
        config.video.fileType = .mp4

        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [weak self, weak picker] items, _ in
            for item in items {
                switch item {
                case .video(let video):
                    DispatchQueue.main.async {
                        picker?.dismiss(animated: true, completion: nil)
                    }
                    self?.delegate?.mediaPickerManager(self!, didPickVideo: video.url)
                    return
                default:
                    break
                }
            }
            DispatchQueue.main.async {
                picker?.dismiss(animated: true, completion: nil)
            }
        }
        DispatchQueue.main.async {
            viewController.present(picker, animated: true, completion: nil)
        }
    }
}
