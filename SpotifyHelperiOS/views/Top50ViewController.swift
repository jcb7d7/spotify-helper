//
//  ViewController.swift
//  SpotifyHelperiOS
//
//  Created by John Brandenburg on 8/14/18.
//  Copyright © 2018 TechLabs LLC. All rights reserved.
//

import UIKit
import SafariServices
import AVFoundation
import SDWebImage

class SongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var songTextLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistButton: UIButton!
    
}

class Top50ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var player: SPTAudioStreamingController?
    var isLoadingSongs: Bool = false
    var top50Wrapper: SongWrapper?
    var playback: Playback?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var prevTrackButton: UIButton!
    
    func setup() {
        self.playPauseButton.isHidden = true
        self.nextTrackButton.isHidden = true
        self.prevTrackButton.isHidden = true
    }
    
    
    
    @IBAction func playPausePressed(_ sender: Any) {
        Playback.playPause(player: player!)
        if (Playback.isPlaying) {
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        try? player?.stop()
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.top50Wrapper == nil) {
            return 0
        } else {
            return (top50Wrapper?.items!.count)!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.player?.playSpotifyURI(self.top50Wrapper?.items![indexPath.row].uri, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error == nil) {
                Playback.isPlaying = true;
                self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
                self.nextTrackButton.setImage(UIImage(named: "next"), for: .normal)
                self.prevTrackButton.setImage(UIImage(named: "prev"), for: .normal)
                self.playPauseButton.isHidden = false
                self.nextTrackButton.isHidden = false
                self.prevTrackButton.isHidden = false
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath) as! SongTableViewCell
        
        if (self.top50Wrapper!.items!.count >= indexPath.row) {
            let songToShow: Song? = self.top50Wrapper?.items![indexPath.row]
            cell.songTextLabel?.text = songToShow?.name
            cell.albumImageView?.sd_setShowActivityIndicatorView(true)
            cell.albumImageView?.sd_setIndicatorStyle(.gray)
            cell.albumImageView?.sd_setImage(with: URL(string: (songToShow?.album?.artUri)!))
            
            
            
            let rowsToLoadFromBottom = 5;
            let rowsLoaded = self.top50Wrapper?.items?.count
            if (!self.isLoadingSongs && (indexPath.row >= (rowsLoaded! - rowsToLoadFromBottom))) {
                let totalRows = self.top50Wrapper?.total ?? 0
                let remainingSongsToLoad = Int(totalRows) - rowsLoaded!;
                if (remainingSongsToLoad > 0) {
                    self.loadMoreSongs()
                }
            }
        }
        return cell
    }
    
    func loadMoreSongs() {
        self.isLoadingSongs = true
        if (self.top50Wrapper != nil) {
            if ((self.top50Wrapper?.items?.count)! < Int((self.top50Wrapper?.total)!)) {
                let dict: NSDictionary = SongWrapper.getSongs(songHref: (self.top50Wrapper?.next)!, token: self.session.accessToken)
                self.top50Wrapper?.addNext(top50Response: dict, token: self.session.accessToken)
                self.isLoadingSongs = false
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        initializePlayer(authSession: self.session)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initializePlayer(authSession: SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }

    
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        self.top50Wrapper = SongWrapper(songHref: SongWrapper.TOP50ENDPOINT, token: session.accessToken)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

