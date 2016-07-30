//
//  LoginViewController.swift
//  TouchID
//
//  Created by Avinav Goel on 21/03/16.
//  Copyright © 2016 Avinav Goel. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var loginView:UIView!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    
    private var imageSet = ["cloud", "coffee", "food", "pmq", "temple"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Randomly pick an image
        let selectedImageIndex = Int(arc4random_uniform(5))
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        loginView.hidden = true
        authenticateWithTouchID()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func authenticateWithTouchID(){
        
        let localAuthContext = LAContext()
        let reasonText = "Login Required for Sign in"
        var authError : NSError?
        
        if
            !localAuthContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            error: &authError) {
            print(authError?.localizedDescription)
            // Display the login dialog when Touch ID is not available (e.g. insimulator)
            showLoginDialog()
            return
        }

        
        localAuthContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonText, reply: { (success: Bool, error: NSError?) -> Void
            in
            
            if success{
                print("Successfully Authenticated")
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.performSegueWithIdentifier("showHomeScreen", sender: nil)
                    })
            }
                else{
                if let error = error{
                    switch error.code{
                case LAError.AuthenticationFailed.rawValue :
                    print("AUthentication Failed")
                case LAError.PasscodeNotSet.rawValue:
                    print("Passcode not set")
                case LAError.SystemCancel.rawValue:
                    print("Authentication was canceled by system")
                case LAError.UserCancel.rawValue:
                    print("Authentication was canceled by the user")
                case LAError.TouchIDNotEnrolled.rawValue:
                    print("Authentication could not start because Touch ID has no enrolled fingers.")
                case LAError.TouchIDNotAvailable.rawValue:
                    print("Authentication could not start because Touch ID is not available.")
                case LAError.UserFallback.rawValue:
                    print("User tapped the fallback button (Enter Password).")
                default:
                    print(error.localizedDescription)
                    }
                }
                NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.showLoginDialog()
                        })
            }
        }
    )}
    
    
    @IBAction func authenticateWithPassword() {
                        if emailTextField.text == "Avinav" && passwordTextField.text ==
                        "1234" {
                        performSegueWithIdentifier("showHomeScreen", sender: nil)
                    } else {
                        loginView.transform = CGAffineTransformMakeTranslation(25, 0)
                        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping:
                    0.15, initialSpringVelocity: 0.3, options: .CurveEaseInOut, animations: {
                    self.loginView.transform = CGAffineTransformIdentity
                    }, completion: nil)
                        } }
    
    
    func showLoginDialog() {
        // Move the login view off screen
        loginView.hidden = false
        loginView.transform = CGAffineTransformMakeTranslation(0, -700)

        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            
            self.loginView.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
    }

}
