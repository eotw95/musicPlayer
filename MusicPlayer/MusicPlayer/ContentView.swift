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
            
            PlayingBar(viewModel: $viewModel)
        }
        .onAppear() {
            Task {
                await viewModel.authorize()
                try await viewModel.fetchSongs()
            }
        }
    }
}

struct PlayingBar {
    @Binding var viewModel: MusicViewModel
    
    var body: some View {
        ZStack {
            Color.green
            HStack {
                Text(viewModel.playingSong?.title ?? "再生中の曲はありません")
                Spacer()
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .onTapGesture {
                        if !viewModel.isPlaying {
                            viewModel.restartPlayback()
                        } else {
                            viewModel.pause()
                        }
                    }
            }
            .padding()
            .background(Color.green)
        }
        .frame(height: 70)
    }
}
