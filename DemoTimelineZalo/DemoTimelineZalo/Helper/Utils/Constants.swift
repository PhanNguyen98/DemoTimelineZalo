//
//  Constants.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import UIKit

enum StoryboardName: String {
    case postList = "PostList"
    case createPost = "CreatePost"
    case postDetail = "PostDetail"
    case postSearch = "PostSearch"
}

enum PostMedia: Int, CaseIterable {
    case image = 0
    case video
    
    var title: String {
        switch self {
        case .image:
            return "Ảnh"
        case .video:
            return "Video"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .image:
            return UIImage(systemName: "photo.fill")?.withTintColor(.color88CC87, renderingMode: .alwaysOriginal)
        case .video:
            return UIImage(systemName: "video.fill")?.withTintColor(.colorC741C0, renderingMode: .alwaysOriginal)
        }
    }
}

enum PostListSection: Int, CaseIterable {
    case createPost = 0
    case postList
}
