//
//  VideoModel.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit
import CoreData

struct VideoModel {
    var id: UUID
    var path: String?
    var duration: Double
}

extension VideoModel {
    func toEntity(context: NSManagedObjectContext) -> Video {
        let entity = Video(context: context)
        entity.id = self.id
        entity.path = self.path
        entity.duration = self.duration
        return entity
    }
}

extension Video {
    func toModel() -> VideoModel {
        return VideoModel(
            id: self.id ?? UUID(),
            path: self.path,
            duration: self.duration,
        )
    }
}
