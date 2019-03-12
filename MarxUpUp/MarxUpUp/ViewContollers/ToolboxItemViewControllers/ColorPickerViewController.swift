//
//  ColorPickerViewController.swift
//  MarxUpUp
//
//  Created by Ognyanka Boneva on 13.11.18.
//  Copyright © 2018 Ognyanka Boneva. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var colorImageView: UIImageView!
    private var pickerImageView: UIImageView!
    private var finalColorImageView: UIImageView!

    private var blankSpacePath: UIBezierPath!
    private var finalColorPath: UIBezierPath!
    private var pickerPath: UIBezierPath!

    private var colorWheelCenter: CGPoint!
    private var colorWheelSize: CGFloat { return 20 }

    private var hue = CGFloat(0.75)
    private var saturation = CGFloat(1.0)
    private var brightness = CGFloat(1.0)
    private let alpha = CGFloat(1)
    private let defaultColorAttributeValue = CGFloat(1)
    private let colorSectors = CGFloat(360)

    let saturationSlider = UISlider()
    let brightnessSlider = UISlider()

    weak var toolboxItemDelegate: ToolboxItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        let defaultColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        let size = colorImageView.frame.size

        colorImageView.image = createColorWheelImage()
        pickerImageView = UIImageView(image: createPickerImage(withColor: defaultColor,
                                                               andSize: CGSize(width: colorWheelSize + 5,
                                                                               height: colorWheelSize + 5)))
        finalColorImageView = UIImageView(image: createFinalColorImage(withColor: defaultColor,
                                                                       andSize: CGSize(
                                                                        width: (size.width - colorWheelSize) / 2.5,
                                                                        height: (size.height - colorWheelSize) / 2.5)))

        colorImageView.addSubview(pickerImageView)
        colorImageView.addSubview(finalColorImageView)
        pickerImageView.center = CGPoint(x: size.width / 2, y: 5)
        finalColorImageView.center = CGPoint(x: size.width / 2, y: size.height / 2)

        addGestureRecognizers()
        configBrightnessSlider()
        configSaturationSlider()
    }

    private func addGestureRecognizers() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(withGestureRecognizer:)))
        panRecognizer.delegate = self
        colorImageView.addGestureRecognizer(panRecognizer)
        colorImageView.isUserInteractionEnabled = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(withGestureRecognizer:)))
        tapRecognizer.delegate = self
        finalColorImageView.addGestureRecognizer(tapRecognizer)
        finalColorImageView.isUserInteractionEnabled = true
    }

    // MARK: - Create color picker
    private func createColorWheelImage() -> UIImage {
        let size = colorImageView.frame.size
        UIGraphicsBeginImageContext(size)

        let radius = size.width / 2
        let angle  = 2 * Double.pi / Double(colorSectors)
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        colorWheelCenter = center

        var path: UIBezierPath
        for i in 0..<Int(colorSectors) {
            path = UIBezierPath(arcCenter: center, radius: radius,
                                startAngle: CGFloat(Double(i) * angle),
                                endAngle: CGFloat(Double(i + 1) * angle),
                                clockwise: true)
            path.addLine(to: center)
            path.close()
            fillAndStrokePath(path,
                              color: UIColor(hue: CGFloat(i) / colorSectors,
                                            saturation: defaultColorAttributeValue,
                                            brightness: defaultColorAttributeValue,
                                            alpha: defaultColorAttributeValue))
        }

        let innerBlanckSpace = UIBezierPath(ovalIn: CGRect(x: colorWheelSize / 2,
                                                           y: colorWheelSize / 2,
                                                           width: size.width - colorWheelSize,
                                                           height: size.height - colorWheelSize))

        fillAndStrokePath(innerBlanckSpace, color: UIColor.white)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()

        blankSpacePath = innerBlanckSpace
        return image
    }

    private func createPickerImage(withColor color: UIColor, andSize size: CGSize) -> UIImage {
        pickerPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return createImage(pickerPath, color, size)
    }

    private func createFinalColorImage(withColor color: UIColor, andSize size: CGSize) -> UIImage {
        finalColorPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return createImage(finalColorPath, color, size)
    }

    private func createImage(_ path: UIBezierPath, _ color: UIColor, _ size: CGSize) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        UIGraphicsBeginImageContext(size)
        fillAndStrokePath(path, color: color)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
                return UIImage()
        }
        return image
    }

    // MARK: - Render Bezier paths
    private func set(_ color: UIColor, toImageView imageView: UIImageView, withPath path: UIBezierPath) {
        guard let size = imageView.image?.size else {
            return
        }
        UIGraphicsBeginImageContext(size)
        fillAndStrokePath(path, color: color)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    private func fillAndStrokePath(_ path: UIBezierPath, color: UIColor) {
        color.setFill()
        color.setStroke()
        path.fill()
        path.stroke()
    }
}

// MARK: - Handle Tap and Pan gestures
extension ColorPickerViewController: UIGestureRecognizerDelegate {
    @objc func handlePan(withGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: colorImageView)

        guard !blankSpacePath.contains(point) else {
            return
        }

        let dx = point.x - colorWheelCenter.x
        let dy = point.y - colorWheelCenter.y

        hue = CGFloat(atan2(dy, dx)) / CGFloat((2 * Double.pi)) + 1

        let color = UIColor(hue: hue, saturation: defaultColorAttributeValue,
                            brightness: defaultColorAttributeValue, alpha: defaultColorAttributeValue)
        set(color, toImageView: finalColorImageView, withPath: finalColorPath)
        set(color, toImageView: pickerImageView, withPath: pickerPath)

        updateSliderColor()

        guard let diameter = colorImageView.image?.size.width else {
            return
        }

        let radius = diameter / 2
        let newX = (radius - 5) * cos(atan2(dy, dx)) + colorWheelCenter.x
        let newY = (radius - 5) * sin(atan2(dy, dx)) + colorWheelCenter.y
        pickerImageView.center = CGPoint(x: newX, y: newY)
    }

    @objc func handleTap(withGestureRecognizer recognizer: UITapGestureRecognizer) {
        toolboxItemDelegate?.didChooseColor(UIColor(hue: hue, saturation: saturation,
                                                    brightness: brightness, alpha: defaultColorAttributeValue))
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Saturation and Brightness Sliders Methods
extension ColorPickerViewController {
    private func configSaturationSlider() {
        setUpSlider(saturationSlider, withValue: Float(saturation), andAction: #selector(didChangeSaturationSlider))
        colorImageView.addSubview(saturationSlider)
        saturationSlider.center = CGPoint(x: colorWheelCenter.x, y: colorWheelCenter.y * 0.5)
    }

    private func configBrightnessSlider() {
        setUpSlider(brightnessSlider, withValue: Float(brightness), andAction: #selector(didChangeBrightnessSlider))
        colorImageView.addSubview(brightnessSlider)
        brightnessSlider.center = CGPoint(x: colorWheelCenter.x, y: colorWheelCenter.y * 1.5 + 2)
    }

    private func setUpSlider(_ slider: UISlider, withValue value: Float, andAction selector: Selector) {
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = value

        slider.addTarget(self, action: selector, for: UIControl.Event.allEvents)

        slider.tintColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        slider.thumbTintColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    private func updateSliderColor() {
        let saturationColor = UIColor(hue: hue, saturation: saturation,
                                      brightness: defaultColorAttributeValue, alpha: defaultColorAttributeValue)
        saturationSlider.thumbTintColor = saturationColor
        saturationSlider.tintColor = saturationColor

        let brightnessColor = UIColor(hue: hue, saturation: defaultColorAttributeValue,
                                      brightness: brightness, alpha: defaultColorAttributeValue)
        brightnessSlider.thumbTintColor = brightnessColor
        brightnessSlider.tintColor = brightnessColor
    }

    @objc private func didChangeBrightnessSlider() {
        brightness = CGFloat(brightnessSlider.value)
        brightnessSlider.thumbTintColor = UIColor(hue: hue, saturation: defaultColorAttributeValue,
                                                  brightness: brightness, alpha: defaultColorAttributeValue)
        set(UIColor(hue: hue, saturation: saturation,
                    brightness: brightness, alpha: defaultColorAttributeValue),
            toImageView: finalColorImageView, withPath: finalColorPath)
    }

    @objc private func didChangeSaturationSlider() {
        saturation = CGFloat(saturationSlider.value)
        saturationSlider.thumbTintColor = UIColor(hue: hue, saturation: saturation,
                                                  brightness: defaultColorAttributeValue,
                                                  alpha: defaultColorAttributeValue)
        set(UIColor(hue: hue, saturation: saturation,
                    brightness: brightness, alpha: defaultColorAttributeValue),
            toImageView: finalColorImageView, withPath: finalColorPath)
    }
}
