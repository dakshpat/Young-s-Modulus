//
//  DrawingView.swift
//  YoungsModulus
//
//  Created by user216578 on 4/25/22.
//

import Foundation
import SwiftUI

struct drawingView: View{
    
    var deltaLength = 0.0
    
    var body: some View{
        
        ZStack{
            
            borderLine()
                .stroke(Color.black)
            
            drawPath(deltaLength: deltaLength)
                
            
        }
        .background(Color.white)
        .aspectRatio(1, contentMode: .fill)
        
    }
}

struct borderLine: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        return path
        
    }
}

struct drawPath: Shape {
    
    var deltaLength = 0.0
    var youngsMod = youngsModulus()
    
    func path(in rect: CGRect) -> Path{
        
        var path = Path()
        
        let scaleX = rect.width/60
        let scaleY = rect.height/20
    
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width/4, y: rect.height/4))
        
        path.addLine(to: CGPoint(x: (rect.width*3/4) + deltaLength, y: rect.height/4))
        path.addLine(to: CGPoint(x: (rect.maxX) + deltaLength, y: rect.minY))
        path.addLine(to: CGPoint(x: (rect.maxX) + deltaLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: (rect.width*3/4) + deltaLength, y: rect.height*3/4))
        
        path.addLine(to: CGPoint(x: rect.width/4, y: rect.height*3/4))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        
        return path
    }
    
    
}
    


