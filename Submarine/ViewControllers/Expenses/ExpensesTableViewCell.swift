//
//  ExpensesTableViewCell.swift
//  Submarine
//
//  Created by Nick Exon on 14/5/2022.
//

import UIKit

class ExpensesTableViewCell: UITableViewCell {
    @IBOutlet weak var subLogo: UIImageView!
    @IBOutlet weak var subName: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var subPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
