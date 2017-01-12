//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mauricio G. Coello on 8/7/16.
//  Copyright © 2016 Mauricio G. Coello. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    private var operations: Dictionary <String, Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E), //M_E
        "√" : Operation.UnaryOperation(sqrt), //sqrt,
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1}),
        "÷" : Operation.BinaryOperation({ $0 / $1}),
        "+" : Operation.BinaryOperation({ $0 + $1}),
        "-" : Operation.BinaryOperation({ $0 - $1}),
        "+/-" : Operation.UnaryOperation({ -$0 }),
        "%" : Operation.BinaryOperation({ ($0 * $1)/10 }),
        "=" : Operation.Equals,
        "AC" : Operation.Clear
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double, Double)->Double)
        case Equals
        case Clear
    }
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator=value
            case .UnaryOperation(let function):
                accumulator=function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingbinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                accumulator=0
                pending?.firstOperand=0
            }
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingbinaryOperationInfo?
    
    private struct PendingbinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    var result: Double{
        get{
            return accumulator
        }
    }
}