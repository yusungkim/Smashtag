//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by KimYusung on 9/10/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    @IBOutlet weak var tweetUserLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // set text & userID
        tweetTextLabel.text = tweet?.text
        tweetUserLabel.text = tweet?.user.name
        
        // set created date
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel.text = nil
        }
        
        // set user profile image
        if let url = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView.image = UIImage(data: imageData)
                    }
                } else {
                    self?.tweetProfileImageView?.image = nil
                }
            }
        } else {
            tweetProfileImageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
