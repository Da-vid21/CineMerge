//
//  FolderCell.swift
//  CineMerge
//
//  Created by Dawit Tekeste on 4/17/24.
//

import UIKit

class FolderCell: UITableViewCell {

    @IBOutlet weak var folderTitle: UILabel!
    @IBOutlet weak var folderImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }

}
