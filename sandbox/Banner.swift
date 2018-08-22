//
//  Banner.swift
//  sandbox
//
//  Created by Viktoria Gutyrchick on 20.08.2018.
//  Copyright © 2018 Viktoria. All rights reserved.
//

import UIKit
import Appodeal

class Banner : UIViewController, AppodealBannerDelegate {
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appodeal.setBannerDelegate(self)
    }
    
    @IBAction func load(_ sender: Any) {
        
    }
    
    @IBAction func shows(_ sender: Any) {
        Appodeal.showAd(AppodealShowStyle.bannerBottom, rootViewController: self)
    }
    
    @IBAction func closed(_ sender: Any) {
        Appodeal.hideBanner()
    }
    
    func bannerDidLoadAdIsPrecache(_ precache: Bool){
        NSLog("баннер был загружен")
        showAlertMsg(title: "Alert", message: "баннер был загружен", time: 3)
    }
    
    func bannerDidFailToLoadAd(){
        NSLog("баннеру не удалось загрузиться")
        showAlertMsg(title: "Alert", message: "баннеру не удалось загрузиться", time: 3)
    }
    
    func bannerDidClick(){
        NSLog("баннер был кликнут")
        showAlertMsg(title: "Alert", message: "баннер был кликнут", time: 3)
    }
    
    func bannerDidShow(){
        NSLog("баннер был показан")
        showAlertMsg(title: "Alert", message: "баннер был показан", time: 3)
    }
    
    func showAlertMsg(title: String, message: String, time: Int) {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.baseMessage = message
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: self.alertMessage(), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Alert was cancelled")
            self.alertController=nil;
            self.alertTimer?.invalidate()
            self.alertTimer=nil
        }
        
        self.alertController!.addAction(cancelAction)
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Banner.countDown), userInfo: nil, repeats: true)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    @objc func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
        }
        
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message+"\(self.remainingTime)")
    }
}

