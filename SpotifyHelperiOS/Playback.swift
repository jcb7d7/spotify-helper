//
//  Playback.swift
//  SpotifyHelperiOS
//
//  Created by John Brandenburg on 8/21/18.
//  Copyright © 2018 TechLabs LLC. All rights reserved.
//

import UIKit

class Playback: NSObject {
    static var isPlaying:Bool = false
    
    static func playPause(player: SPTAudioStreamingController) {
        var endpoint: String
        if (Playback.isPlaying) {
            player.setIsPlaying(false, callback: nil)
        } else {
            player.setIsPlaying(true, callback: nil)
        }
        Playback.isPlaying = !Playback.isPlaying
    }
}
