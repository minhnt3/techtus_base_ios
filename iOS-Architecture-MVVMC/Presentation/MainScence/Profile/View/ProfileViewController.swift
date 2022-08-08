//
//  ProfileViewController.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 24/05/2022.
//

import UIKit
import Kingfisher

class ProfileViewController: BaseViewController<ProfileViewModel> {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.getProfile()
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel.avatar.observe(on: self, observerBlock: { [weak self] avatar in
            self?.avatarImageView.setImage(url: avatar)
        })
        viewModel.name.observe(on: self, observerBlock: { [weak self] name in
            self?.nameLabel.text = name
        })
        viewModel.email.observe(on: self, observerBlock: { [weak self] email in
            self?.emailLabel.text = email
        })
        viewModel.phone.observe(on: self, observerBlock: { [weak self] phone in
            self?.phoneLabel.text = phone
        })
        viewModel.city.observe(on: self, observerBlock: { [weak self] city in
            self?.cityLabel.text = city
        })
    }

    override func setupLanguagueText() {
        super.setupLanguagueText()
        title = Strings.ProfileScreen.title
        nameLabel.text = Strings.ProfileScreen.nameLabel
        emailLabel.text = Strings.ProfileScreen.emailLabel
        phoneLabel.text = Strings.ProfileScreen.phoneLabel
        cityLabel.text = Strings.ProfileScreen.cityLabel
    }

    @IBAction func doLogOut(_ sender: Any) {
        viewModel.doLogOut()
    }

    private func configureUI() {
        avatarImageView.applyCornerRadius(radius: 64)
    }
}
