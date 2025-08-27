//
//  PostManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit

class PostManager {
    private let postRepo: PostRepository

    init(postRepo: PostRepository = PostRepository()) {
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

    func updatePost(postEdit: PostModel, content: String, dataImages: [UIImage], video: URL?) -> Bool {
        let imageModels: [ImageModel] = dataImages.compactMap {
            if let url = MediaFileManager.saveImageToDocuments(image: $0) {
                return ImageModel(id: UUID(), path: url.path)
            }
            return nil
        }

        var videoModel: VideoModel?
        if let video = video, let url = MediaFileManager.saveVideoToDocuments(videoURL: video) {
            let duration = MediaFileManager.getVideoDuration(from: url)
            videoModel = VideoModel(id: UUID(), path: url.path, duration: duration)
        }

        var updatedPost = postEdit

        if let oldImages = updatedPost.images {
            for image in oldImages {
                MediaFileManager.deleteFile(at: MediaFileManager.urlFromPath(image.path ?? ""))
            }
        }

        if let oldVideo = updatedPost.video {
            MediaFileManager.deleteFile(at: MediaFileManager.urlFromPath(oldVideo.path ?? ""))
        }

        updatedPost.content = content
        updatedPost.images = imageModels
        updatedPost.video = videoModel

        return postRepo.updatePost(postModel: updatedPost)
    }
    
    func deletePost(post: PostModel) -> Bool {
        // Remove images from disk
        for image in post.images ?? [] {
            MediaFileManager.deleteFile(at: MediaFileManager.urlFromPath(image.path ?? ""))
        }
        
        // Remove video from disk if exists
        if let video = post.video {
            MediaFileManager.deleteFile(at: MediaFileManager.urlFromPath(video.path ?? ""))
        }
        
        // Delete from repository
        return postRepo.deletePost(postModel: post)
    }
    
    func getPost(post: PostModel) -> PostModel? {
        return postRepo.getPost(postModel: post)
    }
    
}
