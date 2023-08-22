import SpriteKit
import UIKit

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
    }
}
