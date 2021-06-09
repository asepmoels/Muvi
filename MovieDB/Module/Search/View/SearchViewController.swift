//
//  SearchViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import RxSwift
import SVProgressHUD
import SnapKit
import RxCocoa
import RxRelay
import EmptyDataSet_Swift

class SearchViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let router: MovieRouter
  private let presenter: SearchPresenter
  private let collectionView = UICollectionView(frame: CGRect.zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())
  private let searchBar = SearchTextField()

  init(router: MovieRouter,
       presenter: SearchPresenter) {
    self.presenter = presenter
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    observePresenter()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    setupTheme()
    navigationItem.titleView = searchBar
  }

  private func configureViews() {
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .vertical
      let width = (UIScreen.main.bounds.width - 55) * 0.5
      layout.itemSize = CGSize(width: width, height: 230 / 120 * width)
      layout.sectionInset = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
      layout.minimumInteritemSpacing = 15
      layout.minimumLineSpacing = 15
      layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 48)
    }
    view.addSubview(collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.emptyDataSetSource = self
    collectionView.emptyDataSetDelegate = self
    collectionView.backgroundColor = .mainColor
    collectionView.snp.makeConstraints { [weak self] (maker) in
      guard let self = self else { return }
      maker.leading.trailing.equalToSuperview()
      maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
    collectionView.register(cellType: MovieItemCell.self)
    collectionView.register(supplementaryViewType: ResultTitleCell.self,
                            ofKind: UICollectionView.elementKindSectionHeader)
    view.backgroundColor = .mainBarColor
  }

  private func observePresenter() {
    searchBar.rx.text.asObservable()
      .debounce(.milliseconds(1500), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe { [weak self] (str) in
        self?.presenter.searchMovies(keyword: str ?? "")
      }.disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIApplication.keyboardWillShowNotification)
      .subscribe(onNext: { [weak self] notif in
        if let keyboardFrameValue = notif.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue {
          let keyboardFrame = keyboardFrameValue.cgRectValue
          guard let self = self else { return }
          self.collectionView.snp.remakeConstraints({ (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalToSuperview().inset(keyboardFrame.height)
          })
        }
      }).disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIApplication.keyboardWillHideNotification)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.collectionView.snp.remakeConstraints({ (maker) in
          maker.leading.trailing.equalToSuperview()
          maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
          maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
      }).disposed(by: disposeBag)

    presenter.isLoading.subscribe { (isLoading) in
      isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }.disposed(by: disposeBag)

    presenter.movies.subscribe { [weak self] _ in
      self?.collectionView.reloadData()
    }.disposed(by: disposeBag)

    presenter.error.subscribe(onNext: { [weak self] (error) in
      guard let theError = error else { return }
      self?.handleError(error: theError)
    }).disposed(by: disposeBag)
  }
}

extension SearchViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    presenter.movies.value?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: MovieItemCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.item = presenter.movies.value?[indexPath.row]
    return cell
  }
}

extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    let header: ResultTitleCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
    header.text = searchBar.text ?? ""
    return header
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let item = presenter.movies.value?[indexPath.row] {
      router.routeToDetail(from: self, movie: item)
    }
  }
}

extension SearchViewController: EmptyDataSetSource {
  func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    searchBar.text?.isEmpty ?? false ?
      NSAttributedString(string: "Search") :
      NSAttributedString(string: "Not Found")
  }

  func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    searchBar.text?.isEmpty ?? false ?
      NSAttributedString(string: "Begin to search the great movie here") :
      NSAttributedString(string: "Sorry, we are unable to find the movie you want.")
  }

  func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
    searchBar.text?.isEmpty ?? false ?
      UIImage.movieIcon :
      UIImage.unknownIcon
  }

  func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
    UIColor.primaryYellow
  }
}

extension SearchViewController: EmptyDataSetDelegate {
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
    if let movies = presenter.movies.value,
       movies.count > 0 {
      return false
    }
    return true
  }
}
