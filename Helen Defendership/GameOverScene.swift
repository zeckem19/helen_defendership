//
//  GameOverScene.swift
//  Helen Defendership
//
//  Created by zeckem19on 6/2/18.
//  Copyright © 2018 Lim Ze Hwee Zoe. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    let perfectSound = SKAction.playSoundFileNamed("wellDoneBibi.m4a", waitForCompletion: false)
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    let mainMenuLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 190
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y:self.size.height*0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        var playSound = false
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
            playSound = true
        }

        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 125
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.45)
        self.addChild(highScoreLabel)
        highScoreLabel.zPosition = 4
        
        if playSound == true{
            highScoreLabel.text = "New High Score: \(highScoreNumber)"
            highScoreLabel.fontSize = 100
            let scaleUp = SKAction.scale(to: 1.7, duration: 0.4)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            let scaleSequence = SKAction.sequence([perfectSound,scaleUp, scaleDown])
            highScoreLabel.run(scaleSequence)
            playSound = false
        }
        
        restartLabel.text = "Restart"
        restartLabel.fontSize = 125
        restartLabel.fontColor = SKColor.white
        restartLabel.zPosition = 1
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.3)
        self.addChild(restartLabel)
        
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontSize = 125
        mainMenuLabel.fontColor = SKColor.white
        mainMenuLabel.zPosition = 1
        mainMenuLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.2)
        self.addChild(mainMenuLabel)
        

    }
    
   
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            if restartLabel.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
            }
            if mainMenuLabel.contains(pointOfTouch){
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
            }
        }
    }
}
