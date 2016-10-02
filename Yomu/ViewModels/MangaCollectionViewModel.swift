//
//  MangasViewModel.swift
//  Yomu
//
//  Created by Sendy Halim on 7/3/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

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
  private let _selectedIndex = Variable(SelectedIndex(previousIndex: -1, index: -1))
  private var _fetching = Variable(false)
  private var _mangas: Variable<OrderedSet<Manga>> = {
    let mangas = Database.queryMangas().sorted {
      $0.position < $1.position
    }

    return Variable(OrderedSet(elements: mangas))
  }()
  private let recentlyDeletedManga: Variable<Manga?> = Variable(.none)
  private var mangaViewModels = Variable(List<MangaViewModel>())

  var mangas: Driver<List<MangaViewModel>> {
    return mangaViewModels.asDriver()
  }

  var count: Int {
    return mangaViewModels.value.count
  }

  var fetching: Driver<Bool> {
    return _fetching.asDriver()
  }

  var disposeBag = DisposeBag()

  var reload: Driver<Void> {
    let void = Void()

    return Observable
      .of(_mangas.asObservable().map(const(void)), mangaViewModels.asObservable().map(const(void)))
      .merge()
      .asDriver(onErrorJustReturn: Void())
  }

  init() {
    recentlyDeletedManga
      .asObservable()
      .filter { $0 != nil }
      .map { manga in
        let id = manga?.id

        return Database.queryMangaRealm(id: id!)
      }
      .subscribe(Realm.rx.delete()) ==> disposeBag

    let this = self

    _mangas.asObservable() ~~> {
      let viewModels = $0.flatMap(MangaViewModel.init)
      this.mangaViewModels.value = List(fromArray: viewModels)
    } ==> disposeBag

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

    _fetching.value = true

    return MangaEden
      .request(api)
      .do(onCompleted: { self._fetching.value = false })
      .filterSuccessfulStatusCodes()
      .map(Manga.self)
      .subscribe(onNext: {
        var manga = $0
        manga.id = id
        manga.position = self.count

        // Manga already in collection
        if self._mangas.value.contains(manga) {
          return
        }

        self._mangas.value.append(element: manga)

        for (index, var manga) in self._mangas.value.enumerated() {
          if manga.position == MangaPosition.undefined.rawValue {
            manga.position = index
          }
        }
      })
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
