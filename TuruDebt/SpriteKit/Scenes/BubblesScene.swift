import SpriteKit

extension CGFloat {
    public static func random() -> CGFloat {
        let randomValue: CGFloat = CGFloat(Float.random(in: 0..<100) / Float(0xFFFFFFFF))
        return randomValue
    }

    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}

class BubblesScene: SKFloatingCollectionScene {
    var bottomOffset: CGFloat = 200
    var topOffset: CGFloat = 0

    var onTap: ((String) -> Void)?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configure()
    }

    override func addChild(_ node: SKNode) {
        if node is BubbleNode {
            var xPosition = CGFloat.random(min: -bottomOffset, max: -node.frame.size.width)
            let yPosition = CGFloat.random(
                min: 50,
                max: 150
            )

            if floatingNodes.count % 2 == 0 || floatingNodes.isEmpty {
                xPosition = CGFloat.random(
                    min: frame.size.width + node.frame.size.width,
                    max: frame.size.width + bottomOffset
                )
            }

            if let node = node as? BubbleNode {
                node.onTap = onTap
            }
            node.position = CGPoint(x: xPosition, y: yPosition)
        }
        super.addChild(node)
    }

    override func updateChild(_ node: SKNode, iteration: Int, status: Bool = false) {
        if status {
            if iteration == 0 {
                floatingNodes = []

                let count = children.count
                var childs: [SKNode] = []

                for iteration in 0..<count {
                    childs.append(children[iteration])
                }

                self.removeChildren(in: childs)
            }
        }

        if node is BubbleNode {
            var xPosition = CGFloat.random(min: -bottomOffset, max: -node.frame.size.width)
            let yPosition = CGFloat.random(
                min: 50,
                max: 150
            )

            if floatingNodes.count % 2 == 0 || floatingNodes.isEmpty {
                xPosition = CGFloat.random(
                    min: frame.size.width + node.frame.size.width,
                    max: frame.size.width + bottomOffset
                )
            }

            if let node = node as? BubbleNode {
                node.onTap = onTap
            }
            node.position = CGPoint(x: xPosition, y: yPosition)
        }

        if let newNode = node as? SKFloatingNode {
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

    func sortedFloatingNodes() -> [SKFloatingNode] {
        return floatingNodes.sorted { (node: SKFloatingNode, nextNode: SKFloatingNode) -> Bool in
            let distance = node.position.distance(from: magneticField.position)
            let nextDistance = nextNode.position.distance(from: magneticField.position)
            return distance < nextDistance && node.state != .selected
        }
    }

    func actionForFloatingNode(_ node: SKFloatingNode!) -> SKAction {
        return SKAction.run { [unowned self] () -> Void in
            if let index = self.floatingNodes.firstIndex(of: node) {
                self.removeFloatingNode(at: index)

                if node.state == .selected {
                    let destinationPoint = CGPoint(x: self.size.width / 2, y: self.size.height - 40)
                    (node as? BubbleNode)?.throw(to: destinationPoint) {
                        node.removeFromParent()
                    }
                }
            }
        }
    }
}
