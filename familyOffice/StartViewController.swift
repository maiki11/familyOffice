//
//  StartViewController.swift
//  familyOffice
//
//  Created by miguel reina on 04/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class StartViewController: UIViewController {

    @IBOutlet var logo: UIImageView!
    @IBOutlet var titleLogo: UIImageView!
    @IBOutlet var background: UIVisualEffectView!
    @IBOutlet var loginLayer: UIButton!
    @IBOutlet var signupLayer: UIButton!
    
    var playerController = AVPlayerViewController()
    var player:AVPlayer?
    
    
    override func viewDidLoad() {
        AuthService.authService.isAuth(view: self.self, name:"TabBarControllerView")
        super.viewDidLoad()
        
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
