//
//  File.swift
//  HajjDoctorIos
//
//  Created by Hosam Elsafty on 8/2/18.
//  Copyright © 2018 Hosam Elsafty. All rights reserved.
//

import Foundation

class Medicine {
    let title : String
    let description : String
    var isSelected : Bool
    
    init(name : String, decribe : String, selected: Bool) {
        self.title = name
        self.description = decribe
        self.isSelected = selected
    }
}
