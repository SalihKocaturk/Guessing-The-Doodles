//
//  GameView.swift
//  Guess The Doodle
//
//  Created by salih kocatürk on 13.06.2024.
//

import SwiftUI
import PencilKit
var countDownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
struct GameView: View {
    @ObservedObject var MatchManager: MatchManager
    @State var drawingGuess = ""
    @State var eraserEnabled = false
    func makeGuess(){
        guard drawingGuess != "" else{return}
        MatchManager.sendString("guess: \(drawingGuess)")
        drawingGuess = ""
    }
    var body: some View {
        ZStack {
            GeometryReader{_ in
                Image(MatchManager.currentlyDrawing ? "drawerBg": "guesserBg").resizable().ignoresSafeArea().scaledToFill()
                    .scaleEffect(1.2)
                VStack{
                    topBar
                    
                    ZStack{
                        DrawingView(matchManager: MatchManager, eraserEnabled:$eraserEnabled)
                            .aspectRatio(1, contentMode: .fit)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 10 ))
                        
                      
                        
                        VStack{
                            
                            HStack{
                                Spacer()
                                
                                if MatchManager.currentlyDrawing {
                                    Button{
                                        eraserEnabled.toggle()
                                    } label: {
                                        Image(systemName: eraserEnabled ? "eraser.fill": "eraser")
                                            .font(.title)
                                            .foregroundColor(.purple)
                                            .padding(.top, 10)
                                    }
                                    
                                }
                            }
                            Spacer()
                            
                        }
                        .padding()
                    }
                    
                    pastGuesses
                }
                .padding(.horizontal, 30)
                .ignoresSafeArea(.keyboard, edges: .bottom )
            }
            VStack{
                Spacer()
                promptGroup
            }.ignoresSafeArea(.container)
        }
        .onReceive(countDownTimer) { _ in
            guard MatchManager.isTimeKeeper else {return}
            MatchManager.remainingTime -= 1
        }
    }
    var topBar: some View {
        ZStack(){
            HStack(spacing: 0.0){
                Button{
                    MatchManager.match?.disconnect()
                    MatchManager.resetGame()
                    
                }label: {
                    Image(systemName: "arrowshape.turn.up.left.circle.fill")
                        .font(.largeTitle)
                        .tint(Color(MatchManager.currentlyDrawing ? "primaryYellow": "primaryPurple"))
                    
                }
                Spacer()
                Label("\(MatchManager.remainingTime)", systemImage: "clock.fill").bold().font(.title2)
                
            }
            Text("Score: \(MatchManager.score)")
                .bold()
                .font(.title)
                .foregroundColor(Color(MatchManager.currentlyDrawing ? "primaryYellow": "primaryPurple"))
        }
        
    }
    var pastGuesses: some View {
        ScrollView{
            ForEach(MatchManager.pastGuesses){ guess in
                HStack{
                    Text(guess.message)
                        .font(.title2)
                        .bold(guess.correct)
                    if guess.correct {
                        Image(systemName: "hand.thumbsup.fill")
                            .foregroundColor(MatchManager.currentlyDrawing ? Color(red: 0.808, green: 0.345, blue: 0.776): Color(red: 0.243, green: 0.773, blue: 0.745) )
                    }
                }.frame(maxWidth: .infinity)
                    .padding(.bottom, 1 )
                
            }
            
        }.padding()
            .frame(maxWidth: .infinity)
            .background(
                (MatchManager.currentlyDrawing ? Color(red: 0.243, green: 0.773, blue: 0.745): Color("primaryYellow")
                )
            .brightness(-0.2)
            .opacity(0.5)
                )
            .cornerRadius(20)
            .padding(.vertical)
            .padding(.bottom, 130)
        
    }
    var promptGroup: some View {
        VStack{
            if MatchManager.currentlyDrawing{
                Label("DRAW:",systemImage: "exclamationmark.bubble.fill").font(.title2).bold().foregroundColor(.white)
                Text(MatchManager.drawPrompt.uppercased())
                    .font(.largeTitle)
                    .bold().padding().foregroundColor(.white)
            }else{
                HStack{
                    Label("GUESS THE DRAWING:",systemImage: "exclamationmark.bubble.fill").font(.title2).bold().foregroundColor(Color("primaryPurple"))
                    Spacer()
                }
                HStack {
                    TextField("Type your guess", text: $drawingGuess)
                        .padding()
                        .background(
                            Capsule(style: .circular).fill(.white)
                        )
                        .onSubmit(makeGuess)
                            
                       
                    Button {
                        makeGuess()
                    } label: {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.purple)
                }
                }

            }
        }
        .frame(maxWidth: .infinity)
        .padding([.bottom,.horizontal], 30)
        .padding(.vertical)
        .background(
            (MatchManager.currentlyDrawing ? Color(red: 0.243, green: 0.773, blue: 0.745):Color("primaryYellow")
            
            ).opacity(0.5).brightness(-0.2)
     )
    }
    
    
}
    
    struct GameView_Previews: PreviewProvider {
        static var previews: some View {
            GameView(MatchManager: MatchManager())
        }
    }

