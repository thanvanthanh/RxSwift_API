//
//  ABCTableViewCell.swift
//  LearnRxSwift
//
//  Created by Thân Văn Thanh on 05/07/2021.
//

import UIKit

class ABCTableViewCell: UITableViewCell {

    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoLBL: UILabel!
    @IBOutlet weak var idLBL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
