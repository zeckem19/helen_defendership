//
//  GameViewController.swift
//  Happy birthday Helen
//
//  Created by zeckem19on 3/2/18.
//  Copyright © 2018 Lim Ze Hwee Zoe. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

var backingAudio = AVAudioPlayer()
class GameViewController: UIViewController {

    var filePath = Bundle.main.path(forResource: "StandardBacking", ofType: "mp3")

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let audioNSURL = NSURL(fileURLWithPath: filePath!)
        
        do { backingAudio = try AVAudioPlayer(contentsOf: audioNSURL as URL) }
        catch { return print("Cannot Find Audio") }
        
        backingAudio.volume = 0.4
        backingAudio.numberOfLoops = -1
        backingAudio.play()

        let scene = MainMenuScene(size : CGSize(width:1536, height: 2048))
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
    }


    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

