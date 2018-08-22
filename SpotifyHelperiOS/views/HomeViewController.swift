//
//  HomeViewController.swift
//  SpotifyHelperiOS
//
//  Created by John Brandenburg on 8/21/18.
//  Copyright © 2018 TechLabs LLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var auth: SPTAuth!
    var session: SPTSession!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: NSNotification.Name(rawValue: "loginSuccessfull"), object: nil)
        
        playPauseButton.setImage(UIImage(named: "pin"), for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func top50Pressed(_ sender: Any) {
        performSegue(withIdentifier: "top50", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : Top50ViewController = segue.destination as! Top50ViewController
        destVC.auth = self.auth
        destVC.session = self.session
    }
    
    @objc
    func updateAfterFirstLogin () {
        let userDefaults = UserDefaults.standard
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
        }
    }
}
