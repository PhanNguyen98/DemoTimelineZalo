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

enum PostMedia: String {
    case image = "Ảnh"
    case video = "Video"
    
    var icon: UIImage? {
        switch self {
        case .image:
            return UIImage(systemName: "photo.fill")?.withTintColor(.color88CC87)
        case .video:
            return UIImage(systemName: "video.fill")?.withTintColor(.colorC741C0)
        }
    }
}
