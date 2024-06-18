//
//  Information.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI

struct Information: View {
    let informationText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(informationText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
    }
}

// #Preview {
//     Information()
// }
