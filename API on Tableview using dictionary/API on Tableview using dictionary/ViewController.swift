//
//  ViewController.swift
//  API on Tableview using dictionary
//
//  Created by apple on 16/01/19.
//  Copyright © 2019 Seraphic. All rights reserved.
//

import UIKit

struct details: Decodable{
    var name : String
    var email : String
}


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var searchBar: UITableView!
    @IBOutlet weak var sortButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    @IBAction func sortButton(_ sender: Any) {
        
        if namesort{
            getData()
            UIView.animate(withDuration: 5) {
            self.sortButtonOutlet.title = "Sort by Name"
            }
            namesort = false
        }
        else
        {
            getData()
            UIView.animate(withDuration: 5) {
            self.sortButtonOutlet.title = "Sort by Email"
            }
            namesort = true
        }
        
    }
    
    var dataFilled : Bool = false
    var namesort : Bool = true
    var dictArray = [details]()
    var dict = [String : String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        if namesort {
            cell.label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 35.0)
        cell.label.text = dictArray[indexPath.row].name
        cell.email.text = dictArray[indexPath.row].email
        }
        else
        {
            cell.label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30.0)
            cell.label.text = dictArray[indexPath.row].email
            cell.email.text = dictArray[indexPath.row].name
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = self.view.tintColor
        cell.selectedBackgroundView = backgroundView
        return cell
        
    }
    
    
    func getData()  {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")
        URLSession.shared.dataTask(with: url!) { (data, _, _) in
            do{
            if data == nil
            {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "There was an error", message: "Internet not working", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default , handler: { (x) in
                        exit(0)
                    }))
                    self.present(alert, animated: true)
                }
                return
                }
                var datainJson = try JSONDecoder().decode([details].self, from: data!)
                
                if self.namesort{
                    datainJson.sort(by: { $0.name < $1.name })
                    self.dictArray.sort(by: { $0.name < $1.name } )
                } else {
                    datainJson.sort(by: { $0.email < $1.email })
                    self.dictArray.sort(by: { $0.email < $1.email } )
                }
                if self.dataFilled != true{
                for x in datainJson
                {
                    self.dictArray.append(details(name: x.name, email: x.email))
                    self.dict[x.name] = x.email
                }
                    self.dataFilled=true
                }
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
            catch let error{
                 DispatchQueue.main.async {
                let alert = UIAlertController(title: "There was an error", message: "\(error)", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default , handler: {(x) in
                        exit(0)
                }))
                self.present(alert, animated: true)
                }
            }
            
        }.resume()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print( dictArray[indexPath.row].email )
}

}

