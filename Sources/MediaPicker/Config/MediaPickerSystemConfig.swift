//
//  MediaPickerSystemConfig.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 18/09/24.
//

import Foundation
import Photos


// System config takes care of the CPU consumption oriented fields
open class MediaPickerSystemConfig {
    
    /// Delivery quality to be required while caching and requesting image from OS
    /// By default `AUTO` is set
    let assetDeliveryQuality: MPAssetDeliveryQuality
    
    /// Asset version to be delivered while caching and requesting image
    /// By default `Current` is set
    let assetDeliveryVersion: MPAssetDeliveryVersion
    
    /// A Boolean value that specifies whether Photos can download the requested image from iCloud
    /// By default `True` is set
    let isNetworkAccessEnabled: Bool
    
    
    public init(assetDeliveryQuality: MPAssetDeliveryQuality = .Auto, assetDeliveryVersion: MPAssetDeliveryVersion = .Current, isNetworkAccessEnabled: Bool = true) {
        self.assetDeliveryQuality = assetDeliveryQuality
        self.assetDeliveryVersion = assetDeliveryVersion
        self.isNetworkAccessEnabled = isNetworkAccessEnabled
    }
}




