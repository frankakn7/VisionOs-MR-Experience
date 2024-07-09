//
//  3DObject.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI
import _RealityKit_SwiftUI

struct ThreeDObject: View {
    
    @Environment(\.openWindow) private var openWindow
    
    let objectFileName: String
    
    @Binding var threeDObjectOpened: Bool;
    
    @State var degreesRotating = 0.0
    
    @State var axisY = 1.0
    
    var body: some View {
        Model3D(named: objectFileName) { model in
        //Model3D(named: "LadyOfMalta") { model in
             model
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 //.scaleEffect(1)
                 //.aspectRatio(contentMode: .fit)
            
                 .rotation3DEffect(
                    .degrees(degreesRotating),
                        axis: (x: 0.0, y: axisY, z: 0.0),
                    //axis: rotationAxis,
                        anchor: .center)
                        .frame(depth: 10)
                        .offset(z: -10 / 2)
                 .onAppear{
                     threeDObjectOpened = false
                     withAnimation(
                        .linear(duration: 1)
                        .speed(0.05)
                        .repeatForever(autoreverses: false)) {
                            degreesRotating = 360.00
                        }
                 }
                        .onTapGesture {
                            threeDObjectOpened = true
                            openWindow(id: "3dObjectVolumetric")
                        }
                        .opacity(threeDObjectOpened ? 0 : 1)
         } placeholder: {
             ProgressView()
                 .offset(z: -10 * 0.75)
         }
         /*.gesture(
             DragGesture()
                 .onChanged { value in
                     // Calculate rotation angle
                     let angle = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                     degreesRotating = Double(angle)
                     // Calculate rotation axis
                     //let axisX = -value.translation.height / CGFloat(angle)
                     axisY = value.translation.width / CGFloat(angle)
                     //rotationAxis = (x: axisX, y: axisY, z: 0)
                 }
         )*/
    }
}

 /*#Preview {
     ThreeDObject(objectFileName: "none", true)
 }*/
