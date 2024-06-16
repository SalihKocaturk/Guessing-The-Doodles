//
//  MatchManager.swift
//  Guess The Doodle
//
//  Created by salih kocatürk on 12.06.2024.
//

import Foundation
import GameKit
import PencilKit
import GameController
import Combine
class MatchManager: NSObject, ObservableObject {
    @Published var inGame = false
    @Published var isGameOver = false
    @Published var authenticationState = PlayerAuthState.authenticating
    
    @Published var currentlyDrawing = true
    @Published var drawPrompt = ""
    @Published var pastGuesses = [PastGuess]()
    var timerSubscription: AnyCancellable?
    @Published var score = 0
    @Published var remainingTime = maxTimeRemaining {
        willSet {
            if isTimeKeeper { sendString("timer:\(newValue)") }
            if newValue < 0 { /* Handle negative time if necessary */ }
        }
    }
    @Published var lastReceivedDrawingData = PKDrawing()
    @Published var isTimeKeeper = false
    
    // MatchMaking Vars
    var match: GKMatch?
    var otherPlayer: GKPlayer?
    var playerUUIDKey = UUID().uuidString
    var countDownTimer: Timer?
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            self.handleAuthentication(vc: vc, error: error)
        }
    }
    
    func handleAuthentication(vc: UIViewController?, error: Error?) {
        if let viewController = vc {
            rootViewController?.present(viewController, animated: true)
            return
        }
        if let error = error {
            authenticationState = .error
            print(error.localizedDescription)
            return
        }
        let localPlayer = GKLocalPlayer.local
        if localPlayer.isAuthenticated {
            if localPlayer.isMultiplayerGamingRestricted {
                authenticationState = .restricted
            } else {
                authenticationState = .authenticated
            }
        } else {
            authenticationState = .unauthenticated
        }
    }
    
    func startMatchMaking() {
        let request = GKMatchRequest()
           request.maxPlayers = 2
           request.minPlayers = 2
           guard let matchMakingViewController = GKMatchmakerViewController(matchRequest: request) else {
               print("Failed to create GKMatchmakerViewController")
               return
           }
           matchMakingViewController.matchmakerDelegate = self
           DispatchQueue.main.async {
               self.rootViewController?.present(matchMakingViewController, animated: true)
           }
    }
    func startGame(newMatch: GKMatch) {
        DispatchQueue.main.async {
               self.match = newMatch
               self.match?.delegate = self
               self.otherPlayer = self.match?.players.first
               self.drawPrompt = everydayObjects.randomElement()!
               self.sendString("began:\(self.playerUUIDKey)")
               self.inGame = true
               self.currentlyDrawing = self.playerUUIDKey < self.otherPlayer?.gamePlayerID ?? ""
               self.isTimeKeeper = self.currentlyDrawing
               if self.isTimeKeeper {
                   self.startTimer()
               }
           }
    }
    
    func swapRoles() {
        score += 1
        currentlyDrawing = !currentlyDrawing
        drawPrompt = everydayObjects.randomElement()!
    }
    
    func gameOver() {
        isGameOver = true
        match?.disconnect()
    }
    
    func resetGame() {
        DispatchQueue.main.async {
            self.isGameOver = false
            self.inGame = false
            self.drawPrompt = ""
            self.score = 0
            self.remainingTime = maxTimeRemaining
            self.lastReceivedDrawingData = PKDrawing()
        }
        isTimeKeeper = false
        match?.delegate = nil
        match = nil
        pastGuesses.removeAll()
        playerUUIDKey = UUID().uuidString
    }
    
    func receivedString(_ message: String) {
        let messageSplit = message.split(separator: ":")
        guard let messagePrefix = messageSplit.first else { return }
        let parameter = String(messageSplit.last ?? "")
        switch messagePrefix {
        case "began":
            if playerUUIDKey == parameter {
                playerUUIDKey = UUID().uuidString
                sendString("began:\(playerUUIDKey)")
                break
            }
            currentlyDrawing = playerUUIDKey < parameter
            inGame = true
            isTimeKeeper = currentlyDrawing
            if isTimeKeeper {
                startTimer()
            }
        case "timer":
            remainingTime = Int(parameter) ?? 0
        case "guess":
            var guessCorrect = false
            if parameter.lowercased() == drawPrompt.lowercased() {
                sendString("correct:\(parameter)")
                swapRoles()
                guessCorrect = true
            } else {
                sendString("incorrect:\(parameter)")
            }
            appendPastGuesses(guess: parameter, correct: guessCorrect)
        case "correct":
            swapRoles()
            appendPastGuesses(guess: parameter, correct: true)
        case "incorrect":
            appendPastGuesses(guess: parameter, correct: false)
        default:
            break
        }
    }
    
    func appendPastGuesses(guess: String, correct: Bool) {
        pastGuesses.append(PastGuess(
            message: "\(guess)\(correct ? " was correct!" : "")",
            correct: correct
        ))
    }
    func startTimer() {
            timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    self.remainingTime -= 1
                    if self.remainingTime < 0 {
                        self.timerSubscription?.cancel()
                        self.timerSubscription = nil
                    }
                }
        }
    
}
