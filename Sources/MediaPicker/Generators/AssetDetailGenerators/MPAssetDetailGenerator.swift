//
//  MPAssetDetailGenerator.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 26/09/24.
//

import Foundation
import Photos

/// MPAssetDetailGenerator is a generic protocol applied on every Asset generator.
public protocol MPAssetDetailGenerator {
    
    /**
     Asset property extractor
     
     - Parameter assets: Selected assets
     - Parameter completion: Delivers asset details
     
     */
    func getAssetProperties<T: MPAssetDetails>(asset: PHAsset, completion: @escaping ((T) -> Void))
    
}
