//
//  TestViewController.swift
//  FlyingViewsAnimationApp
//
//  Created by Filipp Kosenko on 17.02.2024.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet var animationView: FlyingViewsView!
    
    @IBAction func startButton(_ sender: UIButton) {
        self.animationView.start()
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        self.animationView.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.animationView.set(item: { UIImageView(image: UIImage(systemName: "square.and.arrow.up.circle.fill")) })
        self.animationView.set(colors: [.blue, .cyan, .systemBlue, .darkGray])
        self.animationView.set(angle: 10)
        self.animationView.setItem(size: 50)
        // Do any additional setup after loading the view.
    }
}
