//
//  DetailViewController.swift
//  SpaceX
//
//  Created by Rudy Aramayo on 12/18/18.
//  Copyright © 2018 OrbitusRobotics. All rights reserved.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {

    @IBOutlet var launch_rocketNameLabel: UILabel!
    @IBOutlet var launch_rocketTypeLabel: UILabel!
    @IBOutlet var launch_launchDateLabel: UILabel!
    @IBOutlet var launch_missionIconImageView:UIImageView!
    
    var launch_missionName: String!
    var launch_rocketName: String!
    var launch_rocketType: String!
    var launch_dateTimeString: String!
    var launch_details: String!
    var launch_payloadArray: NSArray!
    var launch_flickerArray: [String]!
    var launch_missionIconImage: UIImage!

    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache: NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launch_missionIconImageView.alpha = 0.0
        
        title = launch_missionName
        
        cache = NSCache()
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
        launch_rocketNameLabel.text = launch_rocketName
        launch_rocketTypeLabel.text = launch_rocketType
        launch_launchDateLabel.text = launch_dateTimeString
        
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.0, delay: 0.66, animations: { [unowned self] in
            self.launch_missionIconImageView.alpha = 1.0
            self.launch_missionIconImageView.image = self.launch_missionIconImage
        }) { (didFinishAnimation:Bool) in
            
            
        }

    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //1. details section
        //2. payload section
        //3. flicker images section
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return launch_payloadArray.count
        case 2:
            return launch_flickerArray.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0://SpaceXLaunchDetailsCell ** I need to estimate the height based on the text
            return 20.0 + launch_details.heightWithConstrainedWidth(width: tableView.frame.size.width - 40.0, font:UIFont.systemFont(ofSize: 17)) as CGFloat //Note: That 16 matches the Storyboard value. getting the cell and getting the value dynamically is too intense and not really important
        case 1://SpaceXPayloadCell
            return 97.0
        case 2://SpaceXPayloadFlickerImageCell
            return 172.0
        default:
            return 0.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            var cell:SpaceXLaunchDetailsCell
            cell = tableView.dequeueReusableCell(withIdentifier: "LaunchDetailsCell")! as! SpaceXLaunchDetailsCell
            cell.launch_details.text = launch_details
            return cell
        case 1:
            var cell:SpaceXPayloadCell
            cell = tableView.dequeueReusableCell(withIdentifier: "PayloadCell")! as! SpaceXPayloadCell
            //convert dicitonary to the proper strings!n !
            print(launch_payloadArray[indexPath.row])
            cell.launch_payloadID.text = ((launch_payloadArray[indexPath.row] as! NSDictionary).value(forKey: "payload_id") as? String)
            cell.launch_nationality.text = ((launch_payloadArray[indexPath.row] as! NSDictionary).value(forKey: "nationality") as? String)
            cell.launch_manufacturer.text = ((launch_payloadArray[indexPath.row] as! NSDictionary).value(forKey: "manufacturer") as? String)
            
            return cell
        case 2:
            var cell:SpaceXPayloadFlickerImageCell
            cell = tableView.dequeueReusableCell(withIdentifier: "PayloadFlickerImageCell")! as! SpaceXPayloadFlickerImageCell
            cell.launch_payloadFlickerImage?.image = UIImage(named: "placeholder_missionIcon-long")
            
            if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                cell.launch_payloadFlickerImage?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            }else{
                let artworkUrl = launch_flickerArray[indexPath.row]
                let url:URL! = URL(string: artworkUrl)
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async(execute: { () -> Void in
                            if let updateCell = tableView.cellForRow(at: indexPath) as? SpaceXPayloadFlickerImageCell {
                                let img:UIImage! = UIImage(data: data)
                                updateCell.launch_payloadFlickerImage?.image = img
                                self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            }
                        })
                    }
                })
                task.resume()
            }
            
            return cell
        default:
            fatalError("Should Not Get Here!!!")
        }
        
        let cell:UITableViewCell
        cell.textLabel?.text = "WrongCellCount!!!"
        return cell
    }
    
    
}


// MARK: - MFMessageComposeViewControllerDelegate
extension DetailViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate{
    
    @IBAction func shareEventAction(sender:UIBarButtonItem)
    {
        if (MFMessageComposeViewController.canSendText()) {
            
            // Create the action buttons for the alert.
            let smsAction = UIAlertAction(title: "SMS",
                                          style: .default) { (action) in
                                            // Respond to user selection of the action.
                                            self.sendSMS()
            }
            let emailAction = UIAlertAction(title: "Email",
                                            style: .default) { (action) in
                                                // Respond to user selection of the action.
                                                self.sendEmail()
            }
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel) { (action) in
                                                // Respond to user selection of the action.
            }
            
            // Create and configure the alert controller.
            let alert = UIAlertController(title: "Share Event",
                                          message: nil,
                                          preferredStyle: .actionSheet)
            alert.addAction(smsAction)
            alert.addAction(emailAction)
            alert.addAction(cancelAction)
            
            alert.popoverPresentationController?.barButtonItem = sender;
            
            self.present(alert, animated: true) {
                // The alert was presented
            }
            
        }
    }
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["address@example.com"])
        composeVC.setSubject("Hey take a look at this SpaceX Launch: " + self.launch_missionName)
        composeVC.setMessageBody(self.launch_dateTimeString + "\n" + self.launch_details, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendSMS()
    {
        let controller = MFMessageComposeViewController()
        controller.body = "Hey take a look at this SpaceX launch: " + self.launch_missionName
        controller.recipients = []
        controller.messageComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

