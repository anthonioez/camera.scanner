//
//  CircularProgressView.swift
//  camera.scanner
//
//  Created by Anthony Ezeh on 15/09/2022.
//

import SwiftUI

struct CircularView: View {
    @Binding var progress: Double

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: progress / 100)
                .stroke(
                    Color.white,
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                //.animation(.linear, value: progress)
        }
    }
}

struct CircularView_Previews: PreviewProvider {
    static var previews: some View {
        CircularView(progress: .constant(50))
    }
}
