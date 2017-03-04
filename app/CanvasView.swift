//
//  CanvasView.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit
import RxSwift
import RxCocoa

class CanvasView: UIView {
    weak var handlePathView: HandlePathView?
    let pathObserver = PathObserver()

    var movableObjects: [Movable] = []
    var liftedObject: Movable?

    let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        addHandlePathView()

        bind()
    }

    func clear() {
        handlePathView?.clear()
        pathObserver.clear()
        movableObjects.removeAll()
        liftedObject = nil

        for subview in subviews {
            subview.removeFromSuperview()
        }

        redraw()
    }

    func addHandlePathView() {
        let view = HandlePathView()
        view.frame = bounds
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        self.handlePathView = view
    }

    func bind() {
        handlePathView?.rxx.path.asDriver()
            .drive(onNext: { [weak self] in
                self?.pathObserver.handlePath($0)
            })
            .addDisposableTo(disposeBag)

        handlePathView?.rxx.moveTo.asDriver()
            .drive(onNext: { [weak self] in
                self?.moveObjectIfNeeded(to: $0)
            })
            .addDisposableTo(disposeBag)

        pathObserver.rxx.pathGroup.asDriver()
            .drive(onNext: { [weak self] in
                self?.handleMovableObject($0)
            })
            .addDisposableTo(disposeBag)
    }

    func handleMovableObject(_ object: Movable?) {
        guard let object = object else {
            return
        }

        if movableObjects.last?.identifier != object.identifier {
            movableObjects.append(object)
            if let view = object as? UIView {
                view.frame = bounds
                if let handlePathView = handlePathView {
                    insertSubview(view, belowSubview: handlePathView)
                }
            }
        }

        redraw()
    }

    func redraw() {
        for subview in subviews {
            subview.setNeedsDisplay()
        }
        setNeedsDisplay()
    }

    func moveObjectIfNeeded(to point: CGPoint?) {
        guard let point = point else {
            liftedObject?.drop()
            liftedObject = nil
            return
        }

        if let object = liftedObject {
            object.move(to: point)
        } else {
            liftedObject = nearObject(from: point)
            liftedObject?.lift(at: point)
        }
    }

    func nearObject(from point: CGPoint) -> Movable? {
        for object in movableObjects {
            if object.isNear(from: point) {
                return object
            }
        }
        return nil
    }

/*     override func draw(_ rect: CGRect) {
        for object in drawObjects {
            object.draw(rect)
        }
    } */
}
