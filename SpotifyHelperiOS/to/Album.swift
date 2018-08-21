//
//  Album.swift
//  SpotifyHelperiOS
//
//  Created by John Brandenburg on 8/20/18.
//  Copyright © 2018 TechLabs LLC. All rights reserved.
//

import UIKit

class Album: NSObject {
    enum AlbumFields: String {
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
        self.id = json[AlbumFields.id.rawValue] as? String
        self.name = json[AlbumFields.name.rawValue] as? String
        self.uri = json[AlbumFields.uri.rawValue] as? String
        self.href = json[AlbumFields.href.rawValue] as? String
    }
}
