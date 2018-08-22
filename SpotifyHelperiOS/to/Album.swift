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
    var artUri: String?
    
    
    required init(json: [String: Any], token: String) {
        super.init()
        self.id = json[AlbumFields.id.rawValue] as? String
        self.name = json[AlbumFields.name.rawValue] as? String
        self.uri = json[AlbumFields.uri.rawValue] as? String
        self.href = json[AlbumFields.href.rawValue] as? String
        self.artUri = self.getAlbumArtUri(token: token)
        
    }
    
    func getAlbumArtUri(token: String) -> String {
        var request = URLRequest(url: URL(string: self.href!)!)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        let data = try? NSURLConnection.sendSynchronousRequest(request, returning: response)
        let dict = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
        let images = dict["images"] as! NSArray
        var smallest: Int = 1000
        var smallestImageUri: String = (images[0] as! [String: Any])["url"] as! String
        for case let image as [String: Any] in images {
            if ((image["width"] as! Int) < smallest) {
                smallestImageUri = image["url"] as! String
            }
        }
        return smallestImageUri
    }
}
