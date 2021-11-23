//
//  Favourites+Extension.swift
//  FlickerAPITask
//
//  Created by Takasur Azeem on 23/11/2021.
//

import CoreData

extension Favourites {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
