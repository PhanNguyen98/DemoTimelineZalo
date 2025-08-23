//
//  MediaPickerManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 23/8/25.
//

import UIKit
import PhotosUI

protocol MediaPickerManagerDelegate: AnyObject {
    func mediaPickerManager(_ manager: MediaPickerManager, didPickImages images: [UIImage])
    func mediaPickerManager(_ manager: MediaPickerManager, didPickVideo url: URL)
}

class MediaPickerManager: NSObject, PHPickerViewControllerDelegate {
    weak var delegate: MediaPickerManagerDelegate?

    // Present image picker allowing multiple images
    func presentImagePicker(from viewController: UIViewController) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0 // 0 means no limit
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }

    // Present video picker allowing one video
    func presentVideoPicker(from viewController: UIViewController) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }

    // MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        // Separate images and videos
        let imageResults = results.filter { $0.itemProvider.canLoadObject(ofClass: UIImage.self) }
        let videoResults = results.filter { $0.itemProvider.hasItemConformingToTypeIdentifier("public.movie") }

        // Handle images
        if !imageResults.isEmpty {
            var images: [UIImage] = []
            let dispatchGroup = DispatchGroup()
            for result in imageResults {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                        images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) { [weak self] in
                if !images.isEmpty {
                    self?.delegate?.mediaPickerManager(self!, didPickImages: images)
                }
            }
        }

        // Handle video (pick first video only)
        if let videoResult = videoResults.first {
            videoResult.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                guard let url = url else { return }
                // Copy to temp location to persist after picker is dismissed
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                try? FileManager.default.removeItem(at: tempURL)
                do {
                    try FileManager.default.copyItem(at: url, to: tempURL)
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.mediaPickerManager(self!, didPickVideo: tempURL)
                    }
                } catch {
                    // Failed to copy, do not call closure
                }
            }
        }
    }
}
