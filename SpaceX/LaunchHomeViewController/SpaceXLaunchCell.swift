//
//  SpaceXLaunchCell.swift
//  SpaceX
//
//  Created by Rudy Aramayo on 11/2/18.
//  Copyright © 2018 OrbitusRobotics. All rights reserved.
//

import UIKit

class SpaceXLaunchCell: UITableViewCell {

    @IBOutlet var launch_missionName: UILabel!
    @IBOutlet var launch_missionIcon: UIImageView!
    @IBOutlet var launch_rocketName: UILabel!
    @IBOutlet var launch_rocketType: UILabel!
    @IBOutlet var launch_dateTimeString: UILabel!
    
    @IBOutlet var launch_details: UILabel!
    var launch_payloadArray: NSArray!
    var launch_flickrImagesArray: [String]!
    
}
