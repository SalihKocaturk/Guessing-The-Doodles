//
//  ButtonView.swift
//  Guess The Doodle
//
//  Created by salih kocatürk on 12.06.2024.
//

import SwiftUI

struct ButtonView: View {
    @State private var isPressed = false
    @Binding var str: String
    @Binding var color1 : Color
    @Binding var color2 : Color
    @Binding var color3 : Color
    var body: some View {
        
        Button(action: {
                    // Action to perform when button is tapped
                    print("Button tapped!")
                }) {
                    Text(str)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            ZStack {
                                if isPressed {
                                    Color.blue
                                } else {
                                    LinearGradient(gradient: Gradient(colors: [color1, color2, color3]),
                                                   startPoint: .topLeading,
                                                   endPoint: .bottomTrailing)
                                }
                            }
                        )

                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 10, x: 5, y: 5)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: isPressed)
                }
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                    withAnimation {
                        self.isPressed = pressing
                    }
                }) {
                    // Action for long press if needed
                }
            }
    }

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(str: .constant("PLAY"), color1: .constant(Color.yellow), color2: .constant(Color.yellow), color3: .constant(Color.yellow))
    }
}
