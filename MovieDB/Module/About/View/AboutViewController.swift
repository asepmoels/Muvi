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
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    setupTheme()
    navigationItem.title = "About"
  }
}
