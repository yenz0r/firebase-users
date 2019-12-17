//
//  UserTableViewCell.swift
//  Firebase-authorization
//
//  Created by yenz0redd on 17.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    private var firstnameLabel: UILabel!
    private var lastnameLabel: UILabel!
    private var emailLabel: UILabel!

    var firstname: String? {
        didSet {
            self.firstnameLabel.text = self.firstname ?? ""
        }
    }

    var lastname: String? {
        didSet {
            self.lastnameLabel.text = self.lastname ?? ""
        }
    }


    var email: String? {
        didSet {
            self.emailLabel.text = self.email ?? ""
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.firstnameLabel = UILabel()
        self.contentView.addSubview(self.firstnameLabel)
        self.firstnameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10.0)
            make.width.height.equalToSuperview().dividedBy(2)
        }

        self.lastnameLabel = UILabel()
        self.contentView.addSubview(self.lastnameLabel)
        self.lastnameLabel.snp.makeConstraints { make in
            make.leading.height.width.equalTo(self.firstnameLabel)
            make.top.equalTo(self.firstnameLabel.snp.bottom)
        }

        self.emailLabel = UILabel()
        self.contentView.addSubview(self.emailLabel)
        self.emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.firstnameLabel.snp.trailing)
            make.top.bottom.trailing.equalToSuperview()
        }
        self.emailLabel.textAlignment = .center
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.firstname = nil
        self.lastname = nil
        self.email = nil
    }
}
