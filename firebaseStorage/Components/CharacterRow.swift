//
//  CharacterRow.swift
//  firebaseStorage
//
//  Created by Berkay Sutlu on 6.08.2023.
//

import SwiftUI

struct CharacterRow: View {
    var character: Character

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: character.imageURL)) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                Text(character.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
