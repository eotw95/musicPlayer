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
        ZStack {
            ScrollView {
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
                                            ArtworkImage(artwork, width: 100, height: 100)
                                        } else {
                                            Image(systemName: "music.note")
                                                .frame(width: 100, height: 100, alignment: .leading)
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
                        .padding()
                    }
                    
                    Text("オススメのアルバム一覧を取得")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .top) {
                            if viewModel.recomendatedAlbums.isEmpty {
                                Text("Empty Playlist")
                            } else {
                                ForEach(viewModel.recomendatedAlbums) { recommendation in
                                    VStack(alignment: .leading) {
                                        if let artwork = recommendation.artwork {
                                            ArtworkImage(artwork, width: 100, height: 100)
                                        } else {
                                            Image(systemName: "music.note")
                                                .frame(width: 100, height: 100, alignment: .leading)
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
                        .padding()
                    }
                    
                    Text("オススメのプレイリスト一覧を取得")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .top) {
                            if viewModel.recomendatedPlaylists.isEmpty {
                                Text("Empty Playlist")
                            } else {
                                ForEach(viewModel.recomendatedPlaylists) { recommendation in
                                    VStack(alignment: .leading) {
                                        if let artwork = recommendation.artwork {
                                            ArtworkImage(artwork, width: 100, height: 100)
                                        } else {
                                            Image(systemName: "music.note")
                                                .frame(width: 100, height: 100, alignment: .leading)
                                        }
                                        VStack(alignment: .leading) {
                                            Text(recommendation.title)
                                                .font(.headline)
                                                .frame(width: 100)
                                                .lineLimit(1)
                                        }
                                    }
                                    .padding(.horizontal, 5)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Text("オススメのステーション一覧を取得")
                        .font(.headline)
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .top) {
                            if viewModel.recomendatedStations.isEmpty {
                                Text("Empty Playlist")
                            } else {
                                ForEach(viewModel.recomendatedStations) { recommendation in
                                    VStack(alignment: .leading) {
                                        if let artwork = recommendation.artwork {
                                            ArtworkImage(artwork, width: 100, height: 100)
                                        } else {
                                            Image(systemName: "music.note")
                                                .frame(width: 100, height: 100, alignment: .leading)
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
                        .padding()
                    }
                }
                .onAppear() {
                    Task {
                        await viewModel.authorize()
                        try await viewModel.fetchSongs()
                        try await viewModel.fetchRecomendations()
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
}
