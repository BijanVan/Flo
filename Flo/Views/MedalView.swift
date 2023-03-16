//
//  MedalView.swift
//  Flo
//
//  Created by Bijan Nazem on 2023-02-19.
//

import UIKit

class MedalView: UIImageView {
    // MARK: Properties

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        prepareSubviews()
        styleSubviews()
    }

    // MARK: Overrides
    override func layoutSubviews() {
        image = createMedalImage()
    }

    // MARK: Private functions
    private func prepareSubviews() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: defaultSize),
            heightAnchor.constraint(greaterThanOrEqualToConstant: defaultSize),
        ])
    }

    private func styleSubviews() {
    }

    private func createMedalImage() -> UIImage {
        let width = bounds.width
        let height = bounds.height
        let ribbonWidth = width / 4
        let ribbonHeight = width / 8
        let lineWidth = ribbonWidth / 8
        let drawSize = CGSizeMake(width, height)
        UIGraphicsBeginImageContextWithOptions(drawSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            fatalError("\(#function):\(#line) Failed to get current context.")
        }

        let darkGoldColor = UIColor(red: 0.6, green: 0.5, blue: 0.15, alpha: 1.0)
        let midGoldColor = UIColor(red: 0.86, green: 0.73, blue: 0.3, alpha: 1.0)
        let lightGoldColor = UIColor(red: 1.0, green: 0.98, blue: 0.9, alpha: 1.0)

        let shadow = UIColor.black.withAlphaComponent(0.80)
        let shadowOffset = CGSize(width: 2.0, height: 2.0)
        let shadowBlurRadius: CGFloat = 5
        context.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)

        context.beginTransparencyLayer(auxiliaryInfo: nil)

        let lowerRibbon = UIBezierPath()
        lowerRibbon.move(to: CGPointMake(0, 0))
        lowerRibbon.addLine(to: CGPointMake(ribbonWidth, 0))
        lowerRibbon.addLine(to: CGPointMake(width / 3 + ribbonWidth, ribbonHeight + ribbonWidth))
        lowerRibbon.addLine(to: CGPointMake(width / 3, ribbonHeight + ribbonWidth))
        lowerRibbon.close()
        UIColor.red.setFill()
        lowerRibbon.fill()

        let clasp = UIBezierPath(roundedRect: CGRectMake(width / 3, ribbonHeight + ribbonWidth, ribbonWidth, ribbonWidth / 2), cornerRadius: lineWidth)
        clasp.lineWidth = lineWidth
        darkGoldColor.setStroke()
        clasp.stroke()

        let center = CGPointMake(clasp.bounds.midX, clasp.bounds.midY  + width / 4)
        let radius = width / 4
        let medallion = UIBezierPath(arcCenter: CGPointMake(center.x, center.y), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        context.saveGState()
        medallion.addClip()
        let colors = [darkGoldColor.cgColor, midGoldColor.cgColor, lightGoldColor.cgColor] as CFArray
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),colors: colors, locations: [0, 0.5, 1]) else { fatalError("Failed to create gradient") }
        context.drawLinearGradient(gradient, start: CGPointMake(medallion.bounds.minX, medallion.bounds.minY), end: CGPointMake(medallion.bounds.maxX, medallion.bounds.maxY), options: [])
        context.restoreGState()

        let scale = 0.8
        var transform = CGAffineTransform(translationX: center.x, y: center.y)
        transform = transform.scaledBy(x: scale, y: scale)
        transform = transform.translatedBy(x: -center.x, y: -center.y)

        medallion.lineWidth = 2.0
        medallion.apply(transform)
        medallion.stroke()

        let upperRibbon = UIBezierPath()
        upperRibbon.move(to: CGPointMake(width - ribbonWidth, 0))
        upperRibbon.addLine(to: CGPointMake(width, 0))
        upperRibbon.addLine(to: CGPointMake(width / 3 + ribbonWidth, ribbonHeight + ribbonWidth))
        upperRibbon.addLine(to: CGPointMake(width / 3, ribbonHeight + ribbonWidth))
        upperRibbon.close()
        UIColor.blue.setFill()
        upperRibbon.fill()

        let number: NSString = "1"
        guard let font = UIFont(name: "Academy Engraved LET", size: 30) else {
            fatalError("\(#function):\(#line) Failed to instantiate font")
        }
        let numberAttributes: [NSAttributedString.Key : AnyObject] = [
          .font: font,
          .foregroundColor: darkGoldColor,
        ]
        let numberSize = number.size(withAttributes: numberAttributes)
        let numberCenter = CGPointMake(center.x - numberSize.width / 2, center.y - numberSize.height / 4)
        let numberRect = CGRect(origin: numberCenter, size: numberSize)
        number.draw(in: numberRect, withAttributes: numberAttributes)

        context.endTransparencyLayer()
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
struct MedalView_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                return MedalView()
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
