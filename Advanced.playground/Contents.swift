func sepBar() {
    print("---------------")
}

// 参照共有を行うクラス型と構造体の比較

protocol Target {
    var identifier: String { get set }
    var count: Int { get set }
    mutating func action()
}

extension Target {
    mutating func action() {
        count += 1
        print("id: \(identifier), count: \(count)")
    }
}

struct ValueTypeTarget : Target {
    var identifier = "Value Type"
    var count = 0
    
    init() {}
}

class ReferenceTypeTarget : Target {
    var identifier = "Reference Type"
    var count = 0
}

struct Timer {
    var target: Target
    mutating func start() {
        for _ in 0..<5 {
            target.action()
        }
    }
}

// 構造体のターゲットを登録してタイマーを実行
let valueTypeTarget: Target = ValueTypeTarget()
var timer1 = Timer(target: valueTypeTarget)
timer1.start()
valueTypeTarget.count

// クラスのターゲットを登録してタイマーを実行
let referenceTypeTarget = ReferenceTypeTarget()
var timer2 = Timer(target: referenceTypeTarget)
timer2.start()
referenceTypeTarget.count

sepBar()

// デリゲートパターンの実装

protocol GameDelegate : class {
    var numberOfPlayers : Int { get }
    func gameDidStart(_ game : Game)
    func gameDidEnd(_ game : Game)
}

class TwoPersonsGameDelegate : GameDelegate {
    var numberOfPlayers: Int { return 2 }
    func gameDidStart(_ game: Game) { print("Game start") }
    func gameDidEnd(_ game : Game) { print("Game end") }
}

class Game {
    weak var delegate: GameDelegate?
    
    func start() {
        print("Number of players is \(delegate?.numberOfPlayers ?? 1)")
        delegate?.gameDidStart(self)
        print("Playing")
        delegate?.gameDidEnd(self)
    }
}

let delegate = TwoPersonsGameDelegate()
let twoPersonsGame = Game()
twoPersonsGame.delegate = delegate
twoPersonsGame.start()

sepBar()

// クロージャによるコールバックの実装

class Game2 {
    private var result = 0
    
    func start(completion: (Int) -> Void) {
        print("Playing")
        result = 42
        completion(result)
    }
}

let game = Game2()
game.start { result in
    print("Result is \(result)")
}

sepBar()

// クロージャのキャプチャ

import PlaygroundSupport
import Dispatch

// Playgroundでの非同期実行を待つオプション
PlaygroundPage.current.needsIndefiniteExecution = true

class SomeClass {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    deinit {
        print("deinit")
    }
}

do {
    let object = SomeClass(id: 42)
    let queue = DispatchQueue.main
    
    queue.asyncAfter(deadline: .now() + 3) {
        print(object.id)
    }
}



class SomeClass2 {
    let id2: Int
    
    init(id2: Int) {
        self.id2 = id2
    }
}

let object1 = SomeClass2(id2: 42)
let object2 = SomeClass2(id2: 43)

let closure = { [weak object1, unowned object2] () -> Void in
    print(object1)
    print(object2)
}

closure()

sepBar()