//
//  MangaContainerSplitViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 7/3/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import AppKit
import Cartography
import RxSwift

class MangaContainerViewController: NSViewController {
  @IBOutlet weak var mangaContainerView: NSView!
  @IBOutlet weak var chapterContainerView: NSView!
  @IBOutlet weak var chapterPageContainerView: NSView!
  @IBOutlet weak var searchMangaButtonContainer: NSView!
  @IBOutlet weak var searchMangaContainer: NSView!

  let mangaCollectionVM = MangaCollectionViewModel()
  var mangaCollectionVC: MangaCollectionViewController!

  let chapterCollectionVM = ChapterCollectionViewModel()
  var chapterCollectionVC: ChapterCollectionViewController!

  var chapterPageCollectionVC: ChapterPageCollectionViewController?

  let searchedMangaCollectionVM = SearchedMangaCollectionViewModel()
  var searchedMangaVC: SearchedMangaCollectionViewController!

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    mangaCollectionVC = MangaCollectionViewController(viewModel: mangaCollectionVM)
    chapterCollectionVC = ChapterCollectionViewController(viewModel: chapterCollectionVM)
    searchedMangaVC = SearchedMangaCollectionViewController(viewModel: searchedMangaCollectionVM)

    mangaContainerView.addSubview(mangaCollectionVC.view)
    chapterContainerView.addSubview(chapterCollectionVC.view)
    searchMangaContainer.addSubview(searchedMangaVC.view)

    mangaCollectionVC.mangaSelectionDelegate = chapterCollectionVC
    chapterCollectionVC.chapterSelectionDelegate = self
    searchedMangaVC.delegate = self

    setupRoutes()
    setupConstraints()
  }

  override func viewWillLayout() {
    searchMangaButtonContainer.drawBorder(.Right(1.0, 0, Config.style.darkenBackgroundColor))
  }

  func setupRoutes() {
    Router.register(YomuRoute.Main([
      mangaContainerView,
      chapterContainerView,
      searchMangaButtonContainer
    ]))

    Router.register(YomuRoute.SearchManga([
      searchMangaContainer
    ]))

    Router.register(YomuRoute.ChapterPage([
      chapterPageContainerView
    ]))
  }

  func setupConstraints() {
    constrain(mangaCollectionVC.view, mangaContainerView) {
      mangaCollectionView, mangaContainerView in
      mangaCollectionView.top == mangaContainerView.top
      mangaCollectionView.bottom == mangaContainerView.bottom

      mangaCollectionView.width >= 300
      mangaCollectionView.height >= 300
    }

    constrain(searchedMangaVC.view, searchMangaContainer) {
      searchMangaCollectionView, searchMangaContainer in
      searchMangaCollectionView.top == searchMangaContainer.top
      searchMangaCollectionView.bottom == searchMangaContainer.bottom
      searchMangaCollectionView.trailing == searchMangaContainer.trailing
      searchMangaCollectionView.leading == searchMangaContainer.leading
    }


    constrain(chapterCollectionVC.view, chapterContainerView) {
      chapterCollectionView, chapterContainerView in
      chapterCollectionView.top == chapterContainerView.top
      chapterCollectionView.bottom == chapterContainerView.bottom
      chapterCollectionView.trailing == chapterContainerView.trailing
      chapterCollectionView.leading == chapterContainerView.leading

      chapterCollectionView.width >= 470
      chapterCollectionView.height >= 300
    }
  }

  @IBAction func showSearchMangaView(sender: NSButton) {
    Router.moveTo(YomuRouteId.SearchManga)
  }
}

extension MangaContainerViewController: ChapterSelectionDelegate {
  func chapterDidSelected(chapter: Chapter) {
    if chapterPageCollectionVC != nil {
      chapterPageCollectionVC!.view.removeFromSuperview()
    }

    let pageVM = ChapterPageCollectionViewModel(chapterId: chapter.id)
    chapterPageCollectionVC = ChapterPageCollectionViewController(viewModel: pageVM)
    chapterPageCollectionVC!.delegate = self
    chapterPageContainerView.addSubview(chapterPageCollectionVC!.view)

    setupChapterPageCollectionConstraints()
    Router.moveTo(YomuRouteId.ChapterPage)
  }

  func setupChapterPageCollectionConstraints() {
    constrain(chapterPageCollectionVC!.view, chapterPageContainerView) {
      chapterPageCollectionView, chapterPageContainerView in
      chapterPageCollectionView.top == chapterPageContainerView.top
      chapterPageCollectionView.bottom == chapterPageContainerView.bottom
      chapterPageCollectionView.left == chapterPageContainerView.left
      chapterPageCollectionView.right == chapterPageContainerView.right
    }
  }
}

extension MangaContainerViewController: ChapterPageCollectionViewDelegate {
  func closeChapterPage() {
    Router.moveTo(YomuRouteId.Main)
  }
}

extension MangaContainerViewController: SearchedMangaDelegate {
  func searchedMangaDidSelected(viewModel: SearchedMangaViewModel) {
    viewModel.apiId ~> { [weak self] in
      guard let `self` = self else {
        return
      }

      self.mangaCollectionVM.fetch($0) >>> self.disposeBag
    } >>> self.disposeBag

    Router.moveTo(YomuRouteId.Main)
  }

  func closeView(sender: SearchedMangaCollectionViewController) {
    Router.moveTo(YomuRouteId.Main)
  }
}
