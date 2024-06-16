//
//  GameOverView.swift
//  Guess The Doodle
//
//  Created by salih kocatürk on 12.06.2024.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var MatchManager : MatchManager
    var body: some View {
        VStack
         {
             Spacer()
             Image("gameOver")
                 .resizable()
                 .scaledToFit()
                 .padding(.horizontal , 70)
                 .padding(.vertical)
             Text("score:  \(MatchManager.score)").font(.largeTitle).bold().foregroundColor(Color("primaryYellow"))
             
             Spacer()
             Button {
                 MatchManager.resetGame()
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
                    .fill(MatchManager.authenticationState != .authenticated || MatchManager.inGame ? Color.gray : Color.yellow)
             )
             Text(MatchManager.authenticationState.rawValue).font(.headline.weight(.semibold))
                 .foregroundColor(Color("primaryYellow"))
                 .padding()
             Spacer()
         }.background(Image("gameOverBg").resizable()
             .scaledToFit()
             .scaleEffect(1.2)
         ).ignoresSafeArea()
       
     }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(MatchManager: MatchManager())
    }
}
