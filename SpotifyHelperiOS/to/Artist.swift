//
//  Artist.swift
//  SpotifyHelperiOS
//
//  Created by John Brandenburg on 8/20/18.
//  Copyright © 2018 TechLabs LLC. All rights reserved.
//

import UIKit

class Artist: NSObject {
    enum ArtistFields: String {
        case id = "id"
        case name = "name"
        case uri = "uri"
        case href = "href"
    }
    
    var id: String?
    var name: String?
    var uri: String?
    var href: String?
    
    required init(json: [String: Any]) {
        self.id = json[ArtistFields.id.rawValue] as? String
        self.name = json[ArtistFields.name.rawValue] as? String
        self.uri = json[ArtistFields.uri.rawValue] as? String
        self.href = json[ArtistFields.href.rawValue] as? String
    }
}
