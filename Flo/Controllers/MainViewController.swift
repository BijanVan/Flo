//
//  ViewController.swift
//  Flo
//
//  Created by Bijan Nazem on 2023-02-15.
//

import UIKit

class MainViewController: UIViewController {
    let addButton = PushButton()
    let removeButton = PushButton()
    let counterView = CounterView()

    static let addButtonWidth = 100.0
    static let removeButtonWidth = 50.0

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSubviews()
        styleSubviews()
    }

    // MARK: Private functions
    private func prepareSubviews() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        counterView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(counterView)
        view.addSubview(addButton)
        view.addSubview(removeButton)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            counterView.topAnchor.constraint(equalTo: guide.topAnchor),
            counterView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            counterView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            counterView.widthAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8),
        ])

        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: counterView.bottomAnchor, constant: defaultSpacing),
            addButton.widthAnchor.constraint(equalToConstant: Self.addButtonWidth),
            addButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: defaultSpacing),
            removeButton.widthAnchor.constraint(equalToConstant: Self.removeButtonWidth),
            removeButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
        ])
    }

    private func styleSubviews() {
        addButton.fillColor = .systemGray
        addButton.addTarget(self, action: #selector(pushButtonPressed(_:)), for: .touchUpInside)
        
        removeButton.isAddButton = false
        removeButton.fillColor = .systemRed
        removeButton.addTarget(self, action: #selector(pushButtonPressed(_:)), for: .touchUpInside)

        counterView.counterColor = .systemGray2
        counterView.outlineColor = .systemGray
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct MainViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                MainViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

