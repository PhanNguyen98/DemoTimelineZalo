//
//  ReactionModel.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 28/8/25.
//

import UIKit
import CoreData

struct ReactionModel {
    var id: UUID
    var type: ReactionType
    var createAt: Date
}

extension ReactionModel {
    func toEntity(context: NSManagedObjectContext) -> Reaction {
        let entity = Reaction(context: context)
        entity.id = self.id
        entity.type = Int16(self.type.rawValue)
        entity.createAt = self.createAt
        return entity
    }
}

extension Reaction {
    func toModel() -> ReactionModel {
        return ReactionModel(
            id: self.id ?? UUID(),
            type: ReactionType(rawValue: Int(self.type)) ?? .like,
            createAt: self.createAt ?? Date()
        )
    }
}


