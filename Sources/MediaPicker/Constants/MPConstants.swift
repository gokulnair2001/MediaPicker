//
//  MPConstants.swift
//  MediaPicker
//
//  Created by Gokul Nair(Work) on 07/10/24.
//

import UIKit


public struct MPConstants {
    
    public struct Color {
        /// Picker Tint Color
        nonisolated(unsafe) public static var pickerTint: UIColor = .white
        nonisolated(unsafe) public static var backgroundColor: UIColor = .white
    }

    public struct Font {
        nonisolated(unsafe) public static var cellLabelFont: UIFont? = UIFont(name: "Avenir", size: 14)
    }
}
