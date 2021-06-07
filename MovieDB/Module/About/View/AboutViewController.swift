//
//  AboutViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit

class AboutViewController: UIViewController {
  init() {
    super.init(nibName: "AboutViewController", bundle: nil)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .mainBarColor
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    setupTheme()
    navigationItem.title = "About"
  }
}
