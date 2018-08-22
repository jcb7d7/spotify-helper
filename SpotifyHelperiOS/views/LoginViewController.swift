//
//  LoginViewController.swift
//  SpotifyHelperiOS
//
//  Created by John Brandenburg on 8/21/18.
//  Copyright © 2018 TechLabs LLC. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var auth = SPTAuth.defaultInstance()!
    var loginUrl: URL?
    
    @IBOutlet weak var loginButton: UIButton!
    
    func setup() {
        auth.clientID = "432c0b2c7a8e4379b4f3ea504e42d501"
        auth.redirectURL = URL(string: "spotifyhelper://render")
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserReadTopScope];
        self.loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                performSegue(withIdentifier: "loginSuccess", sender: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : HomeViewController = segue.destination as! HomeViewController
        destVC.auth = self.auth
    }
}
