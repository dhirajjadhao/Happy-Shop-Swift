//
//  ProductCartViewController.swift
//  Happy Shop
//
//  Created by Dhiraj Jadhao on 27/04/16.
//  Copyright © 2016 Dhiraj Jadhao. All rights reserved.
//

import UIKit
import Realm


class ProductCartViewController: UIViewController {

    
    var totalProductsInCart:RLMResults!
    var notification:RLMNotificationToken!
    var subTotal:Float = 0.00
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var continueShoppingButton:UIButton!
    
    
    // MARK: - View Delegate Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.notification = RLMRealm.defaultRealm().addNotificationBlock { notification, realm in
            
            self.subTotal = 0
            
            if self.totalProductsInCart.count == 0{
                
                self.tableView.hidden = true
            }
            else{
                
                self.tableView.hidden = false
            }
            
            self.tableView.reloadData()
            
        }
     
        self.totalProductsInCart = Product.allObjects()
        
        if self.totalProductsInCart.count == 0{
            
            self.tableView.hidden = true
        }
        else{
            
            self.tableView.hidden = false
        }
        
        self.tableView.reloadData()
      
    }
    
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        self.notification.stop()
       
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    

    

    
    // MARK: - Table View Delegates Methods
    
    
    func tableView(tableView: UITableView!, titleForHeaderInSection indexPath: NSIndexPath!) -> NSString{
        
        return "Your Bag"
    }
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1
    }
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return Int(self.totalProductsInCart.count+1)
    }
    
    
    
    
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        if indexPath.row == Int(self.totalProductsInCart.count) {
            
            return 226
        }
        
        return 114
    }
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    
        
        if indexPath.row == Int(self.totalProductsInCart.count) {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("orderSummaryCell", forIndexPath: indexPath) as! ProductSummeryCell
            
            for i:UInt in 0 ..< self.totalProductsInCart.count {
                
                let productObject = self.totalProductsInCart.objectAtIndex(i) as! Product
                subTotal = subTotal + productObject.productPriceForTotalUnits
                
            }
            
            cell.summerySubTotalLabel.text = String(format:"S$%.2f",subTotal)
            cell.summeryTotalLabel.text = String(format:"S$%.2f",subTotal)
            cell.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
            
            cell.continueShoppingButton.addTarget(self, action: #selector(backButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
            
            return cell
            
        }
        else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! ProductCartCell
            
            let productObject = self.totalProductsInCart.objectAtIndex(UInt(indexPath.row)) as! Product
            
            let placeholderImage = UIImage(named: "placeholder")!
            let URL = NSURL(string:productObject.productImageURL)
            
            cell.productImageView.af_setImageWithURL(URL!, placeholderImage: placeholderImage)
            cell.productOnSale.hidden = !productObject.onSale
            cell.productNameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
            cell.productUnitPriceLabel.text = String(format:"S$%.2f",productObject.productUnitPrice)
            cell.productTotalPriceLabel.text = String(format:"S$%.2f",productObject.productUnitPrice * Float(productObject.productUnits));
            cell.productQuantityLabel.text = String(format:"Qty: %ld",productObject.productUnits);
            cell.productQuantityStepper.value = Double(productObject.productUnits)
            cell.productQuantityStepper.tag = indexPath.row
            cell.productQuantityStepper.addTarget(self, action: #selector(productQuantityStepperPressed), forControlEvents: UIControlEvents.TouchUpInside)
            cell.backgroundColor = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
            
            return cell
        }
        

    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if indexPath.row != Int(self.totalProductsInCart.count) {
            
            self.performSegueWithIdentifier("showDetailFromCart", sender: self)
        }
        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        
        if indexPath.row == Int(self.totalProductsInCart.count) {
            
            return false
        }
        
        return true
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let productObjectToBeDeleted = self.totalProductsInCart.objectAtIndex(UInt(indexPath.row)) as! Product
            
            let realm = RLMRealm.defaultRealm()
            
            try! realm.transactionWithBlock(){
                
                realm.deleteObject(productObjectToBeDeleted)
            }

            
        }
    }
    
    
    
    
    
    // MARK: - Action Methods
    
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    
    
    func productQuantityStepperPressed(sender: UIStepper){
        
        let productObjectToBeUpdated = self.totalProductsInCart.objectAtIndex(UInt(sender.tag)) as! Product
        
        let realm = RLMRealm.defaultRealm()
        
        try! realm.transactionWithBlock(){
            
            productObjectToBeUpdated.productUnits = Int(sender.value)
            productObjectToBeUpdated.productPriceForTotalUnits = Float(productObjectToBeUpdated.productUnits)*productObjectToBeUpdated.productUnitPrice;
            
            realm.addOrUpdateObject(productObjectToBeUpdated)
        }
        
    }
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showDetailFromCart") {
            
            let destinationView:ProductDetailViewController = segue.destinationViewController as! ProductDetailViewController
            
            let productObjectSelected = self.totalProductsInCart.objectAtIndex(UInt((self.tableView.indexPathForSelectedRow?.row)!)) as! Product
            
            destinationView.selectedProductID = productObjectSelected.productIndex
            
            
        }
        
    }

}
