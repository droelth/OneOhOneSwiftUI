//
//  AllCharactersView.swift
//  firebaseStorage
//
//  Created by Berkay Sutlu on 6.08.2023.
//

import SwiftUI

struct AllCharactersView: View {
    @StateObject var characterListViewModel = CharacterListViewModel()
    var body: some View {
        VStack{
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ], spacing: 20) {
                    ForEach(characterListViewModel.characters) { character in
                        NavigationLink(destination: CharacterDetail(character: character)) {
                            CharacterRow(character: character)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
            }
            .navigationBarTitle("Characters")
            .onAppear {
                characterListViewModel.fetchCharacters()
            }
        }
    }
}

struct AllCharactersView_Previews: PreviewProvider {
    static var previews: some View {
        AllCharactersView()
    }
}
