//
//  PushButton.swift
//  Flo
//
//  Created by Bijan Nazem on 2023-02-15.
//

import UIKit

class PushButton: UIButton {
    static let plusLineWidth = 3.0
    static let plusButtonScale = 0.6
    static let halfPointShift = 0.5

    // MARK: Properties
    var isAddButton = true
    var fillColor: UIColor = .systemGreen

    // MARK: Overrides
    override func draw(_ rect: CGRect) {
        let diameter = min(bounds.width, bounds.height)
        // TODO: add support for the landscape mode
        let offset = rect.midY - diameter / 2
        let ovalRect = CGRectMake(rect.origin.x, offset, diameter, diameter)
        let ovalPath = UIBezierPath(ovalIn: ovalRect)
        fillColor.setFill()
        ovalPath.fill()

        let plusWidth = diameter * Self.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        let plusPath = UIBezierPath()
        plusPath.lineWidth = Self.plusLineWidth
        plusPath.move(to: CGPointMake(halfWidth - halfPlusWidth + Self.halfPointShift, halfHeight + Self.halfPointShift))
        plusPath.addLine(to: CGPointMake(halfWidth + halfPlusWidth + Self.halfPointShift, halfHeight + Self.halfPointShift))
        if isAddButton {
            plusPath.move(to: CGPointMake(halfWidth + Self.halfPointShift, halfWidth - halfPlusWidth + Self.halfPointShift + offset))
            plusPath.addLine(to: CGPointMake(halfWidth + Self.halfPointShift, halfWidth + halfPlusWidth + Self.halfPointShift + offset))
        }
        UIColor.white.setStroke()
        plusPath.stroke()
    }

    convenience init() {
        self.init(type: .custom)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        styleSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions
    private func prepareSubviews() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: defaultSize),
            widthAnchor.constraint(equalTo: heightAnchor),
        ])
    }

    private func styleSubviews() {
    }

    private var halfWidth: CGFloat {
      return bounds.width / 2
    }

    private var halfHeight: CGFloat {
      return bounds.height / 2
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct PushButton_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                return PushButton()
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

