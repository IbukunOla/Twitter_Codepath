//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Ibukun on 4/28/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate {
    func did(post: Tweet)
}

class ComposeViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextView!
    
    weak var delegate: ComposeViewControllerDelegate?
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.af_setImage(withURL: URL(string: user.imageURL)!)
        nameLabel.text = user.name
        tagLabel.text = user.screenName

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapTweet(_ sender: Any) {
        APIManager.shared.composeTweet(with: tweetTextField.text) { (tweet, err) in
            if let err = err {
                print(err.localizedDescription)
            } else {
                self.delegate?.did(post: tweet!)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
