//
//  BackgroundView.swift
//  Flo
//
//  Created by Bijan Nazem on 2023-02-17.
//

import UIKit

class BackgroundView: UIView {
    // MARK: Properties
    var lightColor: UIColor = .systemOrange
    var darkColor: UIColor = .systemYellow
    var patternSize: CGFloat = 100

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        styleSubviews()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("\(#function):\(#line) Failed to get current context.")
        }
        
        context.setFillColor(darkColor.cgColor)
        context.fill(CGRectMake(0, 0, patternSize, patternSize))
        UIColor(patternImage: pattern()).setFill()
        context.fill(rect)
    }

    // MARK: Private functions
    private func prepareSubviews() {
    }

    private func styleSubviews() {
        isOpaque = false
    }

    private func pattern() -> UIImage {
        let drawSize = CGSizeMake(patternSize, patternSize)
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        guard let drawingContext = UIGraphicsGetCurrentContext() else {
          fatalError("\(#function):\(#line) Failed to get current context.")
        }

        darkColor.setFill()
        drawingContext.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))

        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPointMake(patternSize / 2, 0))
        trianglePath.addLine(to: CGPointMake(0, patternSize / 2))
        trianglePath.addLine(to: CGPointMake(patternSize, patternSize / 2))

        trianglePath.move(to: CGPointMake(0, patternSize / 2))
        trianglePath.addLine(to: CGPointMake(patternSize / 2, patternSize))
        trianglePath.addLine(to: CGPointMake(0, patternSize))
        trianglePath.addLine(to: CGPointMake(0, patternSize / 2))

        trianglePath.move(to: CGPointMake(patternSize, patternSize / 2))
        trianglePath.addLine(to: CGPointMake(patternSize, patternSize))
        trianglePath.addLine(to: CGPointMake(patternSize / 2, patternSize))
        trianglePath.addLine(to: CGPointMake(patternSize, patternSize / 2))

        lightColor.setFill()
        trianglePath.fill()

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
          fatalError("\(#function):\(#line) Failed to get an image from current context.")
        }
        UIGraphicsEndImageContext()

        return image
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct BackgroundView_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                return BackgroundView()
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
