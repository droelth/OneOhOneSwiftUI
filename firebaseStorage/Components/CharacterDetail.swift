//
//  CharacterDetail.swift
//  firebaseStorage
//
//  Created by Berkay Sutlu on 6.08.2023.
//

import SwiftUI

struct CharacterDetail: View {
    @StateObject var characterViewModel = CharacterViewModel()
    var character: Character
    @State var winRate : Double = 0.0
    @State private var showingDeleteAlert = false
    @Environment(\.presentationMode) var presentationMode


    var body: some View {
        VStack {
            AsyncImage(url: URL(string: character.imageURL)) { image in
                image
                    .resizable()
                    .frame(width: 300, height: 300)
                    .padding()
                    .cornerRadius(50)
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            
                Text(character.name)
                    .font(.title).bold()
                
                Text(character.description)
                    .font(.body)
                    .padding()
            VStack{
                Text("Wins: \(character.winCount)")
                    .font(.subheadline)
                Text("Loses: \(character.loseCount)")
                    .font(.subheadline)
                Text("Win Rate is  :  \(winRate.formatted(.number))")
                    .font(.subheadline)
            }.padding(30).border(.black,width: 2)
            
            Button("Delete Character", action: {
                            showingDeleteAlert = true
                        })
                        .foregroundColor(.red)
                        .alert(isPresented: $showingDeleteAlert) {
                            Alert(
                                title: Text("Delete Character"),
                                message: Text("Are you sure you want to delete this character?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteCharacter()
                                },
                                secondaryButton: .cancel()
                            )
                        }
            
            Spacer()
        }.onAppear{
            calcWR()
        }
        .navigationBarTitle(character.name)
    }
    private func deleteCharacter() {
           characterViewModel.deleteCharacter(character: character) { error in
               if let error = error {
                   print("Error deleting character: \(error.localizedDescription)")
               } else {
                   // Character deleted, navigate back
                   presentationMode.wrappedValue.dismiss()
               }
           }
       }
    func calcWR() {
        if character.winCount > 0 && character.loseCount > 0 {
            let allGames = Double(character.winCount + character.loseCount)
            winRate = Double(character.winCount) / allGames
        } else {
            winRate = 0.0
        }
    }
}

