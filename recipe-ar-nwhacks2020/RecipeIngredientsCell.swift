//
//  RecipeIngredientsCell.swift
//  recipe-ar-nwhacks2020
//
//  Created by Winson Wong on 2020-01-12.
//  Copyright © 2020 Winson Wong. All rights reserved.
//

import UIKit

class RecipeIngredientsCell: UITableViewCell {

    @IBOutlet weak var ingredientsTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
