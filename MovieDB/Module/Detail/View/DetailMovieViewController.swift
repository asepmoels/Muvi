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

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!

  init(presenter: DetailMoviePresenter) {
    self.presenter = presenter
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
  }

  private func observePresenter() {
    presenter.isLoading.subscribe { (isLoading) in
      isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }.disposed(by: disposeBag)

    presenter.movie.subscribe { [weak self] _ in
      self?.updateContent()
    }.disposed(by: disposeBag)
  }

  private func updateContent() {
    let item = presenter.movie.value
    titleLabel.text = item?.title
    genreLabel.text = item?.genres
      .map({ $0.name }).joined(separator: " • ")
    posterImage.sd_imageIndicator = SDWebImageActivityIndicator.white
    posterImage.sd_setImage(with: item?.posterURL)

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
}
