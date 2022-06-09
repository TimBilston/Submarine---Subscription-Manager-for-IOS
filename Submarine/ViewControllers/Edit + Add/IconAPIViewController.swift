//
//  IconAPIViewController.swift
//  Submarine
//
//  Created by Nick Exon on 6/5/2022.
//

import UIKit
import Foundation

protocol sendIconProtocol {
    func sendIconBack(icon: UIImage)
}

class IconAPIViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var delegate: sendIconProtocol? = nil

    @IBOutlet weak var searchBar: UISearchBar!
    
    var iconIds : [Int]?
    var indicator = UIActivityIndicatorView()
    
    var currentRequestIndex: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        iconIds = [Int]()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        NSLayoutConstraint.activate([ indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor), indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
        guard let searchText = searchBar.text else{
            print("no text in search bar")
            return
        }
        iconIds = [Int]()
        
        collectionView.reloadData()
        indicator.startAnimating()
        
        getIcon(searchTerm: searchText)
    }
    func getIcon(searchTerm: String) {
        
        let headers = [
            "Accept": "application/json",
            "Authorization": "Bearer X0vjEUN6KRlxbp2DoUkyHeM0VOmxY91rA6BbU5j3Xu6wDodwS0McmilLPBWDUcJ1"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.iconfinder.com/v4/icons/search?query=" + searchTerm + "&count=30")! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            if (error != nil) {
                print(error as Any)
            } else {
                if let httpResponse = response as? HTTPURLResponse, let data = data{
                    print(httpResponse)
                    self.processResults(data: data)
                }
            }
        })
        dataTask.resume()
    }
    
    func processResults(data : Data){
        do{
            let decoder = JSONDecoder()
            let icons = try decoder.decode(name.self, from: data)
            print(icons)
            for icon in icons.icons {
                print (icon.icon_id)
                self.iconIds!.append(icon.icon_id)
            }
            DispatchQueue.main.async {
                if(!self.iconIds!.isEmpty){
                    self.collectionView.reloadData()
                }
            }
        }
        catch let error {
            print(error)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collectionView.allowsSelection = true
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconIds?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "logoViewCell", for: indexPath) as! IconCollectionViewCell
        //cell.backgroundColor = .black
        if iconIds?[indexPath.row] != nil{
            let headers = [
                "Accept": "application/json",
                "Authorization": "Bearer X0vjEUN6KRlxbp2DoUkyHeM0VOmxY91rA6BbU5j3Xu6wDodwS0McmilLPBWDUcJ1"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://api.iconfinder.com/v4/icons/" + String(iconIds![indexPath.row]) + "/formats/png/64/download")! as URL,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error as Any)
                } else {
                    if let httpResponse = response as? HTTPURLResponse, let data = data{
                        guard let dataValue = data as? Data else {return}
                        let img = UIImage(data: dataValue)
                        DispatchQueue.main.async {
                            cell.cellImageView.image = img
                        }
                    }
                }
            })
            dataTask.resume()
        }
        return cell
    }
    
    @IBAction func saveImageClicked(_ sender: Any) {
        
        //performSegue(withIdentifier: "inverseIconSegue", sender: self)
        if delegate != nil{
            guard let index = collectionView.indexPathsForSelectedItems?.last else{
                return
            }
            guard let cell = collectionView.cellForItem(at: index) as? IconCollectionViewCell else{
                return
            }
            guard let image = cell.cellImageView else { return }
            guard let imageFile = image.image else {return}
            self.delegate?.sendIconBack(icon: imageFile)
            
            dismiss(animated: true, completion: nil)

        }
        return
    }
     
    struct name : Codable{
        let icons: [Icon]
    }
    struct Icon : Codable{
        let icon_id: Int
    }
}
