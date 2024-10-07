//
//  MPMediaType.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 11/09/24.
//

import Photos


/// All the media types which Media Picker supports
@frozen public enum MPMediaType {
    
    /// Photos and static images
    case Image
    
    /// Video files
    case Video
    
    /// PHAssetMediaType mapper
    var getPHAssetMediaType: PHAssetMediaType {
        switch self {
        case .Image:
            return .image
        case .Video:
            return .video
        }
    }
}
