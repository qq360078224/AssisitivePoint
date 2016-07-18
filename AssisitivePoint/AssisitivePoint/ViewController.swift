//
//  ViewController.swift
//  AssisitivePoint
//
//  Created by XQ on 16/7/13.
//  Copyright © 2016年 MQB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.greenColor()
        // label验证回传值
        let label:UILabel = UILabel()
        label.frame = CGRectMake(0, 0, 200, 30)
        label.center = self.view.center
        label.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(label)
        // 添加小白点
        let XBDview:AssisitiveView = AssisitiveView.init(frame: CGRectMake(0, 60, 50, 50), nameArr: ["a", "b", "c", "d", "e"])
        self.view.addSubview(XBDview)
        // 闭包回传值
        XBDview.myClosure = {(tag:Int) ->Void in
            label.text = "这是第个\(tag)按钮点击了"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

