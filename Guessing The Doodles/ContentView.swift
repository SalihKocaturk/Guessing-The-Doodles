//
//  ContentView.swift
//  Guessing The Doodles
//
//  Created by salih kocatürk on 17.06.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var matchManager =  MatchManager()
    var body: some View {
        ZStack{
            if matchManager.isGameOver{
                GameOverView(MatchManager: matchManager)
            }else if matchManager.inGame{
                GameView(MatchManager: matchManager)
            }else{
                MenuView(MatchManager: matchManager)
            }
        }.onAppear{
            matchManager.authenticateUser()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
