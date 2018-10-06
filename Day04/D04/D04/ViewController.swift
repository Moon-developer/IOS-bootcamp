//
//  ViewController.swift
//  D04
//
//  Created by Marco on 2018/10/05.
//  Copyright © 2018 Marco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APITwitterDelegate  {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputText: UITextField!

    var to = ""
    var tweets : [Tweet] = []
    
    // append all gotten tweets here
    func Tweets(tweet: Tweet) {
        print("=============================================================")
        self.tweets.append(tweet)
        
    }
    
    // print out an alert message
    func TwitterError(error: NSError) {
        print(error)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! tweetTableViewCell
        //cell.death = Data.Names[indexPath.row]
        cell.appendLabel(details: self.tweets[indexPath.row])
        return cell
    }
    
    @IBAction func function(_ sender: Any) {
        let test = APIController(delegate: self, token: self.to)
        if (inputText.text != "") {
            test.requestTwitter(variable: inputText.text! )
            tableView.reloadData()
        } else {
            print("Empty field!")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connect()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connect()
    {
        let customerKey = "0q9lIPPpotMDDcBB2qDMVWgT4"
        let customerSecret = "VTbhUM9NOqLDN8U4evnDdXrE58JyFkcuNy4924aXqtqeX8sdT7"
        let bearer = ((customerKey + ":" + customerSecret).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        request.setValue("Basic \(bearer)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response as Any)
            if let err = error{
                print(err)
            }
            else if let d = data{
                do{
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                        if let temp = dic["access_token"] {
                            self.to = (temp as? String)!
                        }
                    }
                }
                catch(let err){
                    print("connect error")
                    print(err)
                }
            }
        }
        task.resume()
    }

}

