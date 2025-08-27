//
//  ImageModel.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit
import CoreData

struct ImageModel {
    var id: UUID
    var path: String?
}

extension ImageModel {
    func toEntity(context: NSManagedObjectContext) -> Image {
        let entity = Image(context: context)
        entity.id = self.id
        entity.path = self.path
        return entity
    }

    func toUIImage() -> UIImage? {
        guard let path = self.path else { return nil }
        let url = MediaFileManager.urlFromPath(path)
        return UIImage(contentsOfFile: url.path)
    }
}

extension Image {
    func toModel() -> ImageModel {
        return ImageModel(
            id: self.id ?? UUID(),
            path: self.path,
        )
    }
}
