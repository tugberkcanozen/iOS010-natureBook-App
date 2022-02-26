//
//  ViewController2.swift
//  Nature Book Swift
//
//  Created by Tuğberk Can Özen on 26.02.2022.
//

import UIKit
import CoreData

class ViewController2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func imageTap() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveClickedButton(_ sender: Any) {
        // Veri Kaydetme İşlemi
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: "Gallery", into: context)
        
        saveData.setValue(nameTextField.text!, forKey: "name")
        saveData.setValue(placeTextField.text!, forKey: "place")
        
        if let year = Int(yearTextField.text!) {
            saveData.setValue(year, forKey: "year")
        }
        
        let imagePress = imageView.image?.jpegData(compressionQuality: 0.5)
        saveData.setValue(imagePress, forKey: "image")
        saveData.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("Succes")
        } catch {
            print("Error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "newData"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
 
}
