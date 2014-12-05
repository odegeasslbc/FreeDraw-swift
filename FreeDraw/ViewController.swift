//
//  ViewController.swift
//  FreeDraw
//
//  Created by 刘炳辰 on 14/11/22.
//  Copyright (c) 2014年 刘炳辰. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIPickerViewDelegate{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var drawView : AnyObject!
    @IBOutlet weak var tintSlider: UISlider!
    @IBOutlet weak var stepLabel: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var holderView: UIView!
    let alert:UIAlertView! = UIAlertView()
    let picker = UIPickerView()
    //一次性删除线条的长度
    var steps = 5
    
    //显示日期
    @IBAction func showDate(sender: AnyObject) {
        if datePicker.hidden == false{
            datePicker.hidden = true
        }else{
            datePicker.hidden = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //保存画图到相册
    @IBAction func save(sender: AnyObject) {
        
        var theDrawView = drawView as DrawView
        //遍历整个view的所有subview，找到画板view
        
        //for sub in self.view.subviews {
          //  if sub.isKindOfClass(UIView){
                
                UIGraphicsBeginImageContextWithOptions(holderView.frame.size,false,0.0)
                holderView.layer.renderInContext(UIGraphicsGetCurrentContext())
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
        
                let alert = SCLAlertView()
        
                alert.addButton("YES", action: {
                    UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil)
                    //弹出 保存成功 提示
                    let alert1 = SCLAlertView()
                    alert1.showSuccess(self, title: "保存成功", subTitle: "^_^", closeButtonTitle: "OK", duration: 0)
                })
                alert.showInfo(self, title: "确定保存？", subTitle: "图片将被保存到相册", closeButtonTitle: "NO", duration: 0)
        
        
        
            //}
        //}
    }
    
    @IBAction func removePhoto(sender: AnyObject) {
        imageView.image = nil
    }
    //读取图片
    @IBAction func loadPhoto(sender : AnyObject) {
        
        let pickerC = UIImagePickerController()
        
        pickerC.delegate = self
        var theDrawView = drawView as DrawView
        //theDrawView.backgroundColor = UIColor.whiteColor()
        //theDrawView.alpha = 0.5
        self.presentViewController(pickerC, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        let gotImage = info[UIImagePickerControllerOriginalImage] as UIImage
        let beginImage = CIImage(image: gotImage)
        var theDrawView = drawView as DrawView
        
        imageView.image = gotImage
        holderView.addSubview(imageView)
        //将imageview图层置于最底端
        holderView.sendSubviewToBack(imageView)
        
    }
    
    //清空所有
    @IBAction func clearTapped() {
        //alert.show()
        let newAlert = SCLAlertView()
        newAlert.addButton("YES"){
            self.loadView()
        }
        newAlert.showError(self, title: "are you sure", subTitle: "delect all you have done?", closeButtonTitle: "NO", duration: 0)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.loadView()
        }
    }
    
    
    @IBAction func steps(sender: AnyObject) {
        if let number = stepLabel.text.toInt(){
            steps = number
            println(number)
        }
    }
    //删除线条
    @IBAction func remove(sender: AnyObject) {
        var theDrawView = drawView as DrawView
        for var i = 0;i<steps;i++ {
            theDrawView.removeLastLine()
        }
    }
    
    //改变线条颜色
    @IBAction func colorTapped(button: UIButton!) {
        var theDrawView = drawView as DrawView
        var color : UIColor = UIColor.blackColor()
        
        if (button.titleLabel?.text == "Red") {
            color = UIColor.redColor()
        } else if (button.titleLabel?.text == "Black") {
            color = UIColor.blackColor()
        } else if(button.titleLabel?.text == "Blue"){
            color = UIColor.blueColor()
        } else if(button.titleLabel?.text == "Yellow"){
            color = UIColor.yellowColor()
        } else if(button.titleLabel?.text == "Green"){
            color = UIColor.greenColor()
        }
        
        theDrawView.drawColor = color
        
    }
    
    
    //改变线条粗细
    @IBAction func tintChanged(sender: AnyObject) {
        var theDrawView = drawView as DrawView
        let nbr = Int(tintSlider.value * 10) + 1
        theDrawView.lineWidth = nbr
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.tag = 0
        alert.message = "are you sure to remove all?"
        alert.addButtonWithTitle("yes")
        alert.addButtonWithTitle("no")
        alert.delegate = self
        
        picker.delegate = self
        let numbers = NSArray(arrayLiteral: "1","2","3","4","5")
        let rect = CGRectMake(self.view.frame.width/2, self.view.frame.height/2, 200, 300)
        
        //self.view.addSubview(picker)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

