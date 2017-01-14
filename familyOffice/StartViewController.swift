//
//  StartViewController.swift
//  familyOffice
//
//  Created by miguel reina on 04/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet var logo: UIImageView!
    @IBOutlet var titleLogo: UIImageView!
    @IBOutlet var background: UIVisualEffectView!
    @IBOutlet var loginLayer: UIButton!
    @IBOutlet var signupLayer: UIButton!
    
    
    override func viewDidLoad() {
        AuthService.authService.isAuth(view: self.self, name:"TabBarControllerView")
        super.viewDidLoad()
        animateView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //background.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*UIView.animate(withDuration: 1, delay: 0.0, options: <#T##UIViewAnimationOptions#>, animations: {
            
        }, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)*/
    }
    
    func animateView(){
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        logo.transform = CGAffineTransform(translationX: 0, y: -200)
        logo.transform = CGAffineTransform(rotationAngle: 90).concatenating(scale)
        self.titleLogo.alpha = 0
        
        UIView.animate(withDuration: 2, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.logo.alpha = 1
            let scale = CGAffineTransform(scaleX: 1, y: 1)
            self.logo.transform = CGAffineTransform(rotationAngle: 0).concatenating(scale)
        },completion: nil)
        
        //let firstPositionX = self.titleLogo.frame.origin.x
        //let firstPositionY = self.titleLogo.frame.origin.y

        //print(firstPositionX)
        //print(firstPositionY-20)
        
        UIView.animate(withDuration: 1.5, delay: 1.2, options: .curveEaseInOut, animations: {
            self.titleLogo.transform = CGAffineTransform(translationX: 0, y: -20.0 )
            self.titleLogo.alpha = 1
        }, completion: nil)
        
        self.loginLayer.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 1.6, options: .curveEaseInOut, animations: {
            self.loginLayer.transform = CGAffineTransform(translationX: 0, y: -20.0 )
            self.loginLayer.alpha = 1
        }, completion: nil)
        
        self.signupLayer.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 1.8, options: .curveEaseInOut, animations: {
            self.signupLayer.transform = CGAffineTransform(translationX: 0, y: -20.0 )
            self.signupLayer.alpha = 1
        }, completion: nil)
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        gotoView(view: "LoginView")
    }
   
    @IBAction func signUp(_ sender: UIButton) {
        gotoView(view: "SignUpView")
    }
    
    func gotoView(view:String )  {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: view)
        self.present(homeViewController, animated: true, completion: nil)
    }

}
