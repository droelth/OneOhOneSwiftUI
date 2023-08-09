//
//  CharacterViewModel.swift
//  firebaseStorage
//
//  Created by Berkay Sutlu on 6.08.2023.
//

import Firebase
import SwiftUI
import FirebaseStorage

class CharacterViewModel: ObservableObject {
    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("characters/\(UUID().uuidString).jpg")
        let imageData = image.jpegData(compressionQuality: 0.8)!

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        imageRef.putData(imageData, metadata: metadata) { (_, error) in
            if let error = error {
                completion(.failure(error))  // Unwrap 'error' here
            } else {
                imageRef.downloadURL { (url, error) in
                    if let imageURL = url?.absoluteString {
                        completion(.success(imageURL))
                    } else {
                        completion(.failure(error!))  // Unwrap 'error' here
                    }
                }
            }
        }
    }
    
    func deleteCharacter(character: Character, completion: @escaping (Error?) -> Void) {
            let db = Firestore.firestore()
            let characterRef = db.collection("characters").document(character.id)

            characterRef.delete { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    
    func updateCharacterWinLossCounts(character: Character, completion: @escaping (Error?) -> Void) {
            let db = Firestore.firestore()
            let characterRef = db.collection("characters").document(character.id)

            let updatedData: [String: Any] = [
                "winCount": character.winCount,
                "loseCount": character.loseCount
            ]

            characterRef.updateData(updatedData) { error in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }

    func saveCharacterToFirestore(name: String, description: String, imageURL: String, winCount: Int, loseCount: Int , completion: @escaping (Error?) -> Void) {
        let characterData: [String: Any] = [
            "name": name,
            "description": description,
            "imageURL": imageURL,
            "winCount": winCount,
            "loseCount": loseCount
        ]

        let db = Firestore.firestore()
        db.collection("characters").addDocument(data: characterData) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
