//
//  HandlePathView.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit
import RxSwift
import RxCocoa

class HandlePathView: UIView {
    var currentPath: Path?
    var mode: Mode = .draw

    var forceTouchThreshold: CGFloat = 3.0

    let rxx = Rxx()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }

        let path = Path()
        path.movePoint(to: point)
        path.line(to: point)
        self.currentPath = path
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let point = touch.location(in: self)

        if mode == .move {
            rxx.moveTo.value = point
        } else if touch.force > forceTouchThreshold {
            mode = .move
            rxx.moveTo.value = point
        } else {
            mode = .draw
            currentPath?.line(to: point)
            rxx.path.value = currentPath
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .move {
            rxx.moveTo.value = nil
        } else {
            rxx.path.value = currentPath
        }
        currentPath = nil
        mode = .draw
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if mode == .move {
            rxx.moveTo.value = nil
        } else {
            rxx.path.value = currentPath
        }
        currentPath = nil
        mode = .draw
    }
}

// MARK: - Mode

extension HandlePathView {
    enum Mode {
        case draw
        case move
    }
}

// MARK: - Rx

extension HandlePathView {
    struct Rxx {
        let path: Variable<Path?> = Variable(nil)
        let moveTo: Variable<CGPoint?> = Variable(nil)
    }
}
