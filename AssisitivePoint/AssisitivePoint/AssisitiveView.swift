//
//  AssisitiveView.swift
//  AssisitivePoint
//
//  Created by XQ on 16/7/13.
//  Copyright © 2016年 MQB. All rights reserved.
//

import UIKit

class AssisitiveView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    // MARK: - 闭包"block"
    typealias assisitiveClosure = (tag:Int)->Void
    var myClosure:assisitiveClosure?
    // MARK: - 声明属性
    func width(view:UIView)->CGFloat {
        return view.frame.size.width
    }
    func height(view:UIView)->CGFloat {
        return view.frame.size.height
    }
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
    let SCREEN_HEIGTH = UIScreen.mainScreen().bounds.height
    var mainBtn = UIButton()
    var btnArr = Array<UIButton>()
    var panGesture = UIPanGestureRecognizer()
    // MARK: - 重写init方法
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    // MARK: - 增加init方法
    convenience init(frame: CGRect, nameArr:[String]) {
        self.init(frame:frame)
//        self.backgroundColor = UIColor.redColor()
        // 设置mainBtn
        mainBtn = UIButton(type: .Custom)
        mainBtn.frame = CGRectMake(0, 0, width(self), height(self))
        mainBtn.setBackgroundImage(UIImage(named: "btnBG"), forState: .Normal)
        mainBtn.addTarget(self, action: "btnClick:", forControlEvents: .TouchUpInside)
        self.addSubview(mainBtn)
        // 拖拽手势
        panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.addGestureRecognizer(panGesture)
        // 初始化子按钮
        self.initBtns(nameArr)
    }
    // MARK: - 初始化子按钮
    func initBtns(nameArr:[String]) {
        for i in 0..<nameArr.count {
            let btn = UIButton(type: .System)
            btn.frame = self.frame
            btn.tag = 100 + i
            btn.center = CGPointMake(width(self) / 2, height(self) / 2)
            btn.backgroundColor = UIColor.orangeColor()
            btn.clipsToBounds = true
            btn.layer.cornerRadius = btn.frame.size.width / 2
            btn.setTitle("\(btn.tag)", forState: .Normal)
            btn.addTarget(self, action: "subBtnClick:", forControlEvents: .TouchUpInside)
            btn.hidden = true
            self.insertSubview(btn, belowSubview: mainBtn)
            btnArr.append(btn)
        }
    }
    // MARK: - mainBtn 点击事件
    func btnClick(sender:UIButton) {
        // 在左边还是右边
        let isLeft = self.frame.origin.x < SCREEN_WIDTH / 2 && mainBtn.frame.origin.x < SCREEN_WIDTH / 2
        // 修改self的frame
        self.changeSelfFrame(isLeft, isOpne: !sender.selected)
        for (index, btn) in btnArr.enumerate() {
            if !sender.selected {
                // 除去拖拽手势
                self.removeGestureRecognizer(panGesture)
                var x:CGFloat = 0.0
                let y:CGFloat  = self.height(self) / 2
                if isLeft {
                    x = CGFloat(index + 1) * 50 + self.width(mainBtn) / 2
                }else {
                    x = SCREEN_WIDTH - CGFloat(index + 1) * 50 - self.width(mainBtn) / 2 - 10
                }
                // 展开动画
                btn.center = mainBtn.center
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    btn.center = CGPointMake(x + 5, y)
                })
                btn.hidden = !btn.hidden
            }else {
                // 添加拖拽手势
                self.addGestureRecognizer(panGesture)
                if !isLeft {
                    btn.center.x = -CGFloat(index + 1) * 50 + self.width(mainBtn) / 2
                }
                // 收起动画
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    btn.center = CGPointMake(self.width(self) / 2, self.height(self) / 2)
                    }, completion: { (finished) -> Void in
                        btn.hidden = !btn.hidden
                })
            }
        }
        sender.selected = !sender.selected
    }
    // MARK: - 改变self的frame
    func changeSelfFrame(isleft:Bool, isOpne:Bool) {
        var newSelfframe:CGRect = self.frame
        // 左边
        if isleft {
            if isOpne {
                newSelfframe.size.width = SCREEN_WIDTH
                self.frame = newSelfframe
            }else {
                newSelfframe.size.width = mainBtn.frame.size.width
                self.frame = newSelfframe
            }
        }else {
            var newMainBtnFrame = mainBtn.frame
            if isOpne {
                newSelfframe.origin.x = 0
                newSelfframe.size.width = SCREEN_WIDTH
                self.frame = newSelfframe
                newMainBtnFrame.origin.x = SCREEN_WIDTH - mainBtn.frame.size.width
            }else {
                newSelfframe.origin.x = SCREEN_WIDTH - mainBtn.frame.size.width
                newSelfframe.size.width = mainBtn.frame.size.width
                self.frame = newSelfframe
                newMainBtnFrame.origin.x = 0
            }
            mainBtn.frame = newMainBtnFrame
        }
    }
    // MARK: - subBtn点击事件
    func subBtnClick(sender:UIButton) {
        
        // 闭包传值
        if (myClosure != nil) {
            myClosure!(tag: sender.tag)
        }
    }
    // MARK: - 拖拽手势方法
    func handlePanGesture(sender:UIPanGestureRecognizer) {
        switch sender.state {
        case UIGestureRecognizerState.Changed:
            //print(self.frame.origin)
            // 获得手势作用的view
            let view = sender.view;
            // 获得偏移量
            let offset = sender.translationInView(self.superview)
            view?.transform = CGAffineTransformTranslate((view?.transform)!, offset.x, offset.y)
            // 设置位移
            sender.setTranslation(CGPointZero, inView: view)
        case UIGestureRecognizerState.Ended:
            let view = sender.view;
            switch sender.view?.frame.origin.x {
                // 屏幕左边
            case let x where x < SCREEN_WIDTH / 2:
                view?.transform = CGAffineTransformMakeTranslation(0, self.frame.origin.y - self.frame.size.height)
                // 屏幕右边
            case let x where x > SCREEN_WIDTH / 2:
                view?.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH - self.frame.size.width, self.frame.origin.y - self.frame.size.height)
            default:
                break
            }
            switch sender.view?.frame.origin.y {
                // 屏幕左边
            case let y where y < 0:
                view?.transform = CGAffineTransformMakeTranslation(self.frame.origin.x, -self.frame.size.height)
                // 屏幕右边
            case let y where y > SCREEN_HEIGTH - self.height(self):
                view?.transform = CGAffineTransformMakeTranslation(self.frame.origin.x, SCREEN_HEIGTH - self.frame.size.height - 64)
            default:
                break
            }
            // 设置位移
            sender.setTranslation(CGPointZero, inView: view)
        default:
            break
        }
    }
    // MARK: - 重写方法系统自带
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
