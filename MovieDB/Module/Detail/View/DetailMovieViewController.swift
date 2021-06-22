//
//  DetailMovieViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import UIKit
import RxSwift
import SDWebImage
import Core
import Movies

typealias DetailMoviePresenterType = GetItemPresenter<
  Int, Movie, Interactor<
    Int, Movie, MovieRepository<
      MovieRemoteDataSource, MoviesLocalDataSource
    >
  >
>
typealias AddFavoritePresenterType = GetItemPresenter<
  Movie, Movie, Interactor<
    Movie, Movie, AddFavoriteRepository<
      MovieLocalDataSource
    >
  >
>
typealias RemoveFavoritePresenterType = GetItemPresenter<
  Movie, Movie, Interactor<
    Movie, Movie, RemoveFavoriteRepository<
      MovieLocalDataSource
    >
  >
>

class DetailMovieViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let detailPresenter: DetailMoviePresenterType
  private let addFavoritePresenter: AddFavoritePresenterType
  private let removeFavoritePresenter: RemoveFavoritePresenterType
  private let router: DetailMovieRouter
  var movieID: Int = 0

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var favoriteButton: UIButton!
  @IBOutlet weak var trailerButton: UIButton!
  @IBOutlet weak var castsCollectionView: UICollectionView!
  @IBOutlet weak var gradientImage: UIImageView!

  init(router: DetailMovieRouter,
       detailPresenter: DetailMoviePresenterType,
       addFavoritePresenter: AddFavoritePresenterType,
       removeFavoritePresenter: RemoveFavoritePresenterType) {
    self.detailPresenter = detailPresenter
    self.router = router
    self.addFavoritePresenter = addFavoritePresenter
    self.removeFavoritePresenter = removeFavoritePresenter
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
    detailPresenter.getItem(request: movieID)
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
    gradientImage.image = .gradientImage
    trailerButton.setImage(.playButton, for: .normal)
    favoriteButton.setImage(.plusButton, for: .normal)
    favoriteButton.setImage(UIImage(systemName: "minus"), for: .selected)
  }

  private func observePresenter() {
    detailPresenter.item.subscribe { [weak self] data in
      self?.handleDataState(state: data, onLoaded: {
        self?.updateContent()
        self?.castsCollectionView.reloadData()
      })
    }.disposed(by: disposeBag)

    addFavoritePresenter.item
      .bind(to: detailPresenter.item)
      .disposed(by: disposeBag)

    removeFavoritePresenter.item
      .bind(to: detailPresenter.item)
      .disposed(by: disposeBag)
  }

  private func updateContent() {
    let item = detailPresenter.item.value.value
    if !(item?.isFavorite ?? false),
       favoriteButton.isSelected {
      favoriteButton.isSelected = false
      detailPresenter.getItem(request: movieID)
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
    trailerButton.isHidden = trailer == nil

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

  var trailer: String? {
    detailPresenter.item.value.value?
      .videos?
      .filter({ $0.type == "Trailer" && $0.site.lowercased() == "youtube" })
      .first?.key
  }

  @IBAction func favoriteButtonDidTapped(_ sender: UIButton) {
    let movie = detailPresenter.item.value.value
    if sender.isSelected {
      removeFavoritePresenter.getItem(request: movie)
    } else {
      addFavoritePresenter.getItem(request: movie)
    }
  }

  @IBAction func watchButtonDidTapped(_ sender: Any) {
    guard let videoKey = trailer else {
      return
    }
    router.routeToYoutubePlayer(from: self, videoId: videoKey)
  }
}

extension DetailMovieViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    detailPresenter.item.value.value?.casts?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: CastCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.item = detailPresenter.item.value.value?.casts?[indexPath.row]
    return cell
  }
}
