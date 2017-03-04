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

#if (arch(i386) || arch(x86_64)) && os(iOS)
    var forceTouchThreshold: CGFloat = 10.0
#else
    var forceTouchThreshold: CGFloat = 3.0
#endif

    let rxx = Rxx()

    var recorder: Recorder {
        return Recorder.shared
    }

    func clear() {
        currentPath = nil
        mode = .draw
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }

        began(with: point)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }

        let point = touch.location(in: self)
        let force = touch.force > forceTouchThreshold
        moved(with: point, force: force)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ended()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        ended()
    }

    func began(with point: CGPoint) {
        recorder.record(.began(point))

        let path = Path()
        path.movePoint(to: point)
        path.line(to: point)
        self.currentPath = path
    }

    func moved(with point: CGPoint, force: Bool) {
        recorder.record(.moved(point, force))

        if mode == .move {
            rxx.moveTo.value = point
        } else if force {
            mode = .move
            rxx.moveTo.value = point
        } else {
            mode = .draw
            currentPath?.line(to: point)
            rxx.path.value = currentPath
        }
    }

    func ended() {
        recorder.record(.ended)

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
