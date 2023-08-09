//
//  Character.swift
//  firebaseStorage
//
//  Created by Berkay Sutlu on 6.08.2023.
//
import FirebaseFirestore
import SwiftUI

struct Character: Identifiable, Equatable {
    var id: String
    var name: String
    var description: String
    var imageURL: String
    var winCount: Int
    var loseCount: Int

    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let name = data["name"] as? String,
              let description = data["description"] as? String,
              let imageURL = data["imageURL"] as? String,
              let winCount = data["winCount"] as? Int,
              let loseCount = data["loseCount"] as? Int
        else {
            return nil
        }
        self.id = document.documentID
        self.name = name
        self.description = description
        self.imageURL = imageURL
        self.winCount = winCount
        self.loseCount = loseCount
    }
}
