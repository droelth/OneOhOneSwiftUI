//
//  CharacterListViewModel.swift
//  firebaseStorage
//
//  Created by Berkay Sutlu on 6.08.2023.
//
import SwiftUI
import Firebase
import FirebaseStorage

class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character] = []

    func fetchCharacters() {
        let db = Firestore.firestore()
        db.collection("characters").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching characters: \(error.localizedDescription)")
            } else {
                var fetchedCharacters: [Character] = []
                for document in snapshot!.documents {
                    if let character = Character(document: document) {
                        fetchedCharacters.append(character)
                    }
                }
                self.characters = fetchedCharacters
            }
        }
    }
}
