//
//  MediaPickerConfig.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 11/09/24.
//

import Foundation


/// Media picker configurations
open class MediaPickerConfig {
    
    /// selection limit restricts user from selecting assets more than the specified count
    let selectionLimit: Int
    
    /// Media picker will only fetch the media types specified here
    let mediaTypesToSelect: [MPMediaType]
    
    /// System config mainly takes care of the CPU consumption oriented fields
    let systemConfig: MediaPickerSystemConfig
    
    init(selectionLimit: Int, mediaTypesToSelect: [MPMediaType], systemConfig: MediaPickerSystemConfig = MediaPickerSystemConfig()) {
        self.selectionLimit = selectionLimit
        self.mediaTypesToSelect = mediaTypesToSelect
        self.systemConfig = systemConfig
    }
}
