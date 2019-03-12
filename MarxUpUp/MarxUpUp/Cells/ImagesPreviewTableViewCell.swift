//
//  ImagesPreviewTableViewCell.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 12.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ImagesPreviewTableViewCell: UITableViewCell {
    @IBOutlet weak var URLImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        URLImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
