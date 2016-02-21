//
//  MailboxViewController.swift
//  Codepath-Week3-Assignment
//
//  Created by Lim, Jeremie on 2/18/16.
//  Copyright © 2016 Lim, Jeremie. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

class MailboxViewController: UIViewController {
    
    
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var laterParent: UIView!
    @IBOutlet weak var rescheduleParent: UIView!
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var messageUIView: UIImageView!
    @IBOutlet weak var laterImageView: UIImageView!
    @IBOutlet weak var archiveImageView: UIImageView!
    @IBOutlet weak var messageParentView: UIView!

    
    var messageOriginalCenter: CGPoint!
    var messageStart: CGFloat!
    var messageEnd: CGFloat!
    var messageDeleted: CGFloat!
    var laterImageViewCenter: CGPoint!
    var archiveStart: CGFloat!
    var laterStart: CGFloat!
    var archiveImageViewCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedScrollView.contentSize = CGSize(width: 320, height: 2000)
        
        laterParent.alpha = 0
        rescheduleParent.alpha = 0
        archiveImageView.alpha = 0
        
        messageStart = messageUIView.center.x
        messageEnd =  messageStart - 400
        messageDeleted =  messageStart + 400
        
        laterStart = laterImageView.center.x
        archiveStart = archiveImageView.center.x
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
        //        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        
        let yellowColor: String = "#FAD333"
        let grayColor: String = "#E3E3E3"
        let brownColor: String = "#D8A675"
        let greenColor: String = "#70D962"
        let redColor: String = "#EB5433"
        
        feedScrollView.backgroundColor = UIColor.init(hexString: grayColor)
        
        if sender.state == UIGestureRecognizerState.Began {
            messageOriginalCenter = messageUIView.center
            laterImageViewCenter = laterImageView.center
            archiveImageViewCenter = archiveImageView.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            messageUIView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageUIView.center.y)
            
            laterImageView.alpha = convertValue(1, r1Min: 0, r1Max: 60, r2Min:0, r2Max: abs(translation.x))
            archiveImageView.alpha = convertValue(1, r1Min: 0, r1Max: 60, r2Min:0, r2Max: abs(translation.x))
      
            if translation.x <= -60 && translation.x >= -259 {
                laterImageView.center = CGPoint(x: (laterImageViewCenter.x + translation.x) + 60, y: laterImageViewCenter.y)
                
                feedScrollView.backgroundColor = UIColor.init(hexString: yellowColor)
                
                laterImageView.image = UIImage(named: "later_icon")
            } else if translation.x <= -260 {
                laterImageView.center = CGPoint(x: (laterImageViewCenter.x + translation.x) + 60, y: laterImageViewCenter.y)
                
                feedScrollView.backgroundColor = UIColor.init(hexString: brownColor)
                
                laterImageView.image = UIImage(named: "list_icon")
            } else if translation.x >= 60 && translation.x <= 259 {
                
                feedScrollView.backgroundColor = UIColor.init(hexString: greenColor)
                
                archiveImageView.center = CGPoint(x: (archiveImageViewCenter.x + translation.x) - 60, y: archiveImageViewCenter.y)
                
                archiveImageView.image = UIImage(named: "archive_icon")
                
            } else if translation.x >= 260 {
                feedScrollView.backgroundColor = UIColor.init(hexString: redColor)
                
                archiveImageView.center = CGPoint(x: (archiveImageViewCenter.x + translation.x) - 60, y: archiveImageViewCenter.y)
                
                archiveImageView.image = UIImage(named: "delete_icon")
            } else {
                laterImageView.center.x = laterStart
                
                feedScrollView.backgroundColor = UIColor.init(hexString: grayColor)
            }
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            if translation.x <= -60 && translation.x >= -259 {
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    
                    self.messageUIView.center.x = self.messageEnd
                    
                    }, completion: nil)
                
                UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                    self.rescheduleParent.alpha = 1
                    }, completion: nil)
                
                self.laterImageView.alpha = 0
                self.archiveImageView.alpha = 0
                
            } else if translation.x <= -260 {
                
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    
                    self.messageUIView.center.x = self.messageEnd
                    
                    }, completion: nil)
                
                UIView.animateWithDuration(0.3, delay: 0.3, options: [], animations: { () -> Void in
                    
                    self.laterParent.alpha = 1
                    
                    }, completion: nil)
                
                
                self.laterImageView.alpha = 0
                self.archiveImageView.alpha = 0
                
            } else if translation.x >= 60  {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageUIView.center.x = self.messageDeleted
                    self.feedView.center.y -= 87
                    
                    self.laterImageView.alpha = 0
                    self.archiveImageView.alpha = 0
                })
                
                UIView.animateWithDuration(0.3, delay: 1, options: [], animations: { () -> Void in
                    self.messageUIView.center.x = self.messageOriginalCenter.x
                    self.feedView.center.y += 87
                    
                    }, completion: { (Bool) -> Void in
                        self.laterImageView.alpha = 1
                        self.archiveImageView.alpha = 1
                        self.archiveImageView.center.x = self.archiveStart
                    })
                
                
            } else {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    
                    self.messageUIView.center.x = self.messageStart
                    self.laterImageView.center.x = self.laterStart
                    
                    }, completion: nil)
            }
        }
    }
    
    @IBAction func didDismissReschedule(sender: AnyObject) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.rescheduleParent.alpha = 0
            self.feedView.center.y -= 87
        }
        
       UIView.animateWithDuration(0.3, delay: 1, options: [], animations: { () -> Void in
            self.messageUIView.center.x = self.messageOriginalCenter.x
            self.feedView.center.y += 87
        }, completion: nil)
    }
    
    @IBAction func didDismissLater(sender: AnyObject) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.laterParent.alpha = 0
            self.feedView.center.y -= 87
        }
        
        UIView.animateWithDuration(0.3, delay: 1, options: [], animations: { () -> Void in
            self.messageUIView.center.x = self.messageOriginalCenter.x
            self.feedView.center.y += 87
            }, completion: nil)
    }
    
  
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
