//
//  ProfileTableViewCell.swift
//  Cool Chat
//
//  Created by Jansen Ducusin on 3/15/21.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    var viewModel: ProfileViewModel? {
        didSet { configure() }
    }
    
    // MARK: - Properties
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setDimensions(height: 28, width: 28)
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var iconView: UIView = {
        let view = UIView()
        view.addSubview(self.iconImage)
        self.iconImage.centerX(inView: view)
        self.iconImage.centerY(inView: view)
        view.backgroundColor = .themeLightBlack
        view.setDimensions(height: 40, width: 40)
        view.layer.cornerRadius = 40 / 2
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [self.iconView, self.titleLabel])
        stack.spacing = 8
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: self.leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    private func configure(){
        guard let viewModel = viewModel else {return}
        self.iconImage.image = UIImage(systemName:  viewModel.iconImageName)
        titleLabel.text = viewModel.description
    }
}
