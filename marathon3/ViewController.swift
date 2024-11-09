//
//  ViewController.swift
//  marathon3
//
//  Created by Diyor Tursunov on 09/11/24.
//

import UIKit

extension ViewController {
    enum Constants {
        static let squareSize: CGFloat = 100
        static let maxSquareSize:CGFloat = 150
        static let defaultOffset: CGFloat = 16
        static let squareTopOffset: CGFloat = 100
        static let maxAngle: Double = Double.pi / 2
        static let minAngle: Double = .zero
    }
}

class ViewController: UIViewController {
    
    private let slider = UISlider()
    
    private let squareView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
               
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        [slider, squareView].forEach(view.addSubview)
        
        squareView.frame = CGRect(
            x: Constants.defaultOffset,
            y: Constants.squareTopOffset,
            width: Constants.squareSize,
            height: Constants.squareSize
        )
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 200
            ),
            slider.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.defaultOffset
            ),
            slider.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -Constants.defaultOffset
            )
        ])
        
        slider.addTarget(self, action: #selector (sliderValueChanged), for: .valueChanged)

        slider.minimumValue = 0
        slider.maximumValue = 100
    }
    
    @objc private func sliderValueChanged(slider: UISlider, event: UIEvent) {
        let value = Double(slider.value)

        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .moved:
                changeFrame()
            case .ended:
                if Int(value) < Int(slider.maximumValue / 3) {
                    slider.setValue(slider.minimumValue, animated: true)
                } else {
                    slider.setValue(slider.maximumValue, animated: true)
                }
                
                changeFrame(with: true)
            default:
                break
            }
        }
        
        print(value)
    }
    
    private func changeFrame(with animation: Bool = false) {
        let value = Double(slider.value)

        var t = CGAffineTransform.identity
        t = t.translatedBy(
            x: valueAtPercentage(
                value,
                start: 0,
                end: UIScreen.main.bounds.width - 32 - Constants.squareSize - 32
            ),
            y: .zero
        )
        
        t = t.rotated(by: valueAtPercentage(
            value,
            start: Constants.minAngle,
            end: Constants.maxAngle)
        )
        
        t = t.scaledBy(
            x: valueAtPercentage(value, start: 1, end: 1.5),
            y: valueAtPercentage(value, start: 1, end: 1.5)
        )
        if animation {
            UIView.animate(withDuration: 0.3) {
                self.squareView.transform = t
            }
        } else {
            squareView.transform = t
        }
    }
    
    func valueAtPercentage(_ percentage: Double, start: Double, end: Double) -> Double {
        return start + (end - start) * percentage / 100
    }
}

