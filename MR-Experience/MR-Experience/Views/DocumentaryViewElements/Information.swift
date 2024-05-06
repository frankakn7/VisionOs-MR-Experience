//
//  Information.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI

struct Information: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Great Sphinx of Giza")
                .font(.title)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 5)
            Text("Location: Giza, Egypt\n" +
                 "Built: c. 2558–2532 BC\n" +
                 "Material: limestone")
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    Information()
}
