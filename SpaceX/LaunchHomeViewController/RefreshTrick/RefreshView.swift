//
//  RefreshView.swift
//  SpaceX
//
//  Created by Rudy Aramayo on 11/2/18.
//  Copyright © 2018 OrbitusRobotics. All rights reserved.
//

import UIKit
import SpriteKit

private let sceneHeight: CGFloat = 180

protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(refreshView: RefreshView)
}

class RefreshView: UIView {

  private unowned var scrollView: UIScrollView
  var progressPercentage: CGFloat = 0
  var isRefreshing = false
  var refreshItems = [RefreshItem]()
  weak var delegate: RefreshViewDelegate?
  var burstNode: SKEmitterNode?
    
  required init?(coder aDecoder: NSCoder) {
    scrollView = UIScrollView()//This is a compiler trick because we never use this and the property should be optional
    super.init(coder:aDecoder)!
    
    setupRefreshItems()
    
  }
  
  func setupRefreshItems() {
    let buildingsImageView = UIImageView(image:UIImage(named: "building_and_sky"))
    let groundImageView = UIImageView(image:UIImage(named: "ground"))
    let launchTriggerImageView = UIImageView(image:UIImage(named: "launch_trigger"))
    let launchFingerImageView = UIImageView(image:UIImage(named: "launch_finger"))
    
    let rocketImageView = UIImageView(image:UIImage(named: "rocket"))
    
    
    refreshItems = [
    
      RefreshItem(view: buildingsImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.height - buildingsImageView.bounds.height / 2), parallaxRatio: 1.5, sceneHeight: sceneHeight),
      RefreshItem(view: groundImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.height / 2), parallaxRatio: 0.5, sceneHeight: sceneHeight),
      RefreshItem(view: launchTriggerImageView, centerEnd: CGPoint(x: bounds.width * 0.1, y: bounds.height - groundImageView.bounds.height ), parallaxRatio: 3, sceneHeight: sceneHeight),
      RefreshItem(view: launchFingerImageView, centerEnd: CGPoint(x: bounds.width * 0.1, y: bounds.height - groundImageView.bounds.height/2 - 40.0), parallaxRatio: -1, sceneHeight: sceneHeight),
      
      RefreshItem(view: rocketImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.height/2 - rocketImageView.bounds.height / 2 - 44.0), parallaxRatio: 1, sceneHeight: sceneHeight),
    ]
    
    for refreshItem in refreshItems {
      addSubview(refreshItem.view)
    }
    
    let spriteView = SKView( frame: CGRect(x: self.frame.width/2.0 - 73, y: 55, width: 150, height: 150))
    let myScene = SKScene()
    myScene.backgroundColor = .clear
    spriteView.backgroundColor = .clear
    spriteView.allowsTransparency = true
    spriteView.presentScene(myScene)
    addSubview(spriteView)
    
    let burstPath = Bundle.main.path(forResource: "RocketFire",
                                     ofType: "sks")
    burstNode = NSKeyedUnarchiver.unarchiveObject(withFile: burstPath!) as? SKEmitterNode
    burstNode?.position = CGPoint(x: 0.5, y: 0.5)
    burstNode?.setScale( 0.01 )
    burstNode?.particleBirthRate = 0
    myScene.addChild(burstNode!)

  }
    
    func beginRefreshing(){
        isRefreshing = true
        
        self.burstNode?.particleBirthRate = 500
        
        UIView.animate(withDuration: 6.0, delay: 2.0, options: .curveEaseIn, animations: { [unowned self] () -> Void in
            print("begin refresh animation")
            self.scrollView.contentInset.top += sceneHeight
            
            //Animate buildings view to stars
            self.refreshItems[0].view.center = CGPoint(
                x: self.refreshItems[0].view.center.x,
                y: self.refreshItems[0].view.center.y + 300
            )
            //Animate ground away as well
            self.refreshItems[1].view.center = CGPoint(
                x: self.refreshItems[1].view.center.x,
                y: self.refreshItems[1].view.center.y + 300
            )
            //Animate ground away as well
            self.refreshItems[2].view.center = CGPoint(
                x: self.refreshItems[2].view.center.x,
                y: self.refreshItems[2].view.center.y + 300
            )
            //Animate ground away as well
            self.refreshItems[3].view.center = CGPoint(
                x: self.refreshItems[3].view.center.x,
                y: self.refreshItems[3].view.center.y + 300
            )
            
        }) { (_) -> Void in
            print("begin refresh completion block")
            
        }
    }
    
    func endRefreshing(){
        isRefreshing = true
    
        print("end refresh completion block")
        
        self.burstNode?.particleBirthRate = 100
        
        delayBySeconds(4, delayedCode: {
            self.burstNode?.particleBirthRate = 0
        })
        
        delayBySeconds(8, delayedCode: {
            UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveLinear, animations: { [unowned self] () -> Void in
                self.scrollView.contentInset.top -= sceneHeight
                self.isRefreshing = false
            })
        })
        
    }
  
    func updateRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForPercentage(progressPercentage)
        }
    }

    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame:frame)
        clipsToBounds = true
        backgroundColor = UIColor.green
        setupRefreshItems()
    }
}


extension RefreshView: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progressPercentage == 1 {
            beginRefreshing()
            targetContentOffset.pointee.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(refreshView: self)
        }
    }
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if (isRefreshing) {
        return
    }
    let refreshViewVisibleHeight = max(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))
    progressPercentage = min(1, refreshViewVisibleHeight / sceneHeight)
    print("progress percentage: \(progressPercentage)")
    updateRefreshItemPositions()
  }
}








