//
//  Array+Extensions.swift
//  MediaPicker
//
//  Created by Gokul Nair(Work) on 07/10/24.
//

import Foundation


extension Array where Element: Equatable {
    
    public mutating func toggleElement(_ element: Element) {
        
        if let index = self.firstIndex(of: element) {
            self.remove(at: index)
        } else {
            self.append(element)
        }
    }
}

