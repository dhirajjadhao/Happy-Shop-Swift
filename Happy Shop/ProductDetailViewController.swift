//
//  ProductDetailViewController.swift
//  Happy Shop
//
//  Created by Dhiraj Jadhao on 26/04/16.
//  Copyright © 2016 Dhiraj Jadhao. All rights reserved.
//

import UIKit
import Realm
import Alamofire
import AlamofireImage
import SVProgressHUD

class ProductDetailViewController: UIViewController {
    
    
    // MARK: - Properties

    var selectedProductID:Int!
    var notification:RLMNotificationToken!
    var  productDetail:NSMutableDictionary = NSMutableDictionary()
 
    @IBOutlet var productImageView:UIImageView!
    @IBOutlet var productName:UILabel!
    @IBOutlet var productPrice:UILabel!
    @IBOutlet var productOnSale:UILabel!
    @IBOutlet var productDescription:UITextView!
    @IBOutlet var cartButton:UIButton!
    @IBOutlet var addToCartButton:UIButton!


    
    
    
    // MARK: - View Delegate Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.notification = RLMRealm.defaultRealm().addNotificationBlock { notification, realm in
            
            
            self.updateCart()
        }
        
        self.updateCart()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        self.notification.stop()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.updateCart()
        
        SVProgressHUD.show()
        self.fetchProductDetail()
    }
    
    
    
    
    
    
    
    
    
    // MARK: - UI Setup Methods
    
    func setupUI() {
        
        self.addToCartButton.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.addToCartButton.layer.shadowOffset = CGSizeMake(0, -5)
        self.addToCartButton.layer.shadowOpacity = 0.4
        
        if (productDetail.objectForKey("name") != nil) {
            
            self.title = productDetail.objectForKey("name") as? String
            
            let placeholderImage = UIImage(named: "placeholder")!
            let URL = NSURL(string: productDetail.objectForKey("img_url") as! String)!
            self.productImageView.af_setImageWithURL(URL,placeholderImage: placeholderImage)
            self.productName.text = productDetail.objectForKey("name") as? String
            self.productPrice.text = String(format:"S$%.2f",(productDetail.objectForKey("price") as? Float)!)
            self.productDescription.text = productDetail.objectForKey("description") as? String
            
            if productDetail.objectForKey("under_sale") as! Bool {
                
                self.productOnSale.hidden = false
            }
            else{
                
                self.productOnSale.hidden = true
            }
            
            
        }
        else{
            
            self.title = "Loading..."
            self.productName.text = "Loading..."
            self.productPrice.text = "Loading..."
            self.productDescription.text = "Loading..."
            self.productOnSale.hidden = true
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Cart Methods
    
    func updateCart() {
        
        self.cartButton.badgeValue = String(Product.allObjects().count)
        self.cartButton.badgeBGColor = UIColor.init(red: 211/255.0, green: 11/255.0, blue: 55/255.0, alpha: 1.0);
        
    }
    
    
    
    
    
    
    
    // MARK: - Fetch Product Details
    
    func fetchProductDetail(){
        
        Alamofire.request(.GET, "http://sephora-mobile-takehome-2.herokuapp.com/api/v1/products/\(self.selectedProductID).json", parameters:nil)
            .responseJSON { response in
                
                self.productDetail = (response.result.value?.objectForKey("product"))! as! NSMutableDictionary
                SVProgressHUD.dismiss()
                self.setupUI()
  
        }
        
    }

    
    
    
    

    // MARK: - Action Methods
    
    @IBAction func addToCartButtonPressed(sender: AnyObject) {
        
        
        let predicate = NSPredicate(format:"productIndex = %d",self.selectedProductID)
        let productObject = Product.objectsWithPredicate(predicate).firstObject()
        
        if Product.allObjects().count>0 && productObject != nil {
         
            SVProgressHUD.showInfoWithStatus("Item already in Bag.")
        }
        else{
            
           
                let producObjectToBeAdded = Product()
                
                producObjectToBeAdded.productIndex = productDetail.objectForKey("id") as! Int
                producObjectToBeAdded.productName = productDetail.objectForKey("name") as! String
                producObjectToBeAdded.productImageURL = productDetail.objectForKey("img_url") as! String
                producObjectToBeAdded.productUnits = 1
                producObjectToBeAdded.productUnitPrice = (productDetail.objectForKey("price") as? Float)!
                producObjectToBeAdded.productPriceForTotalUnits = producObjectToBeAdded.productUnitPrice * Float(producObjectToBeAdded.productUnits)
                producObjectToBeAdded.onSale = productDetail.objectForKey("under_sale") as! Bool
                
                let realm = RLMRealm.defaultRealm()
            
                 try! realm.transactionWithBlock(){
                
                        realm.addOrUpdateObject(producObjectToBeAdded)
                    }
            
                SVProgressHUD.showSuccessWithStatus("Item added in Bag.")
  
            
        }
    }
}
