//
//  RefreshItem.swift
//  SpaceX
//
//  Created by Rudy Aramayo on 11/2/18.
//  Copyright © 2018 OrbitusRobotics. All rights reserved.
//


import UIKit

class RefreshItem {

  private var centerStart: CGPoint
  private var centerEnd: CGPoint
  unowned var view: UIView
  
  init(view: UIView, centerEnd: CGPoint, parallaxRatio: CGFloat, sceneHeight: CGFloat) {
    self.view = view
    self.centerEnd = centerEnd
    centerStart = CGPoint(x: centerEnd.x, y: centerEnd.y + (parallaxRatio * sceneHeight))
    self.view.center = centerStart
  }
  
  func updateViewPositionForPercentage(_ percentage: CGFloat) {
    view.center = CGPoint(
      x: centerStart.x + (centerEnd.x - centerStart.x) * percentage,
      y: centerStart.y + (centerEnd.y - centerStart.y) * percentage
    )
  }
  
}










