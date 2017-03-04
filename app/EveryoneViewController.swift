//
//  EveryoneViewController.swift
//
//  Created by ToKoRo on 2017-03-04.
//

import UIKit

class EveryoneViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?

    var books: [Book] {
        return BookManager.shared.books
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView?.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension EveryoneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let book = books[indexPath.row]
        cell.textLabel?.text = book.title
        return cell
    }
}
