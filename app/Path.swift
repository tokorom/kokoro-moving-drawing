//
//  Path.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit

struct Path {
    let identifier: String
    let bezierPath = UIBezierPath()

    init() {
        self.identifier = UUID().uuidString
    }

    func move(to point: CGPoint) {
        bezierPath.move(to: point)
    }

    func addLine(to point: CGPoint) {
        bezierPath.addLine(to: point)
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
