//
//  SignInViewController.swift
//  Firebase-authorization
//
//  Created by yenz0redd on 17.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLabel.text = ""
        self.navigationItem.title = "Sign in"
    }

    private func toggleLabel(_ text: String?) {
        self.errorLabel.text = text ?? ""
    }

    @IBAction func singInPressed(_ sender: UIButton) {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, err in
            guard err == nil else {
                self?.toggleLabel(err?.localizedDescription)
                return
            }

            guard let firstname = self?.firstnameTextField.text else { return }
            guard let lastname = self?.lastnameTextField.text else { return }
            guard let result = result else { return }

            let db = Firestore.firestore()
            db.collection("users").addDocument(
                data: [
                    "firstname": firstname,
                    "lastname": lastname,
                    "uid": result.user.uid
                ], completion: { err in
                    if let err = err {
                        self?.toggleLabel(err.localizedDescription)
                    } else {
                        self?.toggleLabel("Successfully registered!")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController")
                        loginVC.modalPresentationStyle = .fullScreen
                        self?.navigationController?.pushViewController(loginVC, animated: true)
                    }
                }
            )
        }
    }
}
