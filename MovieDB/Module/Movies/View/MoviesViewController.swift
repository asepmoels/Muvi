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

class MoviesViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let router: MovieRouter
  private let presenter: MoviePresenter
  private let tableView = UITableView(frame: CGRect.zero, style: .grouped)

  init(router: MovieRouter,
       presenter: MoviePresenter) {
    self.router = router
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    observePresenter()
    presenter.getTrending()
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
    presenter.isLoading.subscribe { (isLoading) in
      isLoading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }.disposed(by: disposeBag)

    presenter.trendings.filter({ $0 != nil }).subscribe { [weak self] _ in
      self?.tableView.reloadData()
      self?.presenter.getNowPlaying()
    }.disposed(by: disposeBag)

    presenter.nowPlayings.filter({ $0 != nil }).subscribe { [weak self] _ in
      self?.tableView.reloadData()
      self?.presenter.getPopular()
    }.disposed(by: disposeBag)

    presenter.populars.filter({ $0 != nil }).subscribe { [weak self] _ in
      self?.tableView.reloadData()
      self?.presenter.getTopRated()
    }.disposed(by: disposeBag)

    presenter.topRateds.filter({ $0 != nil }).subscribe { [weak self] _ in
      self?.tableView.reloadData()
      self?.presenter.getUpcoming()
    }.disposed(by: disposeBag)

    presenter.upcomings.subscribe { [weak self] _ in
      self?.tableView.reloadData()
    }.disposed(by: disposeBag)
  }
}

extension MoviesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    presenter.homeContents.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if presenter.homeContents[indexPath.section] == .banner {
      let cell: MoviesBannerCell = tableView.dequeueReusableCell(for: indexPath)
      cell.items = presenter.trendings.value
      cell.selectionHandler = { [weak self] movie in
        guard let self = self else { return }
        self.router.routeToDetail(from: self, movie: movie)
      }
      return cell
    }

    let cell: MovieListCell = tableView.dequeueReusableCell(for: indexPath)
    switch presenter.homeContents[indexPath.section] {
    case .nowPlaying:
      cell.items = presenter.nowPlayings.value
    case .popular:
      cell.items = presenter.populars.value
    case .topRated:
      cell.items = presenter.topRateds.value
    case .upcoming:
      cell.items = presenter.upcomings.value
    default:
      break
    }
    cell.selectionHandler = { [weak self] movie in
      guard let self = self else { return }
      self.router.routeToDetail(from: self, movie: movie)
    }
    return cell
  }
}

extension MoviesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(MovieGenreHeaderView.self)
    header?.titleLabel.text = presenter.homeContents[section].rawValue
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
