//
//  BoxedArray.swift
//  CareerUp
//
//  Created by Adam Emery on 10/20/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class BoxedArray<T> : NSObject {
    var array : Array<T>
    
    init(arrayIn:Array<T>) {
        array = arrayIn
    }
    subscript (index: Int) -> T {
        get { return array[index] }
        set(newValue) { array[index] = newValue }
    }
}
