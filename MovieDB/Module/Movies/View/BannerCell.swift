//
//  BannerCell.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Reusable
import SDWebImage

class BannerCell: UICollectionViewCell, NibReusable {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!

  var item: Movie? {
    didSet {
      setContent()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  private func setContent() {
    titleLabel.text = item?.title.uppercased()
    imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
    imageView.sd_setImage(with: item?.backdropURL)
  }
}
