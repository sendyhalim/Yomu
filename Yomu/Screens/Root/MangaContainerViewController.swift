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
  @IBOutlet weak var chapterPageContainerView: ChapterPageContainer!
  @IBOutlet weak var searchMangaButtonContainer: NSView!
  @IBOutlet weak var searchMangaContainerView: NSView!

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
    searchMangaContainerView.addSubview(searchedMangaVC.view)

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
      searchMangaContainerView
    ]))

    Router.register(route: YomuRoute.chapterPage([
      chapterPageContainerView
    ]))
  }

  func setupConstraints() {
    constrain(mangaCollectionVC.view, mangaContainerView) { child, parent in
      child.top == parent.top
      child.bottom == parent.bottom
      child.trailing == parent.trailing
      child.leading == parent.leading

      child.width >= 300
      child.height >= 300
    }

    constrain(searchedMangaVC.view, searchMangaContainerView) { child, parent in
      child.top == parent.top
      child.bottom == parent.bottom
      child.trailing == parent.trailing
      child.leading == parent.leading
    }

    constrain(chapterCollectionVC.view, chapterContainerView) { child, parent in
      child.top == parent.top
      child.bottom == parent.bottom
      child.trailing == parent.trailing
      child.leading == parent.leading

      child.width >= 470
      child.height >= 300
    }
  }

  @IBAction func showSearchMangaView(_ sender: NSButton) {
    Router.moveTo(id: YomuRouteId.SearchManga)
  }
}

extension MangaContainerViewController: ChapterSelectionDelegate {
  func chapterDidSelected(_ chapter: Chapter, navigator: ChapterNavigator) {
    if chapterPageCollectionVC != nil {
      chapterPageCollectionVC!.view.removeFromSuperview()
    }

    let pageVM = ChapterPageCollectionViewModel(chapterViewModel: ChapterViewModel(chapter: chapter))
    chapterPageCollectionVC = ChapterPageCollectionViewController(viewModel: pageVM, navigator: navigator)
    chapterPageCollectionVC!.delegate = self
    chapterPageCollectionVC!.chapterSelectionDelegate = self
    chapterPageContainerView.addSubview(chapterPageCollectionVC!.view)
    chapterPageContainerView.delegate = chapterPageCollectionVC

    setupChapterPageCollectionConstraints()
    Router.moveTo(id: YomuRouteId.ChapterPage)
  }

  func setupChapterPageCollectionConstraints() {
    constrain(chapterPageCollectionVC!.view, chapterPageContainerView) { child, parent in
      child.top == parent.top
      child.bottom == parent.bottom
      child.left == parent.left
      child.right == parent.right
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
    viewModel.apiId
      .drive(onNext: { [weak self] in
        guard let `self` = self else {
          return
        }

        self.mangaCollectionVM.fetch(id: $0) ==> self.disposeBag
      }) ==> self.disposeBag

    Router.moveTo(id: YomuRouteId.Main)
  }

  func closeView(_ sender: AnyObject?) {
    Router.moveTo(id: YomuRouteId.Main)
  }
}
