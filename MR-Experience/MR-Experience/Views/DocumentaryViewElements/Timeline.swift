//
//  Timeline.swift
//  MR-Experience
//
//  Created by Christian Helbig on 03.05.24.
//

import SwiftUI

struct Timeline: View {
    let timestamps: [String: Timestamp]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 100) {
                Spacer(minLength: 20)
                VStack {
                    Text("3000 BC")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                VStack {
                    Text("2500 BC")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                VStack {
                    Text("2000 BC")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                VStack {
                    Text("1500 BC")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                VStack {
                    Text("1000 BC")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                VStack {
                    Text("500 BC")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                VStack {
                    Text("250 BC")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                VStack {
                    Text("1 BC")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                VStack {
                    Text("100 AD")
                        .bold()
                        .font(.headline)
                    Text("Some event")
                        .multilineTextAlignment(.center)
                        .italic()
                    Rectangle()
                        .fill(.white)
                        .frame(width: 2, height: 10)
                }.fixedSize()
                Spacer(minLength: 20)
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
    }
}

// #Preview {
//     Timeline()
// }
