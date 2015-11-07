//
//  ViewController.swift
//  Swift-JSON-API
//
//  Created by Domenico Vacchiano on 07/11/15.
//  Copyright © 2015 DomenicoVacchiano. All rights reserved.
//

import UIKit

class ViewController: UIViewController,L3SDKJWARequestDelegate, UITableViewDataSource {
   
    let kTagLabelName = 1
    let kTagLabelUrl = 2
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var ds:NSArray = []
    //MARK View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource=self
        activityIndicator.hidden=true;
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK IBAction(s)
    @IBAction func sendWebRequest(sender:AnyObject){
        //send a request
        L3SDKJWARequest.sendTo(
            url: "https://api.github.com/users/alchimya/repos",
            withMethod: L3SDKJWARequest.HTTPRequestMethod.GET,
            andParams: nil,
            andDelegate: self)

        
        dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.hidden=false
                [self.activityIndicator .startAnimating()]
            })
    }

    //MARK JWA callbacks
    func L3SDKJWARequestDelegate_Response (response:AnyObject?){
       
        //web data response presentation
        if let _ = response as? NSDictionary {
            //do something with your json dictionary
            print("jsons response has a dictionary format")
        }
        else if let jsonArray = response as? NSArray {
            //do something with your json array
            
            dispatch_async(dispatch_get_main_queue(),{
                self.ds=jsonArray
                [self.tableView .reloadData()]
                self.activityIndicator.hidden=true
                [self.activityIndicator .stopAnimating()]
            })
            /*
            for item in jsonArray {
                let repo = item as! NSDictionary
                print(repo.objectForKey("name"))
                print(repo.objectForKey("url"))
            }
            */
            
        }
       // print(response)
        

        
    }

    func L3SDKJWARequestDelegate_Error(error:NSError){
        print(error)
        self.activityIndicator.hidden=true
        [self.activityIndicator .stopAnimating()]
    }
    
    //MAKR tableview datasource

    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.ds.count;
    }

    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        let lName = cell?.viewWithTag(kTagLabelName) as! UILabel
        let lUrl = cell?.viewWithTag(kTagLabelUrl)as! UILabel
        
        let repo=self.ds[indexPath.row]
    
        lName.text=repo.objectForKey("name") as? String
        lUrl.text=repo.objectForKey("url") as? String
        
        return cell!
    }
    
    
}

