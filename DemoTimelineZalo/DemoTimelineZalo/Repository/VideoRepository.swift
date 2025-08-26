//
//  VideoRepository.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import Foundation
import UIKit
import CoreData

class VideoRepository {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    func saveContext() {
        let context = self.context
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    func addVideo(videoModel: VideoModel) -> VideoModel? {
        let context = self.context
        let video = videoModel.toEntity(context: context)
        saveContext()
        return video.toModel()
    }

    func fetchAllVideos() -> [VideoModel] {
        let context = self.context
        let fetchRequest: NSFetchRequest<Video> = Video.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { $0.toModel() }
        } catch {
            print("Failed to fetch videos: \(error)")
            return []
        }
    }

    func updateVideo(videoModel: VideoModel) {
        let _ = videoModel.toEntity(context: context)
        saveContext()
    }

    func deleteVideo(videoModel: VideoModel) {
        let context = self.context
        let fetchRequest: NSFetchRequest<Video> = Video.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", videoModel.id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            if let video = results.first {
                context.delete(video)
                saveContext()
            }
        } catch {
            print("Failed to delete video: \(error)")
        }
    }

    func deleteAllVideos() {
        let context = self.context
        let fetchRequest: NSFetchRequest<Video> = Video.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            for video in results {
                context.delete(video)
            }
            saveContext()
        } catch {
            print("Failed to delete all videos: \(error)")
        }
    }
}
