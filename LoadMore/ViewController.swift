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
    var sort = "id"
    var order = "asc"
    var previousIndex = -150
    var nextIndex = 0
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var orderSegmentControl: UISegmentedControl!
    var isNextCalled = true
    
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
        let parameters = [
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
                        
                        // store new users data in temporary array
                        var userTempArray:[User] = []
                        for result in results{
                            let user = User(dictionary: result)
                            userTempArray.append(user!)
                        }
                        
                        // append the new data at the beginning or at the end
                        if self.isNextCalled{
                            self.userArray = self.userArray + userTempArray
                            if self.userArray.count > 100 {self.userArray.removeSubrange(0...49)}
                            self.nextIndex += 50
                            self.previousIndex += 50
                        }
                        else{
                            self.userArray = userTempArray + self.userArray
                            if self.userArray.count > 100 {self.userArray.removeSubrange(100...149)}
                            self.previousIndex -= 50
                            self.nextIndex -= 50
                        }
                        
                        //reload the tableview
                        self.userTableView.reloadData()
                    }
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
            if previousIndex > -1 && nextIndex <= 950{
                return userArray.count + 2
            }
            else{
                return userArray.count + 1
            }
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var useroffset = 0
        //setting offset
        if previousIndex > -1{
            useroffset = 1
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "previous", for: indexPath) as! LoadPreviousTableViewCell
                return cell
            }
        }
        if indexPath.row-useroffset < userArray.count{
            let user = userArray[indexPath.row - useroffset]
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
            return cell
        }
    }

    @IBAction func loadMoreButtonPressed(_ sender: UIButton) {
        loadUsers(sortBy: sort, orderBy: order, fromIndex: nextIndex)
        isNextCalled = true
    }
    
    @IBAction func loadPreviousButtonPressed(_ sender: UIButton) {
        loadUsers(sortBy: sort, orderBy: order, fromIndex: previousIndex)
        isNextCalled = false
    }
    
    @IBAction func sortKeyPressed(_ sender: UISegmentedControl) {
        sort = sortBy[sender.selectedSegmentIndex]
        order = orderBy[orderSegmentControl.selectedSegmentIndex]
        userArray.removeAll()
        nextIndex = 50
        previousIndex = 0
        isNextCalled = true
        loadUsers(sortBy: sort, orderBy: order, fromIndex: 0)
    }
    
    @IBAction func orderKeyPressed(_ sender: UISegmentedControl) {
        sort = sortBy[sortSegmentControl.selectedSegmentIndex]
        order = orderBy[sender.selectedSegmentIndex]
        userArray.removeAll()
        nextIndex = 50
        previousIndex = 0
        isNextCalled = true
        loadUsers(sortBy: sort, orderBy: order, fromIndex: 0)
    }
    
    
}

