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
    
    
    @IBOutlet weak var composeTextField: UITextField!
    @IBOutlet weak var composeView: UIView!
    @IBOutlet weak var composeWindowView: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var composeWindowParent: UIView!
    @IBOutlet weak var laterParent: UIView!
    @IBOutlet weak var rescheduleParent: UIView!
    @IBOutlet weak var feedScrollView: UIScrollView!
    @IBOutlet weak var messageUIView: UIImageView!
    @IBOutlet weak var laterImageView: UIImageView!
    @IBOutlet weak var archiveImageView: UIImageView!
    @IBOutlet weak var messageParentView: UIView!
    
    var feedScrollViewCenter: CGPoint!
    var feedScrollViewStart: CGFloat!
    var feedScrollViewEnd: CGFloat!
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
        
        // Initialize feed scroll size
        feedScrollView.contentSize = CGSize(width: 320, height: 2000)
        
        // Hide default windows
        laterParent.alpha = 0
        rescheduleParent.alpha = 0
        archiveImageView.alpha = 0
        
        // Initialize message positions
        messageStart = messageUIView.center.x
        messageEnd =  messageStart - 320
        messageDeleted =  messageStart + 320
        
        feedScrollViewStart = feedScrollView.center.x
        feedScrollViewEnd = feedScrollViewStart + 280
        
        laterStart = laterImageView.center.x
        archiveStart = archiveImageView.center.x
        
        
        // Create edge gesture for menu
        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        let rightEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        
        leftEdgeGesture.edges = UIRectEdge.Left
        rightEdgeGesture.edges = UIRectEdge.Right
        
        feedScrollView.addGestureRecognizer(leftEdgeGesture)
        feedScrollView.addGestureRecognizer(rightEdgeGesture)
        
        
        composeView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        
        composeView.alpha = 0
        
        composeWindowParent.center.y = composeWindowParent.frame.height + 568
        
        composeView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        
        
//        let feedPanGesture = UIPanGestureRecognizer(target: self, action: "didPanFeed")
//        feedScrollView.addGestureRecognizer(feedPanGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let velocity = sender.velocityInView(view)
        let translation = sender.translationInView(view)
        
        if sender.state == .Began {
            feedScrollViewCenter = feedScrollView.center
        } else if sender.state == .Changed {
            feedScrollView.center = CGPoint(x: feedScrollViewCenter.x + translation.x, y: feedScrollViewCenter.y)
        } else if sender.state == .Ended {
            
            if velocity.x > 0 {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    self.feedScrollView.center.x = self.feedScrollViewEnd
                    }, completion: nil)
            }
                
            else {
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    self.feedScrollView.center.x = self.feedScrollViewStart
                    }, completion: nil)
            }
        }
        
    }
    
    @IBAction func didPanTray(sender: UIPanGestureRecognizer) {
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
    }
    
    @IBAction func didDismissLater(sender: AnyObject) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.laterParent.alpha = 0
            self.feedView.center.y -= 87
        }
    }
    
    @IBAction func didPressCompose(sender: AnyObject) {
        
        self.composeView.alpha = 1
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.composeWindowParent.center.y = (self.composeWindowParent.frame.height / 2) + 24
            
            self.composeView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            }) { (Bool) -> Void in
                self.composeTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func didCancelComposeButton(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.composeWindowParent.center.y = self.composeWindowParent.frame.height + 568
            
            self.composeView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            }) { (Bool) -> Void in
                self.composeView.alpha = 0
                
        }
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
        if(event.subtype == UIEventSubtype.MotionShake) {
//            UIView.animateWithDuration(0.3, delay: 1, options: [], animations: { () -> Void in
//                self.messageUIView.center.x = self.messageOriginalCenter.x
//                self.feedView.center.y += 87
//                }, completion: nil)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.messageUIView.center.x = self.messageOriginalCenter.x
                self.feedView.center.y += 87
                
                }, completion: { (Bool) -> Void in
                    self.laterImageView.alpha = 1
                    self.archiveImageView.alpha = 1
//                    self.archiveImageView.center.x = self.archiveStart
            })
        }
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
