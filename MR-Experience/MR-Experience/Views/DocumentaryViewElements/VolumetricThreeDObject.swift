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
    
    //@Binding var threeDObjectName: String;
    var threeDObjectName: String;
    
    @State private var _degreesRotating = 0.0
    @State private var _axisY = 1.0
    
    var body: some View {
        Model3D(named: threeDObjectName) { model in
        //Model3D(named: "LadyOfMalta") { model in
             model
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 //.scaledToFit()
                 //.aspectRatio(contentMode: .fit)
            
                 .rotation3DEffect(
                    .degrees(_degreesRotating),
                        axis: (x: 0.0, y: _axisY, z: 0.0),
                    //axis: rotationAxis,
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
                     //let axisX = -value.translation.height / CGFloat(angle)
                     _axisY = value.translation.width / CGFloat(angle)
                     //rotationAxis = (x: axisX, y: _axisY, z: 0)
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
