//
//  ResultTitleCell.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Reusable

class ResultTitleCell: UICollectionReusableView, Reusable {
  private let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureViews()
  }

  private func configureViews() {
    addSubview(label)
    label.snp.makeConstraints { (maker) in
      maker.leading.trailing.equalTo(20)
      maker.centerY.equalToSuperview()
    }
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .white
  }

  var text: String = "" {
    didSet {
      if text.isEmpty {
        label.text = ""
      } else {
        let content = NSMutableAttributedString(string: "Showing result of ")
        content.append(NSAttributedString(string: "\'\(text)\'",
                                          attributes: [
                                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
                                          ]))
        label.attributedText = content
      }
    }
  }
}
