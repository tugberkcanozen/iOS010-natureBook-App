//
//  ViewController.swift
//  Nature Book Swift
//
//  Created by Tuğberk Can Özen on 26.02.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var nameArray = [String]()
    var idArray = [UUID]()
    var sourceName = ""
    var sourceId: UUID?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
        
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
    
    @objc func getData() {
        self.nameArray.removeAll(keepingCapacity: true)
        self.idArray.removeAll(keepingCapacity: true)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Gallery")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                
                if let name = result.value(forKey: "name") as? String {
                    self.nameArray.append(name)
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                
                self.tableView.reloadData()
                
            }
        
        
        } catch {
            
        }
    }
    
    @objc func addItem() {
        sourceName = ""
        performSegue(withIdentifier: "toSecondVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSecondVC" {
            let destinationVC = segue.destination as! ViewController2
            destinationVC.targetName = sourceName
            destinationVC.targetId = sourceId
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sourceName = nameArray[indexPath.row]
        sourceId = idArray[indexPath.row]
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }

}

