

import SwiftUI

struct CharacterListView: View {
    @State private var teamAPlayers: [Character] = []
    @State private var teamBPlayers: [Character] = []
    @State private var currentPlayerTeam = 1 // 1 for Team A, 2 for Team B
    @State private var selectedPlayer: Character?
    @StateObject private var characterListViewModel = CharacterListViewModel()
    @State private var selectedCharacters: [Character] = [] // Keep track of selected characters
    @State var turnCount = 1
    @State var team1name = ""
    @State var team2name = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack{
                        Text("Choose Team Names").padding(10).font(.title).fontWeight(.heavy)
                        HStack{
                            TextField("Team 1", text: $team1name).padding(10).background(.blue.opacity(0.4)).autocorrectionDisabled().cornerRadius(30)
                            TextField("Team 2", text: $team2name).padding(10).background(.yellow.opacity(0.4)).autocorrectionDisabled().cornerRadius(30)
                        }.padding(10)
                        
                    }
                    Divider()
                    HStack {
                        NavigationLink {
                            AllCharactersView()
                        } label: {
                            Text("Characters").font(.title).fontWeight(.medium)
                        }
                        Spacer()
                        NavigationLink {
                            AddCharacterView()
                        } label: {
                            Text("Add Character")
                        }
                    }.padding(10)
                    
                    ScrollView(.horizontal) {
                        
                        LazyHStack(spacing: 20) {
                            ForEach(characterListViewModel.characters) { character in
                                Button(action: {
                                    if !selectedCharacters.contains(where: { $0.id == character.id }) {
                                        addCharacterToTeam(character)
                                        selectedCharacters.append(character)
                                    }
                                }) {
                                    CharacterRow(character: character)
                                }
                            }
                        }
                    } // CHARACTERS SLIDER
                    .padding(.horizontal,10)
                    .onAppear {
                        characterListViewModel.fetchCharacters()
                    }
                    
                    VStack {
                        Text("Selected Players:")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            VStack {
                                Text(team1name.isEmpty == true ? "Team A:" : team1name )
                                    .font(.headline)
                                ForEach(teamAPlayers) { player in
                                    Text(player.name)
                                        .font(.body)
                                }
                            }
                            Spacer()
                            VStack {
                                Text(team2name.isEmpty == true ? "Team B:" : team2name )
                                    .font(.headline)
                                ForEach(teamBPlayers) { player in
                                    Text(player.name)
                                        .font(.body)
                                }
                            }
                        }
                        if (teamAPlayers.isEmpty != true ||  teamBPlayers.isEmpty != true){
                            Button {
                                selectedCharacters.removeAll()
                                teamAPlayers.removeAll()
                                teamBPlayers.removeAll()
                            } label: {
                                Text("Clear Teams").foregroundColor(.red)
                            }
                        }
                        
                    }.padding(10) // SELECTED PLAYERS / SHOW TEAMS
                    Divider()
                    HStack {
                        Text("Choose Turn Count : ")
                        Spacer()
                        Picker("Select a Number", selection: $turnCount) {
                                        ForEach(1...11, id: \.self) { number in
                                            Text("\(number)")
                                        }
                                    }
                        .pickerStyle(.automatic)
                    }.padding(10)
                    
                    NavigationLink {
                        GameView(turnCount: turnCount, team1name: team1name, team2name: team2name, teamAPlayers: $teamAPlayers,teamBPlayers: $teamBPlayers)
                    } label: {
                        Text("Begin Playing!")
                    }

                    Spacer()
                }
            }
        }
    }
    private func addCharacterToTeam(_ character: Character) {
        if selectedCharacters.firstIndex(where: { $0.id == character.id }) != nil {
                return // Character already selected, do nothing
            }
        if currentPlayerTeam == 1 {
            if teamAPlayers.count < 2 {
                teamAPlayers.append(character)
                currentPlayerTeam = 2
            } else if teamBPlayers.count < 2 {
                teamBPlayers.append(character)
                currentPlayerTeam = 1
            }
        } else if currentPlayerTeam == 2 {
            if teamBPlayers.count < 2 {
                teamBPlayers.append(character)
                currentPlayerTeam = 1
            } else if teamAPlayers.count < 2 {
                teamAPlayers.append(character)
                currentPlayerTeam = 2
            }
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView()
    }
}



