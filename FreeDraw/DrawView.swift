//
//  DrawView.swift
//  FreeDrawing
//
//  Created by Alex Nichol on 6/13/14.
//  Copyright (c) 2014 Alex Nichol. All rights reserved.
//

import UIKit

class DrawView: UIView {
  
  var lines: [Line] = []
  var lastPoint: CGPoint!
  var drawColor = UIColor.blackColor()
  var lineWidth = 5
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let point = touch.locationInView(self)
        lastPoint = point
        self.superview!.bringSubviewToFront(self)
    }
  
  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)  {
    var newTouch = touches.first as! UITouch
    let newPoint = newTouch.locationInView(self)
    lines.append(Line(start: lastPoint, end: newPoint, color: drawColor, width:CGFloat(lineWidth)))
    lastPoint = newPoint
    
    self.setNeedsDisplay()
  }
  
  override func drawRect(rect: CGRect)  {
    var context = UIGraphicsGetCurrentContext()
    CGContextSetLineCap(context, kCGLineCapRound)
    //CGContextSetLineWidth(context, CGFloat(lineWidth))
    for line in lines {
      CGContextBeginPath(context)
      CGContextSetLineWidth(context, line.width)
      CGContextMoveToPoint(context, line.startX, line.startY)
      CGContextAddLineToPoint(context, line.endX, line.endY)
      CGContextSetStrokeColorWithColor(context, line.color.CGColor)
      CGContextStrokePath(context)
    }
  }
    
    func removeLastLine() {
        if lines.count > 0{
            lines.removeLast()
            self.setNeedsDisplay()
        }
    }
  
}
