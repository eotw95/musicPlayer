//
//  MusicViewModel.swift
//  MusicPlayer
//
//  Created by Ryuji Koyama on 2025/01/25.
//

import Foundation
import MusicKit

class MusicViewModel: ObservableObject {
    private let musicService: MusicService
    
    @Published var songs: MusicItemCollection<Song> = []
    @Published var authorizationStatus: MusicAuthorization.Status = .notDetermined
    @Published var isPlaying: Bool = false
    @Published var playingSong: Song?
    @Published var recomendatedAlbums: [AlbumEnity] = []
    @Published var recomendatedPlaylists: [PlaylistEnity] = []
    @Published var recomendatedStations: [StationEnity] = []
    
    init(musicService: MusicService) {
        self.musicService = musicService
    }
    
    func authorize() async {
        let status = await MusicAuthorization.request()
        DispatchQueue.main.async { [self] in
            authorizationStatus = status
            handleAuthorizationStatus(status: status)
        }
    }
    
    func fetchSongs() async throws {
        guard authorizationStatus == .authorized else {
            print("not authorized")
            return
        }
        
        do {
            let result = try await musicService.fetchSongs()
            DispatchQueue.main.async {
                self.songs = result
            }
        } catch {
            print(error)
        }
    }
    
    func fetchRecomendations() async throws {
        guard authorizationStatus == .authorized else {
            print("not authorized")
            return
        }
        
        do {
            let recomendations = try await musicService.fetchRecommendations()
            
            for recomendation in recomendations {
                // MusicItemCollection<Album>のコレクションからAlbumを抽出
                for item in recomendation.items {
                    switch item {
                    case .album(let album): do {
                        self.recomendatedAlbums.append(
                            AlbumEnity(
                                id: album.id,
                                title: album.title,
                                artistName: album.artistName,
                                artwork: album.artwork
                            )
                        )
                    }
                    case .playlist(let playlist): do {
                        self.recomendatedPlaylists.append(
                            PlaylistEnity(
                                id: playlist.id,
                                title: playlist.name,
                                artwork: playlist.artwork
                            )
                        )
                    }
                    case .station(let station): do {
                        self.recomendatedStations.append(
                            StationEnity(
                                id: station.id,
                                title: station.name,
                                artwork: station.artwork
                            )
                        )
                    }
                    @unknown default:
                        return
                    }
                }
            }
        }
    }
    
    func playback(song: Song) async throws{
        DispatchQueue.main.async {
            self.isPlaying = true
            self.playingSong = song
        }
        try await musicService.playback(song: song)
    }
    
    func restartPlayback() async throws{
        DispatchQueue.main.async {
            self.isPlaying = true
        }
        try await musicService.restartPlayback()
    }
    
    func pause() {
        isPlaying = false
        musicService.pause()
    }
    
    private func handleAuthorizationStatus(status: MusicAuthorization.Status) {
        switch status {
        case .authorized:
            print("authorization status authorized")
        case .denied:
            print("authorization status denied")
        case .notDetermined:
            print("authorization status not determined")
        case .restricted:
            print("authorization status restricted")
        @unknown default:
            print("authorization status unknown")
        }
    }
}
