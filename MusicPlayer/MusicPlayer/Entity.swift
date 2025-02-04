//
//  Entity.swift
//  MusicPlayer
//
//  Created by Ryuji Koyama on 2025/02/04.
//

import Foundation
import MusicKit

struct AlbumEnity: Identifiable {
    var id: MusicItemID
    var title: String
    var artistName: String
    var artwork: Artwork?
}

struct PlaylistEnity: Identifiable {
    var id: MusicItemID
    var title: String
    var artwork: Artwork?
}

struct StationEnity: Identifiable {
    var id: MusicItemID
    var title: String
    var artwork: Artwork?
}
