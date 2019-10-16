//
//  ConcurrencySupport.swift
//  Sudoku
//
//  Created by slee on 2016/1/15.
//  Copyright © 2016年 slee. All rights reserved.
//

import Foundation

var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

var GlobalUserInteractiveQueue: DispatchQueue {
    
    return DispatchQueue.global(qos:.userInteractive)
}

var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInitiated)
}

var GlobalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos:  .utility)
}

var GlobalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: .background)
}

