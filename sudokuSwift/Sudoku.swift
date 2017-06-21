//
//  Sudoku.swift
//  sudokuSwift
//
//  Created by 岡本隆志 on 2017/06/21.
//  Copyright © 2017年 岡本隆志. All rights reserved.
//

import Foundation

class Cell {
    let row: Int
    let col: Int
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}

class SolvedCell: Cell
{
    let blk: Int
    let val: Int
    
    init(row: Int, col: Int, blk: Int, val: Int) {
        self.blk = blk
        self.val = val
        super.init(row: row, col: col)
    }
}

class UnsolvedCell : Cell
{
    let unused : Set<Int>
    init(row: Int, col: Int, unused: Set<Int>) {
        self.unused = unused
        super.init(row: row, col: col)
    }
}

class Result
{
    let solved: Bool
    let array: [[Int]]
    
    init(solved: Bool, array: [[Int]] = []) {
        self.solved = solved
        self.array = array
    }
}

class Solver {
    static let Size: Int = 9
    
    let InitialCell: [SolvedCell];
    
    static var SubBlockMask: [[Int]] = [
        [0, 0, 0, 1, 1, 1, 2, 2, 2],
        [0, 0, 0, 1, 1, 1, 2, 2, 2],
        [0, 0, 0, 1, 1, 1, 2, 2, 2],
        [3, 3, 3, 4, 4, 4, 5, 5, 5],
        [3, 3, 3, 4, 4, 4, 5, 5, 5],
        [3, 3, 3, 4, 4, 4, 5, 5, 5],
        [6, 6, 6, 7, 7, 7, 8, 8, 8],
        [6, 6, 6, 7, 7, 7, 8, 8, 8],
        [6, 6, 6, 7, 7, 7, 8, 8, 8],
        ]
    
    init(input: [[Int]]) {
        var initialCell = [SolvedCell]();
        for row in 0..<Solver.Size {
            for col in 0..<Solver.Size {
                let val = input[row][col]
                if val > 0
                {
                    let blk = Solver.SubBlockMask[row][col];
                    initialCell.append(SolvedCell(row: row, col: col, blk: blk, val: val))
                }
            }
        }
        InitialCell = initialCell
    }
    
    func answerArray(results: [SolvedCell]) -> [[Int]] {
        var answer = [[Int]](repeating: [Int](repeating: 0, count: Solver.Size), count: Solver.Size)
        for row in 0..<Solver.Size {
            for col in 0..<Solver.Size {
                if let result = results.filter({ r in r.row == row && r.col == col}).first {
                    answer[row][col] = result.val
                }
            }
        }
        return answer
    }
    
    func unusedValues(currentCell: Cell, solvedCells: [SolvedCell]) -> Set<Int> {
        let blk = Solver.SubBlockMask[currentCell.row][currentCell.col];
        
        let usedValues = solvedCells
            .filter({cell in cell.row == currentCell.row || cell.col == currentCell.col || cell.blk == blk})
            .map({cell in cell.val})
        return Set(1...9).subtracting(Set(usedValues))
    }
    
    func solve(results: [SolvedCell] = []) -> Result {
        let solvedCells = InitialCell + results
        var unsolvedCells = [UnsolvedCell]();
        
        for row in 0..<Solver.Size {
            for col in 0..<Solver.Size {
                if solvedCells.filter({cell in cell.row == row && cell.col == col}).first == nil
                {
                    let unused = unusedValues(currentCell: Cell(row: row, col: col), solvedCells: solvedCells)
                    unsolvedCells.append(UnsolvedCell(row: row, col: col, unused: unused))
                }
            }
        }
        
        if unsolvedCells.count == 0 {
            return Result(solved: true, array: answerArray(results: solvedCells))
        }
        else {
            if unsolvedCells.map({cell in cell.unused.count > 0}).reduce(true, {(b1, b2) in b1 && b2 }) {
                let head: UnsolvedCell = unsolvedCells.reduce(unsolvedCells.first!, {(b1, b2) in b1.unused.count < b2.unused.count ? b1 : b2})
                
                let answers = head.unused.map({val in solve(results: results + [SolvedCell(row: head.row, col: head.col, blk: Solver.SubBlockMask[head.row][head.col], val: val)])})
                    .filter({result in result.solved})
                
                if answers.count == 1 {
                    return answers.first!
                }
            }
        }
        
        return Result(solved: false)
    }
}
