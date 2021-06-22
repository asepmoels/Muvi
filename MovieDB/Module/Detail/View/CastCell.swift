//
//  CastCell.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import UIKit
import Reusable
import SDWebImage
import Movies

class CastCell: UICollectionViewCell, Reusable {
  private let imageView = UIImageView(frame: .zero)
  private let nameLabel = UILabel(frame: .zero)

  var item: Cast? {
    didSet {
      setContent()
    }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureViews()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureViews()
  }

  private func configureViews() {
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { (maker) in
      maker.leading.top.trailing.equalToSuperview()
      maker.height.equalTo(imageView.snp.width)
    }
    imageView.layer.cornerRadius = 45
    imageView.layer.masksToBounds = true
    imageView.backgroundColor = .gray
    imageView.contentMode = .scaleAspectFill
    nameLabel.font = UIFont.systemFont(ofSize: 12)
    nameLabel.numberOfLines = 0
    nameLabel.textColor = .white
    nameLabel.textAlignment = .center
    contentView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { (maker) in
      maker.top.equalTo(imageView.snp.bottom).offset(16)
      maker.leading.trailing.equalToSuperview()
    }
  }

  private func setContent() {
    nameLabel.text = item?.name.uppercased()
    imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
    imageView.sd_setImage(with: item?.fotoURL)
  }
}
