//
//  Movable.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import CoreGraphics

protocol Movable {
    var identifier: String { get }
    func lift(at point: CGPoint)
    func move(to point: CGPoint)
    func drop()
    func isNear(from targetPoint: CGPoint) -> Bool
    func isNear(from targetPath: Path) -> Bool
}
