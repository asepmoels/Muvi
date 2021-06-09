//
//  DetailMovieViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import UIKit
import RxSwift
import SVProgressHUD
import SDWebImage

class DetailMovieViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let presenter: DetailMoviePresenter
  private let router: DetailMovieRouter

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var trailerButton: UIButton!
  @IBOutlet weak var castsCollectionView: UICollectionView!

  init(router: DetailMovieRouter,
       presenter: DetailMoviePresenter) {
    self.presenter = presenter
    self.router = router
    super.init(nibName: nil, bundle: nil)
    hidesBottomBarWhenPushed = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    observePresenter()
    presenter.getDetailMovie()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    setupTheme()
    navigationController?.navigationBar.backgroundColor = .clear
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: .backButton,
      style: .done,
      target: self,
      action: #selector(back(sender:)))
  }

  @objc private func back(sender: Any?) {
    navigationController?.popViewController(animated: true)
  }

  private func configureViews() {
    scrollView.contentInsetAdjustmentBehavior = .never
    favoriteButton.titleLabel?.numberOfLines = 0
    favoriteButton.titleLabel?.textAlignment = .center
    castsCollectionView.register(cellType: CastCell.self)
  }

  private func observePresenter() {
    presenter.isLoading.subscribe { (isLoading) in
      isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }.disposed(by: disposeBag)

    presenter.movie.subscribe { [weak self] _ in
      self?.updateContent()
    }.disposed(by: disposeBag)

    presenter.error.subscribe(onNext: { [weak self] (error) in
      guard let theError = error else { return }
      self?.handleError(error: theError)
    }).disposed(by: disposeBag)
  }

  private func updateContent() {
    let item = presenter.movie.value
    if !(item?.isFavorite ?? false),
       favoriteButton.isSelected {
      favoriteButton.isSelected = false
      presenter.getDetailMovie()
      return
    }
    titleLabel.text = item?.title
    genreLabel.text = item?.genres
      .map({ $0.name }).joined(separator: " • ")
    posterImage.sd_imageIndicator = SDWebImageActivityIndicator.white
    posterImage.sd_setImage(with: item?.posterURL)
    favoriteButton.isSelected = item?.isFavorite ?? false
    castsCollectionView.reloadData()
    if let layout = castsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.itemSize = CGSize(width: 90, height: 148)
      layout.minimumInteritemSpacing = 8
      layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    trailerButton.isHidden = presenter.trailer == nil

    if let overview = item?.overview {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.lineHeightMultiple = 1.3
      let attribute = [
        NSAttributedString.Key.paragraphStyle: paragraphStyle
      ]
      let attributtedString = NSAttributedString(string: overview, attributes: attribute)
      overviewLabel.attributedText = attributtedString
    }
  }

  @IBAction func favoriteButtonDidTapped(_ sender: UIButton) {
    if sender.isSelected {
      presenter.removeFromFavorite()
    } else {
      presenter.addToFavorite()
    }
  }

  @IBAction func watchButtonDidTapped(_ sender: Any) {
    guard let videoKey = presenter.trailer else {
      return
    }
    router.routeToYoutubePlayer(from: self, videoId: videoKey)
  }
}

extension DetailMovieViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    presenter.movie.value?.casts?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: CastCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.item = presenter.movie.value?.casts?[indexPath.row]
    return cell
  }
}
