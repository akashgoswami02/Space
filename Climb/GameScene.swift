//
//  GameScene.swift
//  Climb
//
//  Created by Akash Goswami on 1/28/16.
//  Copyright (c) 2016 Akash Goswami. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    
    static let ship : UInt32 = 0x1 << 1
    static let block : UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    @objc var ship = SKSpriteNode()
    @objc var score = Int()
    @objc var block = SKNode()
    @objc var moveAndRemove = SKAction()
    @objc var gameStarted = Bool ()
    @objc var isAlive = Bool ()
    
    override func didMove(to view: SKView) {
       
        /* Setup your scene here */
        /*let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)*/
        
        createScene()
        
        /*block.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        block.physicsBody?.affectedByGravity = false
        block.setScale(0.5)
        self.addChild(block)*/
        
        
        
    }
    
    @objc func createScene() {
        
        ship = SKSpriteNode (imageNamed: "Ufo")
        
        ship.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4)
        ship.setScale(0.3)
        
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.frame.width/2)
        ship.physicsBody?.categoryBitMask = PhysicsCategory.ship
        ship.physicsBody?.collisionBitMask = PhysicsCategory.block
        ship.physicsBody?.contactTestBitMask = PhysicsCategory.block
        
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.allowsRotation = false
        
        ship.physicsBody?.affectedByGravity = false
        ship.zPosition = 1
        
        self.addChild(ship)
        
        isAlive = true
    }
    
    @objc func createBlocks() {
     
        block = SKNode()
        
        let leftBlock = SKSpriteNode(imageNamed: "Block")
        let rightBlock = SKSpriteNode(imageNamed: "Block")
        
        leftBlock.position = CGPoint(x: self.frame.width/2 + 200, y: self.frame.height)
        rightBlock.position = CGPoint(x: self.frame.width/2 - 200, y: self.frame.height)
        
        leftBlock.setScale(0.5)
        rightBlock.setScale(0.5)
        
        leftBlock.physicsBody = SKPhysicsBody(rectangleOf: leftBlock.size)
        leftBlock.physicsBody?.categoryBitMask = PhysicsCategory.block
        leftBlock.physicsBody?.collisionBitMask = PhysicsCategory.ship
        leftBlock.physicsBody?.contactTestBitMask = PhysicsCategory.ship
        leftBlock.physicsBody?.isDynamic = false
        leftBlock.physicsBody?.affectedByGravity = false
        
        rightBlock.physicsBody = SKPhysicsBody(rectangleOf: rightBlock.size)
        rightBlock.physicsBody?.categoryBitMask = PhysicsCategory.block
        rightBlock.physicsBody?.collisionBitMask = PhysicsCategory.ship
        rightBlock.physicsBody?.contactTestBitMask = PhysicsCategory.ship
        rightBlock.physicsBody?.isDynamic = false
        rightBlock.physicsBody?.affectedByGravity = false
        
        
    
        block.addChild(leftBlock)
        block.addChild(rightBlock)
        
        block.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -50, max: 50)
        block.position.x = randomPosition
        
        //block.position.x = 30
        
        //block.physicsBody?.isDynamic = false
        //block.physicsBody?.affectedByGravity = false
       
        block.run(moveAndRemove)
        
        self.addChild(block)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
        
        if gameStarted == false {
            
            gameStarted = true
            
            let spawn = SKAction.run({
                () in
                
                self.createBlocks()
            })
            
            let delay = SKAction.wait(forDuration: 1.5)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            let distance = CGFloat(self.frame.height +  block.frame.height + block.frame.height)
            let moveBlocks = SKAction.moveBy(x: 0, y: -distance - block.frame.height, duration: TimeInterval (0.01*distance))
        
            let removeBlocks = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([moveBlocks, removeBlocks])
            
            /*for touch in touches {
                
                let location = touch.locationInNode(self)
                
                ship.position.x = location.x
                
                //let sprite = SKSpriteNode(imageNamed:"Spaceship")
                
                // sprite.xScale = 0.5
                // sprite.yScale = 0.5
                // sprite.position = location
                
                //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
                
                //sprite.runAction(SKAction.repeatActionForever(action))
                
                //self.addChild(sprite)
            }*/
        }
        else {
            
            if isAlive == true {
            
            for touch in touches {
            
                    let location = touch.location(in: self)
                
                    ship.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                
                    if location.x > self.frame.width / 2 {
                        ship.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 0))
                    }
                    else {
                        ship.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0))
                    }
                }
            }
                
                /*for touch in touches {
        
                    let location = touch.locationInNode(self)
            
                    ship.position.x = location.x
            
            //let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
           // sprite.xScale = 0.5
           // sprite.yScale = 0.5
           // sprite.position = location
            
            //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            //sprite.runAction(SKAction.repeatActionForever(action))
            
            //self.addChild(sprite)
            }*/
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
       /* let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == PhysicsCategory.ship && bodyB.categoryBitMask == PhysicsCategory.block {
            
            ship.speed = 0
            self.removeAllActions()
            self.removeAllChildren()
            isAlive = false
            score = 0
            createScene()
        
        }
        
        if bodyA.categoryBitMask == PhysicsCategory.block && bodyB.categoryBitMask == PhysicsCategory.ship {
            
            ship.speed = 0
            self.removeAllActions()
            self.removeAllChildren()
            isAlive = false
            score = 0
            createScene()
        }*/
        
        ship.speed = 0
        self.removeAllActions()
        self.removeAllChildren()
        isAlive = false
        createScene()
    }
    
    /*override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.locationInNode(self)
            
            ship.position.x = location.x
        }
    }*/
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
