//
//  MangaChapterCollectionViewItem.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxSwift

class ChapterItem: NSCollectionViewItem {
  @IBOutlet weak var chapterTitle: NSTextField!
  @IBOutlet weak var chapterNumber: NSTextField!
  @IBOutlet weak var chapterPreview: NSImageView!

  var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    chapterPreview.kf.indicatorType = .activity
  }

  func didEndDisplaying() {
    chapterPreview.image = .none

    disposeBag = DisposeBag()
  }

  func setup(withViewModel viewModel: ChapterViewModel) {
    disposeBag = DisposeBag()

    // Show activity indicator right now because fetch preview will
    // fetch chapter pages first, after the pages are loaded, the first image of the pages
    // will be fetched. Activity indicator will be removed automatically by kingfisher
    // after image preview is fetched.
    chapterPreview.kf.indicator?.startAnimatingView()
    viewModel.fetchPreview() ==> disposeBag
    viewModel.title ~~> chapterTitle.rx.text.orEmpty ==> disposeBag
    viewModel.previewUrl ~~> chapterPreview.setImageWithUrl ==> disposeBag
    viewModel.number ~~> chapterNumber.rx.text.orEmpty ==> disposeBag
  }

  override func viewWillLayout() {
    let border = Border(position: .bottom, width: 1.0, color: Config.style.borderColor)

    view.drawBorder(border)
  }
}
