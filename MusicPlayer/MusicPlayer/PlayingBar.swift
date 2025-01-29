//
//  PlayingBar.swift
//  MusicPlayer
//
//  Created by Ryuji Koyama on 2025/01/29.
//

import SwiftUI
import MusicKit

struct PlayingBar: View {
    @Binding var playingSong: Song?
    @Binding var isPlaying: Bool
    
    var body: some View {
        ZStack {
            Color.green
            HStack {
                Text(playingSong?.title ?? "再生中の曲はありません")
                Spacer()
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .onTapGesture {
                        guard let _ = playingSong else { return }
                        isPlaying.toggle()
                    }
            }
            .padding()
            .background(Color.green)
        }
        .frame(height: 70)
    }
}
