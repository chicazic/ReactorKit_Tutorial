//
//  ExampleReactor.swift
//  ReactorKit_Tutorial
//
//  Created by 송형욱 on 2021/12/26.
//

import ReactorKit
import RxSwift

final class ExampleReactor: Reactor {
    
    // MARK: init
    /*
     만약 사용자로부터 Int값만 받길 원할 경우
     혹은 글자수제한을 두고 싶다면 어떻게 해야할까?
     */
    enum COUNT { // HANDLING VALID
        case success(_ count: String?)
        case failure
//        case failure(_ alert: ALERT?)
    }
    
    let initialState: State = State()
    
    enum Action {
        case textChanged(String?)
        case increased(String?)
        case reset
    }
    
    enum Mutation {
        case write(text: String?)
        case plus(count: COUNT)
        case reset
        case isReset(bool: Bool)
    }

    struct State {
        var text: String?
        var count: String? = "0"
        var isReset: Bool = false
//        var alert: ALERT?
    }
}

extension ExampleReactor {
    
    // MARK: Input, Output
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textChanged(let text):
            return .just(.write(text: text))
        case .increased(let count):
            return self.countIncreased(count: count)
        case .reset:
            return .concat([
                Observable.just(.isReset(bool: true)), // 로딩중을 알리는 로직으로 활용가능
                Observable.just(.reset),
                Observable.just(.isReset(bool: false))
            ])
            /*
             Observable.concat 이란?
             Combining Operator
             순서대로 합쳐주는 것
             ex.
             let example = Observable.of([1,2])
             let example2 = Observable.of([3,4])
             Observable.concat([example, example2])
                        .subscribe({ print($0) })
                        .disposed(by: self.disposeBag)
             1
             2
             3
             4
             */
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var _state = state
        switch mutation {
        case .write(text: let text):
            _state.text = text
        case .plus(count: let count):
            switch count {
            case .success(let count):
                _state.count = count
            case .failure:
                _state.count = "fail"
            }
        case .reset:
            _state.text = nil
            _state.count = "0"
        case .isReset(bool: let bool):
            _state.isReset = bool
        }
        return _state
    }
}

extension ExampleReactor {
    
    // MARK: Private
    private func countIncreased(count: String?) -> Observable<Mutation> {
        guard let _count = count,
              let countInt = Int(_count)
        else { return .just(.plus(count: .failure)) }
        
        let res = countInt + 1
        
        return .just(.plus(count: .success(String(res))))
    }
}
