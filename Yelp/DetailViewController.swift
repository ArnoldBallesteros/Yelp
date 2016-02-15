//
//  DetailViewController.swift
//  Yelp
//
//  Created by Arnold Ballesteros on 2/14/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //PosterView is low res,
    //thought it would be of higher res to enlarge on detail
    //view controller
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var ratingsView: UIImageView!
    @IBOutlet weak var addressView: UILabel!
    @IBOutlet weak var ratingsCountLabel: UILabel!
    @IBOutlet weak var distanceView: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    //Snippet is just a preview of the reviews
    //Wasn't able to access review api
    //without requesting access to business API
    @IBOutlet weak var snippetLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    var business = Business!()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = business.name
        posterView.setImageWithURL(business.imageURL!)
        categoriesLabel.text = business.categories
        ratingsView.setImageWithURL(business.ratingImageURL!)
        addressView.text = business.address
        ratingsCountLabel.text = "\(business.reviewCount!) Reviews"
        distanceView.text = business.distance
        phoneLabel.text = business.phone
        snippetLabel.text = business.snippet
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
