
import SwiftUI

struct GameView: View {
    @StateObject var characterViewModel = CharacterViewModel()
    
    @State var turnCount: Int // How many rounds will game last
    @State var team1name: String // Team 1's Name
    @State var team2name: String // Team 2's Name
    @Binding var teamAPlayers: [Character] // Team A Players
    @Binding var teamBPlayers: [Character] // Team B Players
    
    @State private var showAlert = false

    @State var alertMessage = ""
    @State var winner1 = ""
    @State var winner2 = ""
    @State var winnerTie = "It s a tie!"
    
    @State private var teamAPenaltyPoints = Array(repeating: 0, count: 15)
    @State private var teamBPenaltyPoints = Array(repeating: 0, count: 15)
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Scoreboard").font(.title).fontWeight(.bold)
                HStack{
                    VStack{
                        Text(team1name).fontWeight(.medium).font(.title2)
                        ForEach(teamAPlayers) { player in
                            Text(player.name).font(.caption)
                        }
                    }
                    Text("\(teamAPenaltyPoints.reduce(0, +))").padding(.horizontal,20).font(.title3)
                    Spacer()
                    Text("\(teamBPenaltyPoints.reduce(0, +))").padding(.horizontal,20).font(.title3)
                    VStack{
                        Text(team2name).fontWeight(.medium).font(.title2)
                        ForEach(teamBPlayers) { player in
                            Text(player.name).font(.caption)
                        }
                    }
                    
                }.onAppear{
                    winner1 = "\(team1name) Wins"
                    winner2 = "\(team2name) Wins"
                }
                Text("The Deficit is : \(teamAPenaltyPoints.reduce(0, +) - teamBPenaltyPoints.reduce(0, +))").font(.callout)
                Divider()
                ForEach(0..<turnCount, id: \.self) { roundIndex in
                    RoundRow(
                        roundNumber: roundIndex + 1,
                        teamAPenaltyPoints: $teamAPenaltyPoints[roundIndex],
                        teamBPenaltyPoints: $teamBPenaltyPoints[roundIndex]
                    )
                    .padding(.vertical, 5)
                }
                Divider()
                Button {
                    finishRounds()
                    showAlert = true
                } label: {
                    Text("Finish the Game").font(.title3).fontWeight(.medium).foregroundColor(.white).padding(10).background(.blue).cornerRadius(50)
                }.alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Winner is"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }

            }.padding(10)
        }
    }
    
    private func finishRounds() {
        let teamATotalPenaltyPoints = teamAPenaltyPoints.reduce(0, +)
        let teamBTotalPenaltyPoints = teamBPenaltyPoints.reduce(0, +)
        
        var winningTeam: [Character]
        var losingTeam: [Character]
        
        if teamATotalPenaltyPoints < teamBTotalPenaltyPoints {
            winningTeam = teamAPlayers
            losingTeam = teamBPlayers
            print(winningTeam)
        } else if teamATotalPenaltyPoints > teamBTotalPenaltyPoints {
            winningTeam = teamBPlayers
            losingTeam = teamAPlayers
            print(winningTeam)
        } else {
            return // It's a tie, no updates needed
        }
        
        // Update winCount for characters in the winning team
        for index in winningTeam.indices {
            if let winningIndexA = teamAPlayers.firstIndex(of: winningTeam[index]) {
                teamAPlayers[winningIndexA].winCount += 1
            }
            if let winningIndexB = teamBPlayers.firstIndex(of: winningTeam[index]) {
                teamBPlayers[winningIndexB].winCount += 1
            }
        }

        // Update loseCount for characters in the losing team
        for index in losingTeam.indices {
            if let losingIndexA = teamAPlayers.firstIndex(of: losingTeam[index]) {
                teamAPlayers[losingIndexA].loseCount += 1
            }
            if let losingIndexB = teamBPlayers.firstIndex(of: losingTeam[index]) {
                teamBPlayers[losingIndexB].loseCount += 1
            }
        }

        // Update the characters in Firestore using CharacterViewModel
        for character in teamAPlayers + teamBPlayers {
            characterViewModel.updateCharacterWinLossCounts(character: character) { error in
                if let error = error {
                    print("Error updating character: \(error.localizedDescription)")
                }
            }
        }
        
        alertMessage = "\(winningTeam[0].name) & \(winningTeam[1].name)"
    }


    
}
