//
//  MPAssetDeliveryVersion.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 18/09/24.
//

import Photos


/// Delivery version defines the asset to be delivered must be of which version
@frozen public enum MPAssetDeliveryVersion {
    
    /// Request the most recent version of the image asset (the one that reflects all edits).
    case Current
    
    /// Request the original, highest-fidelity version of the image asset.
    case Original
    
    /// Request a version of the image asset without adjustments.
    case Unadjusted
    
    
    /// PHImageRequestOptionsVersion mapper (Used to define caching/request type)
    var phImageDeliveryVersion: PHImageRequestOptionsVersion {
        switch self {
        case .Current:
            return .current
        case .Original:
            return .original
        case .Unadjusted:
            return .unadjusted
        }
    }
    
    /// PHVideoRequestOptionsVersion mapper (Used to define caching/request type)
    var phVideoDeliveryVersion: PHVideoRequestOptionsVersion {
        switch self {
        case .Current:
            return .current
        case .Original, .Unadjusted:
            return .original
        }
    }
}
