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
    func fetchRecommendations(term: String) async throws -> MusicItemCollection<MusicPersonalRecommendation>
    
    func playback(song: Song) async throws
    func restartPlayback()
    func pause()
    
    func searchSongs(term: String) async throws -> MusicItemCollection<Song>
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
    
    func fetchRecommendations(term: String) async throws -> MusicItemCollection<MusicPersonalRecommendation> {
        do {
            let response = try await MusicPersonalRecommendationsRequest().response()
            return response.recommendations
        } catch {
            handleError(error, context: "Fetching recommendations with term '\(term)' failed")
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
    
    func restartPlayback() {
        player.restartCurrentEntry()
    }
    
    func pause() {
        player.pause()
    }
    
    func searchSongs(term: String) async throws -> MusicItemCollection<Song> {
        do {
            let response = try await MusicLibrarySearchRequest(
                term: term,
                types: [Song.self] as [any MusicLibrarySearchable.Type]
            ).response()
            return response.songs
        } catch {
            handleError(error, context: "Searching songs with term '\(term)' failed")
            throw error
        }
    }
}

private extension MusicService {
    func handleError(_ error: Error, context: String) {
        print("[Error] \(context): \(error.localizedDescription)")
    }
}
