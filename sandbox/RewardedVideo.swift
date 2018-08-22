//
//  RewardedVideo.swift
//  sandbox
//
//  Created by Viktoria Gutyrchick on 20.08.2018.
//  Copyright © 2018 Viktoria. All rights reserved.
//

import UIKit
import Appodeal

class RewardedVideo : UIViewController, AppodealRewardedVideoDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appodeal.setRewardedVideoDelegate(self)
    }
    
    @IBAction func load(_ sender: Any) {
        Appodeal.load()
    }
    
    @IBAction func show(_ sender: Any) {
        Appodeal.showAd(AppodealShowStyle.rewardedVideo, rootViewController: self)
    }
    
    func rewardedVideoDidLoadAd(){
        NSLog("видеореклама была загружена")
    }
    
    func rewardedVideoDidFailToLoadAd(){
        NSLog("видеорекламе не удалось загрузиться")
    }
    
    func rewardedVideoDidPresent(){
        NSLog("видеореклама начала отображаться")
    }
    
    func rewardedVideoWillDismiss(){
        NSLog("видеореклама была закрыта")
    }
    
    func rewardedVideoDidFinish(_ rewardAmount: UInt, name rewardName: String!){
        NSLog("видео было полностью просмотрено")
    }
}

