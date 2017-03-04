//
//  PathGroup.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit

final class PathGroup: UIView {
    let identifier: String
    var paths: [Path] = []

    var liftedPoint: CGPoint?
    var originCenter: CGPoint?

   required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        self.identifier = UUID().uuidString
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
    }

    func addPath(_ path: Path) {
        paths.append(path)
    }

    func contains(path: Path) -> Bool {
        return paths.last?.identifier == path.identifier
    }
}

// MARK: - Drawable

extension PathGroup: Drawable {
    override func draw(_ rect: CGRect) {
        for path in paths {
            path.draw(rect)
        }
    }
}

// MARK: - Movable

extension PathGroup: Movable {
    func isNear(from targetPath: Path) -> Bool {
        for path in paths {
            if path.isNear(from: targetPath) {
                return true
            }
        }
        return false
    }

    func isNear(from targetPoint: CGPoint) -> Bool {
        for path in paths {
            if path.isNear(from: targetPoint) {
                return true
            }
        }
        return false
    }

    func lift(at point: CGPoint) {
        liftedPoint = point
        originCenter = center
    }

    func move(to point: CGPoint) {
        guard let liftedPoint = liftedPoint,
            let originCenter = originCenter
        else {
            return
        }

        center = CGPoint(
            x: originCenter.x - (liftedPoint.x - point.x),
            y: originCenter.y - (liftedPoint.y - point.y)
        )

        for path in paths {
            path.originPoint = frame.origin
        }
    }

    func drop() {
        liftedPoint = nil
    }
}
