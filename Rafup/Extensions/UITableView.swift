//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//


import UIKit

public extension UITableView {
    
    /// MARK:- Index path of last row in tableView.
    public var indexPathForLastRow: IndexPath? {
        return indexPathForLastRow(inSection: lastSection)
    }
    
    /// MARK:- Index of last section in tableView.
    public var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
    
    public func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    public func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    public func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    public func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    /**
     Displays or hides a label in the background of the table view.
     
     - parameter message:    The String message to display. The message is hidden
     if `nil` is provided.
     */
    public func setBackgroundMessage(_ message: String?, color: UIColor? = UIColor.lightGray) {
        if let message = message {
            // Display a message when the table is empty
            let messageLabel = UILabel()
            messageLabel.text = message
            //messageLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            messageLabel.textColor = color
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            
            self.backgroundView = messageLabel
            self.separatorStyle = .none
        } else {
            self.backgroundView = nil
            self.separatorStyle = .singleLine
        }
    }
    
    /*func scrollToSelectedRow() {
     let selectedRows = self.indexPathsForSelectedRows
     if let selectedRow = selectedRows?[0] as? NSIndexPath {
     self.scrollToRowAtIndexPath(selectedRow, atScrollPosition: .Middle, animated: true)
     }
     }*/
    
    func scrollToFirstRow(_ animated: Bool? = false) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfRows = self.numberOfRows(inSection: 0)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated!)
            }
        })
    }

    func scrollToHeader() {
        self.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    
    func scrollToTop(_ animated: Bool? = false) {
        DispatchQueue.main.async(execute: {
            self.setContentOffset(CGPoint.zero, animated: animated!)
        })
    }
    
    func scrollToBottom(_ animated: Bool = false) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
        })
    }
}

public extension UITableViewCell {
    
    public func removeMargins() {
        
        if self.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            self.separatorInset = UIEdgeInsets.zero
        }
        
        if self.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            self.preservesSuperviewLayoutMargins = false
        }
        
        if self.responds(to: #selector(setter: UIView.layoutMargins)) {
            self.layoutMargins = UIEdgeInsets.zero
        }
    }
}

public extension UICollectionView {
    
    public func setBackgroundMessage(_ message: String?) {
        if let message = message {
            // Display a message when the table is empty
            let messageLabel = UILabel()
            messageLabel.text = message
            //messageLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            messageLabel.font = UIFont.systemFont(ofSize: 14)
            messageLabel.textColor = UIColor.gray
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.sizeToFit()
            
            self.backgroundView = messageLabel
        } else {
            self.backgroundView = nil
        }
    }
    
    public func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func scrollToTop(_ animated: Bool? = false) {
        self.setContentOffset(CGPoint.zero, animated: animated!)
    }
    
    func scrollToBottom(_ animated: Bool = false) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let lastSection = self.numberOfSections - 1
            _ = self.numberOfSections
            let numberOfRows = self.numberOfItems(inSection: lastSection)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: lastSection)
                self.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: animated)
            }
        })
        
//        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
//        setContentOffset(bottomOffset, animated: animated)
    }
    
    // MARK:- Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    public func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
}

// MARK:- Methods
public extension UITableView {
    
    // MARK:- Number of all rows in all sections of tableView.
    ///
    /// - Returns: The count of all rows in the tableView.
    public func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
    
    // MARK:- IndexPath for last row in section.
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    public func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard section >= 0 else { return nil }
        guard numberOfRows(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }
    
    // MARK:- Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    public func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    // MARK:- Remove TableFooterView.
    public func removeTableFooterView() {
        tableFooterView = nil
    }
    
    // MARK:- Remove TableHeaderView.
    public func removeTableHeaderView() {
        tableHeaderView = nil
    }
}

/*
extension UITableView {
    
    // MARK:- Dequeue reusable UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    /// - Returns: UITableViewCell object with associated class name (optional value)
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: name)) as? T
    }
    
    // MARK:- Dequeue reusable UITableViewCell using class name for indexPath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    public func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T
    }
    
    // MARK:- Dequeue reusable UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    /// - Returns: UITableViewHeaderFooterView object with associated class name (optional value)
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T
    }
    
    // MARK:- Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the header or footer view.
    ///   - name: UITableViewHeaderFooterView type.
    public func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    // MARK:- Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    public func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    // MARK:- Register UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    public func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    // MARK:- Register UITableViewCell using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the tableView cell.
    ///   - name: UITableViewCell type.
    public func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    // MARK:- Register UITableViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    public func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle? = nil
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        
        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
    
}
 */


