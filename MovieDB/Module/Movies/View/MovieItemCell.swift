//
//  MovieItemCell.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import UIKit
import Reusable
import SDWebImage

class MovieItemCell: UICollectionViewCell, NibReusable {
  var item: Movie? {
    didSet {
      setContent()
    }
  }

  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var actorLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  private func setContent() {
    genreLabel.text = item?.originalLanguage
    titleLabel.text = item?.title
    actorLabel.text = item?.overview
    posterImageView.sd_setImage(with: item?.posterURL)
  }
}
