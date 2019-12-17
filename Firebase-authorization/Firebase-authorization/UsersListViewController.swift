//
//  UsersListViewController.swift
//  Firebase-authorization
//
//  Created by yenz0redd on 17.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

struct User {
    let firstname: String
    let lastname: String
    let email: String
}

final class UsersListViewController: UIViewController {
    private var tableView: UITableView!
    private var refreshControl: UIRefreshControl!

    private var users = [User]()

    override func loadView() {
        self.view = UIView()

        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.refreshControl = UIRefreshControl()
        self.tableView.addSubview(self.refreshControl)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Users"
        self.view.backgroundColor = .white

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "userCell")

        self.refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showLoadingAlert()
        self.getUsers {
            sleep(1)
            self.hideLoadingAlert()
            self.tableView.reloadData()
        }
    }

    @objc private func handleRefresh() {
        self.getUsers {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }

    private func showLoadingAlert() {
        let alertController = UIAlertController(
            title: "Loading",
            message: "user from server..",
            preferredStyle: .alert
        )
        self.present(alertController, animated: true, completion: nil)
    }

    private func hideLoadingAlert() {
        self.dismiss(animated: true, completion: nil)
    }

    private func getUsers(completion: @escaping () -> ()) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { [weak self] query, err in
            guard err == nil, let query = query else { return }
            var result = [User]()
            for document in query.documents {
                let firstname = (document.data()["firstname"] as? String) ?? ""
                let lastname = (document.data()["lastname"] as? String) ?? ""
                let email = (document.data()["email"] as? String) ?? ""

                let user = User(firstname: firstname, lastname: lastname, email: email)

                result.append(user)
            }
            DispatchQueue.main.async {
                self?.users = result
                completion()
            }
        }
    }
}

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        cell.firstname = self.users[indexPath.row].firstname
        cell.lastname = self.users[indexPath.row].lastname
        cell.email = self.users[indexPath.row].email
        return cell
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
