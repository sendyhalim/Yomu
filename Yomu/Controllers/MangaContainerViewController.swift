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
    searchMangaButtonContainer.drawBorder(.right(1.0, 0, Config.style.darkenBackgroundColor))
  }

  func setupRoutes() {
    Router.register(route: YomuRoute.main([
      mangaContainerView,
      chapterContainerView,
      searchMangaButtonContainer
    ]))

    Router.register(route: YomuRoute.searchManga([
      searchMangaContainer
    ]))

    Router.register(route: YomuRoute.chapterPage([
      chapterPageContainerView
    ]))
  }

  func setupConstraints() {
    constrain(mangaCollectionVC.view, mangaContainerView) {
      mangaCollectionView, mangaContainerView in
      mangaCollectionView.top == mangaContainerView.top
      mangaCollectionView.bottom == mangaContainerView.bottom
      mangaCollectionView.trailing == mangaContainerView.trailing

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

  @IBAction func showSearchMangaView(_ sender: NSButton) {
    Router.moveTo(id: YomuRouteId.SearchManga)
  }
}

extension MangaContainerViewController: ChapterSelectionDelegate {
  func chapterDidSelected(_ chapter: Chapter) {
    if chapterPageCollectionVC != nil {
      chapterPageCollectionVC!.view.removeFromSuperview()
    }

    let pageVM = ChapterPageCollectionViewModel(chapterVM: ChapterViewModel(chapter: chapter))
    chapterPageCollectionVC = ChapterPageCollectionViewController(viewModel: pageVM)
    chapterPageCollectionVC!.delegate = self
    chapterPageContainerView.addSubview(chapterPageCollectionVC!.view)

    setupChapterPageCollectionConstraints()
    Router.moveTo(id: YomuRouteId.ChapterPage)
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
    Router.moveTo(id: YomuRouteId.Main)
  }
}

extension MangaContainerViewController: SearchedMangaDelegate {
  func searchedMangaDidSelected(_ viewModel: SearchedMangaViewModel) {
    viewModel.apiId ~~> { [weak self] in
      guard let `self` = self else {
        return
      }

      self.mangaCollectionVM.fetch(id: $0) >>>> self.disposeBag
    } >>>> self.disposeBag

    Router.moveTo(id: YomuRouteId.Main)
  }

  func closeView(_ sender: SearchedMangaCollectionViewController) {
    Router.moveTo(id: YomuRouteId.Main)
  }
}
