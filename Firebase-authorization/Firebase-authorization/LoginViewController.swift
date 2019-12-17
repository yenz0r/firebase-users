//
//  LoginViewController.swift
//  Firebase-authorization
//
//  Created by yenz0redd on 17.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLabel.text = ""
        self.navigationItem.title = "Login"
    }

    private func toggleLabel(_ text: String?) {
        self.errorLabel.text = text ?? ""
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, err in
            guard err == nil else {
                self?.toggleLabel(err?.localizedDescription)
                return
            }
            self?.toggleLabel("Successfully done!")
            let usersListVC = UsersListViewController()
            usersListVC.modalPresentationStyle = .fullScreen
            self?.navigationController?.pushViewController(usersListVC, animated: true)
        }
    }
}
