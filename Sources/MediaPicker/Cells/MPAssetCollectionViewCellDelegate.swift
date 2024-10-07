//
//  MPAssetCollectionViewCellDelegate.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 19/09/24.
//

import Foundation

@MainActor
public protocol MPAssetCollectionViewCellDelegate: AnyObject {
    
    /**
     Tells the delegate that the user have selected/deselected an asset
     
     - Parameter index: Selected index
     - Parameter isSelected: Selection status
     
     */
    func didTapOnAsset(_ index: Int, isSelected: Bool)
}
