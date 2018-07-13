//
//  MangaCell.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxSwift

class MangaItem: NSCollectionViewItem {
  @IBOutlet weak var mangaImageView: NSImageView!
  @IBOutlet weak var titleContainerView: NSBox!
  @IBOutlet weak var titleTextField: NSTextField!
  @IBOutlet weak var categoryTextField: NSTextField!
  @IBOutlet weak var selectedIndicator: NSBox!

  var disposeBag = DisposeBag()

	func setup(withViewModel viewModel: MangaViewModel) {
		disposeBag = DisposeBag()

		viewModel
      .title
      .drive(titleTextField.rx.text.orEmpty) ==> disposeBag

		viewModel
      .previewUrl
      .drive(onNext: mangaImageView.setImageWithUrl) ==> disposeBag

		viewModel
      .categoriesString
      .drive(categoryTextField.rx.text.orEmpty) ==> disposeBag

		viewModel
      .selected
      .map(!)
      .drive(selectedIndicator.rx.isHidden) ==> disposeBag
	}

  override func viewDidLoad() {
    super.viewDidLoad()

    mangaImageView.kf.indicatorType = .activity
  }

  override func viewWillLayout() {
    super.viewWillLayout()

    let border = Border(position: .bottom, width: 1.0, color: Config.style.borderColor)
    titleContainerView.drawBorder(border)
  }
}
