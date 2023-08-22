import SpriteKit

extension CGPoint {
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - self.x, point.y - self.y)
    }
}

@objc public protocol SKFloatingCollectionSceneDelegate {
    @objc optional func floatingScene(_ scene: SKFloatingCollectionScene, shouldSelectFloatingNodeAt index: Int) -> Bool
    @objc optional func floatingScene(_ scene: SKFloatingCollectionScene, didSelectFloatingNodeAt index: Int)

    @objc optional func floatingScene(_ scene: SKFloatingCollectionScene, shouldDeselectFloatingNodeAt index: Int) -> Bool
    @objc optional func floatingScene(_ scene: SKFloatingCollectionScene, didDeselectFloatingNodeAt index: Int)

    @objc optional func floatingScene(_ scene: SKFloatingCollectionScene, startedRemovingOfFloatingNodeAt index: Int)
    @objc optional func floatingScene(_ scene: SKFloatingCollectionScene, canceledRemovingOfFloatingNodeAt index: Int)

    @objc optional func floatingScene(_ scene: SKFloatingCollectionScene, shouldRemoveFloatingNodeAt index: Int) -> Bool
    @objc optional func floatingScene(_ scene: SKFloatingCollectionScene, didRemoveFloatingNodeAt index: Int)
}

public enum SKFloatingCollectionSceneMode {
    case normal
    case editing
    case moving
}

open class SKFloatingCollectionScene: SKScene {
    public private(set) var magneticField = SKFieldNode.radialGravityField()
    private(set) var mode: SKFloatingCollectionSceneMode = .normal {
        didSet {
            modeUpdated()
        }
    }
    public var floatingNodes: [SKFloatingNode] = []

    private var touchPoint: CGPoint?
    private var touchStartedTime: TimeInterval?
    private var removingStartedTime: TimeInterval?

    open var timeToStartRemoving: TimeInterval = 0.7
    open var timeToRemove: TimeInterval = 2
    open var allowEditing = false
    open var allowMultipleSelection = true
    open var restrictedToBounds = true
    open var pushStrength: CGFloat = 10_000

    open weak var floatingDelegate: SKFloatingCollectionSceneDelegate?

    override open func didMove(to view: SKView) {
        super.didMove(to: view)
        configure()
    }

    // MARK: -
    // MARK: Frame Updates
    // @todo refactoring
    override open func update(_ currentTime: TimeInterval) {
        floatingNodes.forEach { node in
            let distanceFromCenter = self.magneticField.position.distance(from: node.position)
            node.physicsBody?.linearDamping = 2

            if distanceFromCenter <= 100 {
                node.physicsBody?.linearDamping += ((100 - distanceFromCenter) / 10)
            }
        }

        if mode == .moving || !allowEditing {
            return
        }

        if let touchStartedTime, let touchPoint {
            let deltaTime = currentTime - touchStartedTime
            if deltaTime >= timeToStartRemoving {
                self.touchStartedTime = nil

                if let node = atPoint(touchPoint) as? SKFloatingNode {
                    removingStartedTime = currentTime
                    startRemovingNode(node)
                }
            }
        } else if mode == .editing, let removingStartedTime, let touchPoint {
            let deltaTime = currentTime - removingStartedTime

            if deltaTime >= timeToRemove {
                self.removingStartedTime = nil

                if let node = atPoint(touchPoint) as? SKFloatingNode {
                    if let index = floatingNodes.firstIndex(of: node) {
                        removeFloatingNode(at: index)
                    }
                }
            }
        }
    }

    // MARK: -
    // MARK: Touching Handlers
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            touchPoint = touch.location(in: self)
            touchStartedTime = touch.timestamp
        }
    }

    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .editing {
            return
        }

        if let touch = touches.first as UITouch? {
            let plin = touch.previousLocation(in: self)
            let lin = touch.location(in: self)
            var distanceX = lin.x - plin.x
            var distanceY = lin.y - plin.y
            let bevelDegree = sqrt(pow(lin.x, 2) + pow(lin.y, 2))
            distanceX = bevelDegree == 0 ? 0 : (distanceX / bevelDegree)
            distanceY = bevelDegree == 0 ? 0 : (distanceY / bevelDegree)

            if distanceX == 0 && distanceY == 0 {
                return
            } else if mode != .moving {
                mode = .moving
            }

            for node in floatingNodes {
                let width = node.frame.size.width / 2
                let height = node.frame.size.height / 2
                var direction = CGVector(
                    dx: pushStrength * distanceX,
                    dy: pushStrength * distanceY
                )

                if restrictedToBounds {
                    if !(-width...(size.width + width) ~= node.position.x) && (node.position.x * distanceX) > 0 {
                        direction.dx = 0
                    }

                    if !(-height...(size.height + height) ~= node.position.y) && (node.position.y * distanceY) > 0 {
                        direction.dy = 0
                    }
                }
                node.physicsBody?.applyForce(direction)
            }
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode != .moving, let touchPoint {
            if let node = atPoint(touchPoint) as? SKFloatingNode {
                updateState(of: node)
            }
        }
        mode = .normal
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        mode = .normal
    }

    // MARK: -
    // MARK: Nodes Manipulation
    private func cancelRemovingNode(_ node: SKFloatingNode!) {
        mode = .normal
        node.physicsBody?.isDynamic = true
        node.state = node.previousState

        if let index = floatingNodes.firstIndex(of: node) {
            floatingDelegate?.floatingScene?(self, canceledRemovingOfFloatingNodeAt: index)
        }
    }

    open func floatingNode(at index: Int) -> SKFloatingNode? {
        if 0..<floatingNodes.count ~= index {
            return floatingNodes[index]
        }
        return nil
    }

    open func indexOfSelectedNode() -> Int? {
        return indexesOfSelectedNodes().first
    }

    open func indexesOfSelectedNodes() -> [Int] {
        var indexes: [Int] = []

        for (iteration, node) in floatingNodes.enumerated() where node.state == .selected {
            indexes.append(iteration)
        }
        return indexes
    }

    override open func atPoint(_ point: CGPoint) -> SKNode {
        var currentNode = super.atPoint(point)

        while !(currentNode.parent is SKScene) && !(currentNode is SKFloatingNode)
            && (currentNode.parent != nil) && !currentNode.isUserInteractionEnabled {
                currentNode = currentNode.parent!
        }
        return currentNode
    }

    open func removeFloatingNode(at index: Int) {
        if shouldRemoveNode(at: index) {
            let node = floatingNodes[index]
            floatingNodes.remove(at: index)
            node.removeFromParent()
            floatingDelegate?.floatingScene?(self, didRemoveFloatingNodeAt: index)
        }
    }

    private func startRemovingNode(_ node: SKFloatingNode) {
        mode = .editing
        node.physicsBody?.isDynamic = false
        node.state = .removing

        if let index = floatingNodes.firstIndex(of: node) {
            floatingDelegate?.floatingScene?(self, startedRemovingOfFloatingNodeAt: index)
        }
    }

    private func updateState(of node: SKFloatingNode) {
        if let index = floatingNodes.firstIndex(of: node) {
            switch node.state {
            case .normal:
                if shouldSelectNode(at: index) {
                    if !allowMultipleSelection, let selectedIndex = indexOfSelectedNode() {
                        let node = floatingNodes[selectedIndex]
                        updateState(of: node)
                    }
                    node.state = .selected
                    floatingDelegate?.floatingScene?(self, didSelectFloatingNodeAt: index)
                }

            case .selected:
                if shouldDeselectNode(at: index) {
                    node.state = .normal
                    floatingDelegate?.floatingScene?(self, didDeselectFloatingNodeAt: index)
                }

            case .removing:
                cancelRemovingNode(node)
            }
        }
    }

    // MARK: -
    // MARK: Configuration
    override open func addChild(_ node: SKNode) {
        if let newNode = node as? SKFloatingNode {
            configureNode(newNode)
            floatingNodes.append(newNode)
        }

        super.addChild(node)
    }

    open func updateChild(_ node: SKNode, iteration: Int, status: Bool = false) {
        super.removeAllChildren()

        let reeNode = node as? SKFloatingNode
        configureNode(reeNode)
        floatingNodes.append(reeNode!)

        super.addChild(node)
    }

    private func configure() {
        physicsWorld.gravity = CGVector.zero
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        magneticField = SKFieldNode.radialGravityField()
        magneticField.region = SKRegion(radius: 10_000)
        magneticField.minimumRadius = 10_000
        magneticField.strength = 8000
        magneticField.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(magneticField)
    }

    func configureNode(_ node: SKFloatingNode!) {
        if node.physicsBody == nil {
            let path = node.path ?? CGMutablePath()
            node.physicsBody = SKPhysicsBody(polygonFrom: path)
        }
        node.physicsBody?.isDynamic = true
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.mass = 0.3
        node.physicsBody?.friction = 0
        node.physicsBody?.linearDamping = 3
    }

    private func modeUpdated() {
        switch mode {
        case .normal, .moving:
            touchStartedTime = nil
            removingStartedTime = nil
            touchPoint = nil
        default: ()
        }
    }

    // MARK: -
    // MARK: Floating Delegate Helpers
    private func shouldRemoveNode(at index: Int) -> Bool {
        if 0..<floatingNodes.count ~= index {
            if let shouldRemove = floatingDelegate?.floatingScene?(self, shouldRemoveFloatingNodeAt: index) {
                return shouldRemove
            }
            return true
        }
        return false
    }

    private func shouldSelectNode(at index: Int) -> Bool {
        if let shouldSelect = floatingDelegate?.floatingScene?(self, shouldSelectFloatingNodeAt: index) {
            return shouldSelect
        }
        return true
    }

    private func shouldDeselectNode(at index: Int) -> Bool {
        if let shouldDeselect = floatingDelegate?.floatingScene?(self, shouldDeselectFloatingNodeAt: index) {
            return shouldDeselect
        }
        return true
    }
}
