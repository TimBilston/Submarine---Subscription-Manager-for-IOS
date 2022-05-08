//
//  VolumeData.swift
//  Submarine
//
//  Created by Nick Exon on 6/5/2022.
//

import UIKit

class VolumeData: NSObject, Decodable {

    var icons: [IconData]?
    private enum CodingKeys: String, CodingKey {
        case icons = "icons"
    }
}
