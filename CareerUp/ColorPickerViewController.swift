//
//  ColorPickerViewController.swift
//  CareerUp
//
//  Created by Adam Emery on 10/24/14.
//  Copyright (c) 2014 Adam Emery. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController, UITextFieldDelegate {
    var colorButton = UIButton()
    
    @IBOutlet var redSlider:UISlider?
    @IBOutlet var greenSlider:UISlider?
    @IBOutlet var blueSlider:UISlider?
    @IBOutlet var alphaSlider:UISlider?
    
    @IBOutlet var redField:UITextField?
    @IBOutlet var greenField:UITextField?
    @IBOutlet var blueField:UITextField?
    @IBOutlet var alphaField:UITextField?
    
    @IBOutlet var colorField:UITextField?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        redField?.delegate = self
        greenField?.delegate = self
        blueField?.delegate = self
        alphaField?.delegate = self

        colorField?.backgroundColor = colorButton.backgroundColor
        let colorIn = Color()
        colorIn.convert(colorField!.backgroundColor!)
    
        let redFloat = Float(colorIn.red * 255.0)
        let greenFloat = Float(colorIn.green * 255.0)
        let blueFloat = Float(colorIn.blue * 255.0)
        let alphaFloat = Float(colorIn.alpha * 255.0)

        redSlider?.setValue(redFloat, animated: false)
        greenSlider?.setValue(greenFloat, animated: false)
        blueSlider?.setValue(blueFloat, animated: false)
        alphaSlider?.setValue(alphaFloat, animated: false)

        redField?.text = "\(Int(redFloat))"
        greenField?.text = "\(Int(greenFloat))"
        blueField?.text = "\(Int(blueFloat))"
        alphaField?.text = "\(Int(alphaFloat))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func redSliderChanged(slider:UISlider){
        colorField?.backgroundColor = UIColor.redColor()
        
        let value = Int(slider.value)
        redField?.text = "\(value)"
        setColorField()
    }
    
    @IBAction func greenSliderChanged(slider:UISlider){
        colorField?.backgroundColor = UIColor.greenColor()
        
        let value = Int(slider.value)
        greenField?.text = "\(value)"
        setColorField()
    }
    
    
    @IBAction func blueSliderChanged(slider:UISlider){
        colorField?.backgroundColor = UIColor.blueColor()
        
        let value = Int(slider.value)
        blueField?.text = "\(value)"
        setColorField()
    }
    
    @IBAction func alphaSliderChanged(slider:UISlider){
        colorField?.backgroundColor = UIColor.clearColor()
        
        let value = Int(slider.value)
        alphaField?.text = "\(value)"
        setColorField()
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textString = textField.text
        
        let startIndex = textString.startIndex
        let rangeStartIndex = advance(startIndex, range.location)
        let rangeEndIndex = advance(rangeStartIndex, range.length)
        
        let swiftRange: Range<String.Index> = Range<String.Index>(start: rangeStartIndex, end: rangeEndIndex)
        
        var newString = textString.stringByReplacingCharactersInRange(swiftRange, withString: string)
        
        if newString.isEmpty {
            newString = "0"
        }
        
        let stringValue = newString.toInt()
        
        if stringValue < 255 && stringValue != nil{
            switch textField {
                case redField!:
                    redSlider?.setValue(Float(stringValue!), animated: true)
                case greenField!:
                    greenSlider?.setValue(Float(stringValue!), animated: true)
                case blueField!:
                    blueSlider?.setValue(Float(stringValue!), animated: true)
                case alphaField!:
                    alphaSlider?.setValue(Float(stringValue!), animated: true)
                default:
                    println("field unknown")
            }
            
            textField.text = "\(stringValue!)"
            setColorField()
        }
        return false
    }

    func setColorField(){
        let red:CGFloat = CGFloat(redSlider!.value) / 255.0
        let green:CGFloat = CGFloat(greenSlider!.value) / 255.0
        let blue:CGFloat = CGFloat(blueSlider!.value) / 255.0
        let alpha:CGFloat = CGFloat(alphaSlider!.value) / 255.0
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        colorField?.backgroundColor = color
    }
    
    @IBAction func apply(){
        self.colorButton.backgroundColor =  colorField?.backgroundColor
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
