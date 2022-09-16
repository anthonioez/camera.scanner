//
//  ScanningView.swift
//  camera.scanner
//
//  Created by Anthony Ezeh on 15/09/2022.
//

import SwiftUI

struct ScanningView: View {

    @Binding var percent: Double
    @State private var waveOffset = Angle(degrees: 0)
    @State private var waveOffset2 = Angle(degrees: 180)

    var body: some View {
        ZStack {
            CircularView(progress: $percent)
                .frame(width: 270, height: 270)

            VStack {
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.4))
                    Wave(offset: Angle(degrees: self.waveOffset.degrees), percent: Double(percent)/100)
                        .fill(.white.opacity(0.5))
                        .frame(width: 200, height: 220)
                    Wave(offset: Angle(degrees: self.waveOffset2.degrees), percent: Double(percent)/100)
                        .fill(.white)
                        .opacity(0.5)
                        .frame(width: 200, height: 220)
                }
                .frame(width: 220, height: 220)
                .border(.red, width: 2)
                .mask(
                    Image.init("fingerprint")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 200, height: 200)
                )
            }
            .padding(.all)
            .onAppear {
                withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                    waveOffset = Angle(degrees: 360)
                    waveOffset2 = Angle(degrees: -180)
                }
            }
            .foregroundColor(.clear)
        }
    }
}

struct Wave: Shape {

    var offset: Angle
    var percent: Double

    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle(degrees: newValue) }
    }

    func path(in rect: CGRect) -> Path {

        var p = Path()
        let waveHeight = 0.015 * rect.height
        let yOffset = CGFloat(1 - percent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle(degrees: 360)
        p.move(to: CGPoint(x: 0, y: yOffset + waveHeight * CGFloat(sin(offset.radians))))

        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * rect.width
            p.addLine(to: CGPoint(x: x, y: yOffset + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }

        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        p.closeSubpath()

        return p
    }
}

struct ScanningView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningView(percent: .constant(0))
    }
}
