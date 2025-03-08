//
//  ReviewCell.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//

import UIKit
import SnapKit

class ReviewCell: UITableViewCell {
    
    private let reviewerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let reviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(reviewerImageView)
        contentView.addSubview(reviewTextLabel)
        
        reviewerImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        reviewTextLabel.snp.makeConstraints { make in
            make.left.equalTo(reviewerImageView.snp.right).offset(15)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    
    }
    
    func configure(with review: Review) {
        reviewerImageView.image = UIImage(named: review.imageName)
        reviewTextLabel.text = review.text
    }
    
}
