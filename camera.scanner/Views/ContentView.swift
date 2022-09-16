//
//  ContentView.swift
//  camera.scanner
//
//  Created by Anthony Ezeh on 15/09/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var service = CameraService()

    @State private var percent: Double = 0.0
    @State private var waveTimer : Timer?

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            CameraPreview(session: service.session)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                ScanningView(percent: $percent)

                Spacer()
                    .frame(height: 20)

                Text("\(Int(percent))%")
                    .foregroundColor(.white)
                    .font(.custom("Arial", fixedSize: 24))

                Spacer()
                    .frame(height: 10)

                Text(percent <= 100 ? "scanning..." : "Hurray! Completed!")
                    .font(.custom("Arial", fixedSize: 18))
                    .foregroundColor(.white.opacity(0.65))
            }

            VStack {
                Spacer()

                Text("Please place your finger to scan your phone!")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .frame(width: 300, alignment: .bottom)
                    .padding(.bottom, 32)
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .onAppear {
            service.configure({ ready in
                if ready {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.startAnimation()
                    })
                }
            })
        }
        .onTapGesture {
            restartAnimation()
        }
        .alert(isPresented: $service.shouldShowAlertView, content: {
            Alert(title: Text("Camera Access"),
                  message: Text("App doesn't have access to use your camera."),
                  dismissButton: .default(Text("Open Settings"), action: {
                service.openSettings()
            }))
        })
    }

    func startAnimation() {
        waveTimer =  Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            if percent <= 100 {
                withAnimation(Animation.linear(duration: 0.03)) {
                    percent += 0.25
                }
            } else {
                waveTimer?.invalidate()
                waveTimer = nil
            }
        }
    }

    func restartAnimation() {
        guard waveTimer == nil else {
            return
        }

        percent = 0

        startAnimation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
