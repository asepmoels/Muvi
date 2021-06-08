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

class SearchViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let presenter: SearchPresenter
  private let collectionView = UICollectionView(frame: CGRect.zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())
  private let searchBar = SearchTextField()

  init(presenter: SearchPresenter) {
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
}
