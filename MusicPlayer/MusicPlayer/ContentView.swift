//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Ryuji Koyama on 2025/01/23.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @StateObject private var viewModel = MusicViewModel(musicService: MusicServiceImpl())
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    if viewModel.songs.isEmpty {
                        Text("Empty Playlist")
                    } else {
                        ForEach(Array(viewModel.songs)) { song in
                            HStack(alignment: .top) {
                                if let artwork = song.artwork {
                                    ArtworkImage(artwork, width: 150, height: 150)
                                } else {
                                    Image(systemName: "music.note")
                                        .frame(width: 150, height: 150, alignment: .leading)
                                }
                                VStack(alignment: .leading) {
                                    Text(song.title)
                                        .font(.headline)
                                    Text(song.artistName)
                                        .font(.caption)
                                }
                            }
                            .onTapGesture {
                                Task {
                                    try await viewModel.play(song: song)
                                }
                            }
                        }
                    }
                }
            }
            
            PlayingBar(
                song: $viewModel.playingSong,
                isPlaying: $viewModel.isPlaying
            )
        }
        .onAppear() {
            Task {
                await viewModel.authorize()
                try await viewModel.fetchSongs()
            }
        }
    }
}

#Preview {
    ContentView()
}
