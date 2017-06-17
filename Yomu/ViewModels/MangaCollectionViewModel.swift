//
//  MangasViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/3/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import OrderedSet
import class RealmSwift.Realm
import RxCocoa
import RxMoya
import RxSwift
import RxRealm
import Swiftz

struct SelectedIndex {
  let previousIndex: Int
  let index: Int
}

struct MangaCollectionViewModel {
  // MARK: Public
  var count: Int {
    return mangaViewModels.value.count
  }

  // MARK: Output
  let fetching: Driver<Bool>
  let reload: Driver<Void>
  let mangas: Driver<List<MangaViewModel>>

  // MARK: Private
  fileprivate let _selectedIndex = Variable(SelectedIndex(previousIndex: -1, index: -1))
  fileprivate var _fetching = Variable(false)
  fileprivate var _mangas: Variable<OrderedSet<Manga>> = {
    let mangas = Database.queryMangas().sorted {
      $0.position < $1.position
    }

    return Variable(OrderedSet(elements: mangas))
  }()
  fileprivate let recentlyDeletedManga: Variable<Manga?> = Variable(.none)
  fileprivate let mangaViewModels = Variable(List<MangaViewModel>())
  fileprivate let disposeBag = DisposeBag()

  init() {
    fetching = _fetching.asDriver()
    mangas = mangaViewModels.asDriver()
    reload = Observable
      .of(
        _mangas.asObservable().map(void),
        mangaViewModels.asObservable().map(void)
      )
      .merge()
      .asDriver(onErrorJustReturn: Void())

    recentlyDeletedManga
      .asObservable()
      .filter { $0 != nil }
      .map { manga in
        let id = manga?.id

        return Database.queryMangaRealm(id: id!)
      }
      .subscribe(Realm.rx.delete()) ==> disposeBag

    _mangas
      .asObservable()
      .map {
        let viewModels = $0.flatMap(MangaViewModel.init)

        return List(fromArray: viewModels)
      }
      .bind(to: mangaViewModels) ==> disposeBag

    _mangas
      .asObservable()
      .filter { $0.count != 0 }
      .flatMap { Observable.from($0) }
      .map(MangaRealm.from(manga:))
      .subscribe(Realm.rx.add(update: true)) ==> disposeBag
  }

  subscript(index: Int) -> MangaViewModel {
    return mangaViewModels.value[UInt(index)]
  }

  func fetch(id: String) -> Disposable {
    let api = MangaEdenAPI.mangaDetail(id)

    let request = MangaEden.request(api).share()

    let fetchingDisposable = request
      .map(const(false))
      .startWith(true)
      .asDriver(onErrorJustReturn: false)
      .drive(_fetching)

    let resultDisposable = request
      .filterSuccessfulStatusCodes()
      .map(Manga.self)
      .map {
        var manga = $0
        manga.id = id
        manga.position = self.count

        return manga
      }
      .filter {
        return !self._mangas.value.contains($0)
      }
      .subscribe(onNext: {
        self._mangas.value.append(element: $0)
      })

    return CompositeDisposable(fetchingDisposable, resultDisposable)
  }

  func setSelectedIndex(_ index: Int) {
    let previous = _selectedIndex.value
    let selectedIndex = SelectedIndex(previousIndex: previous.index, index: index)
    _selectedIndex.value = selectedIndex

    mangaViewModels.value.forEach {
      $0.setSelected(false)
    }

    self[selectedIndex.index].setSelected(true)
  }

  func move(fromIndex: Int, toIndex: Int) {
    let manga = self[fromIndex].manga
    _mangas.value.remove(index: fromIndex)
    _mangas.value.insert(element: manga, atIndex: toIndex)
    updateMangaPositions()
  }

  func remove(mangaIndex: Int) {
    recentlyDeletedManga.value = _mangas.value.remove(index: mangaIndex)
    updateMangaPositions()
  }

  private func updateMangaPositions() {
    let indexes: [Int] = [Int](0..<self.count)

    indexes.forEach {
      _mangas.value[$0].position = $0
    }
  }
}
