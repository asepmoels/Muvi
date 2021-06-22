//
//  MovieListCell.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Reusable
import Movies

class MovieListCell: UITableViewCell, Reusable {
  private let collectionView = UICollectionView(frame: CGRect.zero,
                                                collectionViewLayout: UICollectionViewFlowLayout())

  var items: [Movie]? {
    didSet {
      collectionView.reloadData()
    }
  }
  var selectionHandler: ((Movie) -> Void)?

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
      layout.itemSize = CGSize(width: 120, height: 230)
      layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
      layout.minimumInteritemSpacing = 6.5
      layout.minimumLineSpacing = 6.5
    }
    contentView.addSubview(collectionView)
    collectionView.backgroundColor = .clear
    collectionView.snp.makeConstraints { (maker) in
      maker.edges.equalToSuperview()
    }
    collectionView.register(cellType: MovieItemCell.self)
    collectionView.dataSource = self
    collectionView.delegate = self
  }
}

extension MovieListCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    items?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: MovieItemCell = collectionView.dequeueReusableCell(for: indexPath)
    cell.item = items?[indexPath.row]
    return cell
  }
}

extension MovieListCell: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    if let movie = items?[indexPath.row] {
      selectionHandler?(movie)
    }
  }
}
