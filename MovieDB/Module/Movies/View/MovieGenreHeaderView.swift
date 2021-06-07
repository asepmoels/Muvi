//
//  MovieGenreHeaderView.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Reusable

class MovieGenreHeaderView: UITableViewHeaderFooterView, Reusable {
  let titleLabel = UILabel()

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureViews()
  }

  private func configureViews() {
    let clearView = UIView()
    clearView.backgroundColor = .mainColor
    backgroundView = clearView
    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
    titleLabel.textColor = .white
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (maker) in
      maker.leading.trailing.equalTo(20)
      maker.top.equalTo(16)
    }
    clipsToBounds = true
  }
}
