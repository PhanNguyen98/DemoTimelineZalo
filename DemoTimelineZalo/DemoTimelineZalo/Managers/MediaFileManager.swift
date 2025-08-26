//
//  MediaFileManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit
import Kingfisher
import AVFoundation

struct MediaFileManager {
    
    // MARK: Save Video
    static func saveVideoToDocuments(videoURL: URL) -> URL? {
        let fileManager = FileManager.default
        do {
            let documentsDir = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let destinationURL = documentsDir.appendingPathComponent("post_video_\(Date().formattedString(format: "HH_mm_ss_SSS_yyyy_MM_dd")).mp4")
            
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.copyItem(at: videoURL, to: destinationURL)
            return destinationURL
        } catch {
            print("❌ Failed to save video to Documents: \(error)")
            return nil
        }
    }

    // MARK: Save Image
    static func saveImageToDocuments(image: UIImage) -> URL? {
        let fileManager = FileManager.default
        var url: URL?
        
        do {
            let documentsDir = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            if let data = image.jpegData(compressionQuality: 0.8) {
                let destinationURL = documentsDir.appendingPathComponent("post_image_\(Date().formattedString(format: "HH_mm_ss_SSS_yyyy_MM_dd")).jpg")
                try data.write(to: destinationURL)
                url = destinationURL
            }
        } catch {
            print("❌ Failed to save images to Documents: \(error)")
        }
        
        return url
    }
    
    // MARK: Delete File
    static func deleteFile(at url: URL?) {
        guard let url = url else { return }
        let fileManager = FileManager.default
        
        do {
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
                print("🗑️ Deleted file at: \(url.lastPathComponent)")
            }
        } catch {
            print("❌ Failed to delete file: \(error)")
        }
    }
    
    // MARK: Load Image
    @MainActor static func loadImage(from url: URL?, into imageView: UIImageView) {
        guard let url = url else { return }
        imageView.kf.indicatorType = .activity

        let provider = LocalFileImageDataProvider(fileURL: url)
        imageView.kf.setImage(with: provider, placeholder: nil, options: [.transition(.fade(0.2))]) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("⚠️ Failed to load image with Kingfisher: \(error)")
            }
        }
    }
    
    // MARK: Get Video Duration
    static func getVideoDuration(from url: URL) -> Double {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        return CMTimeGetSeconds(duration)
    }
    
    // MARK: Build URL from saved path
    static func urlFromPath(_ path: String) -> URL {
        let fileName = (path as NSString).lastPathComponent
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documents.appendingPathComponent(fileName)
    }
}
