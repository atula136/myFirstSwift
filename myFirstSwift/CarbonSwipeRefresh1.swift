//
//  CarbonSwipeRefresh.swift
//  Demo
//
//  Created by tiennguyen on 3/21/17.
//  Copyright © 2017 molabo. All rights reserved.
//

import UIKit

enum PullState : Int {
    case ready = 0
    case dragging
    case refreshing
    case finished
}

let STROKE_ANIMATION = "stroke_animation"
let ROTATE_ANIMATION = "rotate_animation"

class CarbonSwipeRefresh1: UIControl {
    var colors = [Any]()
    
    var initConstraits: Int = 0
    var topConstrait: NSLayoutConstraint?
    var centerXConstrait: NSLayoutConstraint?
    var tableScrollView: UIScrollView?
    var pathLayer: CAShapeLayer?
    var arrowLayer: CAShapeLayer?
    var container: UIView?
    var marginTop: CGFloat = 0.0 {
        didSet {
            layoutIfNeeded()
        }
    }
    var isDragging: Bool = false
    var isFullyPulled: Bool = false
    var pullState = PullState(rawValue: 0)
    var colorIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.clear
        self.layer.opacity = 0
        self.colors = [self.tintColor]
        let view = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(40), height: CGFloat(40)))
        container = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(40), height: CGFloat(40)))
        view.addSubview(container!)
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20.0
        view.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0.7))
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 1.0
        view.layer.shadowOpacity = 0.12
        pathLayer = CAShapeLayer()
        pathLayer?.strokeStart = 0
        pathLayer?.strokeEnd = 10
        pathLayer?.fillColor = nil
        pathLayer?.lineWidth = 2.5
        let path = UIBezierPath(arcCenter: CGPoint(x: CGFloat(20), y: CGFloat(20)), radius: 9, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        pathLayer?.path = path.cgPath
        pathLayer?.strokeStart = 1
        pathLayer?.strokeEnd = 1
        pathLayer?.lineCap = kCALineCapSquare
        arrowLayer = CAShapeLayer()
        arrowLayer?.strokeStart = 0
        arrowLayer?.strokeEnd = 1
        arrowLayer?.fillColor = nil
        arrowLayer?.lineWidth = 3
        arrowLayer?.strokeColor = UIColor.blue.cgColor
        let arrow: UIBezierPath? = self.bezierArrow(from: CGPoint(x: CGFloat(20), y: CGFloat(20)), to: CGPoint(x: CGFloat(20), y: CGFloat(21)), width: 1)
        arrowLayer?.path = arrow?.cgPath
        arrowLayer?.transform = CATransform3DMakeTranslation(8.5, 0, 0)
        container?.layer.addSublayer(pathLayer!)
        container?.layer.addSublayer(arrowLayer!)
        self.setAnchorPoint(CGPoint(x: CGFloat(0.5), y: CGFloat(0.5)), forView: container!)
        self.addSubview(view)
        
//        tableScrollView?.addSubviddew(self)
//        translatesAutoresizingMaskIntoConstraints = false
//        let selfConstraints = [
//            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: tableScrollView, attribute: .top, multiplier: 1.0, constant: CGFloat(-50 + marginTop)),
//            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: tableScrollView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
//        ]
//        tableScrollView?.addConstraints(selfConstraints)
//        addConstraints([NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40),
//                        NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)])
//        self.frame.size = CGSize(width: 40, height: 40)
        
        
        let rect = CGRect(x: ((self.superview?.frame.size.width ?? UIScreen.main.bounds.width) - 40) / 2, y: -50 + marginTop, width: 40, height: 40)
        self.frame = rect
    }
        
    convenience init(scrollView: UIScrollView) {
        self.init()
        tableScrollView = scrollView
        marginTop = scrollView.contentOffset.y
        
        let options: NSKeyValueObservingOptions = [.new]
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: options, context: nil)
        scrollView.addObserver(self, forKeyPath: "pan.state", options: options, context: nil)
    }
    
    deinit {
        tableScrollView?.removeObserver(self, forKeyPath: "contentOffset")
        tableScrollView?.removeObserver(self, forKeyPath: "pan.state")
    }
    
    func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        let oldOrigin: CGPoint = view.frame.origin
        view.layer.anchorPoint = anchorPoint
        let newOrigin: CGPoint = view.frame.origin
        var transition = CGPoint()
        transition.x = newOrigin.x - oldOrigin.x
        transition.y = newOrigin.y - oldOrigin.y
        view.center = CGPoint(x: CGFloat(view.center.x - transition.x), y: CGFloat(view.center.y - transition.y))
    }
    
    override func didMoveToSuperview() {
        if (initConstraits == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            topConstrait = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1.0, constant: -50)
            centerXConstrait = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1.0, constant: -20)
            self.translatesAutoresizingMaskIntoConstraints = false
            self.superview?.addConstraint(topConstrait!)
            self.superview?.addConstraint(centerXConstrait!)
        }
        initConstraits = 1
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentOffset") {
            if let value: NSValue = change?[NSKeyValueChangeKey.newKey] as? NSValue {
                let _contentOffset = value.cgPointValue
                self.scrollViewDidScroll(_contentOffset)
            }
        }
        else if (keyPath == "pan.state") {
            if pullState == PullState.refreshing {
                return
            }
            let state = CInt(change?[NSKeyValueChangeKey.newKey] as! Int)
            if state == 2 {
                if pullState == PullState.finished {
                    if (tableScrollView?.contentOffset.y)! > -10 + marginTop {
                        isDragging = true
                        pullState = PullState.dragging
                    }
                }
                else {
                    isDragging = true
                    pullState = PullState.dragging
                }
            }
            else if state == 3 {
                if pullState != PullState.dragging {
                    return
                }
                isDragging = false
                if isFullyPulled {
                    pullState = PullState.refreshing
                    UIView.animate(withDuration: 0.2, animations: {() -> Void in
                        self.topConstrait?.constant = 10 - self.marginTop
                        self.layoutIfNeeded()
                    })
                    self.startAnimating()
                    self.sendActions(for: .valueChanged)
                }
                else {
                    UIView.animate(withDuration: 0.2, animations: {() -> Void in
                        self.topConstrait?.constant = -50 - self.marginTop
                        self.layoutIfNeeded()
                    }, completion: {(_ finished: Bool) -> Void in
                        self.pathLayer?.strokeColor = (self.colors[self.colorIndex] as? UIColor)?.cgColor
                    })
                }
            }
        }
        
    }
    
    func scrollViewDidScroll(_ contentOffset: CGPoint) {
        if pullState == PullState.refreshing {
            return
        }
        let newY = -contentOffset.y - 50
        if contentOffset.y - marginTop > -100 {
            isFullyPulled = false
            pathLayer?.strokeColor = (self.colors[colorIndex] as? UIColor)?.cgColor
            arrowLayer?.strokeColor = (self.colors[colorIndex] as? UIColor)?.cgColor
            self.update(with: contentOffset, outside: false)
            if isDragging {
                topConstrait?.constant = newY
                self.layoutIfNeeded()
            }
        }
        else {
            isFullyPulled = true
            self.update(with: contentOffset, outside: true)
        }
    }
    
    func update(with point: CGPoint, outside flag: Bool) {
        let angle: CGFloat = -(point.y - marginTop) / 130
        container?.layer.transform = CATransform3DMakeRotation(angle * 10, 0, 0, 1)
        if !flag && pullState == PullState.dragging {
            self.showView()
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            pathLayer?.strokeStart = 1 - angle
            self.layer.opacity = Float(angle * 2.0)
            CATransaction.commit()
        }
    }
    
    func startAnimating() {
        let currentAngle = CFloat((container?.layer.value(forKeyPath: "transform.rotation.z") as? NSNumber)!)
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = 3.0
        animation.fromValue = (currentAngle)
        animation.toValue = (2 * .pi + currentAngle)
        animation.isRemovedOnCompletion = false
        animation.repeatCount = .infinity
        container?.layer.add(animation, forKey: ROTATE_ANIMATION)
        let beginHeadAnimation = CABasicAnimation()
        beginHeadAnimation.keyPath = "strokeStart"
        beginHeadAnimation.duration = 0.5
        beginHeadAnimation.fromValue = (0.25)
        beginHeadAnimation.toValue = (1.0)
        beginHeadAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let beginTailAnimation = CABasicAnimation()
        beginTailAnimation.keyPath = "strokeEnd"
        beginTailAnimation.duration = 0.5
        beginTailAnimation.fromValue = (1.0)
        beginTailAnimation.toValue = (1.0)
        beginTailAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart"
        endHeadAnimation.beginTime = 0.5
        endHeadAnimation.duration = 1.0
        endHeadAnimation.fromValue = (0.0)
        endHeadAnimation.toValue = (0.25)
        endHeadAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = 0.5
        endTailAnimation.duration = 1.0
        endTailAnimation.fromValue = (0.0)
        endTailAnimation.toValue = (1.0)
        endTailAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let animations = CAAnimationGroup()
        animations.duration = 1.5
        animations.isRemovedOnCompletion = false
        animations.animations = [beginHeadAnimation, beginTailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = .infinity
        pathLayer?.add(animations, forKey: STROKE_ANIMATION)
        let timer = Timer(timeInterval: 0.5, target: self, selector: #selector(self.changeColor), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    
    func changeColor() {
        self.hideArrow()
        if pullState == PullState.refreshing {
            colorIndex += 1
            if colorIndex > self.colors.count - 1 {
                colorIndex = 0
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            pathLayer?.strokeColor = (self.colors[colorIndex] as? UIColor)?.cgColor
            CATransaction.commit()
            let timer = Timer(timeInterval: 1.5, target: self, selector: #selector(self.changeColor), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    func hideArrow() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        arrowLayer?.opacity = 0
        CATransaction.commit()
    }
    
    func showArrow() {
        arrowLayer?.opacity = 1
    }
    
    func endAnimating() {
        container?.layer.removeAnimation(forKey: ROTATE_ANIMATION)
        pathLayer?.removeAnimation(forKey: STROKE_ANIMATION)
    }
    
    func showView() {
        self.layer.transform = CATransform3DMakeScale(1, 1, 1)
        self.showArrow()
    }
    
    func hideView() {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.layer.opacity = 0
            self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
            // hide on center
            self.centerXConstrait?.constant = -10
            self.topConstrait?.constant += 10
            self.layoutIfNeeded()
        }, completion: {(_ finished: Bool) -> Void in
            self.endAnimating()
            // update center
            self.centerXConstrait?.constant = -20
            self.pullState = PullState.finished
            self.colorIndex = 0
            self.pathLayer?.strokeColor = (self.colors[self.colorIndex] as? UIColor)?.cgColor
            self.topConstrait?.constant = -50 + self.marginTop
        })
    }
    
    func startRefreshing() {
        pullState = PullState.refreshing
        self.layer.transform = CATransform3DMakeScale(0, 0, 1)
        centerXConstrait?.constant = 0
        topConstrait?.constant = 30 - marginTop
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.6, animations: {() -> Void in
            self.layer.opacity = 1
            self.layer.transform = CATransform3DMakeScale(1, 1, 1)
            self.centerXConstrait?.constant = -20
            self.topConstrait?.constant = 10 - self.marginTop
            self.layoutIfNeeded()
        }, completion: { _ in })
        self.startAnimating()
        self.hideArrow()
    }
    
    func endRefreshing() {
        self.hideView()
    }
    
    //-------
    func getAxisAlignedArrowPoints(width: CGFloat, length: CGFloat) -> [CGPoint] {
        
        let points: [CGPoint] = [
            CGPoint(x: CGFloat(0), y: width),
            CGPoint(x: length, y: CGFloat(0)),
            CGPoint(x: CGFloat(0), y: CGFloat(-width))
        ]
        return points
    }
    func transform(forStart startPoint: CGPoint, end endPoint: CGPoint, length: CGFloat) -> CGAffineTransform {
        let cosine: CGFloat = (endPoint.x - startPoint.x) / length
        let sine: CGFloat = (endPoint.y - startPoint.y) / length
        return CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: startPoint.x, ty: startPoint.y)
    }
    //-------
    func bezierArrow(from startPoint: CGPoint, to endPoint: CGPoint, width: CGFloat) -> UIBezierPath {
        let length: CGFloat = CGFloat(hypotf(Float(endPoint.x - startPoint.x), Float(endPoint.y - startPoint.y)))
        var points = [CGPoint](repeating: CGPoint.zero, count: 3)
        points = getAxisAlignedArrowPoints(width: width, length: length)
        let transform: CGAffineTransform = self.transform(forStart: startPoint, end: endPoint, length: length)
        let cgPath: CGMutablePath = CGMutablePath()
        cgPath.addLines(between: points, transform: transform)
        cgPath.closeSubpath()
        
        let bezierPath = UIBezierPath(cgPath: cgPath)
        return bezierPath
    }
}
