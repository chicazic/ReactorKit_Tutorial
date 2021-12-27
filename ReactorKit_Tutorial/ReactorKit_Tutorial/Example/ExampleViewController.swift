//
//  ExampleViewController.swift
//  ReactorKit_Tutorial
//
//  Created by 송형욱 on 2021/12/26.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class ExampleViewController: UIViewController, View {
    
    // MARK: Properties
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countButton: UIButton!
    
    var disposeBag = DisposeBag()
    

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         프로토콜을 정의하면 reactor 속성이 자동으로 생성
         새로운 값 지정 시  [ex.  self.reactor = ExampleReactor() ]
         self.bind(reactor: ExampleReactor()) 를 자동으로 호출
         한번 더 호출하지 않도록 주의하자!
         */
        self.reactor = ExampleReactor()
    }
}

extension ExampleViewController {
    
    // MARK: Bind
    /*
     Reactor에 User Interaction을 Bind 하거나
     Reactor의 State를 각각의 view component에 Bind
     */
    func bind(reactor: ExampleReactor) {
        
        // input
        self.textField
            .rx.text
            .map { Reactor.Action.textChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
            
        self.countButton
            .rx.tap
            .map { self.countLabel.text }
            .map { Reactor.Action.increased($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.resetButton
            .rx.tap
            .map { Reactor.Action.reset }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // output
        reactor.state
            .map { $0.text }
            .distinctUntilChanged()
            .bind(to: self.textLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.count }
            .distinctUntilChanged()
            .bind(to: self.countLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.isReset }
            .filter { $0 }
            .map { _ in nil }
            .bind(to: self.textField.rx.text)
            .disposed(by: self.disposeBag)
            
    }
}
