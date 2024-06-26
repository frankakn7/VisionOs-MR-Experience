//
//  3DObject.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI
import _RealityKit_SwiftUI

struct ThreeDObject: View {
    let objectFileName: String
    
    var body: some View {
        Model3D(named: objectFileName) { model in
             model
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .rotation3DEffect(
                         .degrees(-65),
                         axis: (x: 0.0, y: 1.0, z: 0.0),
                         anchor: .center)
                 //.tint(.brown)
         } placeholder: {
             ProgressView()
         }
    }
}

// #Preview {
//     ThreeDObject()
// }
