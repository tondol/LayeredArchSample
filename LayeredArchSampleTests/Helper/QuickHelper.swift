//
//  QuickHelper.swift
//  LayeredArchSampleTests
//
//  Created by Tomoyuki Hosaka on 2017/10/02.
//  Copyright © 2017年 Tomoyuki Hosaka. All rights reserved.
//

import Foundation
import Nimble
import Quick
import RxSwift
import RxTest

func ==<T: Equatable>(lhs: Event<T>?, rhs: Event<T>?) -> Bool {
    switch (lhs, rhs) {
    case (.some(.next(let value1)), .some(.next(let value2))):
        return value1 == value2
    case (.some(.completed), .some(.completed)):
        return true
    case (.some(.error(_)), .some(.error(_))):
        return true
    case (.none, .none):
        return true
    default:
        return false
    }
}
func equal<T: Equatable>(_ expectedValue: Event<T>?) -> NonNilMatcherFunc<Event<T>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(stringify(expectedValue))>"
        let actualValue = try actualExpression.evaluate()
        let matches = actualValue == expectedValue && expectedValue != nil
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil {
                failureMessage.postfixActual = " (use beNil() to match nils)"
            }
            return false
        }
        return matches
    }
}
func ==<T: Equatable>(lhs: Expectation<Event<T>>, rhs: Event<T>?) {
    lhs.to(equal(rhs))
}

func ==<T: Equatable>(lhs: Event<[T]>?, rhs: Event<[T]>?) -> Bool {
    switch (lhs, rhs) {
    case (.some(.next(let value1)), .some(.next(let value2))):
        return value1.elementsEqual(value2)
    case (.some(.completed), .some(.completed)):
        return true
    case (.some(.error(_)), .some(.error(_))):
        return true
    case (.none, .none):
        return true
    default:
        return false
    }
}
func equal<T: Equatable>(_ expectedValue: Event<[T]>?) -> NonNilMatcherFunc<Event<[T]>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(stringify(expectedValue))>"
        let actualValue = try actualExpression.evaluate()
        let matches = actualValue == expectedValue && expectedValue != nil
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil {
                failureMessage.postfixActual = " (use beNil() to match nils)"
            }
            return false
        }
        return matches
    }
}
func ==<T: Equatable>(lhs: Expectation<Event<[T]>>, rhs: Event<[T]>?) {
    lhs.to(equal(rhs))
}

func ==(lhs: Event<Void>?, rhs: Event<Void>?) -> Bool {
    switch (lhs, rhs) {
    case (.some(.next(_)), .some(.next(_))):
        return true
    case (.some(.completed), .some(.completed)):
        return true
    case (.some(.error(_)), .some(.error(_))):
        return true
    case (.none, .none):
        return true
    default:
        return false
    }
}
func equal(_ expectedValue: Event<Void>?) -> NonNilMatcherFunc<Event<Void>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(stringify(expectedValue))>"
        let actualValue = try actualExpression.evaluate()
        let matches = actualValue == expectedValue && expectedValue != nil
        if expectedValue == nil || actualValue == nil {
            if expectedValue == nil {
                failureMessage.postfixActual = " (use beNil() to match nils)"
            }
            return false
        }
        return matches
    }
}
func ==(lhs: Expectation<Event<Void>>, rhs: Event<Void>?) {
    lhs.to(equal(rhs))
}
