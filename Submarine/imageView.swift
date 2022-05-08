//
//  imageView.swift
//  Submarine
//
//  Created by Nick Exon on 8/5/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path.first
    }
    
    func savePng(_ image: UIImage, id: String) {
        if let pngData = image.pngData(),
            let path = documentDirectoryPath()?.appendingPathComponent(id + ".png") {
            try? pngData.write(to: path)
        }
    }
    
    func saveJpg(_ image: UIImage, id: String) {
        if let jpgData = image.jpegData(compressionQuality: 0.5),
            let path = documentDirectoryPath()?.appendingPathComponent(id + ".jpg") {
            try? jpgData.write(to: path)
        }
    }
    
    func loadFile(fileName: String) -> UIImage?{
        let fileURL = (documentDirectoryPath()?.appendingPathComponent(fileName))!
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            
        }
        return nil
    }
}



