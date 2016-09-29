//
//  ChapterPageCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/20/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//


import AppKit
import RxSwift
import Swiftz

protocol ChapterPageCollectionViewDelegate: class {
  func closeChapterPage()
}

class ChapterPageCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var close: NSButton!
  @IBOutlet weak var readingProgress: NSTextField!
  @IBOutlet weak var zoomIn: NSButton!

  weak var delegate: ChapterPageCollectionViewDelegate?

  let vm: ChapterPageCollectionViewModel
  let disposeBag = DisposeBag()

  init(viewModel: ChapterPageCollectionViewModel) {
    vm = viewModel

    super.init(nibName: "ChapterPageCollection", bundle: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.dataSource = self
    collectionView.delegate = self

    zoomIn
      .rx.tap
      .subscribe(onNext: vm.zoomIn) >>>> disposeBag

    delegate?.closeChapterPage
      >>- { close.rx.tap.subscribe(onNext: $0) }
      ~>> disposeBag

    vm.reload ~~> collectionView.reloadData >>>> disposeBag

    vm.zoomScale ~~> { [weak self] _ in
      self?.collectionView.collectionViewLayout?.invalidateLayout()
    } >>>> disposeBag

    vm.chapterPages ~~> { [weak self] _ in
      self?.collectionView.reloadData()
    } >>>> disposeBag

    vm.readingProgress
      ~~> readingProgress.rx.text
      >>>> disposeBag

    vm.readingProgress ~~> readingProgress.rx.text >>>> disposeBag

    vm.fetch() >>>> disposeBag
  }
}

extension ChapterPageCollectionViewController: NSCollectionViewDataSource {
  func numberOfSections(in collectionView: NSCollectionView) -> Int {
    return 1
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return vm.count
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    itemForRepresentedObjectAt indexPath: IndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(
      withIdentifier: "ChapterPageItem",
      for: indexPath
    ) as! ChapterPageItem

    let pageViewModel = vm[(indexPath as NSIndexPath).item]

    pageViewModel.imageUrl
      ~~> cell.pageImageView.setImageWithUrl
      >>>> disposeBag

    return cell
  }
}

extension ChapterPageCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: NSCollectionView,
    willDisplay item: NSCollectionViewItem,
    forRepresentedObjectAt indexPath: IndexPath
  ) {
    vm.setCurrentPageIndex((indexPath as NSIndexPath).item)
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    layout collectionViewLayout: NSCollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> NSSize {
    print(vm.pageSize)
    return vm.pageSize
  }
}
