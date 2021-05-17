//
//  LogInViewController.swift
//  QuizApp
//
//  Created by Kangseok Lee on 5/12/21.
//

import UIKit
import FBSDKLoginKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    @IBOutlet weak var LogInBttn: UIButton!
    @IBOutlet weak var FacebookBttn: UIButton!
    @IBOutlet weak var ForgotBttn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApplicationDelegate.initializeSDK(nil)
        let emailImage = UIImage(named: "EmailIcon")
        addLeftImageTo(txtField: EmailTxt, andImage: emailImage!)
        let PasswordImage = UIImage(named: "PasswordIcon")
        addLeftImageTo(txtField: PasswordTxt, andImage: PasswordImage!)
        
        EmailTxt.TextBoxDesign()
        PasswordTxt.TextBoxDesign()
        LogInBttn.BttnDesign()
        FacebookBttn.BttnDesign()
        ForgotBttn.BttnDesign()
        alertUsername.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertLogin.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
    }
    
    
    private func addLeftImageTo(txtField: UITextField, andImage img:UIImage){
        
        let leftImageView = UIImageView(frame: CGRect(x:0.0, y:0.0, width: img.size.width, height: img.size.height))
        leftImageView.image = img
        txtField.leftView = leftImageView
        txtField.leftViewMode = .always
        
    }
    
    //Facebook Login Integration
    static let loginManager: LoginManager = LoginManager()
    
    
    @IBAction func FacebookBttn(_ sender: Any) {
        
        if AccessToken.current == nil {
            //Session is not active
            
            LogInViewController.loginManager.logIn(permissions: ["public_profile","email"], from: self, handler: { result,error   in
                if error != nil {
                    
                } else if result!.isCancelled {
                    print("login cancelled by user")
                } else {
                    print("login successfully")
                    let token = result?.token?.tokenString
                    let req = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: .get)
                    req.start {(connection,result,error)
                        in
                        print(result!)
                    }
                    var sb = UIStoryboard(name: "Main", bundle: nil)
                    var vc = sb.instantiateViewController(identifier: "QuizMainPage") as! MenuViewController
                    self.present(vc, animated: true, completion: nil)
                    
                }
            })
            
        } else {
            print("already logged in")
            var sb = UIStoryboard(name: "Main", bundle: nil)
            var vc = sb.instantiateViewController(identifier: "QuizMainPage") as! MenuViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    


    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let alertUsername = UIAlertController(title: "Invalid Username", message: "We're sorry, we can't find that username, please try again", preferredStyle: .alert)
    let alertLogin = UIAlertController(title: "Invalid Login Credentials", message: "Invalid login credentials, please try again", preferredStyle: .alert)

    
    @IBAction func login(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(identifier: "home")
        homeVC.modalPresentationStyle = .fullScreen
        let isValidated = authenticate(username: usernameField.text, password: passwordField.text)
        if (isValidated){
            self.present(homeVC, animated: false)
        } else {
            self.present(alertLogin, animated: true)
        }
    }
    @IBAction func forgotPass(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgotPassVC = storyboard.instantiateViewController(identifier: "forgotPass")
        forgotPassVC.modalPresentationStyle = .fullScreen
        let user = DatabaseHelper.inst.fetchUserSpecifiedData(username: usernameField.text!)
        if (user.username == usernameField.text) {
            self.present(forgotPassVC, animated: false)
        } else {
            self.present(alertUsername, animated: true)
        }
    }
    
    func authenticate(username: String?, password: String?) -> Bool {
        let user = DatabaseHelper.inst.fetchUserSpecifiedData(username: username!)
        if (user.username == username && user.password == password) {
                return true
        }
        return false
    }

}

