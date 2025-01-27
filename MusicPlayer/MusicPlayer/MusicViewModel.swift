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
            songs = try await musicService.fetchSongs()
        } catch {
            print(error)
        }
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
