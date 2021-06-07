//
//  MoviesViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit

class MoviesViewController: UICollectionViewController {
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    setupTheme()
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.navbarLogo,
                                                       style: .plain,
                                                       target: nil,
                                                       action: nil)
  }

  private func configureViews() {
    collectionView.backgroundColor = .mainColor
    collectionView.register(cellType: HomeBannerCell.self)
  }
}

extension MoviesViewController {
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    1
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: HomeBannerCell = collectionView.dequeueReusableCell(for: indexPath)
    return cell
  }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width
    return CGSize(width: width, height: 3 / 4 * width)
  }
}
