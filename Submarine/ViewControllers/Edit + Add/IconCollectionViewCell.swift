//
//  IconCollectionViewCell.swift
//  Submarine
//
//  Created by Nick Exon on 8/5/2022.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = self.contentView.frame.height / 10
        // Initialization code
    }
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                UIView.animate(withDuration: 0.2){
                    self.transform = CGAffineTransform(scaleX: 1.05, y:1.05)
                }
                self.contentView.backgroundColor = UIColor.lightGray
            }
            else{
                UIView.animate(withDuration: 0.2){
                    self.transform = CGAffineTransform.identity
                }
                
                self.contentView.backgroundColor = UIColor.clear
                
            }
        }
    }
}
