//
//  MoviesBannerCell.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import Reusable

class MoviesBannerCell: UITableViewCell, Reusable {
  private let collectionView = UICollectionView(frame: CGRect.zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())
  private var timer: Timer?

  var items: [Movie]? {
    didSet {
      collectionView.reloadData()
    }
  }
  var selectionHandler: ((Movie) -> Void)?

  deinit {
    stopTimer()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureViews()
  }

  func configureViews() {
    selectionStyle = .none
    backgroundColor = .clear
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
      let width = UIScreen.main.bounds.width
      layout.itemSize = CGSize(width: width, height: 281 / 500 * width)
      layout.sectionInset = UIEdgeInsets.zero
      layout.minimumInteritemSpacing = 0
      layout.minimumLineSpacing = 0
    }
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.isPagingEnabled = true
    collectionView.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview()
    }
    collectionView.register(cellType: BannerCell.self)
    collectionView.dataSource = self
    collectionView.delegate = self
    startTimer()
  }

  private func startTimer() {
    if timer != nil { return }
    timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] (_) in
      guard let totalBanner = self?.items?.count,
            let xPosition = self?.collectionView.contentOffset.x,
            let width = self?.collectionView.bounds.width,
            totalBanner > 0 else {
        return
      }

      var currentPage = Int(xPosition / width)
      currentPage += 1
      if currentPage >= totalBanner {
        currentPage = 0
      }
      self?.collectionView.setContentOffset(
        CGPoint(x: CGFloat(currentPage) * width, y: 0),
        animated: true)
    })
  }

  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
}

extension MoviesBannerCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    items?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: BannerCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.item = items?[indexPath.row]
    return cell
  }
}

extension MoviesBannerCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    if let movie = items?[indexPath.row] {
      selectionHandler?(movie)
    }
  }
}
