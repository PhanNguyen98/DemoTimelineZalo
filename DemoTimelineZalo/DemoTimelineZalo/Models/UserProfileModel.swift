//
//  UserProfileModel.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit
import CoreData

struct UserProfileModel {
    var id: UUID
    var name: String
    var avatarURL: URL?
}

extension UserProfileModel {
    func toEntity(context: NSManagedObjectContext) -> UserProfile {
        let entity = UserProfile(context: context)
        entity.id = self.id
        entity.name = self.name
        entity.avatarURL = self.avatarURL
        return entity
    }
}

extension UserProfile {
    func toModel() -> UserProfileModel {
        return UserProfileModel(
            id: self.id ?? UUID(),
            name: self.name ?? "",
            avatarURL: self.avatarURL,
        )
    }
}
