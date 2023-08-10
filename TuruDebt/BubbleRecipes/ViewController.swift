//
//  ViewController.swift
//  Example
//
//  Created by Neverland on 15.08.15.
//  Copyright (c) 2015 ProudOfZiggy. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    fileprivate var skView: SKView!
    fileprivate var floatingCollectionScene: BubblesScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = SKView(frame: UIScreen.main.bounds)
        skView.backgroundColor = SKColor.white
        view.addSubview(skView)
        
        floatingCollectionScene = BubblesScene(size: skView.bounds.size)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        floatingCollectionScene.topOffset = 100 + statusBarHeight
        skView.presentScene(floatingCollectionScene)
        
//        addBubble()
    }
    
//    @objc func addBubble() {
//        let newNode = BubbleNode.instantiate()
//        floatingCollectionScene.addChild(newNode)
//    }
}

