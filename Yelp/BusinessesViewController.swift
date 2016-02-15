//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {

  //@IBOutlet weak var searchBar: UISearchBar! 
  //This is taken out because we are implementing the search Bar into the navigation bar.
  //We cannot place the UISearchBar into the NavBar so we have to do it programatically
   
    @IBOutlet weak var tableView : UITableView!
  
    //Create searchBar Variable
    
    //var searchBar : UISearchBar = UISearchBar()
    
    var businesses : [Business]!
    var filteredData : [Business]!

    var term = "place"
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    //Grab offset data from Yelp Client. Extracted info from offset parameter
    var offset : Int? = 20
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = businesses
        
        //Table View Setup
        tableView.delegate = self
        tableView.dataSource = self
        //Specify that the Table View needs to have a row height of auto layout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        //Used for scroll bar indicator to customize it's height, conforms to auto layout constraints
        tableView.estimatedRowHeight = 120
        
        //Changed Term "Thai" >> "Food"
        
        Business.searchWithTerm("\(term)", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
        //Search Bar Setup
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        //Set the searchBar onto the NavBar
        navigationItem.titleView = searchBar
        print("Reach Search")
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("Searching")
        filteredData = searchText.isEmpty ? businesses : businesses?.filter ({ (business : Business) -> Bool in
            //reference to business name from business.swift in Models folder
            return (business.name)!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        print("Reloading TableView")
        tableView.reloadData()
    }
    
    //Infinite Scrolling
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (!isMoreDataLoading) {
            //Calculate the positions of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            //When the user has scorlled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                //Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //Call function to load more results
                loadMoreData()
            }
        }
    }
    
    //load more data
    func loadMoreData() {
        //Don't have configure session,just call it from the Business View
        //Added parameters to the class function to include the offset within the tableView
        Business.searchWithTerm("\(term)", sort: .Distance, categories: [], deals: true, offset: self.offset, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if (businesses != []) {
                //This conditional states that if the businesses does not equal to the array,
                //correct it by appending the other businesses
                for business in businesses {
                    print("Appending")
                    self.businesses.append(business)
                }
                //Update Flag
                self.isMoreDataLoading = false
                //Stop Loading Indicator
                self.loadingMoreView!.stopAnimating()
                
                //Reload and extend the offset to introduce the new data
                self.filteredData = self.businesses
                self.tableView.reloadData()
                self.offset! += 10
            }
            self.isMoreDataLoading = false
        })
    }
    

    

    
    func tableView(tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
            if filteredData != nil {
                return filteredData!.count
            } else {
                return 0
            }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        //Let business = filteredData to reflect search results. 
        //If businesses was used, data will not be overwritten
        cell.business = filteredData[indexPath.row]
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let business = filteredData![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        
        detailViewController.business = business
        
        print("Prepare for segue called")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
