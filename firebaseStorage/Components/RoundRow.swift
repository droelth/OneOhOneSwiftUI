//
//  RoundRow.swift
//  firebaseStorage
//
//  Created by Berkay Sutlu on 7.08.2023.
//

import SwiftUI

struct RoundRow: View {
    var roundNumber: Int
    @Binding var teamAPenaltyPoints: Int
    @Binding var teamBPenaltyPoints: Int
    
    var body: some View {
        VStack {
            Text("Round \(roundNumber)").bold()
            
            HStack {
                TextField("Team A", value: $teamAPenaltyPoints, formatter: NumberFormatter())
                    .frame(width: 75)
                    .padding(5)
                    .background(Color.blue.opacity(0.4))
                    .cornerRadius(5)
                
                Spacer()
                
                TextField("Team B", value: $teamBPenaltyPoints, formatter: NumberFormatter())
                    .frame(width: 75)
                    .padding(5)
                    .background(Color.blue.opacity(0.4))
                    .cornerRadius(5)
            }
        }
    }
}

