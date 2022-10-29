//
//  DetailViewController.swift
//  Day50
//
//  Created by RqwerKnot on 19/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!    
    
    var selectedItem: Item?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = selectedItem {
            let path = getDocumentDirectory().appendingPathComponent(item.filename)
            imageView.image = UIImage(contentsOfFile: path.path)
            
            title = item.caption
        }
        
    }
    
    func getDocumentDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
