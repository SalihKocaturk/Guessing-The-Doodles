//
//  MatchManager+GkMatchManager.swift
//  Guess The Doodle
//
//  Created by salih kocatürk on 16.06.2024.
//

import Foundation
import GameKit
extension MatchManager: GKMatchmakerViewControllerDelegate{
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        viewController.dismiss(animated: true)
        print("Matchmaking failed with error: \(error.localizedDescription)")
    }
    
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        viewController.dismiss(animated: true)
        print("Match found with players: \(match.players.map { $0.alias })")
        startGame(newMatch: match)
    }
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
            switch state {
            case .connected:
                print("\(player.alias) connected.")
            case .disconnected:
                print("\(player.alias) disconnected.")
                if !isGameOver {
                    let alert = UIAlertController(title: "Player Left", message: "Your opponent left the game!", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "OK", style: .default) { _ in
                        self.match?.disconnect()
                        self.resetGame()
                    }
                    alert.addAction(okButton)
                    DispatchQueue.main.async {
                        self.rootViewController?.present(alert, animated: true)
                    }
                }
            default:
                break
            }
        }
}
