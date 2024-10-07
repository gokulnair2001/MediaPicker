//
//  MPThumbnailGenerator.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 26/09/24.
//

import UIKit
import Photos


/// A generator class which requests for asset thumbnail
public class MPThumbnailGenerator {
    
    /// Image manager instance
    private let imageManager: PHCachingImageManager
    
    /// Generation request options
    private let options: PHImageRequestOptions
    
    
    init(imageManager: PHCachingImageManager, options: PHImageRequestOptions) {
        self.imageManager = imageManager
        self.options = options
    }
    
    /// Asset thumbnail generator
    func getAssetThumbnail(asset: PHAsset, targetSize: CGSize, completion: @escaping (_ image: UIImage?) -> Void) -> MPImageRequestID {
        
        /// Requests for asset image from cache manager
        let imageRequestId = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            
            completion(image)
            
        }
        
        /// Returns the photo request id
        return imageRequestId
    }
}
