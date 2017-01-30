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
  @IBOutlet weak var chapterPageContainer: NSView!
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
    let border = Border(position: .right, width: 1.0, color: Config.style.darkenBackgroundColor)
    searchMangaButtonContainer.drawBorder(border)
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
      chapterPageContainer
    ]))
  }

  func setupConstraints() {
    constrain(mangaCollectionVC.view, mangaContainerView) { mangaCollection, mangaContainerView in
      mangaCollection.top == mangaContainerView.top
      mangaCollection.bottom == mangaContainerView.bottom
      mangaCollection.trailing == mangaContainerView.trailing

      mangaCollection.width >= 300
      mangaCollection.height >= 300
    }

    constrain(searchedMangaVC.view, searchMangaContainer) { searchMangaCollection, searchMangaContainer in
      searchMangaCollection.top == searchMangaContainer.top
      searchMangaCollection.bottom == searchMangaContainer.bottom
      searchMangaCollection.trailing == searchMangaContainer.trailing
      searchMangaCollection.leading == searchMangaContainer.leading
    }

    constrain(chapterCollectionVC.view, chapterContainerView) { chapterCollection, chapterContainerView in
      chapterCollection.top == chapterContainerView.top
      chapterCollection.bottom == chapterContainerView.bottom
      chapterCollection.trailing == chapterContainerView.trailing
      chapterCollection.leading == chapterContainerView.leading

      chapterCollection.width >= 470
      chapterCollection.height >= 300
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

    let pageVM = ChapterPageCollectionViewModel(chapterViewModel: ChapterViewModel(chapter: chapter))
    chapterPageCollectionVC = ChapterPageCollectionViewController(viewModel: pageVM)
    chapterPageCollectionVC!.delegate = self
    chapterPageContainer.addSubview(chapterPageCollectionVC!.view)

    setupChapterPageCollectionConstraints()
    Router.moveTo(id: YomuRouteId.ChapterPage)
  }

  func setupChapterPageCollectionConstraints() {
    constrain(chapterPageCollectionVC!.view, chapterPageContainer) { chapterPageCollection, chapterPageContainer in
      chapterPageCollection.top == chapterPageContainer.top
      chapterPageCollection.bottom == chapterPageContainer.bottom
      chapterPageCollection.left == chapterPageContainer.left
      chapterPageCollection.right == chapterPageContainer.right
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

      self.mangaCollectionVM.fetch(id: $0) ==> self.disposeBag
    } ==> self.disposeBag

    Router.moveTo(id: YomuRouteId.Main)
  }

  func closeView(_ sender: AnyObject?) {
    Router.moveTo(id: YomuRouteId.Main)
  }
}
