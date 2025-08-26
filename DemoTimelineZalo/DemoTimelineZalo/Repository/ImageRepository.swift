//
//  ImageRepository.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import CoreData

class ImageRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    // MARK: - Add Image
    func addImage(imageModel: ImageModel) -> ImageModel? {
        let image = imageModel.toEntity(context: context)
        saveContext()
        return image.toModel()
    }
    
    // MARK: - Fetch all Image
    func fetchAllImages() -> [ImageModel] {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        do {
            let images = try context.fetch(request)
            return images.map { $0.toModel() }
        } catch {
            print("❌ Fetch error: \(error)")
            return []
        }
    }
    
    // MARK: - Update Image
    func updateImage(imageModel: ImageModel) {
        let _ = imageModel.toEntity(context: context)
        saveContext()
    }
    
    // MARK: - Delete Image
    func deleteImage(imageModel: ImageModel) {
        let request: NSFetchRequest<Image> = Image.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", imageModel.id as CVarArg)
        do {
            if let image = try context.fetch(request).first {
                context.delete(image)
                saveContext()
            }
        } catch {
            print("❌ Delete error: \(error)")
        }
    }
    
    // MARK: - Delete all Image
    func deleteAllImages() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Image.fetchRequest()
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

