//
//  3DObject.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI
import _RealityKit_SwiftUI

///A view displaying a three dimensional object in a window. Designed for the main Documentary View.
struct ThreeDObject: View {
    
    @Environment(\.openWindow) private var openWindow
    
    @Binding var objectFileName: String
    
    @Binding var threeDObjectOpened: Bool;
    
    @State var degreesRotating = 0.0
    
    @State var axisY = 1.0
    
    var body: some View {
        // Loads the 3D Object
        Model3D(named: objectFileName) { model in
            model
                .resizable()
                .aspectRatio(contentMode: .fit)
                //Adds a horizontal rotation around the center to the 3D model
                .rotation3DEffect(
                    .degrees(degreesRotating),
                    axis: (x: 0.0, y: axisY, z: 0.0),anchor: .center)
                .frame(depth: 10)
                //ensures that the 3D model does not appear too far in front of the window
                .offset(z: -10 / 2)
                .onAppear{
                    threeDObjectOpened = false
                    //run teh animation when it first appears
                    withAnimation(
                        .linear(duration: 1)
                        .speed(0.05)
                        .repeatForever(autoreverses: false)) {
                            degreesRotating = 360.00
                        }
                }
                .onTapGesture {
                    //when the model is tapped -> state value is updated to indicate it has been opened
                    threeDObjectOpened = true
                    //opens the window
                    openWindow(id: "3dObjectVolumetric")
                }
                .opacity(threeDObjectOpened ? 0 : 1)
        } placeholder: {
            ProgressView()
                .offset(z: -10 * 0.75)
        }
        //Ensures that the rotation restarts when the opened model is closed
         .onChange(of: objectFileName, { oldValue, newValue in
             degreesRotating = 0.0
         })
    }
}

 /*#Preview {
     ThreeDObject(objectFileName: "none", true)
 }*/
