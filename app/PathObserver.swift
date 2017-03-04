//
//  PathObserver.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit
import RxSwift
import RxCocoa

class PathObserver {
    var currentPathGroup: PathGroup {
        if let group = pathGroups.last {
            return group
        } else {
            let group = PathGroup()
            pathGroups.append(group)
            return group
        }
    }

    var pathGroups: [PathGroup] = []

    let rxx = Rxx()

    func handlePath(_ path: Path?) {
        guard let path = path else {
            return
        }

        if !currentPathGroupContains(path: path) {
            if let group = nearGroup(from: path) {
                group.addPath(path)
            } else {
                let group = PathGroup()
                group.addPath(path)
                pathGroups.append(group)
            }
        }

        rxx.pathGroup.value = currentPathGroup
    }

    func currentPathGroupContains(path: Path) -> Bool {
        return currentPathGroup.contains(path: path)
    }

    func nearGroup(from path: Path) -> PathGroup? {
        for group in pathGroups {
            if group.isNear(from: path) {
                return group
            }
        }
        return nil
    }
}

// MARK: - Rx

extension PathObserver {
    struct Rxx {
        let pathGroup: Variable<PathGroup?> = Variable(nil)
    }
}
