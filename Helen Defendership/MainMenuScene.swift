//
//  MainMenuScene.swift
//  Helen Defendership
//
//  Created by zeckem19on 6/2/18.
//  Copyright © 2018 Lim Ze Hwee Zoe. All rights reserved.
//
import Foundation
import SpriteKit
import AVFoundation

class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameBy = SKLabelNode(fontNamed: "Helvetica")
        gameBy.text = "Bobo and Bibi's"
        gameBy.fontSize = 50
        gameBy.fontColor = SKColor.white
        gameBy.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.78)
        gameBy.zPosition = 1
        self.addChild(gameBy)
        
        
        let gameName1 = SKLabelNode(fontNamed: "The Bold Font")
        gameName1.fontSize = 200
        gameName1.text = "Escape"
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName3 = SKLabelNode(fontNamed: "The Bold Font")
        gameName3.fontSize = 80
        gameName3.text = "of"
        gameName3.fontColor = SKColor.white
        gameName3.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.66)
        gameName3.zPosition = 1
        self.addChild(gameName3)
        
        let gameName2 = SKLabelNode(fontNamed: "The Bold Font")
        gameName2.fontSize = 200
        gameName2.text = "Helen"
        gameName2.fontColor = SKColor.white
        gameName2.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.58)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        let startGame = SKLabelNode(fontNamed: "The Bold Font")
        startGame.fontSize = 190
        startGame.text = "Start Game"
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.45)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
        let startFunny = SKLabelNode(fontNamed: "The Bold Font")
        startFunny.fontSize = 100
        startFunny.text = "Funny Game"
        startFunny.fontColor = SKColor.white
        startFunny.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.365)
        startFunny.zPosition = 1
        startFunny.name = "startFunny"
        self.addChild(startFunny)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let nodeITapped = atPoint(pointOfTouch)
            if nodeITapped.name == "startButton" {
                fmInstance.funnyMode = false
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
                }
            if nodeITapped.name == "startFunny" {
                fmInstance.funnyMode = true
                changeMusic()
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
            }
        }
    }
    func changeMusic() {
        backingAudio.stop()
        let filePath = Bundle.main.path(forResource: "Backing Audio", ofType: "m4a")
        let audioNSURL = NSURL(fileURLWithPath: filePath!)
        do { backingAudio = try AVAudioPlayer(contentsOf: audioNSURL as URL) }
        catch { return print("Cannot Find Audio") }
        backingAudio.volume = 0.8
        backingAudio.numberOfLoops = -1
        backingAudio.play()
    }
    
}
