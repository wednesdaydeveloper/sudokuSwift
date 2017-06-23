//
//  main.swift
//  sudokuSwift
//
//  Created by 岡本隆志 on 2017/06/20.
//  Copyright © 2017年 岡本隆志. All rights reserved.
//

import Foundation

var array = [
    [2, 0, 0, 0, 0, 9, 0, 8, 0,],
    [0, 4, 6, 0, 0, 0, 0, 0, 0,],
    [7, 0, 0, 4, 0, 2, 1, 0, 0,],
    [6, 0, 0, 0, 0, 1, 4, 0, 8,],
    [0, 0, 0, 6, 3, 0, 0, 2, 0,],
    [9, 2, 7, 0, 0, 0, 0, 0, 3,],
    [1, 0, 0, 9, 0, 0, 8, 4, 0,],
    [0, 9, 0, 0, 0, 0, 0, 0, 0,],
    [4, 0, 0, 0, 0, 0, 0, 6, 0,],
]
if let answer = Solver(input: array).solve() {
    let array = answer.array
    for row in 0..<Solver.Size {
        for col in 0..<Solver.Size {
            print(array[row][col], terminator: "")
        }
        print()
    }
}
else {
    print("unsolved!")
}
