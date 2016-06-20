//
//  ChapterCollectionViewController.swift
//  Yomu
//
//  Created by Sendy Halim on 6/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import Kingfisher
import RxSwift
import Swiftz

class ChapterCollectionViewController: NSViewController {
  @IBOutlet weak var tableView: NSTableView!

  let vm = ChaptersViewModel(id: "4e70ea03c092255ef70046f0")
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    let chapterItemNib = NSNib(nibNamed: "ChapterItem", bundle: nil)
    tableView.registerNib(chapterItemNib, forIdentifier: "ChapterItem")
    tableView.setDelegate(self)
    tableView.setDataSource(self)

    vm.chapters
      .driveNext { [weak self] chapters in
        self!.tableView.reloadData()
      } >>> disposeBag

    vm.fetch()
  }
}

extension ChapterCollectionViewController: NSTableViewDataSource, NSTableViewDelegate {
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return vm.count
  }

  func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    return 57
  }

  func tableView(
    tableView: NSTableView,
    viewForTableColumn tableColumn: NSTableColumn?,
    row: Int
  ) -> NSView? {
    let item = tableView.makeViewWithIdentifier(
      "ChapterItem",
      owner: self
    ) as! ChapterItem

    let chapter = vm[row]
    item.chapterNumber.stringValue = "\(chapter.number)"
    item.chapterTitle.stringValue = chapter.title

    return item
  }
}
