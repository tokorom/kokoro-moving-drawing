//
//  Drawable.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit

protocol Drawable {
    var identifier: String { get }
    func draw()
}
