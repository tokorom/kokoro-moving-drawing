//
//  DrawingViewController.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit
import RxSwift

class DrawingViewController: UIViewController {
    @IBOutlet weak var canvasView: CanvasView?

    var recorder: Recorder {
        return Recorder.shared
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func publishButtonDidTap(sender: AnyObject) {
        let dicts = recorder.serializedDicts()
        print(dicts)

        recorder.clear()
        canvasView?.clear()
    }
}
