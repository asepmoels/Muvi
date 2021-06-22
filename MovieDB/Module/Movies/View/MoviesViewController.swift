//
//  MoviesViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import RxSwift
import SVProgressHUD
import SnapKit
import Core
import Movies

enum HomeContent: String, CaseIterable {
  case banner
  case nowPlaying = "Now Playing"
  case topRated = "Top Rated"
  case popular = "Popular"
  case upcoming = "Upcoming"
}

typealias MoviesPresenterType = GetGoupedListPresenter<
  Int, Movie, Interactor<
    Int, [Movie], MoviesByGroupRepository<
      MoviesRemoteDataSource
    >
  >
>

class MoviesViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let router: DetailMovieRouter
  private let presenters: [MoviesPresenterType]
  private let tableView = UITableView(frame: CGRect.zero, style: .grouped)

  init(router: DetailMovieRouter,
       presenters: [MoviesPresenterType]) {
    self.router = router
    self.presenters = presenters
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    observePresenter()
    presenters.first?.getList(request: nil)
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
    tableView.register(headerFooterViewType: MovieGenreHeaderView.self)
    tableView.register(cellType: MoviesBannerCell.self)
    tableView.register(cellType: MovieListCell.self)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .mainColor
    view.backgroundColor = .mainBarColor
    view.addSubview(tableView)
    tableView.snp.makeConstraints({ [weak self] maker in
      guard let self = self else { return }
      maker.leading.trailing.bottom.equalToSuperview()
      maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
    })
  }

  private func observePresenter() {
    for index in 0..<HomeContent.allCases.count {
      presenters[index].list.subscribe(onNext: { [weak self] data in
        self?.handleDataState(state: data, onLoaded: {
          self?.tableView.reloadData()
          if index < HomeContent.allCases.count - 1 {
            self?.presenters[1 + index].getList(request: nil)
          }
        })
      }).disposed(by: disposeBag)
    }
  }
}

extension MoviesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    HomeContent.allCases.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if HomeContent.allCases[indexPath.section] == .banner {
      let cell: MoviesBannerCell = tableView.dequeueReusableCell(for: indexPath)
      cell.items = presenters.first?.list.value.value
      cell.selectionHandler = { [weak self] movie in
        guard let self = self else { return }
        self.router.routeToDetailMovie(from: self, movie: movie)
      }
      return cell
    }

    let cell: MovieListCell = tableView.dequeueReusableCell(for: indexPath)
    cell.items = presenters[indexPath.section].list.value.value
    cell.selectionHandler = { [weak self] movie in
      guard let self = self else { return }
      self.router.routeToDetailMovie(from: self, movie: movie)
    }
    return cell
  }
}

extension MoviesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(MovieGenreHeaderView.self)
    header?.titleLabel.text = HomeContent.allCases[section].rawValue
    return header
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    section == 0 ? 8 : 48
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let width = UIScreen.main.bounds.width
    return indexPath.section == 0 ? ceil(281 / 500 * width) : 230
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    0.01
  }
}
