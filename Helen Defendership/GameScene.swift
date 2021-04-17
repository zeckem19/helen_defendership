//
//  GameScene.swift
//  Happy birthday Helen
//
//  Created by zeckem19on 3/2/18.
//  Copyright © 2018 Lim Ze Hwee Zoe. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let funMode = fmInstance.funnyMode
    enum gameState{
        case preGame
        case inGame
        case afterGame
        //case menu
    }
    
    let tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
    var currentGameState = gameState.preGame
    
    var player = SKSpriteNode(imageNamed: "playerShip")
    var levelNumber = 1
    var livesNumber = 4
    
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletSound.m4a", waitForCompletion: false)
    let bulletSound2 = SKAction.playSoundFileNamed("chiu.m4a", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSound3.m4a", waitForCompletion: false)
    
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player: UInt32 = 0b1    //1
        static let Bullet: UInt32 = 0b10    //2
        static let Enemy: UInt32 = 0b100 //4
        static let SBullet: UInt32 = 0b1000 //8
    }
    
    let gameArea : CGRect
    
    
    // random utility functions
    func random2() -> UInt32{
        return arc4random_uniform(2)
    }
    func random10() -> UInt32 {
        return arc4random_uniform(15+(60/UInt32(levelNumber)))
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    

    override init(size: CGSize){
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth)/2
        gameArea = CGRect(x:margin, y:0, width: playableWidth, height: size.height)
        if funMode == true {
            player = SKSpriteNode(imageNamed: "playerShip2")
        }
        super.init(size: size)
    }
    required init?(coder aDecoder:NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView){
        //        for family: String in UIFont.familyNames {
        //            print("\(family)")
        //            for names: String in UIFont.fontNames(forFamilyName: family) {
        //                print("== \(names)")
        //            }
        //        }
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        for i in 0...1 {
            let background = SKSpriteNode( imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width/2,
                                          y: self.size.height*CGFloat(i))
            background.zPosition = 0
            background.name = "Background"
            self.addChild(background)
        }


        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        
        // Physics
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        // Score Label
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width*0.15, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        
        livesLabel.text = "Lives: 4"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100
        
        self.addChild(livesLabel)
        self.addChild(scoreLabel)
        
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 120
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.zPosition = 1
        tapToStartLabel.alpha = 0

        self.addChild(tapToStartLabel)
        
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.4)
        scoreLabel.run(moveOnToScreenAction)
        livesLabel.run(moveOnToScreenAction)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.42)
        tapToStartLabel.run(fadeInAction)
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 600.0
    // background mover
    override func update( _ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSecond * CGFloat(deltaFrameTime)
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            if self.currentGameState == gameState.inGame {
                background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height {
                background.position.y += self.size.height * 2
            }
        }
    }
    func addLife(){
        livesNumber += 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.6, duration: 0.3)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
    }
    
    func loseALife(){
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        let scaleUp = SKAction.scale(to: 1.6, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0{
            runGameOver()
        }
    }
    
    func addScore(){
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore%10 == 0  {
            startNewLevel()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body2.categoryBitMask == PhysicsCategories.SBullet {
            addScore()
            addLife()
            spawnExplosion(spawnPosition: body1.node!.position)
            body1.node?.removeFromParent()
        }
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            // if the player hit the enemy
            
            if body2.node != nil {
                if body2.node!.position.y > self.size.height {
                    return
                } else {
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            runGameOver()
        }
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy {
            // bullet hits enemy
            
            addScore()
            
            
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed : "explosition")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        
        self.addChild(explosion)
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete =  SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([explosionSound,scaleIn,fadeOut,delete])
        
        explosion.run(explosionSequence)
    }
    
    func startNewLevel(){
        levelNumber += 1
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        var levelDuration = TimeInterval()
        switch levelNumber {
            case 1: levelDuration = 2.0
            case 2: levelDuration = 1.8
            case 3: levelDuration = 1.6
            case 4: levelDuration = 1.4
            case 5: levelDuration = 1.2
            case 6: levelDuration = 1.0
            case 7: levelDuration = 0.9
            default: levelDuration = 0.8
        }
        if funMode == true {
            switch levelNumber {
            case 1: levelDuration = 1.0
            case 2: levelDuration = 0.7
            case 3: levelDuration = 0.5
            case 4: levelDuration = 0.4
            case 5: levelDuration = 0.3
            case 6: levelDuration = 0.2
            case 7: levelDuration = 0.1
            default: levelDuration = 0.05
            }
        }
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn,spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }
    
    func firebullet(){
        
        let bullet = SKSpriteNode( imageNamed: "bullet")

        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        // physics
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        bullet.zPosition = 1
        

        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence2 = SKAction.sequence([bulletSound2, moveBullet,deleteBullet])
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet,deleteBullet])
        if random2() == 1 {
            bullet.run(bulletSequence)
        } else {
            bullet.run(bulletSequence2)
        }
    }
    func fireSpecialBullet() {
        var Sbullet = SKSpriteNode( imageNamed: "bullet2")
        if random2() == 1{
            Sbullet = SKSpriteNode(imageNamed: "Sbull2")
        }
        Sbullet.name = "SBullet"
        Sbullet.setScale(0.75)
        Sbullet.position = player.position
        // physics
        Sbullet.physicsBody = SKPhysicsBody(rectangleOf: Sbullet.size)
        Sbullet.physicsBody!.affectedByGravity = false
        Sbullet.physicsBody!.categoryBitMask = PhysicsCategories.SBullet
        Sbullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        Sbullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        Sbullet.zPosition = 1
        
        
        self.addChild(Sbullet)
        
        let moveSBullet = SKAction.moveTo(y: self.size.height + Sbullet.size.height, duration: 2.5)
        let deleteSBullet = SKAction.removeFromParent()
        let SbulletSequence = SKAction.sequence([bulletSound, moveSBullet,deleteSBullet])
        Sbullet.run(SbulletSequence)
    }
    
    func startGame() {
        currentGameState = gameState.inGame

        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipOntoScreenAction,startLevelAction])
        player.run(startGameSequence)
        
    }
    
    func spawnEnemy(){
        let randomXstart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXend = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXstart, y: self.size.height*1.2)
        let endPoint = CGPoint(x: randomXend, y: -self.size.height*0.2)
        var enemy = SKSpriteNode(imageNamed: "enemyShip")
        if funMode == true{
            if random2() == 1 {
                enemy = SKSpriteNode(imageNamed: "enemyShip2")
            } else {
                enemy = SKSpriteNode(imageNamed: "enemyShip3")
            }
        }
        
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        //Physics
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        
        
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration:1.9)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy,deleteEnemy,loseALifeAction])
        if currentGameState == gameState.inGame {
            enemy.run(enemySequence)
        }
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        
        let amountToRotate = atan2(dy,dx)
        
        enemy.zRotation = amountToRotate
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame {
            startGame()
        }
        else if currentGameState == gameState.inGame {
            if funMode == true && random10() == 7 {
                    fireSpecialBullet()
            } else {
                firebullet()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDragged
            }
            if player.position.x > gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            if player.position.x < gameArea.minX + player.size.width/2 {
                player.position.x = gameArea.minX + player.size.width/2
            }
        }
    }
    
    func runGameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1.2)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
    }
    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let transition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
        
    }
}

