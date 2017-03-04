//
//  Recorder.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import CoreGraphics

class Recorder {
    static let shared = Recorder()

    var operations: [Operation] = []

    enum Operation {
        case began(CGPoint)
        case moved(CGPoint, Bool)
        case ended

        var dict: [String: String] {
            switch self {
            case .began(let point):
                return [
                    "operation": "begain",
                    "x": String(describing: point.x),
                    "y": String(describing: point.y)
                ]
            case .moved(let point, let force):
                return [
                    "operation": "moved",
                    "x": String(describing: point.x),
                    "y": String(describing: point.y),
                    "force": String(force)
                ]
            case .ended:
                return [
                    "operation": "ended"
                ]
            }
        }
    }

    func record(_ operation: Operation) {
        operations.append(operation)
    }

    func clear() {
        operations.removeAll()
    }

    func serializedDicts() -> [[String: String]] {
        var dicts: [[String: String]] = []
        for operation in operations {
            dicts.append(operation.dict)
        }
        return dicts
    }
}
