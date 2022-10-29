//
//  ViewController.swift
//  Day50
//
//  Created by RqwerKnot on 19/10/2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var items = [Item]() {
        didSet {
            save()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openPicker))
        
        // load the array of items from disk:
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: "items") {
            if let savedItems = try? JSONDecoder().decode([Item].self, from: savedData) {
                items = savedItems
                tableView.reloadData()
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as? ThingCell else {
            fatalError("Could not dequeue cell: Item")
        }
        
        let item = items[indexPath.row]
        
        cell.label.text = item.caption
        
        let imageURL = getDocumentDirectory().appendingPathComponent(item.filename)
        cell.picture.image = UIImage(contentsOfFile: imageURL.path)
        cell.picture.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.picture.layer.borderWidth = 1
        cell.picture.layer.cornerRadius = 5
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedItem = items[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func openPicker() {
        let picker  = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) // dismiss ImagePicker
        
        if let image = info[.editedImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                let filename = UUID().uuidString
                let path = getDocumentDirectory().appendingPathComponent(filename)
                
                if (try? imageData.write(to: path)) != nil {
                    promptForCaption(for: filename)
                }
            }
        } 
    }
    
    func promptForCaption(for filename: String) {
        let ac = UIAlertController(title: "Name your item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let add = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            
            let newItem = Item(caption: name, filename: filename)
            
            self?.items.insert(newItem, at: 0)
            self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        
        ac.addAction(add)
        
        present(ac, animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
    
    func save() {
        // save to disk the array of items
        if let savedData = try? JSONEncoder().encode(self.items) {
            UserDefaults.standard.set(savedData, forKey: "items")
        } else {
            print("Couldn't encode to JSON data")
        }
    }
}

