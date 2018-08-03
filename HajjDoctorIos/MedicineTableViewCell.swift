//
//  MedicineTableViewCell.swift
//  HajjDoctorIos
//
//  Created by Hosam Elsafty on 8/2/18.
//  Copyright © 2018 Hosam Elsafty. All rights reserved.
//

import UIKit

class MedicineTableViewCell: UITableViewCell {

    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var medicineDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var medicineSelected: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
