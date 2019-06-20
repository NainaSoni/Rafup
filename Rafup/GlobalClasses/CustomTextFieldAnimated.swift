//
//  CustomTextFieldAnimated.swift
//  CustomTextFieldAnimated
//
//  Created by Ashish on 20/07/15.
//  Copyright (c) 2015 Ashish. All rights reserved.
//
//  Objective-C version by Jared Verdi
//  https://github.com/jverdi/JVFloatLabeledTextField
//

import UIKit

open class CustomTextFieldAnimated: UITextField {
    
    let animationDuration = 0.3
    var title = UILabel()
    
    /*
     PickerView properties and date format
     */
    open var pickerArray:[String]    = [String]() //For pickerview items
    open var pickerSelectedIndex    = 0
    open var datePickerView         : UIDatePicker!
    open var pickerView             : UIPickerView!
    open var datePickerFormat:String = "MM/dd/yyyy"
    
    // Delegate for change value.
    open var changeValueDelegate:   CustomTextFieldDelegate?
    
    /*
     Edit Actions
     */
    open var isAllowedCopy: Bool   = true
    open var isAllowedPaste: Bool  = true
    
    // MARK:- Properties
    override open var accessibilityLabel:String? {
        get {
            if text!.isEmpty {
                return title.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    
    override open var placeholder:String? {
        didSet {
            title.text = placeholder
            title.sizeToFit()
        }
    }
    
    override open var attributedPlaceholder:NSAttributedString? {
        didSet {
            title.text = attributedPlaceholder?.string
            title.sizeToFit()
        }
    }
    
    var titleFont:UIFont = UIFont.systemFont(ofSize: 13.0) {
        didSet {
            title.font = titleFont
        }
    }
    
    //Placeholder padding Y
    @IBInspectable var hintYPadding:CGFloat = 0.0
    
    //Title padding Y
    @IBInspectable var titleYPadding:CGFloat = 0.0 {
        didSet {
            var r = title.frame
            r.origin.y = titleYPadding
            title.frame = r
        }
    }
    
    //Title Text Colour
    @IBInspectable var titleTextColour:UIColor = UIColor.gray {
        didSet {
            if !isFirstResponder {
                title.textColor = titleTextColour
            }
        }
    }
    
     //Title Active Text Colour
    @IBInspectable var titleActiveTextColour:UIColor! {
        didSet {
            if isFirstResponder {
                title.textColor = titleActiveTextColour
            }
        }
    }
    
    // MARK:- Init
    required public init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    // MARK:- Overrides
    override open func layoutSubviews() {
        super.layoutSubviews()
        setTitlePositionForTextAlignment()
        let isResp = isFirstResponder
        if isResp && !text!.isEmpty {
            title.textColor = titleActiveTextColour
        } else {
            title.textColor = titleTextColour
        }
        // Should we show or hide the title label?
        if text!.isEmpty {
            // Hide
            hideTitle(isResp)
        } else {
            // Show
            showTitle(isResp)
        }
    }
    
    // MARK:- Set TextField New Bounds
    override open func textRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.textRect(forBounds: bounds)
        if !text!.isEmpty {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
        }
        return r.integral
    }
    
    override open func editingRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.editingRect(forBounds: bounds)
        if !text!.isEmpty {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
        }
        return r.integral
    }
    
    override open func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.clearButtonRect(forBounds: bounds)
        if !text!.isEmpty {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
        }
        return r.integral
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)), !isAllowedCopy {
            return false
        } else if action == #selector(paste(_:)),!isAllowedPaste {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    // MARK:- Public Methods
    
    // MARK:- Private Methods
    fileprivate func setup() {
        borderStyle = UITextBorderStyle.none
        titleActiveTextColour = UIColor.gray
        // Set up title label
        title.alpha = 0.0
        title.font = titleFont
        title.textColor = titleTextColour
        if let str = placeholder {
            if !str.isEmpty {
                title.text = str
                title.sizeToFit()
            }
        }
        self.addSubview(title)
    }
    
    fileprivate func maxTopInset()->CGFloat {
        return max(0, floor(bounds.size.height - font!.lineHeight - 4.0))
    }
    
    fileprivate func setTitlePositionForTextAlignment() {
        let r = textRect(forBounds: bounds)
        var x = r.origin.x
        if textAlignment == NSTextAlignment.center {
            x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
        } else if textAlignment == NSTextAlignment.right {
            x = r.origin.x + r.size.width - title.frame.size.width
        }
        title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
    }
    
    fileprivate func showTitle(_ animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut], animations:{
            // Animation
            self.title.alpha = 1.0
            var r = self.title.frame
            r.origin.y = self.titleYPadding
            self.title.frame = r
            }, completion:nil)
    }
    
    fileprivate func hideTitle(_ animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn], animations:{
            // Animation
            self.title.alpha = 0.0
            var r = self.title.frame
            r.origin.y = self.title.font.lineHeight + self.hintYPadding
            self.title.frame = r
            }, completion:nil)
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
    
    // MARK:- HP - DatePicker
    
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
            //self.sizeToFit()
        }
    }
    
    @objc func updateTextField(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        //formatter.dateStyle = .ShortStyle
        self.text = formatter.string(from: sender.date)
    }
    
    @objc func inputAccessoryViewDidFinish(_ sender:UIBarButtonItem) {
        
        self.resignFirstResponder()
        
        if self.datePicker && self.text == "" {
            let formatter = DateFormatter()
            formatter.dateFormat = datePickerFormat
            self.text = formatter.string(from: self.datePickerView.date)
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
    
    // MARK:- HP - Line View
    
    @IBInspectable var linesWidth: CGFloat = 0.5 { didSet{ drawLines() } }
    
    @IBInspectable var linesColor: UIColor = UIColor.lightGray { didSet{ drawLines() } }
    
    @IBInspectable var leftLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var rightLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var bottomLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var topLine: Bool = false { didSet{ drawLines() } }
    
    fileprivate func drawLines() {
        
        if bottomLine {
            let border = CALayer()
            border.frame = CGRect(x: 0.0, y: frame.size.height - linesWidth, width: frame.size.width, height: linesWidth)
            border.backgroundColor = linesColor.cgColor
            layer.addSublayer(border)
        }
        
        if topLine {
            let border = CALayer()
            border.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: linesWidth)
            border.backgroundColor = linesColor.cgColor
            layer.addSublayer(border)
        }
        
        if rightLine {
            let border = CALayer()
            border.frame = CGRect(x: frame.size.width - linesWidth, y: 0.0, width: linesWidth, height: frame.size.height);
            border.backgroundColor = linesColor.cgColor
            layer.addSublayer(border)
        }
        
        if leftLine {
            let border = CALayer()
            border.frame = CGRect(x: 0.0, y: 0.0, width: linesWidth, height: frame.size.height);
            border.backgroundColor = linesColor.cgColor
            layer.addSublayer(border)
        }
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
        
    }
}

extension CustomTextFieldAnimated: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
