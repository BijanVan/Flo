//
//  GraphView.swift
//  Flo
//
//  Created by Bijan Nazem on 2023-02-16.
//

import UIKit

class GraphView: UIView {
    // MARK: Private properties
    let cornerRadiusSize = CGSizeMake(defaultSize, defaultSize)
    static let margin: CGFloat = 20.0
    static let topBorder: CGFloat = 60
    static let bottomBorder: CGFloat = 50
    static let colorAlpha: CGFloat = 0.3
    static let circleDiameter: CGFloat = 5.0

    // MARK: Properties
    var startColor = UIColor(red: 250/255, green: 233/255, blue: 222/255, alpha: 1)
    var endColor = UIColor(red: 252/255, green: 79/255, blue: 8/255, alpha: 1)
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]

    let averageWaterDrunk = UILabel()
    let maxLabel = UILabel()
    let stackView = UIStackView()

    // MARK: Overrides
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: cornerRadiusSize)
        path.addClip() // CALayer’s cornerRadius is more performant


        guard let context = UIGraphicsGetCurrentContext() else { return }
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)  else { return }
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

        let graphWidth = rect.width - Self.margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + Self.margin + 2
        }

        let graphHeight = rect.height - Self.topBorder - Self.bottomBorder
        guard let maxValue = graphPoints.max() else { return }
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + Self.topBorder - yPoint
        }

        UIColor.white.setFill()
        UIColor.white.setStroke()

        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }

        context.saveGState()
        guard let clippingPath = graphPath.copy() as? UIBezierPath else { return }
        clippingPath.addLine(to: CGPoint(
          x: columnXPoint(graphPoints.count - 1),
          y: rect.height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: rect.height))
        clippingPath.close()
        clippingPath.addClip()

        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: Self.margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: Self.margin, y: bounds.height)

        context.drawLinearGradient(
          gradient,
          start: graphStartPoint,
          end: graphEndPoint,
          options: [])
        context.restoreGState()

        graphPath.lineWidth = 2.0
        graphPath.stroke()

        for i in 0..<graphPoints.count {
          var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
          point.x -= Self.circleDiameter / 2
          point.y -= Self.circleDiameter / 2

          let circle = UIBezierPath(
            ovalIn: CGRect(
              origin: point,
              size: CGSize(
                width: Self.circleDiameter,
                height: Self.circleDiameter)
            )
          )
          circle.fill()
        }

        let linePath = UIBezierPath()
        // Top line
        linePath.move(to: CGPoint(x: Self.margin, y: Self.topBorder))
        linePath.addLine(to: CGPoint(x: rect.width - Self.margin, y: Self.topBorder))
        // Center line
        linePath.move(to: CGPoint(x: Self.margin, y: graphHeight / 2 + Self.topBorder))
        linePath.addLine(to: CGPoint(x: rect.width - Self.margin, y: graphHeight / 2 + Self.topBorder))
        // Bottom line
        linePath.move(to: CGPoint(x: Self.margin, y: rect.height - Self.bottomBorder))
        linePath.addLine(to: CGPoint(x: rect.width - Self.margin, y: rect.height - Self.bottomBorder))
        let color = UIColor(white: 1.0, alpha: Self.colorAlpha)
        color.setStroke()
        linePath.lineWidth = 1.0
        linePath.stroke()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
        styleSubviews()
    }

    //    // TODO: remove this
    //    override var intrinsicContentSize: CGSize {
    //        CGSizeMake(200, 100)
    //    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions
    private func prepareSubviews() {
        averageWaterDrunk.translatesAutoresizingMaskIntoConstraints = false
        maxLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(averageWaterDrunk)
        addSubview(maxLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(greaterThanOrEqualToConstant: defaultSize),
            widthAnchor.constraint(equalTo: heightAnchor),
        ])

        NSLayoutConstraint.activate([
            averageWaterDrunk.topAnchor.constraint(equalTo: topAnchor, constant: defaultSpacing),
            averageWaterDrunk.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultSpacing),
        ])

        NSLayoutConstraint.activate([
            maxLabel.topAnchor.constraint(equalTo: topAnchor, constant: 45),
            trailingAnchor.constraint(equalTo: maxLabel.trailingAnchor, constant: defaultSpacing),
        ])
    }

    private func styleSubviews() {
        isOpaque = false

        averageWaterDrunk.textColor = .systemBackground
        averageWaterDrunk.font = UIFont.preferredFont(forTextStyle: .title2)
        averageWaterDrunk.text = "Average: 2"

        maxLabel.textColor = .systemBackground
        maxLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        maxLabel.text = "99"
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct GraphView_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                return GraphView()
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

