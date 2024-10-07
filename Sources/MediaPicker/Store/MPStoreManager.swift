//
//  MPStoreManager.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 11/09/24.
//

import UIKit
import Photos

/// MPImageRequestID is the request id which OS provides when any request is made to generate image from an asset
typealias MPImageRequestID = Int32

/// Media Picker store manager is the factory which looks after asset fetch from OS and its caching. The store make sure images are fetched and cached properly
public final class MPStoreManager {
    
    /// Fetched Assets
    private(set) var assets: PHFetchResult<PHAsset>?
    
    /// Image cache manager
    private let imageManager = PHCachingImageManager()
    
    /// Media picker configurations
    private let pickerConfig: MediaPickerConfig
    
    
    init(pickerConfig: MediaPickerConfig) {
        self.pickerConfig = pickerConfig
    }
    
    
    /// Retrieves the assets of specified media types
    /// - Parameter completion: block which denotes when fetch is done
    func fetchAssets(completion: @escaping((Bool) -> Void)) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Two options exists Image or video, if count one then use the same else fetch everything from gallery
        if pickerConfig.mediaTypesToSelect.count == 1 {
            assets = PHAsset.fetchAssets(with: pickerConfig.mediaTypesToSelect.first!.getPHAssetMediaType, options: fetchOptions)
        } else {
            assets = PHAsset.fetchAssets(with: fetchOptions)
        }
        
        completion((assets?.count ?? 0) != 0)
    }
    
    /// Asset thumbnail generator
    /// - Parameters:
    ///   - asset: asset for which thumbnail needs to be calculated
    ///   - targetSize: image size to be returned
    ///   - completion: block which notifies when image and duration is computed
    /// - Returns: A numeric identifier for the request.
    func getAssetThumbnail(asset: PHAsset, targetSize: CGSize, completion: @escaping (_ image: UIImage?) -> Void) -> MPImageRequestID {
        /// Calls respective generator
        /// i.e. `MPThumbnailGenerator`
        let thumbnailGenerator = MPThumbnailGenerator(imageManager: imageManager, options: getImageRequestOptions())
        let imageRequestId = thumbnailGenerator.getAssetThumbnail(asset: asset, targetSize: targetSize, completion: completion)
        
        /// Returns the photo request id
        return imageRequestId
    }
    
    /// Video duration calculator
    /// - Parameters:
    ///   - asset: asset for which duration needs to be calculated
    ///   - completion: block which notifies when computation is done
    func getVideoProperties(asset: PHAsset, completion: @escaping ((MPVideoAssetDetails) -> Void)) {
        
        /// Calls respective generator
        /// i.e. `MPVideoDetailsGenerator`
        let videoPropertyGenerator = MPVideoDetailsGenerator(imageManager: imageManager, options: getVideoRequestOptions())
        videoPropertyGenerator.getAssetProperties(asset: asset, completion: completion)
       
    }
    
    /// Image caching mechanism
    /// - Parameters:
    ///   - assets: asset to be cached
    ///   - targetSize: size of image to be cached
    func cacheImage(assets: [PHAsset], targetSize: CGSize) {
        
        let options = getImageRequestOptions()
        
        self.imageManager.startCachingImages(for: assets, targetSize: targetSize, contentMode: .aspectFill, options: options)
    }
    
    /// Cancels the Image caching request
    /// - Parameter id: request id obtained while caching was initiated
    func cancelImageRequest(id: Int) {
        imageManager.cancelImageRequest(PHImageRequestID(id))
    }
    
    /// Stops all the caching process
    func stopCaching() {
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
}

private extension MPStoreManager {
    
    /// Image Request options
    func getImageRequestOptions() -> PHImageRequestOptions {
        
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.version = pickerConfig.systemConfig.assetDeliveryVersion.phImageDeliveryVersion
        options.deliveryMode = pickerConfig.systemConfig.assetDeliveryQuality.phImageDeliveryQuality
        options.isNetworkAccessAllowed = pickerConfig.systemConfig.isNetworkAccessEnabled
        
        return options
    }
    
    /// Video Request options
    func getVideoRequestOptions() -> PHVideoRequestOptions {
        
        let options = PHVideoRequestOptions()
        options.version = pickerConfig.systemConfig.assetDeliveryVersion.phVideoDeliveryVersion
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = pickerConfig.systemConfig.isNetworkAccessEnabled
        
        return options
    }
}
