//
//  MPViewController+Extension.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 18/09/24.
//

import UIKit
import Photos


public extension UIViewController {
    
    func presentMediaPicker(_ mediaPicker: MediaPicker, animated: Bool = true, select: ((_ asset: PHAsset) -> Void)? = nil, deselect: ((_ asset: PHAsset) -> Void)? = nil, cancel: (([PHAsset]) -> Void)? = nil, finish: (([PHAsset]) -> Void)? = nil, error: ((PHAuthorizationStatus) -> Void)? = nil, completion: (() -> Void)? = nil, fetchCompletion: ((_ assetCount: Int, _ status: PHAuthorizationStatus) -> Void)? = nil) {
        
        // Set closures
        mediaPicker.onSelection = select
        mediaPicker.onDeselection = deselect
        mediaPicker.onCancel = cancel
        mediaPicker.onFinish = finish
        mediaPicker.onError = error
        mediaPicker.onFetchCompletion = fetchCompletion
        
        // Present
        self.present(UINavigationController(rootViewController: mediaPicker), animated: animated, completion: completion)
    }
    
}
