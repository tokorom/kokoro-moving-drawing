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

    let rxx = Rxx()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }

        let path = Path()
        path.move(to: point)
        path.addLine(to: point)
        self.currentPath = path
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            return
        }

        currentPath?.addLine(to: point)
        rxx.path.value = currentPath
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rxx.path.value = currentPath
        self.currentPath = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        rxx.path.value = currentPath
        self.currentPath = nil
    }
}

// MARK: - Rx

extension HandlePathView {
    struct Rxx {
        let path: Variable<Path?> = Variable(nil)
    }
}
