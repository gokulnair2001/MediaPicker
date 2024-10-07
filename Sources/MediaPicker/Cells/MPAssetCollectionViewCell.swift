//
//  MPAssetCollectionViewCell.swift
//  Powerplay
//
//  Created by Gokul Nair(Work) on 11/09/24.
//

import UIKit


/// Media Picker asset cell
public class MPAssetCollectionViewCell: UICollectionViewCell {
    
    static let id = "MPAssetCollectionViewCell"
    
    /// Main asset thumbnail image
    private lazy var assetThumbnailView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        img.backgroundColor = MPConstants.Color.backgroundColor
        return img
    }()
    
    /// Video duration label
    private lazy var durationLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = MPConstants.Font.cellLabelFont
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = false
        lbl.layer.masksToBounds = false
        lbl.layer.cornerRadius = 8
        lbl.layer.shadowColor = UIColor.gray.cgColor
        lbl.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        lbl.layer.shadowOpacity = 0.7
        lbl.layer.shadowRadius = 2
        lbl.textAlignment = .right
        return lbl
    }()
    
    /// Asset selection shade view
    private lazy var selectionShadeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.3)
        view.isHidden = true
        return view
    }()
    
    /// Asset selection check mark base view
    private lazy var selectionMarkImageBaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    /// Asset selection check mark view
    private lazy var selectionMarkImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .center
        img.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            img.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            img.image = UIImage(named: "tick_mark_pdf")
        }
        return img
    }()
    
    /// Cell Index path
    var indexPath: Int = 0
    
    /// Cell delegate
    weak var delegate: MPAssetCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        layoutConstraints()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.contentView.addSubview(assetThumbnailView)
        self.assetThumbnailView.addSubview(durationLabel)
        self.assetThumbnailView.addSubview(selectionShadeView)
        self.assetThumbnailView.addSubview(selectionMarkImageBaseView)
        self.selectionMarkImageBaseView.addSubview(selectionMarkImage)
    }
    
    private func layoutConstraints() {
        
        NSLayoutConstraint.activate([
            assetThumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor),
            assetThumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            assetThumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            assetThumbnailView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            selectionShadeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionShadeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionShadeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionShadeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            durationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            durationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            durationLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        selectionMarkImageBaseView.layer.cornerRadius = 11
        NSLayoutConstraint.activate([
            selectionMarkImageBaseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            selectionMarkImageBaseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            selectionMarkImageBaseView.heightAnchor.constraint(equalToConstant: 22),
            selectionMarkImageBaseView.widthAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            selectionMarkImage.centerXAnchor.constraint(equalTo: selectionMarkImageBaseView.centerXAnchor),
            selectionMarkImage.centerYAnchor.constraint(equalTo: selectionMarkImageBaseView.centerYAnchor),
            selectionMarkImage.heightAnchor.constraint(equalToConstant: 18),
            selectionMarkImage.widthAnchor.constraint(equalToConstant: 18)
        ])
        
    }
    
    private func addTarget() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnImage))
        assetThumbnailView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapOnImage() {
        self.delegate?.didTapOnAsset(self.indexPath, isSelected: !isSelected)
    }
    
    ///
    func setAssetThumbnail(image: UIImage) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.assetThumbnailView.image = image
        }
        
    }
    
    /// Image asset cell builder
    func buildImageCell() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.durationLabel.text = ""
            self.durationLabel.isHidden = true
            
        }
        
    }
    
    /// Video asset cell builder
    func buildVideoCell(details: MPVideoAssetDetails) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let minutes = Int(details.duration ?? 0) / 60
            let remainingSeconds = Int(details.duration ?? 0) % 60
            self.durationLabel.text = String(format: "%d:%02d", minutes, remainingSeconds)
            self.durationLabel.isHidden = false
            
        }
        
    }
    
    func isSelected(state: Bool) {
        self.isSelected = state
        self.selectionShadeView.isHidden = !state
        self.selectionMarkImageBaseView.isHidden = !state
        self.durationLabel.isHidden = state
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.assetThumbnailView.image = nil
        self.isSelected(state: false)
    }
}
