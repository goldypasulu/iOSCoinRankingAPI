//
//  CustomTableViewCell1.swift
//  cobaTableView
//
//  Created by Goldy Pasulu on 19/10/22.
//

import UIKit

class CustomTableViewCell1: UITableViewCell {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelSymbol: UILabel!
    @IBOutlet weak var imageViewChange: UIImageView!
    @IBOutlet weak var labelChange: UILabel!
    var favoriteFunc:(() -> ())?
    @IBOutlet weak var outletFavorite: UIButton!
    @IBAction func buttonFavorite(_ sender: UIButton) {
        favoriteFunc?()
    }
}
