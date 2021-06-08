//
//  FavoriteMovieCell.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import UIKit
import SDWebImage
import Reusable

class FavoriteMovieCell: UITableViewCell, NibReusable {
  var item: Movie? {
    didSet {
      setContent()
    }
  }
  var favButtonHandler: ((Movie) -> Void)?

  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  private func setContent() {
    genreLabel.text = item?.genres.map({ $0.name }).joined(separator: " • ")
    titleLabel.text = item?.title
    yearLabel.text = item?.releaseDate.components(separatedBy: "-").first
    posterImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
    posterImageView.sd_setImage(with: item?.backdropURL)
  }

  @IBAction func favButtonDidTapped(_ sender: Any) {
    if let movie = item {
      favButtonHandler?(movie)
    }
  }
}
