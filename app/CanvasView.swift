//
//  CanvasView.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit

class CanvasView: UIView {
    var currentPath: UIBezierPath?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }

        let path = UIBezierPath()
        path.move(to: point)
        path.addLine(to: point)
        self.currentPath = path
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }

        currentPath?.addLine(to: point)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentPath = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentPath = nil
    }
}
