import SpriteKit

extension CGFloat {
    
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

class BubblesScene: SIFloatingCollectionScene {
    
    var bottomOffset: CGFloat = 200
    var topOffset: CGFloat = 0
    
    var onTap: ((String) -> Void)?
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        configure()
    }
    
    override func addChild(_ node: SKNode) {
        if node is BubbleNode {
            var x = CGFloat.random(min: -bottomOffset, max: -node.frame.size.width)
            let y = CGFloat.random(
                min: 50,
                max: 150
            )
            
            if floatingNodes.count % 2 == 0 || floatingNodes.isEmpty {
                x = CGFloat.random(
                    min: frame.size.width + node.frame.size.width,
                    max: frame.size.width + bottomOffset
                )
            }
            
            if let node = node as? BubbleNode {
                node.onTap = onTap
            }
            node.position = CGPoint(x: x, y: y)
        }
        super.addChild(node)
    }
    
    override func updateChild(_ node: SKNode, iteration: Int, status: Bool = false) {
        if status {
            if(iteration == 0) {
                floatingNodes = []
                
                let count = children.count
                var childs: [SKNode] = []
                
                for i in 0..<count {
                    childs.append(children[i])
                }
                
                self.removeChildren(in: childs)
            }
        }
        
        if node is BubbleNode {
            var x = CGFloat.random(min: -bottomOffset, max: -node.frame.size.width)
            let y = CGFloat.random(
                min: 50,
                max: 150
            )
            
            if floatingNodes.count % 2 == 0 || floatingNodes.isEmpty {
                x = CGFloat.random(
                    min: frame.size.width + node.frame.size.width,
                    max: frame.size.width + bottomOffset
                )
            }
            
            if let node = node as? BubbleNode {
                node.onTap = onTap
            }
            node.position = CGPoint(x: x, y: y)
        }
        
        if let newNode = node as? SIFloatingNode {
            configureNode(newNode)
            self.floatingNodes.append(newNode)
        }
        
        super.addChild(node)
        
    }
    
    fileprivate func configure() {
        backgroundColor = SKColor.white
        scaleMode = .aspectFill
        allowMultipleSelection = false
        allowEditing = true
        var bodyFrame = frame
        bodyFrame.size.width = CGFloat(magneticField.minimumRadius)
        bodyFrame.origin.x -= bodyFrame.size.width / 2
        bodyFrame.size.height = frame.size.height - bottomOffset
        bodyFrame.origin.y = frame.size.height - bodyFrame.size.height - topOffset
        physicsBody = SKPhysicsBody(edgeLoopFrom: bodyFrame)
        magneticField.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 + bottomOffset / 2 - topOffset)
    }
    
    func performCommitSelectionAnimation() {
        let currentPhysicsSpeed = physicsWorld.speed
        physicsWorld.speed = 0
        let sortedNodes = sortedFloatingNodes()
        var actions: [SKAction] = []
        
        for node in sortedNodes {
            node.physicsBody = nil
            let action = actionForFloatingNode(node)
            actions.append(action)
        }
        
        run(SKAction.sequence(actions)) { [weak self] in
            self?.physicsWorld.speed = currentPhysicsSpeed
        }
    }

    func sortedFloatingNodes() -> [SIFloatingNode] {
        return floatingNodes.sorted { (node: SIFloatingNode, nextNode: SIFloatingNode) -> Bool in
            let distance = node.position.distance(from: magneticField.position)
            let nextDistance = nextNode.position.distance(from: magneticField.position)
            return distance < nextDistance && node.state != .selected
        }
    }
    
    func actionForFloatingNode(_ node: SIFloatingNode!) -> SKAction {
        let action = SKAction.run { [unowned self] () -> Void in
            if let index = self.floatingNodes.index(of: node) {
                self.removeFloatingNode(at: index)
                
                if node.state == .selected {
                    let destinationPoint = CGPoint(x: self.size.width / 2, y: self.size.height - 40)
                    (node as? BubbleNode)?.throw(to: destinationPoint) {
                        node.removeFromParent()
                    }
                }
            }
        }
        return action
    }
}
