//
//  ErrorPageView.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 15/07/2022.
//

import UIKit

class ErrorPageView: BaseView {
    @IBOutlet var contenView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var actionCallBackButton: UIButton!
    @IBOutlet var anyActionButton: UIButton!
    private var action: () -> Void = {}
    private var anyAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        contenView.layer.cornerRadius = 20
        actionCallBackButton.layer.cornerRadius = 20
        anyActionButton.layer.cornerRadius = 20
    }

    func setup(title: String,
               message: String,
               action: @escaping (() -> Void),
               anyAction: (() -> Void)?) {
        anyActionButton.isHidden = anyAction == nil
        self.anyAction = anyAction
        self.action = action
        titleLabel.text = title
        messageLabel.text = message
    }

    @IBAction func didTapReload(sender: UIButton) {
        action()
    }

    @IBAction func didTapHelp(sender: UIButton) {
        anyAction?()
    }
}
