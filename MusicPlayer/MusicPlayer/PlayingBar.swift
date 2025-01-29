//
//  PlayingBar.swift
//  MusicPlayer
//
//  Created by Ryuji Koyama on 2025/01/28.
//

import SwiftUI
import MusicKit

struct PlayingBar: View {
    @Binding var playingSong: Song?
    @Binding var isPlaying: Bool
    
    var restartPlayback: () async throws -> Void
    var pausePlayback: () -> Void
    
    var body: some View {
        ZStack {
            Color.green
            HStack {
                Text(playingSong?.title ?? "再生中の曲はありません")
                Spacer()
                
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .onTapGesture {
                        if isPlaying {
                            pausePlayback()
                        } else {
                            guard let _ = playingSong else { return }
                            Task {
                                try await restartPlayback()
                            }
                        }
                    }
            }
            .padding()
            .background(Color.green)
        }
        .frame(height: 70)
    }
}
