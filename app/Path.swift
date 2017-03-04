//
//  Path.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit

class Path {
    let identifier: String
    let bezierPath = UIBezierPath()

    var distanceForNearChecking: CGFloat = -20

    var originPoint: CGPoint = .zero

    init() {
        self.identifier = UUID().uuidString
    }

    var extendedBounds: CGRect {
        let bounds = bezierPath.bounds
        let currentRect = CGRect(
            x: bounds.origin.x + originPoint.x,
            y: bounds.origin.y + originPoint.y,
            width: bounds.size.width,
            height: bounds.size.height
        )
        return currentRect.insetBy(dx: distanceForNearChecking, dy: distanceForNearChecking)
    }

    func movePoint(to point: CGPoint) {
        bezierPath.move(to: point)
    }

    func line(to point: CGPoint) {
        bezierPath.addLine(to: point)
    }
}

// MARK: - Drawable

extension Path: Drawable {
    func draw(_ rect: CGRect) {
        UIColor.black.setStroke()
        bezierPath.lineWidth = 3
        bezierPath.stroke()
    }
}

// MARK: - Movable

extension Path: Movable {
    func isNear(from targetPath: Path) -> Bool {
        return extendedBounds.intersects(targetPath.extendedBounds)
    }

    func isNear(from targetPoint: CGPoint) -> Bool {
        return extendedBounds.contains(targetPoint)
    }

    func lift(at point: CGPoint) {}
    func move(to point: CGPoint) {}
    func drop() {}
}

// MARK: - Translated

extension Path {
    func translatedPath(with moveTo: CGPoint) -> Path {
        class Info {
            var points: [CGPoint] = []
        }
        var info = Info()
        bezierPath.cgPath.apply(info: &info) { info, element in
            guard let infoPointer = UnsafeMutablePointer<Info>(OpaquePointer(info)) else {
                return
            }
            switch element.pointee.type {
            case .closeSubpath:
                break
            default:
                let point = element.pointee.points[0]
                infoPointer.pointee.points.append(point)
            }
        }

        let translated = Path()
        var first = true
        for point in info.points {
            let translatedPoint = CGPoint(
                x: point.x - moveTo.x,
                y: point.y - moveTo.y
            )
            if first {
                translated.movePoint(to: translatedPoint)
                first = false
            } else {
                translated.line(to: translatedPoint)
            }
        }
        return translated
    }
}
