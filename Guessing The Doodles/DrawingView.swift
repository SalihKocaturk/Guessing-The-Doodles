//
//  DrawingView.swift
//  Guess The Doodle
//
//  Created by salih kocatürk on 14.06.2024.
//

import SwiftUI
import PencilKit
struct DrawingView: UIViewRepresentable{
    class Coordinator: NSObject, PKCanvasViewDelegate{
        var matchmanager: MatchManager
        init(matchmanager: MatchManager) {
            self.matchmanager = matchmanager
        }
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            guard canvasView.isUserInteractionEnabled else {return}
            matchmanager.sendData(canvasView.drawing.dataRepresentation(), mode: .reliable)
        }
    }

    @ObservedObject var matchManager: MatchManager
   let canvasView = PKCanvasView()
    @Binding var eraserEnabled : Bool
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput//herhangi bir aracı ile de çizim yapmayı sağlar
        canvasView.tool = PKInkingTool(.pen,color: .black, width: 5)
        canvasView.isUserInteractionEnabled = matchManager.currentlyDrawing
        canvasView.delegate = context.coordinator
        return canvasView
    }
   
    
    func makeCoordinator() -> Coordinator {
        Coordinator(matchmanager: matchManager)
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
        let wasDrawing = uiView.isUserInteractionEnabled
        uiView.isUserInteractionEnabled = matchManager.currentlyDrawing
        if !wasDrawing && matchManager.currentlyDrawing{
            uiView.drawing = PKDrawing()
        }
        if !uiView.isUserInteractionEnabled || matchManager.inGame{
            uiView.drawing = matchManager.lastReceivedDrawingData
        }
        uiView.tool = eraserEnabled ? PKEraserTool(.vector):PKInkingTool(.pen,color: .black, width: 5)
    }
}

struct DrawingView_Previews: PreviewProvider {
    @State static var eraser = false
    static var previews: some View {
        DrawingView( matchManager: MatchManager(), eraserEnabled: $eraser)
    }
}
