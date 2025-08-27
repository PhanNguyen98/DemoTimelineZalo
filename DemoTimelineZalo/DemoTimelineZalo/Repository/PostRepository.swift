//
//  PostRepository.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 21/8/25.
//

import CoreData

class PostRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    // MARK: - Add Post
    func addPost(postModel: PostModel) -> PostModel? {
        let post = postModel.toEntity(context: context)
        saveContext()
        return post.toModel()
    }
    
    // MARK: - Fetch all Post
    func fetchAllPosts() -> [PostModel] {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            let posts = try context.fetch(request)
            return posts.map { $0.toModel() }
        } catch {
            print("❌ Fetch error: \(error)")
            return []
        }
    }
    
    // MARK: - Get Post
    func getPost(postModel: PostModel) -> PostModel? {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", postModel.id as CVarArg)
        do {
            if let post = try context.fetch(request).first {
                return post.toModel()
            }
        } catch {
            print("❌ Get post error: \(error)")
            return nil
        }
        return nil
    }
    
    // MARK: - Update Post
    func updatePost(postModel: PostModel) -> Bool {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", postModel.id as CVarArg)
        do {
            if let post = try context.fetch(request).first {
                post.content = postModel.content
                post.video = postModel.video?.toEntity(context: context)
                if let images = postModel.images?.map({ $0.toEntity(context: context) }) {
                    post.images = NSSet(array: images)
                }
                saveContext()
                return true
            }
        } catch {
            print("❌ Update error: \(error)")
            return false
        }
        return false
    }
    
    // MARK: - Delete Post
    func deletePost(postModel: PostModel) -> Bool {
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", postModel.id as CVarArg)
        do {
            if let post = try context.fetch(request).first {
                context.delete(post)
                saveContext()
                return true
            }
        } catch {
            print("❌ Delete error: \(error)")
            return false
        }
        return false
    }
    
    // MARK: - Delete all Post
    func deleteAllPosts() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Post.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("❌ Delete all error: \(error)")
        }
    }
    
    private func saveContext() {
        try? context.save()
    }
}
