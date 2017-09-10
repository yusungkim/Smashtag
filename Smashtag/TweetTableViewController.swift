//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by KimYusung on 9/10/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController {

    // MARK: Model
    private var tweets = [Array<Twitter.Tweet>]() // array of array of Tweet
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
            print(tweets) // for testing
        }
    }
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty { // searchText is neither nil nor empty
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    private var currentRequest: Twitter.Request?
    private func searchForTweets() {
        if let request = twitterRequest() {
            currentRequest = request
            
            // request.fetchTweets( ([Tweet]) -> void )
            // takes closure, a function, which is excuted when the fetch job is done.
            // because, the fetch is worked on a different queue.
            request.fetchTweets { [weak self] newTweets in
                
                if request == self?.currentRequest { // check the request is still the same, even after the fetching.
                    self?.tweets.insert(newTweets, at: 0)
                } else {
                    // ignore, because the request has been changed.
                    // currentRequest is changed to more recent request on the main queue.
                    // request in this queue is no more relevent.
                }
            }
        }
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
