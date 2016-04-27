//
//  ProductListViewController.swift
//  Happy Shop
//
//  Created by Dhiraj Jadhao on 26/04/16.
//  Copyright © 2016 Dhiraj Jadhao. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CCBottomRefreshControl
import SVProgressHUD


class ProductListViewController: UIViewController {

    
    // MARK: - Properties
    
    var selectedCategory:NSString!
    var productList:NSMutableArray = NSMutableArray()
    var page:Int = 1;
    var bottomRefershControl:UIRefreshControl = UIRefreshControl()
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var cartButton: UIButton!
    
    
    
    
    
    // MARK: - View Delegate Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
     
        self.updateCart()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.updateCart()
        
        self.title = self.selectedCategory as String
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        
        bottomRefershControl.triggerVerticalOffset = 20
        bottomRefershControl.addTarget(self, action:#selector(self.fetchProductList), forControlEvents: UIControlEvents.ValueChanged)
        self.collectionView.bottomRefreshControl = bottomRefershControl
        
        SVProgressHUD.show()
        self.fetchProductList()

    }
    
    

    
    
    
    
    // MARK: - Cart Methods
    
    func updateCart() {
        
        self.cartButton.badgeValue = String(Product.allObjects().count)
        self.cartButton.badgeBGColor = UIColor.init(red: 211/255.0, green: 11/255.0, blue: 55/255.0, alpha: 1.0);
        
    }
    
    
    
    
    
    
    
    // MARK: - Fetch Product List
    
     func fetchProductList(){
        
        Alamofire.request(.GET, "http://sephora-mobile-takehome-2.herokuapp.com/api/v1/products.json", parameters: ["category": self.selectedCategory!,"page":page])
            .responseJSON { response in

               self.productList.addObjectsFromArray((response.result.value?.objectForKey("products"))! as! NSArray as [AnyObject])
               self.bottomRefershControl.endRefreshing()
               SVProgressHUD.dismiss()
               self.collectionView.reloadData()
               self.page+=1
        }
        
    }
    
    
    
    
    
    
    
    // MARK: - Collection View Delegate Methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productList.count
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ProductListCell
        
        cell.productName.text = self.productList[indexPath.item].objectForKey("name") as? String
        cell.productName.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        
        cell.productPrice.text = String(format:"S$%.2f",(self.productList[indexPath.item].objectForKey("price") as? Float)!)
        
        let placeholderImage = UIImage(named: "placeholder")!
        let URL = NSURL(string: self.productList[indexPath.item].objectForKey("img_url") as! String)!
        
        cell.productImageView.af_setImageWithURL(URL, placeholderImage: placeholderImage)
        
        if self.productList[indexPath.item].objectForKey("under_sale") as! Bool {
            
            cell.productOnSale.hidden = false
        }
        else{
            
            cell.productOnSale.hidden = true
        }
        
        return cell
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("productDetail", sender: self)
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.bounds.size.width*0.5-8, 225);
    }
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "productDetail") {
            
            let destinationView:ProductDetailViewController = segue.destinationViewController as! ProductDetailViewController
            
            let productID:NSNumber = self.productList[self.collectionView.indexPathsForSelectedItems()![0].item].objectForKey("id") as! NSNumber
    
            destinationView.selectedProductID = Int(productID)
            
            
            
        }
        
    }

    
}
