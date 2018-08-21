//
//  SongWrapper.swift
//  SpotifyHelperiOS
//
//  Created by John Brandenburg on 8/20/18.
//  Copyright © 2018 TechLabs LLC. All rights reserved.
//

import UIKit

class SongWrapper: NSObject {
    
    static let TOP50ENDPOINT = "https://api.spotify.com/v1/me/top/tracks"
    
    var previous: String?
    var next: String?
    var limit: Int64?
    var total: Int64?
    var href: String?
    var items: [Song]?
    
    init(songHref: String, token: String) {
        super.init()
        let dict: NSDictionary = SongWrapper.getSongs(songHref: songHref, token: token)
        self.href = dict["href"] as? String
        self.next = dict["next"] as? String
        self.previous = dict["previous"] as? String
        self.limit = dict["limit"] as? Int64
        self.total = dict["total"] as? Int64
        
        self.items = []
        if let songs = dict["items"] as? [[String: Any]] {
            for song in songs {
                self.items?.append(Song(json: song))
            }
        }
    }
    
    public func addNext(top50Response: NSDictionary) {
        self.href = top50Response["href"] as? String
        self.next = top50Response["next"] as? String
        self.previous = top50Response["previous"] as? String
        self.limit = top50Response["limit"] as? Int64
        self.total = top50Response["total"] as? Int64
        
        if let songs = top50Response["items"] as? [[String: Any]] {
            for song in songs {
                self.items?.append(Song(json: song))
            }
        }
    }
    
    public static func getSongs(songHref: String, token: String) -> NSDictionary {
        var request = URLRequest(url: NSURL(string: songHref)! as URL)
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        let data = try? NSURLConnection.sendSynchronousRequest(request, returning: response)
        return try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
    }
}
