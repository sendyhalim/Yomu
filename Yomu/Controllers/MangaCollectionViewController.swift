//
//  MangaCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import RxMoya
import RxSwift

protocol MangaSelectionDelegate: class {
  func mangaDidSelected(_ manga: Manga)
}

class MangaCollectionViewController: NSViewController {
  @IBOutlet weak var mangaCollectionView: MenuableCollectionView!

  weak var mangaSelectionDelegate: MangaSelectionDelegate?

  let vm: MangaCollectionViewModel
  let disposeBag = DisposeBag()

  var currentlyDraggedIndexPaths = Set<IndexPath>()

  init(viewModel: MangaCollectionViewModel) {
    vm = viewModel

    super.init(nibName: "MangaCollection", bundle: nil)!
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    mangaCollectionView.menuSource = self
    mangaCollectionView.dataSource = self
    mangaCollectionView.delegate = self
    mangaCollectionView.register(forDraggedTypes: [NSPasteboardTypePNG, NSPasteboardTypeString])

    vm.reload ~~> { [weak self] _ in
      self?.mangaCollectionView.reloadData()
    } ==> disposeBag
  }

  override func viewWillLayout() {
    view.drawBorder(.right(1.0, 0, Config.style.darkenBackgroundColor))
  }
}

extension MangaCollectionViewController: NSCollectionViewDataSource {
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
      withIdentifier: "MangaItem",
      for: indexPath
    ) as! MangaItem

    let mangaViewModel = vm[(indexPath as NSIndexPath).item]

    mangaViewModel.title ~~> cell.titleTextField.rx.text ==> cell.disposeBag
    mangaViewModel.previewUrl ~~> cell.mangaImageView.setImageWithUrl ==> cell.disposeBag
    mangaViewModel.categoriesString ~~> cell.categoryTextField.rx.text ==> cell.disposeBag
    mangaViewModel.selected.map(!) ~~> cell.accessoryButton.rx.hidden ==> cell.disposeBag

    return cell
  }
}

extension MangaCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: NSCollectionView,
    didSelectItemsAt indexPaths: Set<IndexPath>
  ) {
    let index = (indexPaths.first! as NSIndexPath).item
    let viewModel = vm[index]

    vm.setSelectedIndex(index)
    mangaSelectionDelegate?.mangaDidSelected(viewModel.manga)
  }

  // MARK: Drag and drop operation
  // --------------------------------------------------

  func collectionView(
    _ collectionView: NSCollectionView,
    pasteboardWriterForItemAt indexPath: IndexPath
  ) -> NSPasteboardWriting? {
    let item = NSPasteboardItem()
    let mangaViewModel = vm[indexPath.item]

    // We need to set this value
    // to satisfy collectionView(_:validateDrop:proposedIndexPath:dropOperation:)
    // https://developer.apple.com/reference/appkit/nscollectionviewdelegate/1525471-collectionview
    item.setString(mangaViewModel.id, forType: NSPasteboardTypeString)

    return item
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    validateDrop draggingInfo: NSDraggingInfo,
    proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>,
    dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionViewDropOperation>
  ) -> NSDragOperation {
    return NSDragOperation.move
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    draggingSession session: NSDraggingSession,
    willBeginAt screenPoint: NSPoint,
    forItemsAt indexPaths: Set<IndexPath>
  ) {
    currentlyDraggedIndexPaths = indexPaths
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    draggingSession session: NSDraggingSession,
    endedAt screenPoint: NSPoint,
    dragOperation operation: NSDragOperation
  ) {
    currentlyDraggedIndexPaths = []
  }

  func collectionView(
    _ collectionView: NSCollectionView,
    acceptDrop draggingInfo: NSDraggingInfo,
    indexPath: IndexPath,
    dropOperation: NSCollectionViewDropOperation
  ) -> Bool {
    let fromIndexPath = currentlyDraggedIndexPaths.first!

    collectionView.animator().moveItem(at: fromIndexPath, to: indexPath)
    vm.move(fromIndex: fromIndexPath.item, toIndex: indexPath.item)

    return true
  }
}

extension MangaCollectionViewController: CollectionViewMenuSource {
  func menu(for event: NSEvent) -> NSMenu? {
    let menu = NSMenu()


    let point = mangaCollectionView.convert(event.locationInWindow, from: nil)

    // There's a possibility that user right click on empty space between cell items
    guard let indexPath = mangaCollectionView.indexPathForItem(at: point) else {
      return .none
    }

    let delete = NSMenuItem(
      title: "Delete Manga",
      action: #selector(MangaCollectionViewController.deleteManga(item:)),
      keyEquivalent: ""
    )
    delete.representedObject = indexPath

    let showChapters = NSMenuItem(
      title: "Show Chapters",
      action: #selector(MangaCollectionViewController.showChapters(item:)),
      keyEquivalent: ""
    )
    showChapters.representedObject = indexPath

    menu.addItem(showChapters)
    menu.addItem(delete)

    return menu
  }

  func deleteManga(item: NSMenuItem) {
    let indexPath = item.representedObject as! IndexPath

    vm.remove(mangaIndex: indexPath.item)
  }

  func showChapters(item: NSMenuItem) {
    let indexPath = item.representedObject as! IndexPath

    collectionView(mangaCollectionView, didSelectItemsAt: Set([indexPath]))
  }
}
