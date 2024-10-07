//
//  MediaPickerDelegate.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 11/09/24.
//

import PhotosUI


public protocol MediaPickerDelegate: AnyObject {
    
    /**
     Tells the delegate that the picker have selected an asset
     
     - Parameter assets: Selected assets
     
     */
    func mediaPicker(_ mediaPicker: MediaPicker, didSelectAsset asset: PHAsset)
    
    /**
     Tells the delegate that the picker have deselected an asset
     
     - Parameter assets: Selected assets
     
     */
    func mediaPicker(_ mediaPicker: MediaPicker, didDeselectAsset asset: PHAsset)
    
    /**
     Tells the delegate that the picker have finished selecting assets
     
     - Parameter assets: Selected assets
     
     */
    func mediaPicker(_ mediaPicker: MediaPicker, didFinishWithAssets assets: [PHAsset])
    
    /**
     Tells the delegate that the picker have cancelled selecting assets
     
     - Parameter assets: Assets selected when user canceled
     
     */
    func mediaPicker(_ mediaPicker: MediaPicker, didCancelWithAssets assets: [PHAsset])
    
    /**
     Tells the delegate that the picker have reached the selection limit
     
     - Parameter count: Number of selected assets
     
     */
    func mediaPicker(_ mediaPicker: MediaPicker, didReachSelectionLimit count: Int)
    
    /**
     Tells the delegate that the picker have failed to render due to authorisation error
     
     - Parameter status: photo access authorisation status
     
     */
    func mediaPicker(_ mediaPicker: MediaPicker, didFailWithAuthorizationError status: PHAuthorizationStatus)
    
    /**
     Tells the delegate that the picker have successfully fetched assets with authorisation status
     
     - Parameter assetCount: fetched asset count
     - Parameter status: photo access authorisation status
     
     */
    func mediaPicker(_ mediaPicker: MediaPicker, assetCount: Int, didFinishFetchingAssetsWithAuthorization status: PHAuthorizationStatus)
}


extension MediaPickerDelegate {
    
    func mediaPicker(_ mediaPicker: MediaPicker, didSelectAsset asset: PHAsset) { }
    
    func mediaPicker(_ mediaPicker: MediaPicker, didDeselectAsset asset: PHAsset) { }
    
    func mediaPicker(_ mediaPicker: MediaPicker, didFinishWithAssets assets: [PHAsset]) { }
    
    func mediaPicker(_ mediaPicker: MediaPicker, didCancelWithAssets assets: [PHAsset]) { }
    
    func mediaPicker(_ mediaPicker: MediaPicker, didReachSelectionLimit count: Int) { }
    
    func mediaPicker(_ mediaPicker: MediaPicker, didFailWithAuthorizationError status: PHAuthorizationStatus) { }
    
    func mediaPicker(_ mediaPicker: MediaPicker, assetCount: Int, didFinishFetchingAssetsWithAuthorization status: PHAuthorizationStatus) { }
    
}
