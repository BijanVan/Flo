//
//  MainViewController+Actions.swift
//  Flo
//
//  Created by Bijan Nazem on 2023-02-16.
//

import UIKit

extension MainViewController {
    @objc func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            if counterView.counter < CounterView.numberOfGlasses {
                counterView.counter += 1
            }
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }

        checkTotal()
        rotate(button: button)
    }

    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        let from = isGraphViewShowing ? graphView : counterView
        let to = isGraphViewShowing ? counterView : graphView

        UIView.transition(from: from, to: to, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews])

        isGraphViewShowing.toggle()
    }

    // MARK: Private functions
    private func checkTotal() {
      if counterView.counter >= 8 {
          counterView.medalView.isHidden = false
      } else {
          counterView.medalView.isHidden = true
      }
    }

    private func rotate(button: UIButton) {
        let layer = button.layer
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.keyTimes = [0, 1]
        animation.values = [0, CGFloat.pi]
        animation.duration = 0.25
        layer.add(animation, forKey: "transform.rotation")
    }
}
