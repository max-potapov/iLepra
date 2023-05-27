//
//  LepraVideoView.swift
//  iLepra
//
//  Created by Maxim Potapov on 10.04.2023.
//

import AVKit
import SwiftUI

struct LepraVideoView: View {
    let url: URL
    @State private var globalFrame: CGRect = .zero
    private let height: CGFloat = 400

    var body: some View {
        let player: AVPlayer = .init(url: url)
        VideoPlayer(player: player)
            .onTapGesture {}
            .onDisappear {
                player.pause()
            }
            .frame(height: height)
            .clipped()
        #if os(iOS)
            .overlay(
                GeometryReader { proxy in
                    Color.clear.preference(key: RectPreferenceKey.self, value: proxy.frame(in: .global))
                }
            )
            .onPreferenceChange(RectPreferenceKey.self) { value in
                globalFrame = value

                let frameCenter = value.midY
                let screenCenter = UIScreen.main.bounds.size.height / 2

                if abs(frameCenter - screenCenter) < height / 1.3 {
                    player.allowsExternalPlayback = true
                    player.isMuted = true
                    player.play()
                } else {
                    player.pause()
                }
            }
        #endif
    }
}

private struct RectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct LepraVideoView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LepraVideoView(url: .init(string: "https://i.imgur.com/FY1AbSo.mp4")!)
        }
    }
}
