//
//  ViewController.swift
//  LoadMore
//
//  Created by Dhiraj Nayak on 11/30/17.
//  Copyright © 2017 group2. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
//    enum Sort:String {
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case gender = "gender"
//    }
    var sortBy = ["id","first_name","last_name","gender"]
    var orderBy = ["asc","desc"]
    
//    enum Order:String {
//        case ascending = "asc"
//        case descending = "desc"
//    }
    
    var userArray:[User] = []
    var sort = "default"
    var order = "asc"
    
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var orderSegmentControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers(sortBy: sort, orderBy: order, fromIndex: 0)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUsers(sortBy:String, orderBy:String, fromIndex:Int) {
        var parameters = [
            "sortByField" : sortBy,
            "sortByType" : orderBy,
            "index" : fromIndex
            ] as [String : Any]
        
        Alamofire.request("http://18.217.3.86:5000/getusers", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            //error checking
            if let json = response.result.value as? [String:Any]{
                print("JSON: \(json)") // serialized json response
                let code = json["code"] as? Int
                if code == 200{
                    if let results = json["result"] as? [NSDictionary]{
                        for result in results{
                            let user = User(dictionary: result)
                            self.userArray.append(user!)
                        }
                        self.userTableView.reloadData()
                    }
                    print("inside code 200")
                    //let messageResponses =  as! NSDictionary
//                    self.allMessages = MessageResponse(dictionary: messagesResponses as NSDictionary)
//                    self.messageTableView.reloadData()
                }
                else if code == 202{
                    //disable laod more button and show alert
                }
                else{
                    //show generic error
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // PRAGMA MARK:- Table view delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userArray.count != 0{
            return userArray.count + 1
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // check condition for last user
        // if not last user
        if indexPath.row < userArray.count{
            let user = userArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath) as! UserCustomTableViewCell
            cell.firstNameLabel.text = user.first_name
            cell.lastNameLabel.text = user.last_name
            cell.genderLabel.text = user.gender
            cell.emailLabel.text = user.email
            cell.ipaddressLabel.text = user.ip_address
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadmore", for: indexPath) as! LoadMoreCustomTableViewCell
            cell.loadmoreButton.tag = indexPath.row
            return cell
        }
    }

    @IBAction func loadMoreButtonPressed(_ sender: UIButton) {
        print("next id \(sender.tag)")
//        loadUsers(sortBy: String, orderBy: String, fromIndex: sender.tag)
        
    }
    
    @IBAction func sortKeyPressed(_ sender: UISegmentedControl) {
        sort = sortBy[sender.selectedSegmentIndex]
        order = orderBy[orderSegmentControl.selectedSegmentIndex]
        userArray.removeAll()
        loadUsers(sortBy: sort, orderBy: order, fromIndex: 0)
    }
    
    @IBAction func orderKeyPressed(_ sender: UISegmentedControl) {
        sort = sortBy[sortSegmentControl.selectedSegmentIndex]
        order = orderBy[sender.selectedSegmentIndex]
        userArray.removeAll()
        loadUsers(sortBy: sort, orderBy: order, fromIndex: 0)
    }
    
    
}

