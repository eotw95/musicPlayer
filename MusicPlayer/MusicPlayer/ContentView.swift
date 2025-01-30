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
        VStack(alignment: .leading) {
            
            Text("ライブラリの曲一覧を取得")
                .font(.headline)
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    if viewModel.songs.isEmpty {
                        Text("Empty Playlist")
                    } else {
                        ForEach(Array(viewModel.songs)) { song in
                            VStack(alignment: .leading) {
                                if let artwork = song.artwork {
                                    ArtworkImage(artwork, width: 150, height: 150)
                                } else {
                                    Image(systemName: "music.note")
                                        .frame(width: 150, height: 150, alignment: .leading)
                                }
                                VStack(alignment: .leading) {
                                    Text(song.title)
                                        .font(.headline)
                                        .frame(width: 100)
                                        .lineLimit(1)
                                    Text(song.artistName)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                Task {
                                    try await viewModel.playback(song: song)
                                }
                            }
                        }
                    }
                }
            }
            
            Text("オススメのアルバム一覧を取得")
                .font(.headline)
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    if viewModel.recomendatedAlbums.isEmpty {
                        Text("Empty Playlist")
                    } else {
                        ForEach(viewModel.recomendatedAlbums.flatMap { $0 }) { recommendation in
                            VStack(alignment: .leading) {
                                if let artwork = recommendation.artwork {
                                    ArtworkImage(artwork, width: 150, height: 150)
                                } else {
                                    Image(systemName: "music.note")
                                        .frame(width: 150, height: 150, alignment: .leading)
                                }
                                VStack(alignment: .leading) {
                                    Text(recommendation.title)
                                        .font(.headline)
                                        .frame(width: 100)
                                        .lineLimit(1)
                                }
                            }
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                
                            }
                        }
                    }
                }
            }
            
            Text("オススメのプレイリスト一覧を取得")
                .font(.headline)
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    if viewModel.recomendatedPlaylists.isEmpty {
                        Text("Empty Playlist")
                    } else {
                        ForEach(viewModel.recomendatedPlaylists.flatMap { $0 }) { recommendation in
                            VStack(alignment: .leading) {
                                if let artwork = recommendation.artwork {
                                    ArtworkImage(artwork, width: 150, height: 150)
                                } else {
                                    Image(systemName: "music.note")
                                        .frame(width: 150, height: 150, alignment: .leading)
                                }
                                VStack(alignment: .leading) {
                                    Text(recommendation.title)
                                        .font(.headline)
                                        .frame(width: 100)
                                        .lineLimit(1)
                                }
                            }
                            .padding(.horizontal, 5)
                            .onTapGesture {
                                
                            }
                        }
                    }
                }
            }
            
            PlayingBar(
                playingSong: $viewModel.playingSong,
                isPlaying: $viewModel.isPlaying,
                restartPlayback: { try await viewModel.restartPlayback() },
                pausePlayback: { viewModel.pause() }
            )
        }
        .onAppear() {
            Task {
                await viewModel.authorize()
                try await viewModel.fetchSongs()
                try await viewModel.fetchRecommendatedAlbums()
                try await viewModel.fetchRecommendatedPlaylists()
            }
        }
    }
}

#Preview {
    ContentView()
}
