//
//  VolumetricThreeDObject.swift
//  MR-Experience
//
//  Created by Maxim Strzebkowski on 25.06.24.
//

import SwiftUI
import _RealityKit_SwiftUI

struct VolumetricThreeDObject: View {
    
    @Binding var isOpen: Bool;
    
    var threeDObjectName: String;
    
    @State private var _degreesRotating = 0.0
    @State private var _axisY = 1.0
    
    var body: some View {
        Model3D(named: threeDObjectName) { model in
             model
                 .resizable()
                 .aspectRatio(contentMode: .fit)
            
                 .rotation3DEffect(
                    .degrees(_degreesRotating),
                        axis: (x: 0.0, y: _axisY, z: 0.0),
                        anchor: .center)
         } placeholder: {
             ProgressView()
         }
         .frame(width: 500, height: 500)
         .gesture(
             DragGesture()
                 .onChanged { value in
                     // Calculate rotation angle
                     let angle = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                     _degreesRotating = Double(angle)
                     // Calculate rotation axis
                     _axisY = value.translation.width / CGFloat(angle)
                 }
         )
         .onDisappear{
             isOpen.toggle();
         }
    }
}

/*#Preview {
    VolumetricThreeDObject()
}*/
