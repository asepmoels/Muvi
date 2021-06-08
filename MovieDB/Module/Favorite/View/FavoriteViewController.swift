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

class FavoriteViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let router: MovieRouter
  private let presenter: FavoritePresenter
  private let tableView = UITableView(frame: CGRect.zero)
  private let searchBar = SearchTextField()

  init(router: MovieRouter,
       presenter: FavoritePresenter) {
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
    presenter.getFavoriteMovies(keyword: searchBar.text ?? "")
  }

  private func configureViews() {
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 92
    tableView.backgroundColor = .mainColor
    tableView.snp.makeConstraints { [weak self] maker in
      guard let self = self else { return }
      maker.leading.trailing.bottom.equalToSuperview()
      maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
    }
    tableView.register(cellType: FavoriteMovieCell.self)
    view.backgroundColor = .mainBarColor
  }

  private func observePresenter() {
    searchBar.rx.text.asObservable()
      .debounce(.milliseconds(1500), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe { [weak self] (str) in
        self?.presenter.getFavoriteMovies(keyword: str ?? "")
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
          maker.leading.trailing.bottom.equalToSuperview()
          maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        })
      }).disposed(by: disposeBag)

    presenter.isLoading.subscribe { (isLoading) in
      isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }.disposed(by: disposeBag)

    presenter.movies.subscribe { [weak self] _ in
      self?.tableView.reloadData()
    }.disposed(by: disposeBag)

    presenter.movie.subscribe { [weak self] _ in
      self?.presenter.getFavoriteMovies(keyword: self?.searchBar.text ?? "")
    }.disposed(by: disposeBag)
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
                                    self?.presenter.removeFromFavorite(item: movie)
                                  }))
    present(alert, animated: true, completion: nil)
  }
}

extension FavoriteViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter.movies.value?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: FavoriteMovieCell = tableView.dequeueReusableCell(for: indexPath)
    cell.item = presenter.movies.value?[indexPath.row]
    cell.favButtonHandler = { [weak self] movie in
      self?.confirmRemoveFavorite(movie: movie)
    }
    return cell
  }
}

extension FavoriteViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let item = presenter.movies.value?[indexPath.row] {
      router.routeToDetail(from: self, movie: item)
    }
  }
}
