//
//  FavoriteViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import UIKit
import RxSwift
import SVProgressHUD
import SnapKit
import RxCocoa
import RxRelay
import EmptyDataSet_Swift
import Core
import Movies

typealias FavoritePresenterType = GetListPresenter<
  String, Movie, Interactor<
    String, [Movie], FavoriteMoviesRepository<
      MoviesLocalDataSource
    >
  >
>

class FavoriteViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let router: DetailMovieRouter
  private let favoritePresenter: FavoritePresenterType
  private let removeFavoritePresenter: RemoveFavoritePresenterType
  private let tableView = UITableView(frame: CGRect.zero)
  private let searchBar = SearchTextField()

  init(router: DetailMovieRouter,
       favoritePresenter: FavoritePresenterType,
       removeFavoritePresenter: RemoveFavoritePresenterType) {
    self.favoritePresenter = favoritePresenter
    self.router = router
    self.removeFavoritePresenter = removeFavoritePresenter
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
    favoritePresenter.getList(request: searchBar.text ?? "")
  }

  private func configureViews() {
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.emptyDataSetDelegate = self
    tableView.emptyDataSetSource = self
    tableView.rowHeight = 92
    tableView.backgroundColor = .mainColor
    tableView.snp.makeConstraints { [weak self] maker in
      guard let self = self else { return }
      maker.leading.trailing.equalToSuperview()
      maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
    tableView.register(cellType: FavoriteMovieCell.self)
    view.backgroundColor = .mainBarColor
  }

  private func observePresenter() {
    searchBar.rx.text.asObservable()
      .debounce(.milliseconds(1500), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe { [weak self] (str) in
        self?.favoritePresenter.getList(request: str ?? "")
      }.disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIApplication.keyboardWillShowNotification)
      .subscribe(onNext: { [weak self] notif in
        if let keyboardFrameValue = notif.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue {
          let keyboardFrame = keyboardFrameValue.cgRectValue
          guard let self = self else { return }
          self.tableView.snp.remakeConstraints({ (maker) in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.bottom.equalToSuperview().inset(keyboardFrame.height)
          })
        }
      }).disposed(by: disposeBag)

    NotificationCenter.default.rx.notification(UIApplication.keyboardWillHideNotification)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.tableView.snp.remakeConstraints({ (maker) in
          maker.leading.trailing.equalToSuperview()
          maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
          maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
      }).disposed(by: disposeBag)

    favoritePresenter.list.subscribe(onNext: { [weak self] data in
      self?.handleDataState(state: data, onLoaded: {
        self?.tableView.reloadData()
      })
    }).disposed(by: disposeBag)

    removeFavoritePresenter.item.subscribe(onNext: { [weak self] data in
      if data.value != nil {
        self?.favoritePresenter.getList(request: self?.searchBar.text ?? "")
      }
    }).disposed(by: disposeBag)
  }

  private func confirmRemoveFavorite(movie: Movie) {
    let alert = UIAlertController(
      title: "Are you sure?",
      message: "This action will remove \(movie.title) movie from you favorite",
      preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "Yes, Remove",
                                  style: .destructive,
                                  handler: { [weak self] _ in
                                    self?.removeFavoritePresenter.getItem(request: movie)
                                  }))
    present(alert, animated: true, completion: nil)
  }
}

extension FavoriteViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    favoritePresenter.list.value.value?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: FavoriteMovieCell = tableView.dequeueReusableCell(for: indexPath)
    cell.item = favoritePresenter.list.value.value?[indexPath.row]
    cell.favButtonHandler = { [weak self] movie in
      self?.confirmRemoveFavorite(movie: movie)
    }
    return cell
  }
}

extension FavoriteViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = favoritePresenter.list.value.value?[indexPath.row] {
      router.routeToDetailMovie(from: self, movie: item)
    }
  }
}

extension FavoriteViewController: EmptyDataSetSource {
  func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    searchBar.text?.isEmpty ?? false ?
      NSAttributedString(string: "Empty") :
      NSAttributedString(string: "Not Found")
  }

  func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
    searchBar.text?.isEmpty ?? false ?
      NSAttributedString(string: "You have no favorite movie for now.") :
      NSAttributedString(string: "Sorry, no matched movie in your favorite list.")
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

extension FavoriteViewController: EmptyDataSetDelegate {
  func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
    if let movies = favoritePresenter.list.value.value,
       movies.count > 0 {
      return false
    }
    return true
  }
}
