//
//  PathObserver.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit
import RxSwift
import RxCocoa

class PathObserver {
    var currentPathGroup_: PathGroup?
    var currentPathGroup: PathGroup {
        if let group = currentPathGroup_ {
            return group
        } else {
            let group = PathGroup()
            currentPathGroup_ = group
            return group
        }
    }

    let rxx = Rxx()

    func clearCurrentPathGroup() {
        currentPathGroup_ = nil
    }

    func handlePath(_ path: Path?) {
        guard let path = path else {
            return
        }
        if !currentPathGroupContains(path: path) {
            if !isNearFromCurrentGroup(with: path) {
                clearCurrentPathGroup()
            }
            currentPathGroup.addPath(path)
        }
        if let group = currentPathGroup_ {
            rxx.pathGroup.value = group
        }
    }

    func currentPathGroupContains(path: Path) -> Bool {
        return currentPathGroup.contains(path: path)
    }

    func isNearFromCurrentGroup(with path: Path) -> Bool {
        return currentPathGroup.isNear(by: path)
    }
}

// MARK: - Rx

extension PathObserver {
    struct Rxx {
        let pathGroup: Variable<PathGroup?> = Variable(nil)
    }
}
