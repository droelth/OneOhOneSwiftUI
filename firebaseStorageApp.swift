//
//  firebaseStorageApp.swift
//  firebaseStorage
//
//  Created by Berkay Sutlu on 6.08.2023.
//

import SwiftUI
import Firebase

@main
struct firebaseStorageApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            CharacterListView()
        }
    }
}
