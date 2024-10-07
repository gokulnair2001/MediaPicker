//
//  MPAssetDeliveryQuality.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 18/09/24.
//

import Photos


/// Delivery Quality defines at the quality at which thumbnails must be generated
@frozen public enum MPAssetDeliveryQuality {
    
    /// Photos provides only the highest-quality image available, regardless of how much time it takes to load.
    case High
    
    /// Photos provides only a fast-loading image, possibly sacrificing image quality.
    case Fast
    
    /// Photos automatically provides one or more results in order to balance image quality and responsiveness.
    case Auto
    
    var phImageDeliveryQuality: PHImageRequestOptionsDeliveryMode {
        switch self {
        case .High:
            return .highQualityFormat
        case .Fast:
            return .fastFormat
        case .Auto:
            return .opportunistic
        }
    }
}
