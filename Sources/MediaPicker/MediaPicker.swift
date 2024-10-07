//
//  MediaPicker.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 11/09/24.
//

import UIKit
import PhotosUI
import MobileCoreServices


/// Media picker is multiple asset picker
open class MediaPicker: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(MPAssetCollectionViewCell.self, forCellWithReuseIdentifier: MPAssetCollectionViewCell.id)
        
        return collectionView
    }()
    
    /// Media picker configurations
    private var config: MediaPickerConfig
    
    /// Flag Variable to store rendered cell size (Used to cache and request thumbnail for an asset)
    private var cellSize: CGSize = .zero
    
    /// Locally maintaining selected assets
    private var selectedAssets: [PHAsset] = []
    
    /// On Fetch completion block
    var onFetchCompletion: ((_ assetCount: Int, _ status: PHAuthorizationStatus) -> Void)?
    
    /// On Selection completion block
    var onSelection: ((_ asset: PHAsset) -> Void)?
    
    /// On Deselection completion block
    var onDeselection: ((_ asset: PHAsset) -> Void)?
    
    /// On Cancel completion block
    var onCancel: ((_ assets: [PHAsset]) -> Void)?
    
    /// On Finish completion block
    var onFinish: ((_ assets: [PHAsset]) -> Void)?

    /// On Error completion block
    var onError: ((_ authorisationStatus: PHAuthorizationStatus) -> Void)?
    
    /// Media Picker store manager instance
    private lazy var storeManager: MPStoreManager = {
        let sm = MPStoreManager(pickerConfig: config)
        return sm
    }()
    
    /// MP Delegate
    weak var delegate: MediaPickerDelegate?
    
    init(config: MediaPickerConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        layoutConstraints()
        addTarget()
        setupNavigationBar()
        
        checkAuthorisationStatusAndFetchAssets(authorisationStatus: MediaPicker.currentAuthorization)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.storeManager.stopCaching()
    }
    
    private func addViews() {
        self.view.backgroundColor = MPConstants.Color.backgroundColor
        self.view.addSubview(collectionView)
    }
    
    private func layoutConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func addTarget() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        
        
        navigationItem.title = "\(selectedAssets.count) Items Selected"
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancelButton))
        cancelButton.tintColor = MPConstants.Color.pickerTint
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapDoneButton))
        cancelButton.tintColor = MPConstants.Color.pickerTint
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    /// Checks for Gallery authorisation status and takes actions as per the status
    /// - Parameter authorisationStatus: Current authorisation status
    private func checkAuthorisationStatusAndFetchAssets(authorisationStatus: PHAuthorizationStatus) {
        
        switch authorisationStatus {
            
        case .notDetermined:
            requestPhotoLibraryAccess()
            break
            
        case .restricted, .denied:
            onError?(authorisationStatus)
            self.delegate?.mediaPicker(self, didFailWithAuthorizationError: authorisationStatus)
            break
            
        case .authorized, .limited:
            
            self.storeManager.fetchAssets { [weak self] fetchCompleted in
                guard let self else { return }
                self.reloadCollectionView()
            }
            
            onFetchCompletion?(storeManager.assets?.count ?? 0, authorisationStatus)
            self.delegate?.mediaPicker(self, assetCount: self.storeManager.assets?.count ?? 0, didFinishFetchingAssetsWithAuthorization: authorisationStatus)
            break
            
        @unknown default:
            onError?(authorisationStatus)
            self.delegate?.mediaPicker(self, didFailWithAuthorizationError: authorisationStatus)
            break
            
        }
        
    }
    
    @objc private func didTapCancelButton() {
        onCancel?(selectedAssets)
        self.delegate?.mediaPicker(self, didCancelWithAssets: selectedAssets)
        self.dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton() {
        onFinish?(selectedAssets)
        self.delegate?.mediaPicker(self, didFinishWithAssets: selectedAssets)
        self.dismiss(animated: true)
    }
    
    /// Requests for PhotoLibrary access
    private func requestPhotoLibraryAccess() {
        
        if #available(iOS 14, *) {
            
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                
                guard let self else { return }
                
                self.checkAuthorisationStatusAndFetchAssets(authorisationStatus: status)
            }
            
        } else {
            
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                
                guard let self else { return }
                
                self.checkAuthorisationStatusAndFetchAssets(authorisationStatus: status)
            }
            
        }
    }
    
    /// Reloads the picker
    private func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Collection View Delegates
extension MediaPicker: UICollectionViewDelegate {
    
    /// Data source count to compute cells to be genrated
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeManager.assets?.count ?? 0
    }
    
}

// MARK: - UICollectionViewDataSource
extension MediaPicker: UICollectionViewDataSource {
    
    /// Cell rendering logic
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MPAssetCollectionViewCell.id, for: indexPath) as? MPAssetCollectionViewCell,
              let asset = storeManager.assets?.object(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        /// Check if the following asset is pre-selected
        cell.isSelected(state: selectedAssets.contains(asset))
        cell.indexPath = indexPath.row
        
        /// Stores the photo request id and notifies store manager to generate thumbnail
        let photoRequestId = storeManager.getAssetThumbnail(asset: asset, targetSize: cellSize) { (image) in
            
            guard let image else { return }
            
            cell.setAssetThumbnail(image: image)
            
        }
        
        /// Asset specific rendering
        if asset.mediaType == .video {
            
            storeManager.getVideoProperties(asset: asset) { details in
                
                cell.buildVideoCell(details: details)
            }
            
        } else {
            
            cell.buildImageCell()
            
        }
        
        /// For any new cell, stop the current image request which is in queue. This will help to avoid false thumbnail generation
        if cell.tag != 0 {
            storeManager.cancelImageRequest(id: cell.tag)
        }
        
        /// Assigns the new photo request id to cell tag
        cell.tag = Int(photoRequestId)
        
        return cell
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MediaPicker: UICollectionViewDelegateFlowLayout {
    
    /// Cell size layout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 1
        let totalSpacing = (numberOfCellsPerRow - 1) * spacingBetweenCells
        let width = (collectionView.bounds.width - totalSpacing) / numberOfCellsPerRow
        
        /// Globally storing cell size
        self.cellSize = CGSize(width: width, height: width)
        
        return cellSize
    }
    
    // Set minimum spacing between cells
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        /// Space between cells
        return 1
    }
    
    // Set minimum line spacing between rows
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        /// Space between rows
        return 1
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension MediaPicker: UICollectionViewDataSourcePrefetching {
    
    /// Prefetch items helps media picker to preload the thumbnails which will be rendered next
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        /// Gets assets to be cached
        let assets = indexPaths.compactMap({ storeManager.assets?[$0.row] })
        /// caches the filtered assets
        storeManager.cacheImage(assets: assets, targetSize: cellSize)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        /// Not required currently
    }
}

// MARK: - UIContextMenuConfiguration
@available(iOS 13.0, *)
extension MediaPicker {
    
    /// Media picker context menu setup
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let asset = storeManager.assets?.object(at: indexPath.item) else { return nil }
        let isSelected = selectedAssets.contains(asset)
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            let selectAction = UIAction(title: isSelected ? "UnSelect" : "Select", image: UIImage(systemName: isSelected ? "x.circle"  : "checkmark.circle")) { _ in
                self.didTapOnAsset(indexPath.row, isSelected: !isSelected)
            }
            
            return UIMenu(title: "", children: [selectAction])
        }

    }
    
}

// MARK: - MPAssetCollectionViewCellDelegate
extension MediaPicker: MPAssetCollectionViewCellDelegate {
    
    /// Delegates when any asset is selected/deselected
    /// - Parameters:
    ///   - index: Index of the respective asset
    ///   - isSelected: selection status
    public func didTapOnAsset(_ index: Int, isSelected: Bool) {
        
        guard let _asset = storeManager.assets?.object(at: index) else { return }
        
        /// Check for selection limit
        if isSelected && (selectedAssets.count == config.selectionLimit) {
            self.delegate?.mediaPicker(self, didReachSelectionLimit: config.selectionLimit)
            return
        }
        
        /// Adds/Removes assets
        self.selectedAssets.toggleElement(_asset)
        /// Reloads the cell
        self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        
        /// Updating Nav Title
        navigationItem.title = "\(selectedAssets.count) Items Selected"
        
        /// Trigger the necessary delegate for select & deselect
        if isSelected {
            onSelection?(_asset)
            self.delegate?.mediaPicker(self, didSelectAsset: _asset)
        } else {
            onDeselection?(_asset)
            self.delegate?.mediaPicker(self, didDeselectAsset: _asset)
        }
    }
}

// MARK: - Utility methods
extension MediaPicker {
    
    /// States the current authorisation status
    public static var currentAuthorization : PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
}
