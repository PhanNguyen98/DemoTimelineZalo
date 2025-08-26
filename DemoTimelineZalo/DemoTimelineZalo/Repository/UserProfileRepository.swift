//
//  UserProfileRepository.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import Foundation
import CoreData

class UserProfileRepository {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    func addUserProfile(userModel: UserProfileModel) -> UserProfileModel? {
        let entity = userModel.toEntity(context: context)
        saveContext()
        return entity.toModel()
    }

    func getUser(by id: UUID) -> UserProfileModel? {
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            if let entity = try context.fetch(fetchRequest).first {
                return entity.toModel()
            } else {
                return nil
            }
        } catch {
            print("Failed to fetch user by id: \(error)")
            return nil
        }
    }

    func fetchAllUsers() -> [UserProfileModel] {
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { $0.toModel() }
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }

    func updateUserProfile(userModel: UserProfileModel) {
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", userModel.id as CVarArg)
        do {
            if let entity = try context.fetch(fetchRequest).first {
                entity.name = userModel.name
                entity.avatarURL = userModel.avatarURL
                saveContext()
            }
        } catch {
            print("Failed to update user: \(error)")
        }
    }

    func deleteUserProfile(userModel: UserProfileModel) {
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", userModel.id as CVarArg)
        do {
            if let entity = try context.fetch(fetchRequest).first {
                context.delete(entity)
                saveContext()
            }
        } catch {
            print("Failed to delete user: \(error)")
        }
    }

    func deleteAllUsers() {
        let fetchRequest: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            for entity in entities {
                context.delete(entity)
            }
            saveContext()
        } catch {
            print("Failed to delete all users: \(error)")
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
