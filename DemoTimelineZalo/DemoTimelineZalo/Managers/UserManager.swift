//
//  UserManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import Foundation

final class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    // Currently logged-in user
    private(set) var currentUser: UserProfileModel?
    
    private let userProfileRepo = UserProfileRepository()
    
    // MARK: - Load from UserDefaults and handle first launch
    func loadUser() {
        if let idString = UserDefaultsManager.shared.userId,
           let name = UserDefaultsManager.shared.name,
           let id = UUID(uuidString: idString) {
            // Not first launch, fetch user from repository
            
            if let existingUser = userProfileRepo.getUser(by: id) {
                currentUser = existingUser
            } else {
                // User not found in repository, create new user and save
                let newUser = UserProfileModel(id: id, name: name, avatarURL: nil)
                currentUser = userProfileRepo.addUserProfile(userModel: newUser)
            }
        } else {
            // First launch, create new user and save
            let newUser = UserProfileModel(id: UUID(), name: "Phan Nguyen", avatarURL: nil)
            UserDefaultsManager.shared.userId = newUser.id.uuidString
            UserDefaultsManager.shared.name = newUser.name
            currentUser = userProfileRepo.addUserProfile(userModel: newUser)
        }
    }
    
    // Public function to get the current user
    public func getCurrentUser() -> UserProfileModel? {
        return currentUser
    }
    
    // MARK: - Check login status
    var isLoggedIn: Bool {
        return currentUser != nil
    }
}
