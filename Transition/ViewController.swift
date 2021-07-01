

import UIKit

class ViewController: UIViewController, ChildTransition {
    private var internalAnimator: PageCurlAnimator = {
        let animator = PageCurlAnimator()
        animator.isAnimated = true
        return animator
    }()

    var transitionAnimator: Animator? {
        return internalAnimator
    }

    @IBOutlet private weak var previousButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet internal weak var containerView: UIView!

    var count: Int = 0
    var all: [UIColor] = {
        return [.red, .orange, .yellow, .green, .cyan, .blue, .purple]
    }()

    var previousChild: ColorViewController?
    var currentChild: ColorViewController?
    var previousIndex: Int = NSNotFound
    var currentIndex: Int = NSNotFound

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        count = all.count
        addChild(at: 0)
        enableInteractiveTransition { [weak self] next in
            guard let vc = self else { return }
            vc.internalAnimator.slideToLeft = next
            if next {
                vc.addChild(at: vc.currentIndex + 1)
            } else {
                vc.addChild(at: vc.currentIndex - 1)
            }
        }
    }

    @IBAction private func previousAction(_ button: UIButton) {
        internalAnimator.slideToLeft = false
        addChild(at: currentIndex - 1)
    }

    @IBAction private func nextAction(_ button: UIButton) {
        internalAnimator.slideToLeft = true
        addChild(at: currentIndex + 1)
    }

    func addChild(at index: Int) {
        guard let vc = childViewController(at: index) else {
            return
        }

        startTransition(from: currentChild, to: vc)
        previousChild = currentChild
        previousIndex = currentIndex
        currentChild = vc
        currentIndex = index

        previousButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < count - 1
    }

    func childViewController(at index: Int) -> ColorViewController? {
        guard index >= 0, index < all.count else {
            return nil
        }

        let viewController = ColorViewController()
        viewController.color = all[index]
        viewController.index = index
        return viewController
    }

    func transitionDidFinished(_ completed: Bool) {
        if completed {
            previousChild = nil
        } else {
            currentChild = previousChild
            currentIndex = previousIndex
        }
    }
}

class ColorViewController: UIViewController {
    var color: UIColor?
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = color
    }
}
