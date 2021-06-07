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
  private let presenter: MoviePresenter
  private let tableView = UITableView()

  init(presenter: MoviePresenter) {
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
    presenter.getNowPlaying()
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

    presenter.nowPlayings.subscribe { [weak self] _ in
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
    let cell: MovieListCell = tableView.dequeueReusableCell(for: indexPath)
    cell.items = presenter.nowPlayings.value
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
    64
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    230
  }
}
