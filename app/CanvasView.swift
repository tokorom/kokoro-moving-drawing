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

    var drawObjects: [Drawable] = []

    let disposeBag = DisposeBag()
    let pathObserver = PathObserver()

    override func awakeFromNib() {
        super.awakeFromNib()

        addHandlePathView()

        bind()
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

        pathObserver.rxx.pathGroup.asDriver()
            .drive(onNext: { [weak self] in
                self?.handleDrawObject($0)
            })
            .addDisposableTo(disposeBag)
    }

    func handleDrawObject(_ object: Drawable?) {
        guard let object = object else {
            return
        }

        if drawObjects.last?.identifier != object.identifier {
            drawObjects.append(object)
            print("### objects.count: \(drawObjects.count)")
        }
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        for object in drawObjects {
            object.draw()
        }
    }
}
