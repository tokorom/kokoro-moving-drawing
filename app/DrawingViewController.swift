//
//  DrawingViewController.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit
import RxSwift
import SVProgressHUD

class DrawingViewController: UIViewController {
    @IBOutlet weak var canvasView: CanvasView?

    var recorder: Recorder {
        return Recorder.shared
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func publishButtonDidTap(sender: AnyObject) {
        let _ = recorder.serializedDicts()

        SVProgressHUD.show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            SVProgressHUD.showSuccess(withStatus: "Arrived :)")
            self?.recorder.clear()
            self?.canvasView?.clear()
        }
    }
}
