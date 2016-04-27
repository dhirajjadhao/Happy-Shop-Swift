//
//  HomeViewController.swift
//  Happy Shop
//
//  Created by Dhiraj Jadhao on 26/04/16.
//  Copyright © 2016 Dhiraj Jadhao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    
    @IBOutlet var cartButton: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    var categories:NSArray!
    
    
    
    
    
    
    
    // MARK: - View Delegate Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.updateCart()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        categories = ["Skincare", "Bath & Body", "Men", "Nails", "Tools", "Makeup"]
        
        self.updateCart()
    }
    
    


    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "productList") {
            let destinationView:ProductListViewController = segue.destinationViewController as! ProductListViewController
            destinationView.selectedCategory = categories[self.collectionView.indexPathsForSelectedItems()![0].item] as! NSString
        }
        
    }
    
    
    
    
    
    
    
    // MARK: - Cart Methods
    
    func updateCart() {
        
        self.cartButton.badgeValue = String(Product.allObjects().count)
        self.cartButton.badgeBGColor = UIColor.init(red: 211/255.0, green: 11/255.0, blue: 55/255.0, alpha: 1.0);
        
    }
    
    
    
    
    
    
    
    // MARK: - Collection View Delegate Methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HomeViewCell
        
        cell.categoryName.text = categories[indexPath.item] as? String
        return cell
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("productList", sender: self)
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.bounds.size.width * 0.5 - 8, 54)
    }
    
    
}


