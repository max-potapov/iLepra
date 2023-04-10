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

    var body: some View {
        let player: AVPlayer = .init(url: url)
        VideoPlayer(player: player)
            .onTapGesture {}
            .onDisappear {
                player.pause()
            }
            .frame(height: 400)
            .clipped()
    }
}

struct LepraVideoView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LepraVideoView(url: .init(string: "https://i.imgur.com/FY1AbSo.mp4")!)
        }
    }
}
