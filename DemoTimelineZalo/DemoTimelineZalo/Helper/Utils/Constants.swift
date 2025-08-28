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

enum ReactionType: Int, CaseIterable {
    case like = 0
    case love
    case haha
    case wow
    case sad
    case angry
    
    var title: String {
        switch self {
        case .like: return "Thích"
        case .love: return "Yêu"
        case .haha: return "Haha"
        case .wow: return "Wow"
        case .sad: return "Huhu"
        case .angry: return "Giận"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .like: return .heartSelected
        case .love: return .emoji
        case .haha: return .laughing
        case .wow: return .surprised
        case .sad: return .crying
        case .angry: return .angry
        }
    }
    
    var color: UIColor {
        switch self {
        case .like, .angry:
            return .color7B4140
        case .haha, .wow, .sad, .love:
            return .colorD3AF34
        }
    }
    
    var iconDefault: UIImage? {
        return .heart
    }
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

enum ScreenSize {
    static let width  = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let bounds = UIScreen.main.bounds
}

enum CreatePostEntryMode {
    case normal
    case imagePicker
    case videoPicker
}

enum OptionType: Int, CaseIterable {
    case deletePost = 0
    case editPost
    
    var icon: UIImage? {
        switch self {
        case .deletePost:
            return UIImage(systemName: "trash")?.withTintColor(.colorACAFB2, renderingMode: .alwaysOriginal)
        case .editPost:
            return UIImage(systemName: "pencil.line")?.withTintColor(.colorACAFB2, renderingMode: .alwaysOriginal)
        }
    }
    
    var title: String {
        switch self {
        case .deletePost:
            return "Xóa bài đăng"
        case .editPost:
            return "Chỉnh sửa bài đăng"
        }
    }
    
    var subTitle: String? {
        switch self {
        case .deletePost:
            return "Bài đăng này sẽ ẩn khỏi nhật ký"
        case .editPost:
            return "Bao gồm nội dung, ảnh, video, ..."
        }
    }
}
