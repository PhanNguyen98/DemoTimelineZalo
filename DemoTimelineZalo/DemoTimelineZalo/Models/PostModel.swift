//
//  PostModel.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit
import CoreData

struct PostModel {
    var id: UUID
    var content: String
    var createdAt: Date
    var author: UserProfileModel
    var images: [ImageModel]?
    var video: VideoModel?
}

extension PostModel {
    func toEntity(context: NSManagedObjectContext) -> Post {
        let entity = Post(context: context)
        entity.id = self.id
        entity.content = self.content
        entity.createdAt = self.createdAt
        entity.author = self.author.toEntity(context: context)
        
        if let images = self.images?.map({ $0.toEntity(context: context) }) {
            entity.images = NSSet(array: images)
        }
        
        entity.video = self.video?.toEntity(context: context)
        return entity
    }
    
}

extension Post {
    func toModel() -> PostModel {
        return PostModel(
            id: self.id ?? UUID(),
            content: self.content ?? "",
            createdAt: self.createdAt ?? Date(),
            author: self.author?.toModel() ?? UserProfileModel(id: UUID(), name: ""),
            images: (self.images as? Set<Image>)?.map { $0.toModel() },
            video: self.video?.toModel()
        )
    }
}
