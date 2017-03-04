//
//  Path.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit

struct Path {
    let identifier: String
    let bezierPath = UIBezierPath()

    var distanceForNearChecking: CGFloat = -10

    init() {
        self.identifier = UUID().uuidString
    }

    var extendedBounds: CGRect {
        return bezierPath.bounds.insetBy(dx: distanceForNearChecking, dy: distanceForNearChecking)
    }

    func move(to point: CGPoint) {
        bezierPath.move(to: point)
    }

    func addLine(to point: CGPoint) {
        bezierPath.addLine(to: point)
    }

    func isNear(from targetPath: Path) -> Bool {
        return extendedBounds.intersects(targetPath.extendedBounds)
    }
}

// MARK: - Drawable

extension Path: Drawable {
    func draw() {
        UIColor.black.setStroke()
        bezierPath.lineWidth = 3
        bezierPath.stroke()
    }
}
