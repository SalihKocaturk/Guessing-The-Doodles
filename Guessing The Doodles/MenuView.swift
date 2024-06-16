//
//  MenuView.swift
//  Guess The Doodle
//
//  Created by salih kocatürk on 12.06.2024.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var MatchManager: MatchManager
    var str = "PLAY"
    var body: some View {
       
       VStack
        {
            Spacer()
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding(30)
            Spacer()
            Button {
                MatchManager.startMatchMaking()
            } label: {
                Text("PLAY")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
            }
            .disabled(MatchManager.authenticationState != .authenticated || MatchManager.inGame)
            .padding(.vertical, 20)
            .padding(.horizontal, 100)
            .background(
                Capsule(style: .circular)
                    .fill(MatchManager.authenticationState != .authenticated || MatchManager.inGame ? Color.gray : Color("playBtn"))
            )
            Text(MatchManager.authenticationState.rawValue).font(.headline.weight(.semibold))
                .foregroundColor(Color("primaryYellow"))
                .padding()
            Spacer()
        }.background(Image("menuBg").resizable()
            .scaledToFit()
            .scaleEffect(1.2)
        ).ignoresSafeArea()
      
    }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(MatchManager: MatchManager())
    }
}
