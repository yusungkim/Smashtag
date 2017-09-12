//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by KimYusung on 9/10/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Model
    private var tweets = [Array<Twitter.Tweet>]() {// array of array of Tweet
        didSet {
            //print(tweets) // for testing
            
            // it doesn't reloadData() here, because that work is heavy.
            // instead we are going to add (insert) the new tweets to the tableView only.
            // see, the searchForTweets() function.
        }
    }
    
    var searchText: String? {
        didSet {
            // update textTextField
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder() // let keyboard away from the screen.
            
            // clear prevoius data
            tweets.removeAll()
            tableView.reloadData()
            
            searchForTweets()
            title = searchText
        }
    }
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty { // searchText is neither nil nor empty
            return Twitter.Request(search: "\(query) -filter:safe -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = lastTwitterRequest?.newer ?? twitterRequest() {
            lastTwitterRequest = request
            
            // request.fetchTweets( ([Tweet]) -> void )
            // takes closure, a function, which is excuted when the fetch job is done.
            // because, the fetch is worked on a different queue.
            request.fetchTweets { [weak self] newTweets in // this is off the main queue
                
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest { // check the request is still the same, even after the fetching.
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade) // instead of reloadData(), only insert new data on the display.
                    } else {
                        // ignore, because the request has been changed.
                        // currentRequest is changed to more recent request on the main queue.
                        // request in this queue is no more relevent.
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        searchForTweets()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // automatic row-height set
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // for testing
        //searchText = "#stanford"
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true // nothing happens, just return in this case.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        
        // Configure the cell...
        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
}
