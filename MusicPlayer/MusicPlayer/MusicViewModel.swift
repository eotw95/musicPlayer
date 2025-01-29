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
