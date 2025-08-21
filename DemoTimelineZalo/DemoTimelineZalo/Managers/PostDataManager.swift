//
//  PostDataManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import CoreData

class PostDataManager {
    static let shared = PostDataManager()
    private let context = CoreDataManager.shared.context
    
    private init() {}
    
    // MARK: - Add Post
    func addPost(content: String?, images: [Image]? = nil, videos: [Video]? = nil, author: UserProfile) -> Post? {
        let post = Post(context: context)
        post.id = UUID()
        post.content = content
        post.createdAt = Date()
        post.author = author
        
        if let imgs = images {
            post.images = NSSet(array: imgs)
        }
        
        if let vids = videos {
            post.videos = NSSet(array: vids)
        }
        
        CoreDataManager.shared.saveContext()
        return post
    }
    
    // MARK: - Fetch all Post
    func fetchAllPosts() -> [Post] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            return try context.fetch(request)
        } catch {
            print("❌ Fetch error: \(error)")
            return []
        }
    }
    
    // MARK: - Update Post
    func updatePost(post: Post, newContent: String?, newImages: [Image]?, newVideos: [Video]?) {
        post.content = newContent
        if let imgs = newImages {
            post.images = NSSet(array: imgs)
        }
        if let vids = newVideos {
            post.videos = NSSet(array: vids)
        }
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: - Delete Post
    func deletePost(post: Post) {
        context.delete(post)
        CoreDataManager.shared.saveContext()
    }
    
    // MARK: - Delete all Post
    func deleteAllPosts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Post.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            CoreDataManager.shared.saveContext()
        } catch {
            print("❌ Delete all error: \(error)")
        }
    }
}
