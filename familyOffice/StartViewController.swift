//
//  StartViewController.swift
//  familyOffice
//
//  Created by miguel reina on 04/01/17.
//  Copyright © 2017 Miguel Reina y Leonardo Durazo. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import AVFoundation
import AVKit

class StartViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {

    @IBOutlet var logo: UIImageView!
    @IBOutlet var titleLogo: UIImageView!
    @IBOutlet var googleSignUp: GIDSignInButton!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var footer: UIStackView!
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    
    
    func webviewDidFinishLoad(_ : UIWebView){
        UTILITY_SERVICE.stopLoading(view: self.view)
    }
    
    override func viewDidLoad() {
        AUTH_SERVICE.isAuth(view: self.self, name:"TabBarControllerView")
        super.viewDidLoad()
        print(UIDevice().description)
        if(UIDevice.current.model == "Iphone 5s"){
            logo.frame.origin.y = logo.frame.origin.y-20
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //Loading video
        let videoString:String? = Bundle.main.path(forResource: "background", ofType: "mp4")
        if let url = videoString {
            let videoURL = NSURL(fileURLWithPath: url)
            
            player = AVPlayer(url: videoURL as URL)
            player?.actionAtItemEnd = .none
            player?.isMuted = true
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            playerLayer.zPosition = -1
            
            playerLayer.frame = view.frame
            
            view.layer.addSublayer(playerLayer)
            
            player?.play()
            
            // add observer to watch for video end in order to loop video
            NotificationCenter.default.addObserver(self, selector: #selector(StartViewController.videoDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)

            //NotificationCenter.default.addObserver(self, selector: #selector(StartViewController.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player)
            
        }else {
            debugPrint("Error al cargar video")
        }
        
        animateView()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        UTILITY_SERVICE.enabledView()
    }
    
    func videoDidReachEnd() {
        
        //now use seek to make current playback time to the specified time in this case (O)
        let duration : Int64 = 0
        let preferredTimeScale : Int32 = 1
        let seekTime : CMTime = CMTimeMake(duration, preferredTimeScale)
        player!.seek(to: seekTime)
        player!.play()
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
        
        UIView.animate(withDuration: 1.5, delay: 1.2, options: .curveEaseInOut, animations: {
            self.titleLogo.transform = CGAffineTransform(translationX: 0, y: -20.0 )
            self.titleLogo.alpha = 1
        }, completion: nil)
        
        self.emailField.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 1.6, options: .curveEaseInOut, animations: {
            self.emailField.transform = CGAffineTransform(translationX: 0, y: -20.0 )
            self.emailField.alpha = 1
        }, completion: nil)
        
        self.emailField.layer.borderColor = UIColor( red: 1/255, green: 255.0/255, blue:255.0/255, alpha: 1.0 ).cgColor
        
        self.passwordField.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 1.6, options: .curveEaseInOut, animations: {
            self.passwordField.transform = CGAffineTransform(translationX: 0, y: -20.0 )
            self.passwordField.alpha = 1
        }, completion: nil)
        
        self.loginButton.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 1.8, options: .curveEaseInOut, animations: {
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: -20.0 )
            self.loginButton.alpha = 1
        }, completion: nil)
        
        self.googleSignUp.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 1.8, options: .curveEaseInOut, animations: {
            self.googleSignUp.transform = CGAffineTransform(translationX: 0, y: -20.0 )
            self.googleSignUp.alpha = 1
        }, completion: nil)
       
        self.footer.alpha = 0
        UIView.animate(withDuration: 1.0, delay: 2.4, options: .curveEaseInOut, animations: {
            self.footer.alpha = 1
        }, completion: nil)
        
    }
   
    @IBAction func signUp(_ sender: UIButton) {
        UTILITY_SERVICE.loading(view: self.view)
        UIApplication.shared.beginIgnoringInteractionEvents()
        gotoView(view: "SignUpView")
    }
    
    func gotoView(view:String )  {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: view)
        self.present(homeViewController, animated: true, completion: nil)
    }
    //signin login
    @IBAction func handleSignIn(_ sender: UIButton) {
        if(!(emailField.text?.isEmpty)! && !(passwordField.text?.isEmpty)!){
            UTILITY_SERVICE.loading(view: self.view)
            UTILITY_SERVICE.disabledView()
            NotificationCenter.default.addObserver(forName: LOGINERROR, object: nil, queue: nil){_ in
                let alert = UIAlertController(title: "Verifica tus datos", message: "Su correo electrónico y contraseña son incorrectas.", preferredStyle: .alert)
                ANIMATIONS.shakeTextField(txt: self.emailField)
                ANIMATIONS.shakeTextField(txt: self.passwordField)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                UTILITY_SERVICE.enabledView()
                UTILITY_SERVICE.stopLoading(view: self.view)
            }
            AUTH_SERVICE.login(email: emailField.text!, password: passwordField.text!)
        }else{
            let alert = UIAlertController(title: "Verifica tus datos", message: "Inserte un correo electrónico y una contraseña", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            ANIMATIONS.shakeTextField(txt: emailField)
            ANIMATIONS.shakeTextField(txt: passwordField)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            UTILITY_SERVICE.stopLoading(view: self.view)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //change color status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func emailField(_ sender: Any) {
        textFieldDidBeginEditing(self.emailField)
    }
    
    @IBAction func emailFieldEnd(_ sender: Any) {
        textFieldDidEndEditing(self.emailField)
    }
    
    @IBAction func passwordFieldBeginEditing(_ sender: Any) {
        textFieldDidBeginEditing(self.passwordField)
    }
    
    @IBAction func passwordFieldEndEditing(_ sender: Any) {
        textFieldDidEndEditing(self.passwordField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField: textField, moveDistance: -150, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField: textField, moveDistance: -150, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool){
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

}
