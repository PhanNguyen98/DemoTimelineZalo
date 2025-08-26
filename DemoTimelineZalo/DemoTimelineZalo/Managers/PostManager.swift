//
//  PostManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit

class PostManager {
    private let postRepo: PostRepository

    init(postRepo: PostRepository) {
        self.postRepo = postRepo
    }

    func createPost(content: String, images: [UIImage], video: URL?, user: UserProfileModel) -> PostModel? {
        let imageModels: [ImageModel] = images.compactMap {
            if let url = MediaFileManager.saveImageToDocuments(image: $0) {
                return ImageModel(id: UUID(), path: url.path)
            }
            return nil
        }

        var videoModel: VideoModel?
        if let video = video, let url = MediaFileManager.saveVideoToDocuments(videoURL: video){
            let duration = MediaFileManager.getVideoDuration(from: url)
            videoModel = VideoModel(id: UUID(), path: url.path, duration: duration)
        }

        let postModel = PostModel(
            id: UUID(),
            content: content,
            createdAt: Date(),
            author: user,
            images: imageModels,
            video: videoModel
        )
        return postRepo.addPost(postModel: postModel)
    }
    
    func deletePost(post: PostModel) -> Bool {
        // Remove images from disk
        for image in post.images ?? [] {
            MediaFileManager.deleteFile(at: URL(fileURLWithPath: image.path ?? ""))
        }
        
        // Remove video from disk if exists
        if let video = post.video {
            MediaFileManager.deleteFile(at: URL(fileURLWithPath: video.path ?? ""))
        }
        
        // Delete from repository
        return postRepo.deletePost(postModel: post)
    }
}
