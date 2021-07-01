import UIKit

public typealias InteractiveTransitionBeganHandler = (Bool) -> Void

class PanGestureInteractiveTransition: InteractiveTransition {
    init(view: UIView, recognizedHandler: InteractiveTransitionBeganHandler?) {
        isActive = false
        recognizerView = view
        internalThreshold = 0.3
        super.init()

        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(recognizer:)))
        view.addGestureRecognizer(recognizer)
        handler = recognizedHandler

        self.recognizer = recognizer
    }

    var isActive: Bool

    var threshold: CGFloat {
        get {
            return internalThreshold
        }

        set {
            internalThreshold = max(min(1, newValue), 0)
        }
    }

    private var internalThreshold: CGFloat
    private weak var recognizer: UIPanGestureRecognizer!
    private weak var recognizerView: UIView!
    private var handler: InteractiveTransitionBeganHandler?
    private var isRightToLeft: Bool {
        return recognizer.velocity(in: recognizerView).x < 0
    }

    @objc private func panGestureHandler(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            isActive = true
            handler?(isRightToLeft)
        case .changed:
            let translation = recognizer.translation(in: recognizerView)
            let value = translation.x / recognizerView.bounds.width
            updateTransition(with: abs(value))

        case .ended:
            isActive = false
            if percent >= threshold {
                finishTransition()
            } else {
                cancelTransition()
            }
        case .cancelled, .failed:
            isActive = false
            cancelTransition()
        default:
            isActive = false
            break
        }
    }
}
