//
//  PlayingBar.swift
//  MusicPlayer
//
//  Created by Ryuji Koyama on 2025/01/28.
//

import SwiftUI
import MusicKit

struct PlayingBar: View {
    @Binding var song: Song?
    @Binding var isPlaying: Bool
    
    var body: some View {
        ZStack {
            Color.green
            HStack {
                Text(song?.title ?? "再生中の曲はありません")
                Spacer()
                
                if isPlaying {
                    Image(systemName: "pause.fill")
                } else {
                    Image(systemName: "play.fill")
                }
            }
            .padding()
            .background(Color.green)
        }
        .frame(height: 70)
    }
}
