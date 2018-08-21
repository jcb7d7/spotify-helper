//
//  Song.swift
//  SpotifyHelperiOS
//
//  Created by John Brandenburg on 8/20/18.
//  Copyright © 2018 TechLabs LLC. All rights reserved.
//

import UIKit

class Song: NSObject {
    
    enum SongFields: String {
        case id = "id"
        case name = "name"
        case album = "album"
        case artists = "artists"
        case href = "href"
        case popularity = "popularity"
        case uri = "uri"
        case durationMs = "duration_ms"
    }
    
    var id: String?
    var name: String?
    var album: Album?
    var artists: [Artist]?
    var href: String?
    var popularity: Int64?
    var uri: String?
    var durationMs: Int64?
    
    required init(json: [String: Any]) {
        self.id = json[SongFields.id.rawValue] as? String
        self.name = json[SongFields.name.rawValue] as? String
        self.album = json[SongFields.album.rawValue] as? Album
        self.artists = json[SongFields.artists.rawValue] as? [Artist]
        self.uri = json[SongFields.uri.rawValue] as? String
        self.href = json[SongFields.href.rawValue] as? String
        self.popularity = json[SongFields.popularity.rawValue] as? Int64
        self.durationMs = json[SongFields.durationMs.rawValue] as? Int64
    }
}
