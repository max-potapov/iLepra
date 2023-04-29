//
//  LepraTextLoadingIndicatorView.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import SwiftUI

struct LepraTextLoadingIndicatorView: View {
    @State private var text: String = ""
    private let now: Date = .now
    private static let every: TimeInterval = 0.2
    private let timer = Timer.publish(every: Self.every, on: .main, in: .common).autoconnect()
    private let characters = Array("⣾⣽⣻⢿⡿⣟⣯⣷")

    var body: some View {
        VStack {
            Text(text)
                .font(.largeTitle)
                .transition(.slide)
            Text("Ищем рыбу...")
                .font(.footnote)
        }
        .onReceive(timer) { time in
            let tick: Int = .init(time.timeIntervalSince(now) / Self.every) - 1
            let index: Int = tick % characters.count
            text = "\(characters[index])"
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

struct LepraTextLoadingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        LepraTextLoadingIndicatorView()
    }
}
