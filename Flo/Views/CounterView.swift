//
//  CounterView.swift
//  Flo
//
//  Created by Bijan Nazem on 2023-02-15.
//

import UIKit

class CounterView: UIView {
    static let numberOfGlasses = 8
    static let lineWidth: CGFloat = 5.0
    static let arcWidth: CGFloat = 76

    // MARK: Properties
    let label = UILabel()

    var counter: Int = 5 {
        didSet {
            label.text = "\(counter)"
            setNeedsDisplay()
        }
    }
    var outlineColor = UIColor.blue
    var counterColor = UIColor.orange

    // MARK: Overrides
    override func draw(_ rect: CGRect) {
        let diameter = min(bounds.width, bounds.height)
        let middle = CGPointMake(bounds.midX, bounds.midY)
        let start: CGFloat = 3 * .pi / 4
        let end: CGFloat = .pi / 4

        let arcPath = UIBezierPath(arcCenter: middle,
                                   radius: (diameter - Self.arcWidth) / 2,
                                   startAngle: start,
                                   endAngle: end,
                                   clockwise: true)
        arcPath.lineWidth = Self.arcWidth
        counterColor.setStroke()
        arcPath.stroke()

        let angleDifference: CGFloat = 2 * .pi - start + end
        let outlineEnd = start + angleDifference * CGFloat(counter) / CGFloat(Self.numberOfGlasses)
        let outerRadius = (diameter - Self.lineWidth) / 2
        let outlinePath = UIBezierPath(
            arcCenter: middle,
            radius: outerRadius,
            startAngle: start,
            endAngle: outlineEnd,
            clockwise: true)

        let innerRadius = (diameter + Self.lineWidth) / 2 - Self.arcWidth
        outlinePath.addArc(withCenter: middle,
                           radius: innerRadius,
                           startAngle: outlineEnd,
                           endAngle: start,
                           clockwise: false)

        outlinePath.close()
        outlineColor.setStroke()
        outlinePath.lineWidth = Self.lineWidth
        outlinePath.stroke()
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
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: defaultSize),
            widthAnchor.constraint(equalTo: heightAnchor),
        ])

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func styleSubviews() {
        isOpaque = false

        label.text = "\(counter)"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct CounterView_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                return CounterView()
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

