//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Dispatch
import Foundation

let queue = DispatchQueue.main
func sepBar() {
    print("---------------")
}


// Playgroundでの非同期実行を待つオプション
PlaygroundPage.current.needsIndefiniteExecution = true

// weakキーワードによるクロージャのキャプチャ

class SomeClass {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

do {
    let object = SomeClass(id: 42)
    let closure = { [weak object] () -> Void in
        if let o = object {
            print("objectはまだ解放されていません: id => \(o.id)")
        } else {
            print("objectはすでに解放されました")
        }
    }
    
    print("ローカルスコープ内で実行: ", terminator: "")
    closure()
    
    let queue = DispatchQueue.main
    
    queue.asyncAfter(deadline: .now() + 1) {
        print("ローカルスコープ外で実行: ", terminator: "")
        closure()
    }
}

queue.asyncAfter(deadline: .now() + 1.5) {
    sepBar()
}

// unownedキーワードによるクロージャのキャプチャ（エラー）

//do {
//    let object2 = SomeClass(id: 42)
//    let closure2 = { [unowned object2] () -> Void in
//        print("objectはまだ解放されていません: id => \(object2.id)")
//    }
//
//    let queue = DispatchQueue.main
//    queue.asyncAfter(deadline: .now() + 2) {
//        print("ローカルスコープ内で実行: ", terminator: "")
//        closure2()
//    }
//
//    queue.asyncAfter(deadline: .now() + 3) {
//        print("ローカルスコープ外で実行: ", terminator: "")
//        closure2()
//    }
//}

// オブザーバパターンの実装

class Poster {
    static let notificationName = Notification.Name("SomeNotification")
    
    func post() {
        NotificationCenter.default.post(
            name: Poster.notificationName, object: nil)
    }
}

class Observer {
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: Poster.notificationName,
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleNotification(_ notification: Notification) {
        print("通知を受け取りました")
    }
}

var observer = Observer()
let poster = Poster()
poster.post()

// ディスパッチキューへのタスクの追加

let queue2 = DispatchQueue.global(qos: .userInitiated)
queue2.async {
    let isMainThread = Thread.isMainThread
    print("非同期の処理")
}

