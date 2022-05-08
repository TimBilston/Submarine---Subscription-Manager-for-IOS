//
//  IconData.swift
//  Submarine
//
//  Created by Nick Exon on 6/5/2022.
//

import UIKit

class IconData: NSObject, Decodable {
    var imageURL : String?
    var icon_id : Int?
    
    private enum RootKeys: String, CodingKey {
        case raster_sizes
    }
    
    private enum ImageKeys: String, CodingKey{
        case formats
    }
    
    private enum Image: String, CodingKey {
        case download_url
    }
    
    required init(from decoder : Decoder) throws {
    
    }
}
