//
//  PlaybackManager.swift
//  MusicPlayer
//
//  Created by Ryuji Koyama on 2025/01/23.
//

import Foundation
import MusicKit

protocol MusicService {
    func fetchSongs() async throws -> MusicItemCollection<Song>
    func fetchRecommendations() async throws -> MusicItemCollection<MusicPersonalRecommendation>
    
    func playback(song: Song) async throws
    func restartPlayback() async throws
    func pause()
}

class MusicServiceImpl: MusicService {
    let player = ApplicationMusicPlayer.shared
    
    func fetchSongs() async throws -> MusicItemCollection<Song> {
        do {
            let response = try await MusicLibraryRequest<Song>().response()
            return response.items
        } catch {
            handleError(error, context: "Fetching songs failed")
            throw error
        }
    }
    
    func fetchRecommendations() async throws -> MusicItemCollection<MusicPersonalRecommendation> {
        do {
            let response = try await MusicPersonalRecommendationsRequest().response()
            return response.recommendations
        } catch {
            handleError(error, context: "Fetching recommendations failed")
            throw error
        }
    }
    
    func playback(song: Song) async throws {
        do {
            player.queue = [song]
            try await player.play()
        } catch {
            handleError(error, context: "Playing song '\(song.title)' failed")
            throw error
        }
    }
    
    func restartPlayback() async throws{
        do {
            try await player.play()
        } catch {
            handleError(error, context: "restart song failed")
            throw error
        }
    }
    
    func pause() {
        player.pause()
    }
}

private extension MusicService {
    func handleError(_ error: Error, context: String) {
        print("[Error] \(context): \(error.localizedDescription)")
    }
}
