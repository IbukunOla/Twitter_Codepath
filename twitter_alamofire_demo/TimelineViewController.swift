//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshController: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        getTweets()
        
        refreshController = UIRefreshControl();
        refreshController.addTarget(self, action: #selector(TimelineViewController.didRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshController, at: 0)
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    @objc func didRefresh(_ refreshController: UIRefreshControl) {
        getTweets()
        self.refreshController.endRefreshing()
    }
    
    func getTweets() {
        APIManager.shared.getHomeTimeLine { (tweets, err) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let err = err {
                print(err.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTweetDetail" {
            let tweetCell = sender as! TweetCell
            let tweetInfo = tweetCell.tweet
            let tweetDetailVC = segue.destination as! TweetDetailViewController
            tweetDetailVC
        }
    }
    
}
