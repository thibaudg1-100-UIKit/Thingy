//
//  ThingCell.swift
//  Day50
//
//  Created by RqwerKnot on 19/10/2022.
//

import UIKit

class ThingCell: UITableViewCell {
    @IBOutlet var picture: UIImageView!
    @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
