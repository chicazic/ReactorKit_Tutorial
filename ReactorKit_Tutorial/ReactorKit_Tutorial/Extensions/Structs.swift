//
//  Structs.swift
//  ReactorKit_Tutorial
//
//  Created by 송형욱 on 2021/12/27.
//

import Foundation

struct ALERT {
    var title: String = ""
    var msg: String = ""
    var done: String = ""
    var cancel: String? = nil
    var completion: ((Bool) -> Void)? = nil
    
    init(
        title: String = "",
        msg: String = "",
        done: String = "",
        cancel: String? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.msg = msg
        self.done = done
        self.cancel = cancel
        self.completion = completion
    }
}
