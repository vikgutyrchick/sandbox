//
//  Native.swift
//  sandbox
//
//  Created by Viktoria Gutyrchick on 20.08.2018.
//  Copyright © 2018 Viktoria. All rights reserved.
//

import UIKit
import Appodeal

class Native : UIViewController, APDNativeAdLoaderDelegate, APDNativeAdPresentationDelegate {
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var adDescription: UILabel!
    @IBOutlet weak var label: UILabel!
    var apdLoader : APDNativeAdLoader!
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?
    
    override func viewDidLoad(){
        apdLoader = APDNativeAdLoader.init()
        apdLoader.delegate = self
        hideAdView()
    }
    
    @IBAction func close(_ sender: Any) {
        hideAdView()
    }
    
    @IBAction func show(_ sender: Any) {
        showAdView()
    }
    
    @IBAction func load(_ sender: Any) {
        apdLoader.loadAd(with: APDNativeAdType.auto)
    }
    
    func nativeAdLoader(_ loader: APDNativeAdLoader!, didLoad nativeAds: [APDNativeAd]!){
        NSLog("Нативная реклама была загружена")
        let nativeAd = nativeAds[0]
        nativeAd.delegate = self
        adDescription.text = nativeAd.descriptionText
        label.text = nativeAd.title
        nativeAd.attach(to: adView, viewController: self)
        showAlertMsg(title: "Alert", message: "Нативная реклама была загружена", time: 3)
    }
    
    func nativeAdLoader(_ loader: APDNativeAdLoader!, didFailToLoadWithError error: Error!){
        NSLog("Нативной рекламе не удалось загрузиться")
        showAlertMsg(title: "Alert", message: "Нативной рекламе не удалось загрузиться", time: 3)
        
    }
    func nativeAdWillLogImpression(_ nativeAd: APDNativeAd!) {
        NSLog("нативная реклама была показана")
        showAlertMsg(title: "Alert", message: "Нативная реклама была показана", time: 3)
    }
    func nativeAdWillLogUserInteraction(_ nativeAd: APDNativeAd!) {
        NSLog("нативная реклама была кликнута")
        showAlertMsg(title: "Alert", message: "Нативная реклама была кликнута", time: 3)
    }
    
    func hideAdView() {
        adView.isHidden = true
        label.isHidden = true
    }
    
    func showAdView() {
        adView.isHidden = false
        label.isHidden = false
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
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Native.countDown), userInfo: nil, repeats: true)
        
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
