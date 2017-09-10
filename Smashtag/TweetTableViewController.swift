//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by KimYusung on 9/10/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {

    // MARK: Model
    private var tweets = [Array<Tweet>]() // array of array of Tweet
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }
    
    private func searchForTweets() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for testing
        searchText = "#stanford"
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
}
