//
//  GameOverController.swift
//  Selfie apocalypse
//
//  Created by Ivko on 2/6/16.
//  Copyright © 2016 Ivo Paounov. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverController: UIViewController {
    
    let transitionManager = TransitionManager()
    
    var score: Int?
    var selfOverAudioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var labelText: UILabel!
    
    @IBOutlet weak var labelScore: UILabel!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage()
        self.handleScore()
        self.setupAudioPlayers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.removeAudioPlayers()
    }
    
    func handleScore(){
        if self.score != nil {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            var slayerSupremeScore = defaults.valueForKey(DefaultKeys.Player_Top_Score.rawValue) as? Int
            
            if slayerSupremeScore == nil{
                slayerSupremeScore = 0
            }
            
            let currentScore = self.score!
            
            
            if slayerSupremeScore! > currentScore{
                self.labelText.text = "NICE BUT NOT YOUR SUPREME SCORE!\n(\(slayerSupremeScore!))"
                self.labelScore.text = "\(currentScore)"
            }
            else{
                self.labelText.text = "WOW THIS IS YOUR SUPREME SCORE!"
                self.labelScore.text = "\(currentScore)"
                
                defaults.setValue(self.score, forKey: DefaultKeys.Player_Top_Score.rawValue)
                defaults.synchronize()
                self.updateHighscoreInParse(self.score!)
            }
        }
    }
    
    func updateHighscoreInParse(score: Int){
        let parseService = ParseService()
        parseService.addOrUpdeteSlayerInfo(nil, supremeScore: score)
    }
    
    func setBackgroundImage(){
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "SelfOver")?.drawInRect(self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    func setupAudioPlayers(){
        
        if let selfOverAudioUrl = NSBundle.mainBundle().URLForResource("self-over",
            withExtension: "mp3") {
                self.selfOverAudioPlayer = AVAudioPlayerPool.playerWithURL(selfOverAudioUrl)
                self.selfOverAudioPlayer?.prepareToPlay()
                self.selfOverAudioPlayer?.volume = 0.3
                self.selfOverAudioPlayer?.numberOfLoops = 99
                self.selfOverAudioPlayer?.play()
        }
    }
    
    func selfieDidMadeSelfie(selfie: Selfie){
        
    }
    
    func removeAudioPlayers(){
        
        if ((self.selfOverAudioPlayer) != nil) {
            self.selfOverAudioPlayer?.currentTime = 0
            self.selfOverAudioPlayer?.stop()
            self.selfOverAudioPlayer = nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let toViewController = segue.destinationViewController as UIViewController
        
        toViewController.transitioningDelegate = self.transitionManager
    }
}
