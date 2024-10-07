//
//  MPVideoDetailsGenerator.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 26/09/24.
//

import UIKit
import Photos


/// Video details generator
public class MPVideoDetailsGenerator: MPAssetDetailGenerator {
    
    /// Image manager instance
    private let imageManager: PHCachingImageManager
    
    /// Generation request options
    private let options: PHVideoRequestOptions
    
    
    init(imageManager: PHCachingImageManager, options: PHVideoRequestOptions) {
        self.imageManager = imageManager
        self.options = options
    }
    
    /// Video asset extractor
    public func getAssetProperties<T: MPAssetDetails>(asset: PHAsset, completion: @escaping ((T) -> Void)) {
        
        var videoProperties: MPVideoAssetDetails = MPVideoAssetDetails()
        
        imageManager.requestPlayerItem(forVideo: asset, options: options) { playerItem, _ in
            
            if let duration = playerItem?.duration {
                let durationInSeconds = CMTimeGetSeconds(duration)
                videoProperties.duration = durationInSeconds
            }
            
            if let properties = videoProperties as? T {
                completion(properties)
            } else {
                print("Error: Could not cast MPVideoAssetDetails to the expected type \(T.self)")
            }
            
        }
        
    }
    
}
