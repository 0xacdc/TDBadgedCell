//
//  TDBadgedCell.swift
//  TDBadgedCell
//
//  Created by Tim Davies on 07/09/2016.
//  Copyright © 2016 Tim Davies. All rights reserved.
//

import UIKit

class TDBadgedCell: UITableViewCell {

    // Badge value
    var badgeString : String = "" {
        didSet {
            if(badgeString == "") {
                badgeView.removeFromSuperview()
                self.layoutSubviews()
            } else {
                self.contentView.addSubview(badgeView)
                self.drawBadge()
                self.layoutSubviews()
            }
        }
    }
    
    // Badge background colours
    var badgeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1.0)
    var badgeColorHighlighted = UIColor.white
    
    // Font and style
    var badgeFontSize = 11.0;
    var badgeRadius = 20;
    var badgeOffset = CGPoint(x:10, y:0);
    let badgeView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Layout our badge's position
        if(self.contentView.frame.width != self.frame.width) {
            badgeOffset.x = 0 // Accessory types are a pain to get sizing for?
        }
        badgeView.frame.origin.x = floor(self.contentView.frame.width - badgeView.frame.width - badgeOffset.x)
        badgeView.frame.origin.y = floor((self.frame.height / 2) - (badgeView.frame.height / 2))
    }
    
    // When the badge
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        drawBadge()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        drawBadge()
    }
    
    // Draw the bagde image
    private func drawBadge() {
        // Calculate the size of our string
        let textSize : CGSize = NSString(string: badgeString).size(attributes:[NSFontAttributeName:UIFont.boldSystemFont(ofSize:CGFloat(badgeFontSize))])
        
        // Create a frame with padding for our badge
        let height = textSize.height + 10
        var width = textSize.width + 16
        if(width < height) {
            width = height
        }
        let badgeFrame : CGRect = CGRect(x:0, y:0, width:width, height:height)
        
        let badge = CALayer()
        badge.frame = badgeFrame
        
        if(self.isHighlighted || self.isSelected) {
            badge.backgroundColor = badgeColorHighlighted.cgColor
        } else {
            badge.backgroundColor = badgeColor.cgColor
        }

        badge.cornerRadius = (CGFloat(badgeRadius) < (badge.frame.size.height / 2)) ? CGFloat(badgeRadius) : CGFloat(badge.frame.size.height / 2)
        
        // Draw badge into graphics context
        UIGraphicsBeginImageContextWithOptions(badge.frame.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        badge.render(in:ctx)
        ctx.saveGState()
        
        // Draw string into graphics context
        ctx.setBlendMode(CGBlendMode.clear)
        NSString(string: badgeString).draw(in:CGRect(x:8, y:5, width:textSize.width, height:textSize.height), withAttributes: [
            NSFontAttributeName:UIFont.boldSystemFont(ofSize:CGFloat(badgeFontSize)),
            NSForegroundColorAttributeName: UIColor.clear
            ])
        
        let badgeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        badgeView.frame = CGRect(x:0, y:0, width:badgeImage.size.width, height:badgeImage.size.height)
        badgeView.image = badgeImage
    }
}
