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

class ViewController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    var isLoadingSongs: Bool = false
    var top50Wrapper: SongWrapper?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!

    func setup() {
        auth.clientID = "432c0b2c7a8e4379b4f3ea504e42d501";
        auth.redirectURL = URL(string: "spotifyhelper://render");
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserReadTopScope];
        loginUrl = auth.spotifyWebAuthenticationURL();
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
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
                print("playing!")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Song", for: indexPath)
        
        if self.top50Wrapper!.total! >= indexPath.row {
            let songToShow = self.top50Wrapper?.items![indexPath.row]
            cell.textLabel?.text = songToShow?.name!
            cell.detailTextLabel?.text = songToShow?.album?.name
            
            // See if we need to load more species
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
                self.top50Wrapper?.addNext(top50Response: dict)
                self.isLoadingSongs = false
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc
    func updateAfterFirstLogin () {
        loginButton.isHidden = true
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }

    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.top50Wrapper = SongWrapper(songHref: SongWrapper.TOP50ENDPOINT, token: session.accessToken)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

