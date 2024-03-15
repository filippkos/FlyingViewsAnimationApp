//
//  EggsView.swift
//  WeatherApp
//
//  Created by Filipp Kosenko on 05.02.2024.
//

import UIKit

final class FlyingViewsView: UIView {
    
    // MARK: -
    // MARK: Variables

    private var item: (() -> UIView)?
    private var itemSize: CGFloat = 100
    private var colors: [UIColor] = [.green, .red, .brown, .orange, .magenta]
    private var angle: CGFloat = 0 {
        didSet {
            self.setup()
        }
    }
    private var startX: CGFloat = 0
    private var startY: CGFloat = 0
    private var xRange: ClosedRange<Double> = 0...0
    private var items: [UIView] = [];
    private var isMaxXDimension = true
    private var isAnimating = false
    private var timer = Timer()
    
    private let defaultImage = UIImage(systemName: "oval.portrait.fill")!
    
    // MARK: -
    // MARK: Init
    
    init() {
        super.init(frame: CGRect())
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
    }
    
    // MARK: -
    // MARK: Public
    
    func set(item: @escaping () -> UIView) {
        self.item = item
    }
    
    func setItem(size: CGFloat) {
        self.itemSize = size
    }
    
    func set(colors: [UIColor]) {
        self.colors = colors
    }
    
    func set(angle: CGFloat) {
        self.angle = angle
    }
    
    func start() {
        if !self.isAnimating {
            self.isAnimating = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.025, repeats: true, block: { [weak self] (timer) in
                self?.addEgg(angle: self?.angle ?? 0)
            })
        }
    }
    
    func stop() {
        self.isAnimating = false
        self.timer.invalidate()
        self.removeItems()
    }
    
    // MARK: -
    // MARK: Private
    
    private func setup() {
        self.xAxisRange()
        self.startCoordinates()
        self.clipsToBounds = true
    }
    
    private func removeItems() {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        self.items.removeAll()
    }
    
    private func startCoordinates() {
        let angle = self.angle.truncatingRemainder(dividingBy: 360)
        self.startX = (0...180).contains(angle)
            ? -self.itemSize
            : self.frame.width + self.itemSize
        self.startY = (91...270).contains(angle)
            ? -self.itemSize * 2
            : self.frame.height + self.itemSize
    }
    
    private func xAxisRange() {
        self.xRange = (0...180).contains(angle)
            ? -self.itemSize...self.frame.height
            : (-self.frame.height - self.frame.width)...self.frame.width
    }

    private func addEgg(angle: CGFloat) {
        let view = self.addView(point: self.getStartCoordinates())
        self.items.append(view)
        self.animate(view: view, diff: self.frame.height, angle: angle)
    }
    
    private func getStartCoordinates() -> CGPoint {
        var xPoint = Double.random(in: self.xRange)
        var yPoint = Double.random(in: -self.itemSize * 5...self.frame.height + self.itemSize * 5)
        
        self.isMaxXDimension
        ? (xPoint = self.startX)
        : (yPoint = self.startY)
        
        self.isMaxXDimension = !self.isMaxXDimension

        return CGPoint(x: xPoint, y: yPoint)
    }
    
    private func addView(point: CGPoint) -> UIView {
        let view = self.item?() ?? UIImageView(image: self.defaultImage)
       
        view.tintColor = colors.randomElement()
        view.frame = CGRect(x: point.x, y: point.y, width: self.itemSize, height: self.itemSize)
        self.addSubview(view)
        
        return view
    }
    
    private func animate(view: UIView, diff: CGFloat, angle: CGFloat) {
        let pathLength = self.frame.height * 1.5
        let offsetX = pathLength * sin(self.deg2rad(angle))
        let offsetY = -1 * pathLength * cos(self.deg2rad(angle))
        
        UIView.animate(withDuration: Double.random(in: 1...9), delay: 0.0, options: [.curveLinear], animations: {
            view.frame = CGRectOffset(view.frame, offsetX, offsetY)
        }, completion: {_ in
            view.removeFromSuperview()
            self.items = self.items.filter { $0 != view }
        })
    }
    
    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    private static func copyView<T: UIView>(_ view: UIView) -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}
