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
    }
}
