//
//  DoneViewController.swift
//  Picker
//
//  Created by Haroon on 14/11/2014.
//  Copyright (c) 2014 Haroon. All rights reserved.
//

import UIKit
import Accounts
import Social
import SwifteriOS


extension UIView {
    func fadeIn(duration: NSTimeInterval = 1.5, delay: NSTimeInterval = 0.5, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.3, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}

class DoneViewController: UIViewController, UIAlertViewDelegate{
    
    var alertButtonColor: UIColor!
    var finalLabelColor:UIColor!
    var finalBackgroundColor: UIColor!
    var finalLabelFont: UIFont!
    var finalValueMessage: String!
    var tweetSuccess: Bool!
    
    
    @IBOutlet weak var myAddButton: UIButton!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var mylabel: UILabel!
    @IBOutlet weak var mySmilingImage: UIImageView!
    
    @IBAction func addName(sender: AnyObject) {
        getNameAlert()
    }
    
    // MARK: - Stock alert view delegate
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        var username = alertView.textFieldAtIndex(0)?.text!
        let finalUsername = username! as NSString
        
        if finalUsername.length > 1 {
            let defaults = NSUserDefaults()
            defaults.setObject(username, forKey: "name")
            defaults.synchronize()
        }
    }
    
    @IBOutlet weak var aboutButton: UIButton!
    
    @IBAction func aboutView(sender: AnyObject) {
        showAboutAlert()
    }
    
    @IBAction func valuesRetrieval(sender: AnyObject) {
        showValues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareBackgroundAndSetValues()
        addDonateButtonWithConstraints()
        addShadow(aboutButton)
        addShadow(myAddButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        addTapGestureToImage()
        getDefaultsAndAnimateIfPresent()
        
        mylabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.mylabel.text = "Lorem Ipsum Dolor"
            self.mylabel.fadeIn()
        })
        
    }
    
    // MARK: - Action to the imgage tap gesture
    func imageTapped(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: {
            self.mySmilingImage.alpha = 0.2
        })
        
        let alert = SCLAlertView()
        let txt = alert.addTextField(title:"Enter a beautiful tweet here ...")
        
        alert.addButton("Tweet it") {
            let myHashtag = "\n#Beautify"
            
            let accountStore = ACAccountStore()
            let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
            accountStore.requestAccessToAccountsWithType(accountType, options: nil){
                granted, error in
                if granted {
                    let twitterAccounts = accountStore.accountsWithAccountType(accountType)
                    if twitterAccounts?.count == 0 {
                        SweetAlert().showAlert("No configured twitter accounts")
                    }
                    else {
                        let twitterAccount = twitterAccounts[0] as ACAccount
                        let swifter = Swifter(account: twitterAccount)
                        swifter.postStatusUpdate(txt.text + myHashtag, inReplyToStatusID: nil, lat: nil, long: nil, placeID: nil, displayCoordinates: nil, trimUser: nil, success: {
                            (status: [String : SwifteriOS.JSONValue]?) in
                            self.tweetSuccess = true
                            }, failure: {
                                (error: NSError) in
                                self.tweetSuccess = false
                        })
                    }
               }
            }
            var alert = SweetAlert()
            alert.setColor(self.alertButtonColor)
            alert.showAlert("Thank You", subTitle: "Your tweet has been sent successfully", style: AlertStyle.Success, buttonTitle: "Ok", buttonColor: self.alertButtonColor, action: nil)
        }
        
        alert.showEdit("Tweet It", subTitle:"Spread the word if you like this app")
        
        UIView.animateWithDuration(1.5, animations: {
            self.mySmilingImage.alpha = 0.9
        })
    }
    
    func showAboutAlert(){
        
        var aboutMe: String = "Hi folks. I'm haroon, a slash coder and a techie guy digging deep into various new tech-related stuff with great enthusiasm to try new gadgets. I usually spend a lot of time coding in Python and Swift, configuring Linux and exploring Django.\n\nEmail: haroon.prog@gmail.com\nTwitter: @PyBaig\n\nHappy coding"
        
        SweetAlert().showAlert("Hi There!", subTitle: aboutMe, style: AlertStyle.CustomImag(imageFile: "myPic.png"), buttonTitle: "Take Care", buttonColor: alertButtonColor, action: nil)
    }
    
    func getNameAlert() {
        var alert: UIAlertView!
        alert = UIAlertView(title: "Hi mate", message: "Please Enter Your Name", delegate: self, cancelButtonTitle: "Done")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.show()
    }
    
    func showValues() {
        var alert = SweetAlert()
        alert.setColor(finalBackgroundColor)
        alert.showAlert("Your Values", subTitle: "\(finalValueMessage)", style: AlertStyle.Success, buttonTitle: "Got it", buttonColor: alertButtonColor, action: nil)
    }
    
    func prepareBackgroundAndSetValues() {
        self.view.backgroundColor = finalBackgroundColor
        mylabel.textColor = finalLabelColor
        mylabel.font = finalLabelFont
        
        aboutButton.tintColor = finalLabelColor
        var labelColor: String = finalLabelColor.description
        var components = labelColor.componentsSeparatedByString(" ")
        var labelRed = Int (((components[1] as NSString).doubleValue) * 255.0)
        var labelGreen = Int (((components[2] as NSString).doubleValue) * 255.0)
        var labelBlue = Int (((components[3] as NSString).doubleValue) * 255.0)
        
        var backgroundColor: String = finalBackgroundColor.description
        components = backgroundColor.componentsSeparatedByString(" ")
        var backgroundRed = Int (((components[1] as NSString).doubleValue) * 255.0)
        var backgroundGreen = Int (((components[2] as NSString).doubleValue) * 255.0)
        var backgroundBlue = Int (((components[3] as NSString).doubleValue) * 255.0)
        
        if ( (backgroundRed > 180) && (backgroundGreen > 180) && (backgroundBlue > 180) ){
            alertButtonColor = UIColor(red: CGFloat(backgroundRed - 100)/255.0, green: CGFloat(backgroundGreen - 100)/255.0, blue: CGFloat(backgroundBlue - 100)/255.0, alpha: 1.0)
        }
        else {
            alertButtonColor = finalBackgroundColor
        }
        
        var backgroundString: String = "Background color: (\(backgroundRed), \(backgroundGreen), \(backgroundBlue))"
        var labelString: String = "Text color: (\(labelRed), \(labelGreen), \(labelBlue))"
        var fontName = "Awesome Font: "+finalLabelFont.fontName
        
        finalValueMessage = "\(backgroundString)\n\(labelString)\n\(fontName)\n\n*Color values are in RGB"
        myAddButton.tintColor = finalLabelColor
        
    }
    
    func addDonateButtonWithConstraints() {
        
        var donateButton = MKButton(frame: CGRect(x: 10.0, y: 10.0, width: 180.0, height: 45.0))
        donateButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(donateButton)
        
        donateButton.addTarget(self, action: "donateAction:", forControlEvents: UIControlEvents.TouchUpInside)
        donateButton.backgroundColor = finalBackgroundColor
        donateButton.circleLayerColor = finalLabelColor
        donateButton.layer.shadowOpacity = 0.9
        donateButton.layer.shadowRadius = 20
        donateButton.layer.shadowColor = finalLabelColor.CGColor
        donateButton.layer.shadowOffset = CGSize(width: 0, height: 5.5)
        
        donateButton.setTitle("Donate", forState: .Normal)
        donateButton.setTitleColor(finalLabelColor, forState: .Normal)
        donateButton.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 22.0)
        
        var viewsDict = ["donateButton": donateButton]
        
        // MARK: - Constraints
        let width = NSLayoutConstraint.constraintsWithVisualFormat("V:[donateButton(45)]", options: nil, metrics: nil, views: viewsDict)
        let height = NSLayoutConstraint.constraintsWithVisualFormat("H:[donateButton(180)]", options: nil, metrics: nil, views: viewsDict)
        let position_X = NSLayoutConstraint(item: donateButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0)
        let position_Y = NSLayoutConstraint(item: donateButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.83, constant: 0.0)
        
        donateButton.addConstraints(width)
        donateButton.addConstraints(height)
        self.view.addConstraint(position_X)
        self.view.addConstraint(position_Y)
    }
    
    // MARK: - Donate button Action
    func donateAction(sender: UIButton!){
        var customIcon = UIImage(named: "lightbulb")
        UIPasteboard.generalPasteboard().string = "1MoUCY3GTnbJ7xvbqwjUUi4Bxbv6CCFZUi"
        var alertview = JSSAlertView()
        alertview.heightConstant = 6.5
        alertview.show(self, title: "We're Obliged", text: "BitCoin Wallet Address: 1MoUCY3GTnbJ7xvbqwjUUi4Bxbv6CCFZUi\n\nWe copied it for you so you can paste it anywhere.", buttonText: "Ok", color: finalBackgroundColor, iconImage: customIcon)
        alertview.setTextTheme(.Light)
    }
    
    func addTapGestureToImage() {
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: "imageTapped:")
        tapGestureRecogniser.numberOfTapsRequired = 1
        tapGestureRecogniser.numberOfTouchesRequired = 1
        mySmilingImage.addGestureRecognizer(tapGestureRecogniser)
    }
    
    func getDefaultsAndAnimateIfPresent() {
        let getDefault = NSUserDefaults()
        let name = getDefault.objectForKey("name") as NSString!
        
        if let username = name {
            myNameLabel.textColor = finalLabelColor
            myNameLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 45.0)
            myNameLabel.fadeOut(completion: { (Bool) -> Void in
                self.myNameLabel.text = "Good choice " + username + " !"
                self.myNameLabel.fadeIn(completion:{(Bool) -> Void in self.myNameLabel.fadeOut()
                })
            })
        }
    }
    
    func addShadow(anyView: UIView!) {
        anyView.layer.shadowColor = finalLabelColor.CGColor
        anyView.layer.shadowOpacity = 0.9
        anyView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
    }
    
}
