//
//  CustomTextField.swift
//  
//
//  Created by Ashish on 20/07/15.
//  Copyright (c) 2015 Ashish. All rights reserved.
//

import UIKit

// MARK: - Here is the protocol for textfield value change.
public protocol CustomTextFieldDelegate: class {
    func didChangeTextFieldValue(_ sender: CustomTextField)
    func didChangeTextFieldValue(_ sender: CustomTextFieldAnimated)
}


open class CustomTextField: UITextField {
    
    // MARK: - Properties
    fileprivate let borderTop = CALayer()
    fileprivate let borderLeft = CALayer()
    fileprivate let borderBottom = CALayer()
    fileprivate let borderRight = CALayer()
    
    /*
            Add Padding to textview
    */
    open var paddingTop:      CGFloat = 0
    open var paddingLeft:     CGFloat = 0
    open var paddingBottom:   CGFloat = 0
    open var paddingRight:    CGFloat = 0 //24 For cross button
    
    /*
        PickerView properties and date format
     */
    open var pickerArray:   [String] = [String]() //For pickerview items
    open var pickerSelectedIndex   = 0
    open var datePickerView  : UIDatePicker!
    open var pickerView  : UIPickerView!
    open var datePickerFormat:     String = "MM/dd/yyyy"
    
    /*
        Edit Actions
     */
    open var isAllowedCopy: Bool   = true
    open var isAllowedPaste: Bool  = true
    
    // Delegate for change value.
    open var changeValueDelegate:   CustomTextFieldDelegate?

    
    override open var borderWidth: CGFloat { // = 0
        didSet { layer.borderWidth = borderWidth }
    }
    
    override open var borderColor: UIColor? {
        didSet { layer.borderColor = borderColor?.cgColor }
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)), !isAllowedCopy {
            return false
        } else if action == #selector(paste(_:)),!isAllowedPaste {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    // MARK:- Set Placeholder Color
    open var placeholderColor: UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22) {
        didSet{ changeAttributedPlaceholderColor() }
    }

    fileprivate func changeAttributedPlaceholderColor() {
        
        if (self.attributedPlaceholder?.length != nil) {
            if self.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
                
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
            }
        }
    }
    
    // MARK:- Set Placeholder New Bounds
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    fileprivate func newBounds(_ bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += paddingLeft
        newBounds.origin.y += paddingTop
        newBounds.size.height -= paddingTop + paddingBottom
        newBounds.size.width -= paddingLeft + paddingRight
        return newBounds
    }
    
    // MARK:- Set Input Picker
    open var isDoneButton: Bool = false { didSet{ setDoneButton() } }
    fileprivate func setDoneButton() {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.black
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.inputAccessoryViewDidFinish(_:)))
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black], for: .normal)
        let items = [spaceButton, doneButton]
        toolbar.setItems(items, animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    // MARK:- Set Input Picker
    open var inputPicker: Bool = false { didSet{ setInputTyePicker() } }
    fileprivate func setInputTyePicker() {
        
        if inputPicker {
            pickerView = UIPickerView()
            self.inputView = pickerView
            self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
            pickerView.tag = self.tag
            self.isDoneButton = true
            
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    
    // MARK:- Set Time Picker
    open var timePicker: Bool = false { didSet{ setInputTypeTimePicker() } }
    fileprivate func setInputTypeTimePicker() {
        
        if timePicker {
            
            datePickerView  = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.time
            self.inputView = datePickerView
            datePickerView.tag = self.tag
            datePickerView.addTarget(self, action: #selector(self.updateTimeTextField(_:)), for: UIControlEvents.valueChanged)
            
            self.isDoneButton = true
        }
    }
    
     // MARK:- TextFiled Value Change Methods.
    @objc func textFieldDidChange(_ textField: CustomTextField) {
        changeValueDelegate?.didChangeTextFieldValue(self)
        if pickerArray.count > pickerView.selectedRow(inComponent: 0) {
            self.text = pickerArray[pickerView.selectedRow(inComponent: 0)]
            self.placeholder = ""
           // self.sizeToFit()
        }
        
    }
    
    @objc func updateTimeTextField(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        self.text = formatter.string(from: sender.date)
        
        changeValueDelegate?.didChangeTextFieldValue(self)
    }
    
    @objc func updateDateTextField(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = datePickerFormat
        //formatter.dateStyle = .ShortStyle
        self.text = formatter.string(from: sender.date)
        
        changeValueDelegate?.didChangeTextFieldValue(self)
    }
    
    @objc func inputAccessoryViewDidFinish(_ sender:AnyObject) {
        
        self.resignFirstResponder()
        
        if self.datePicker && self.text == "" {
            let formatter = DateFormatter()
            formatter.dateFormat = datePickerFormat
            self.text = formatter.string(from: self.datePickerView.date)
        }
    }

    // MARK:- Set Date Picker
    open var datePicker: Bool = false { didSet{ setInputTyeDatePicker() } }
    fileprivate func setInputTyeDatePicker() {
        
        if datePicker {
            
            datePickerView = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            //let currentDate: Date = Date()
            
            //for maximumDate components
            //let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
            //let components: NSDateComponents = NSDateComponents()
            //components.calendar = calendar
            //components.year = -18
            //let minDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: nil)!
            //components.year = 0
            //let maxDate: NSDate = calendar.dateByAddingComponents(components, toDate: currentDate, options: nil)!
            
            //datePickerView.minimumDate = currentDate

            self.inputView = datePickerView
            datePickerView.tag = self.tag
            datePickerView.addTarget(self, action: #selector(self.updateDateTextField(_:)), for: UIControlEvents.valueChanged)
            
            self.isDoneButton = true
        }
    }
    
    // MARK:- Set Line View
    
    // Set Lines in UITextField like Material design in Android
    
    open var linesWidth: CGFloat = 0.5 { didSet{ drawLines() } }
    open var linesColor: UIColor = UIColor.lightGray { didSet{ drawLines() } }
    
    open var leftLine: Bool   = false { didSet{ drawLines() } }
    open var rightLine: Bool  = false { didSet{ drawLines() } }
    open var bottomLine: Bool = false { didSet{ drawLines() } }
    open var topLine: Bool    = false { didSet{ drawLines() } }
    
    
    fileprivate func drawLines() {
        
        if bottomLine {
            //let border = CALayer()
            borderBottom.frame = CGRect(x: 0.0, y: frame.size.height - linesWidth, width: frame.size.width, height: linesWidth)
            borderBottom.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderBottom)
        }
        
        if topLine {
            //let border = CALayer()
            borderTop.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: linesWidth)
            borderTop.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderTop)
        }
        
        if rightLine {
            //let border = CALayer()
            borderRight.frame = CGRect(x: frame.size.width - linesWidth, y: 0.0, width: linesWidth, height: frame.size.height);
            borderRight.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderRight)
        }
        
        if leftLine {
            //let border = CALayer()
            borderLeft.frame = CGRect(x: 0.0, y: 0.0, width: linesWidth, height: frame.size.height);
            borderLeft.backgroundColor = linesColor.cgColor
            layer.addSublayer(borderLeft)
        }
    }
    
}

public extension CustomTextField {
    
    public func updateAppearance(with color: UIColor? = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)) {
        
        self.bottomLine = true
        self.linesWidth = 1.0
        self.linesColor = color!
        //self.placeholderColor = color!
        //self.paddingLeft = 10
        self.paddingRight = 0
    }
    
//    public func setPalceHolderColour(colour:UIColor) {
//        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: colour])
//    }
    
    public func setPalceHolderFont(font:Font, size:CGFloat, colour: UIColor = UIColor.lightGray) {
        let attributes = [
            NSAttributedStringKey.foregroundColor: colour,
            NSAttributedStringKey.font : UIFont(name: font.rawValue, size: size)! // Note the !
        ]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:attributes)
    }
    
    public func setLeftView(of image: UIImage!) {
        
        //setting left image
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let paddingImage = UIImageView()
        paddingImage.image = image
        paddingImage.contentMode = .scaleAspectFit
        paddingImage.frame = CGRect(x: 15, y: 0, width: 23, height: 40)
        paddingView.addSubview(paddingImage)
        self.leftView = paddingView
        self.leftView?.isUserInteractionEnabled = false
        self.leftViewMode = UITextFieldViewMode.always
        
        self.paddingLeft = paddingView.width + 10
    }

    
    public func setRightViewImage(_ textFieldImg: UIImage!) {
        
        //setting right image
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let paddingImage = UIImageView()
        paddingImage.contentMode = .scaleAspectFit
        paddingImage.image = textFieldImg
        paddingImage.frame = CGRect(x: 12, y: 12, width: 16, height: 16)
        paddingView.addSubview(paddingImage)
        self.rightView = paddingView
        self.rightView?.isUserInteractionEnabled = false
        self.rightViewMode = UITextFieldViewMode.always
        
        self.paddingRight = paddingView.width + 10
    }
}

extension CustomTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelectedIndex = row
        if pickerArray.count > row {
            self.text = pickerArray[row]
        }
    }
}
