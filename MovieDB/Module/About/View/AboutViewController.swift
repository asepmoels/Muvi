//
//  AboutViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Common

class AboutViewController: UIViewController {
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var fotoImage: UIImageView!
  @IBOutlet weak var thisLabel: UILabel!
  @IBOutlet weak var applicationLabel: UILabel!
  @IBOutlet weak var madeLabel: UILabel!

  init() {
    super.init(nibName: "AboutViewController", bundle: nil)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }

  private func configureViews() {
    view.backgroundColor = .mainBarColor
    logoImage.image = .navbarLogo
    fotoImage.image = .aboutFoto
    thisLabel.text = "this".localized()
    applicationLabel.text = "application".localized()
    madeLabel.text = "made_by".localized()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    setupTheme()
    navigationItem.title = "about".localized()
  }
}
