//
//  YoutubePlayerViewController.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import youtube_ios_player_helper

class YoutubePlayerViewController: UIViewController {
  private let videoId: String

  init(videoId: String) {
    self.videoId = videoId
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    self.videoId = ""
    super.init(coder: coder)
  }

  override func loadView() {
    let playerView = YTPlayerView()
    playerView.load(withVideoId: videoId)
    view = playerView
  }
}
