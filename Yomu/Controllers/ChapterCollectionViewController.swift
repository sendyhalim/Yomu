//
//  ChapterCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Kingfisher
import RxSwift
import RxCocoa
import Swiftz

protocol ChapterSelectionDelegate: class {
  func chapterDidSelected(_ chapter: Chapter, navigator: ChapterNavigator)
}

class ChapterCollectionViewController: NSViewController {
  @IBOutlet weak var collectionView: NSCollectionView!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  @IBOutlet weak var chapterTitle: NSTextField!
  @IBOutlet weak var toggleSort: NSButton!

  weak var chapterSelectionDelegate: ChapterSelectionDelegate?

  let vm: ChapterCollectionViewModel
  var disposeBag = DisposeBag()

  init(viewModel: ChapterCollectionViewModel) {
    vm = viewModel

    super.init(nibName: "ChapterCollection", bundle: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.delegate = self
    collectionView.dataSource = self
    setupSubscriptions()
  }

  override func viewWillLayout() {
    super.viewWillLayout()
    collectionView.collectionViewLayout?.invalidateLayout()
  }

  func setupSubscriptions() {
    // Cleanup everytime we setup subscriptions
    disposeBag = DisposeBag()
    vm.reset()

    vm.reload ~~> collectionView.reloadData ==> disposeBag
    vm.fetching ~~> progressIndicator.animating ==> disposeBag

    chapterTitle
      .rx.text.orEmpty
      .throttle(0.5, scheduler: MainScheduler.instance)
      .bindTo(vm.filterPattern) ==> disposeBag

    toggleSort
      .rx.tap
      .bindTo(vm.toggleSort) ==> disposeBag

    vm.orderingIconName.drive(onNext: { [weak self] in
      self?.toggleSort.image = Config.icon(name: $0)
    }) ==> disposeBag
  }
}

extension ChapterCollectionViewController: NSCollectionViewDataSource {
  func collectionView(
    _ collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return vm.count
  }

  @objc(collectionView:didEndDisplayingItem:forRepresentedObjectAtIndexPath:) func collectionView(
    _ collectionView: NSCollectionView,
    didEndDisplaying item: NSCollectionViewItem,
    forRepresentedObjectAt indexPath: IndexPath
  ) {
    let _item = item as! ChapterItem

    _item.didEndDisplaying()
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    itemForRepresentedObjectAt indexPath: IndexPath
  ) -> NSCollectionViewItem {
    let cell = collectionView.makeItem(
      withIdentifier: "ChapterItem",
      for: indexPath
    ) as! ChapterItem

    cell.setup(withViewModel: vm[(indexPath as NSIndexPath).item])

    return cell
  }
}

extension ChapterCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: NSCollectionView,
    didSelectItemsAt indexPaths: Set<IndexPath>
  ) {
    let index = (indexPaths.first! as NSIndexPath).item
    let chapterVm = vm[index]
    let navigator = ChapterNavigator(collection: vm, currentIndex: index)

    collectionView.deselectAll(self)
    chapterSelectionDelegate?.chapterDidSelected(chapterVm.chapter, navigator: navigator)
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    layout collectionViewLayout: NSCollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> NSSize {
    return CGSize(width: collectionView.bounds.size.width, height: 88)
  }
}

extension ChapterCollectionViewController: MangaSelectionDelegate {
  func mangaDidSelected(_ manga: Manga) {
    setupSubscriptions()

    // Reset filter
    chapterTitle.stringValue = ""

    // Scroll to the top everytime manga is selected
    if !vm.isEmpty {
      let index = IndexPath(item: 0, section: 0)
      let indexPaths: Set = [index]
      collectionView.scrollToItems(at: indexPaths, scrollPosition: .top)
    }

    // At this point we are sure that manga.id will 100% available
    vm.fetch(id: manga.id!) ==> disposeBag
  }
}
