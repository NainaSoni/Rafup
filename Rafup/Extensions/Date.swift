//
//  Date.swift
//  Truxx
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import Foundation

public extension Date {
    
    //    How to get 12 hour format time string when system is set to use 24 hour format
    //    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "hh:mm a", options: 0, locale: NSLocale.current)
    // https://stackoverflow.com/questions/6247790/how-to-get-12-hour-format-time-string-when-system-is-set-to-use-24-hour-format
    
    //
    // MARK:- Get system time format as 12 or 24 hours
    //
    var isSystem12HourFormat:Bool {
        let locale = NSLocale.current
        if let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale), formatter.contains("a") {
            //phone is set to 12 hours
            return true
        } else {
            //phone is set to 24 hours
            return false
        }
    }
    
    //
    // MARK:- today
    //
    public static func today() -> Date? {
        
        // *** Create date ***
        let date = Date()
        
        // *** Get components using current Local & Timezone ***
        let components = Constants.kCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        return Constants.kCalendar.date(from: components)
    }
    
    //
    // MARK:- to string
    //
    
    public var sun:     String { get { return convertToString(dateformat: "EEE")       } }
    public var sunday:  String { get { return convertToString(dateformat: "EEEE")      } }
    public var jan:     String { get { return convertToString(dateformat: "MMM")       } }
    public var january: String { get { return convertToString(dateformat: "MMMM")      } }
    public var monJan1: String { get { return convertToString(dateformat: "EEE MMM d") } }
    public var monJan01: String { get { return convertToString(dateformat: "EEE MMM dd") } }
    
    //
    // MARK:- yesterday/tomorrow
    //
    
    public var yesterday: Date { get { return self - 1 } }
    public var tomorrow:  Date { get { return self + 1 } }
    
    //
    // MARK:- components
    //
    
    public var year:    Int { get { return Constants.kCalendar.dateComponents([.year], from: self).year! } }
    public var month:   Int { get { return Constants.kCalendar.dateComponents([.month], from: self).month! } }
    public var day:     Int { get { return Constants.kCalendar.dateComponents([.day], from: self).day! } }
    public var weekday: Int { get { return Constants.kCalendar.dateComponents([.weekday], from: self).weekday! } }
    
    public var daysInMonth: Int {
        get {
            return (Constants.kCalendar as NSCalendar).range(of: [NSCalendar.Unit.day], in: [NSCalendar.Unit.month], for: self).length
        }
    }
    
    //
    // MARK:- month math
    //
    
    public func subtractMonths(_ rhs: Date) -> Int {
        return (year * 12 + month) - (rhs.year * 12 + rhs.month)
    }
    
    //
    // MARK:- with
    //
    
    public func withDay(_ day: Int) -> Date {
        var components = (Constants.kCalendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month], from: self)
        components.day = day
        return Constants.kCalendar.date(from: components)!
    }
    public func withMonth(_ month: Int) -> Date {
        var components = (Constants.kCalendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.day], from: self)
        components.month = month
        return Constants.kCalendar.date(from: components)!
    }
    public func withYear(_ year: Int) -> Date {
        var components = (Constants.kCalendar as NSCalendar).components([NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
        components.year = year
        return Constants.kCalendar.date(from: components)!
    }
    
    var is18yearsOld:Bool {
        return Date().yearsFrom(self) > 18
    }
    
    func yearsFrom(_ date:Date)   -> Int { return (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: date, to: self, options: []).year! }

    
    /// Convert Date to String
    public func convertToString(dateformat format: String) -> String {
        
        //let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format //"yyyy-MM-dd HH:mm:ss.SSS"//2014-09-23 15:15:28.252
        let defaultTimeZoneStr = formatter.string(from: self)
        
        return defaultTimeZoneStr
    }
    
    func components(_ unitFlags: NSCalendar.Unit) -> DateComponents {
        return (Constants.kCalendar as NSCalendar).components(unitFlags, from: self)
    }
    
    // MARK: Internal Components
    
    internal static func componentFlags() -> Set<Calendar.Component> { return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear] }
    
    internal static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
    
    // MARK:- Convert to String
    
    
    /// Converts the date to string using the short date and time style.
    func toString(style:DateStyleType = .short) -> String {
        switch style {
        case .short:
            return self.toString(dateStyle: .short, timeStyle: .short, isRelative: false)
        case .medium:
            return self.toString(dateStyle: .medium, timeStyle: .medium, isRelative: false)
        case .long:
            return self.toString(dateStyle: .long, timeStyle: .long, isRelative: false)
        case .full:
            return self.toString(dateStyle: .full, timeStyle: .full, isRelative: false)
        case .ordinalDay:
            let formatter = Date.cachedOrdinalNumberFormatter
            if #available(iOSApplicationExtension 9.0, *) {
                formatter.numberStyle = .ordinal
            }
            return formatter.string(from: component(.day)! as NSNumber)!
        case .weekday:
            let weekdaySymbols = Date.cachedFormatter().weekdaySymbols!
            let string = weekdaySymbols[component(.weekday)!-1] as String
            return string
        case .shortWeekday:
            let shortWeekdaySymbols = Date.cachedFormatter().shortWeekdaySymbols!
            return shortWeekdaySymbols[component(.weekday)!-1] as String
        case .veryShortWeekday:
            let veryShortWeekdaySymbols = Date.cachedFormatter().veryShortWeekdaySymbols!
            return veryShortWeekdaySymbols[component(.weekday)!-1] as String
        case .month:
            let monthSymbols = Date.cachedFormatter().monthSymbols!
            return monthSymbols[component(.month)!-1] as String
        case .shortMonth:
            let shortMonthSymbols = Date.cachedFormatter().shortMonthSymbols!
            return shortMonthSymbols[component(.month)!-1] as String
        case .veryShortMonth:
            let veryShortMonthSymbols = Date.cachedFormatter().veryShortMonthSymbols!
            return veryShortMonthSymbols[component(.month)!-1] as String
        }
    }
    
    /// Converts the date to string based on DateFormatter's date style and time style with optional relative date formatting, optional time zone and optional locale.
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, isRelative: Bool = false, timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local, locale: Locale = Locale.current) -> String {
        let formatter = Date.cachedFormatter(dateStyle, timeStyle: timeStyle, doesRelativeDateFormatting: isRelative, timeZone: timeZone, locale: locale)
        return formatter.string(from: self)
    }
    
    /**
     Convert the date format.
     
     - Parameters:
        - string:       The date string.
        - forFormat:    The date string Formate.
        - toFormat:     Converted Formate.
     
     - Returns: A new converted Date and String.
     */
    public static func convert(from dateString: String, forFormat: String? = "yyyy-MM-dd HH:mm:ss", toFormat: String? = "yyyy-MM-dd HH:mm:ss") -> (date: Date?, string: String?) {
        
        let dateMakerFormatter = DateFormatter()
        dateMakerFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        //dateMakerFormatter.timeZone = TimeZone(identifier: "UTC") //for GMT Time

        dateMakerFormatter.dateFormat = forFormat
        guard let date = dateMakerFormatter.date(from: dateString) else {
            return (nil, nil)
        }
        dateMakerFormatter.dateFormat = toFormat
        let toDateString = dateMakerFormatter.string(from: date)
        
        return (date, toDateString)
    }
    
    // MARK:- Convert from String
    
    /*
     Initializes a new Date() objext based on a date string, format, optional timezone and optional locale.
     
     - Returns: A Date() object if successfully converted from string or nil.
     */
    init?(fromString string: String, format:DateFormatType, timeZone: TimeZoneType = .local, locale: Locale = Foundation.Locale.current) {
        guard !string.isEmpty else {
            return nil
        }
        var string = string
        switch format {
        case .dotNet:
            let pattern = "\\\\?/Date\\((\\d+)(([+-]\\d{2})(\\d{2}))?\\)\\\\?/"
            let regex = try! NSRegularExpression(pattern: pattern)
            guard let match = regex.firstMatch(in: string, range: NSRange(location: 0, length: string.utf16.count)) else {
                return nil
            }
            #if swift(>=4.0)
                let dateString = (string as NSString).substring(with: match.range(at: 1))
            #else
                let dateString = (string as NSString).substring(with: match.rangeAt(1))
            #endif
            let interval = Double(dateString)! / 1000.0
            self.init(timeIntervalSince1970: interval)
            return
        case .rss, .altRSS:
            if string.hasSuffix("Z") {
                string = string[..<string.index(string.endIndex, offsetBy: -1)].appending("GMT")
            }
        default:
            break
        }
        let formatter = Date.cachedFormatter(format.stringFormat, timeZone: timeZone.timeZone, locale: locale)
        guard let date = formatter.date(from: string) else {
            return nil
        }
        self.init(timeInterval:0, since:date)
    }
    
    // MARK:- Static Cached Formatters
    
    /// A cached static array of DateFormatters so that thy are only created once.
    private static var cachedDateFormatters = [String: DateFormatter]()
    private static var cachedOrdinalNumberFormatter = NumberFormatter()
    
    /// Generates a cached formatter based on the specified format, timeZone and locale. Formatters are cached in a singleton array using hashkeys.
    private static func cachedFormatter(_ format:String = DateFormatType.standard.stringFormat, timeZone: Foundation.TimeZone = Foundation.TimeZone.current, locale: Locale = Locale.current) -> DateFormatter {
        let hashKey = "\(format.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if Date.cachedDateFormatters[hashKey] == nil {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatter.isLenient = true
            Date.cachedDateFormatters[hashKey] = formatter
        }
        return Date.cachedDateFormatters[hashKey]!
    }
    
    /// Generates a cached formatter based on the provided date style, time style and relative date. Formatters are cached in a singleton array using hashkeys.
    private static func cachedFormatter(_ dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, doesRelativeDateFormatting: Bool, timeZone: Foundation.TimeZone = Foundation.NSTimeZone.local, locale: Locale = Locale.current) -> DateFormatter {
        let hashKey = "\(dateStyle.hashValue)\(timeStyle.hashValue)\(doesRelativeDateFormatting.hashValue)\(timeZone.hashValue)\(locale.hashValue)"
        if Date.cachedDateFormatters[hashKey] == nil {
            let formatter = DateFormatter()
            formatter.dateStyle = dateStyle
            formatter.timeStyle = timeStyle
            formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
            formatter.timeZone = timeZone
            formatter.locale = locale
            formatter.isLenient = true
            Date.cachedDateFormatters[hashKey] = formatter
        }
        return Date.cachedDateFormatters[hashKey]!
    }
    
    // MARK:- Extracting components
    
    func component(_ component:DateComponentType) -> Int? {
        let components = Date.components(self)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .nthWeekday:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    
    // The date components available to be retrieved or modifed
    public enum DateComponentType {
        case second, minute, hour, day, weekday, nthWeekday, week, month, year
    }
    

    
    // The type of date that can be used for the dateFor function.
    public enum DateForType {
        case startOfDay, endOfDay, startOfWeek, endOfWeek, startOfMonth, endOfMonth, tomorrow, yesterday, nearestMinute(minute:Int), nearestHour(hour:Int)
    }
    
    // Convenience types for date to string conversion
    public enum DateStyleType {
        /// Short style: "2/27/17, 2:22 PM"
        case short
        /// Medium style: "Feb 27, 2017, 2:22:06 PM"
        case medium
        /// Long style: "February 27, 2017 at 2:22:06 PM EST"
        case long
        /// Full style: "Monday, February 27, 2017 at 2:22:06 PM Eastern Standard Time"
        case full
        /// Ordinal day: "27th"
        case ordinalDay
        /// Weekday: "Monday"
        case weekday
        /// Short week day: "Mon"
        case shortWeekday
        /// Very short weekday: "M"
        case veryShortWeekday
        /// Month: "February"
        case month
        /// Short month: "Feb"
        case shortMonth
        /// Very short month: "F"
        case veryShortMonth
    }
    
    public enum DateFormatType {
        
        /// The ISO8601 formatted year "yyyy" i.e. 1997
        case isoYear
        
        /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
        case isoYearMonth
        
        /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
        case isoDate
        
        /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
        case isoDateTime
        
        /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
        case isoDateTimeSec
        
        /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
        case isoDateTimeMilliSec
        
        /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
        case dotNet
        
        /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
        case rss
        
        /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
        case altRSS
        
        /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
        case httpHeader
        
        /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
        case standard
        
        /// A custom date format string
        case custom(String)
        
        var stringFormat:String {
            switch self {
            case .isoYear: return "yyyy"
            case .isoYearMonth: return "yyyy-MM"
            case .isoDate: return "yyyy-MM-dd"
            case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
            case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            case .dotNet: return "/Date(%d%f)/"
            case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
            case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
            case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
            case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
            case .custom(let customFormat): return customFormat
            }
        }
    }
    
    /// The time zone to be used for date conversion
    public enum TimeZoneType {
        case local, utc
        var timeZone:TimeZone {
            switch self {
            case .local: return NSTimeZone.local
            case .utc: return TimeZone(secondsFromGMT: 0)!
            }
        }
    }

    
    /*
     // How to work with dates and times : DateFormatter
     www.globalnerdy.com/2016/08/22/how-to-work-with-dates-and-times-in-swift-3-part-2-dateformatter/
     
     - Examples: String for format:
     - convert(from: "Tue Nov 29 at 01:00 PM", forFormat: "E MMM dd' at 'hh:mm a")
     - convert(from: "28 November, 2016 at 06:30 PM", forFormat: "dd MMMM, yyyy' at 'hh:mm a", toFormat: "EEEE, MMMM dd, yyyy' at 'h:mm a.")
 
     If dateStyle and timeStyle are both set to…	the date formatter’s output looks like…
     NoStyle
     ShortStyle	1/27/10, 1:00 PM
     MediumStyle	Jan 27, 2010, 1:00:00 PM
     LongStyle	January 27, 2010 at 1:00:00 PM EST
     FullStyle	Wednesday, January 27, 2010 at 1:00:00 PM Eastern Standard Time
    
    'Year: 'y' Month: 'M' Day: 'd	Year: 2007 Month: 1 Day: 9
    MM/dd/yy	01/09/07
    MMM dd, yyyy	Jan 09, 2007
    E MMM dd, yyyy	Tue Jan 09, 2007
    EEEE, MMMM dd, yyyy' at 'h:mm a.	Tuesday, January 09, 2007 at 10:00 AM.
    EEEE, MMMM dd, yyyy' at 'h:mm a zzzz.	Tuesday, January 09, 2007 at 10:00 AM Pacific Standard Time.
 
 */
}


//
// MARK:- date/month math
//

public func +(l: Date, r: DateComponents) -> Date {
    return (Constants.kCalendar as NSCalendar).date(byAdding: r, to: l, options: [])!
}

public func  +(l: Date, r: Int) -> Date { return l + DateComponents(day:    r) }
public func  -(l: Date, r: Int) -> Date { return l + DateComponents(day:   -r) }
public func >>(l: Date, r: Int) -> Date { return l + DateComponents(month:  r) }
public func <<(l: Date, r: Int) -> Date { return l + DateComponents(month: -r) }

public func  +=(l: inout Date, r: Int) { l = l +  r }
public func  -=(l: inout Date, r: Int) { l = l -  r }
public func >>=(l: inout Date, r: Int) { l = l >> r }
public func <<=(l: inout Date, r: Int) { l = l << r }

public prefix func ++(l: inout Date) -> Date {
    l += 1
    return l
}
public postfix func ++(l: inout Date) -> Date {
    let old = l
    l += 1
    return old
}

public func -(l: Date, r: Date) -> Int {
    let components = (Constants.kCalendar as NSCalendar).components([NSCalendar.Unit.day], from: r, to: l, options: [])
    return components.day!
}

//
// MARK:- DateComponents
//

extension DateComponents {
    
    init(day: Int) {
        self.init()
        self.day = day
    }
    init(month: Int) {
        self.init()
        self.month = month
    }
}

extension TimeInterval {
    
    public static func getTimeString(from interval: TimeInterval) -> String {
        
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

}

extension Date {
    
    func weekTimeAgo() -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: Double(self.timeIntervalSince1970))
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            return self.convertToString(dateformat: "EEEE")
        }
    }
}

extension Date {
    
    func timeAgo(showNumeric:Bool = true) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(self)
        let latest = (earliest == now as Date) ? self : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (showNumeric){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (showNumeric){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (showNumeric){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (showNumeric){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (showNumeric){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (showNumeric){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    static var UTCDate: Date {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString  = dateFormatter.string(from: date)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let requiredDate = dateFormatter.date(from: dateString)
        return requiredDate!
    }
    static var timestamp: String {
        return "\(Date().millisecondsSince1970)"
    }
    static var UTCTimestamp: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString  = dateFormatter.string(from: date)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let requiredDate = dateFormatter.date(from: dateString)
        return "\(requiredDate!.millisecondsSince1970)"
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

extension Date {
    
    // The type of comparison to do against today's date or with the suplied date.
    public enum DateComparisonType {
        
        // Days
        
        /// Checks if date today.
        case isToday
        /// Checks if date is tomorrow.
        case isTomorrow
        /// Checks if date is yesterday.
        case isYesterday
        /// Compares date days
        case isSameDay(as:Date)
        
        // Weeks
        
        /// Checks if date is in this week.
        case isThisWeek
        /// Checks if date is in next week.
        case isNextWeek
        /// Checks if date is in last week.
        case isLastWeek
        /// Compares date weeks
        case isSameWeek(as:Date)
        
        // Months
        
        /// Checks if date is in this month.
        case isThisMonth
        /// Checks if date is in next month.
        case isNextMonth
        /// Checks if date is in last month.
        case isLastMonth
        /// Compares date months
        case isSameMonth(as:Date)
        
        // Years
        
        /// Checks if date is in this year.
        case isThisYear
        /// Checks if date is in next year.
        case isNextYear
        /// Checks if date is in last year.
        case isLastYear
        /// Compare date years
        case isSameYear(as:Date)
        
        // Relative Time
        
        /// Checks if it's a future date
        case isInTheFuture
        /// Checks if the date has passed
        case isInThePast
        /// Checks if earlier than date
        case isEarlier(than:Date)
        /// Checks if later than date
        case isLater(than:Date)
        /// Checks if it's a weekday
        case isWeekday
        /// Checks if it's a weekend
        case isWeekend
        
    }
    
    // MARK: Intervals In Seconds
    internal static let minuteInSeconds:Double = 60
    internal static let hourInSeconds:Double = 3600
    internal static let dayInSeconds:Double = 86400
    internal static let weekInSeconds:Double = 604800
    internal static let yearInSeconds:Double = 31556926
    
    // MARK:- Compare Dates
    
    /// Compares dates to see if they are equal while ignoring time.
    func compare(_ comparison:DateComparisonType) -> Bool {
        switch comparison {
        case .isToday:
            return compare(.isSameDay(as: Date()))
        case .isTomorrow:
            let comparison = Date().adjust(.day, offset:1)
            return compare(.isSameDay(as: comparison))
        case .isYesterday:
            let comparison = Date().adjust(.day, offset: -1)
            return compare(.isSameDay(as: comparison))
        case .isSameDay(let date):
            return component(.year) == date.component(.year)
                && component(.month) == date.component(.month)
                && component(.day) == date.component(.day)
        case .isThisWeek:
            return self.compare(.isSameWeek(as: Date()))
        case .isNextWeek:
            let comparison = Date().adjust(.week, offset:1)
            return compare(.isSameWeek(as: comparison))
        case .isLastWeek:
            let comparison = Date().adjust(.week, offset:-1)
            return compare(.isSameWeek(as: comparison))
        case .isSameWeek(let date):
            if component(.week) != date.component(.week) {
                return false
            }
            // Ensure time interval is under 1 week
            return abs(self.timeIntervalSince(date)) < Date.weekInSeconds
        case .isThisMonth:
            return self.compare(.isSameMonth(as: Date()))
        case .isNextMonth:
            let comparison = Date().adjust(.month, offset:1)
            return compare(.isSameMonth(as: comparison))
        case .isLastMonth:
            let comparison = Date().adjust(.month, offset:-1)
            return compare(.isSameMonth(as: comparison))
        case .isSameMonth(let date):
            return component(.year) == date.component(.year) && component(.month) == date.component(.month)
        case .isThisYear:
            return self.compare(.isSameYear(as: Date()))
        case .isNextYear:
            let comparison = Date().adjust(.year, offset:1)
            return compare(.isSameYear(as: comparison))
        case .isLastYear:
            let comparison = Date().adjust(.year, offset:-1)
            return compare(.isSameYear(as: comparison))
        case .isSameYear(let date):
            return component(.year) == date.component(.year)
        case .isInTheFuture:
            return self.compare(.isLater(than: Date()))
        case .isInThePast:
            return self.compare(.isEarlier(than: Date()))
        case .isEarlier(let date):
            return (self as NSDate).earlierDate(date) == self
        case .isLater(let date):
            return (self as NSDate).laterDate(date) == self
        case .isWeekday:
            return !compare(.isWeekend)
        case .isWeekend:
            let range = Calendar.current.maximumRange(of: Calendar.Component.weekday)!
            return (component(.weekday) == range.lowerBound || component(.weekday) == range.upperBound - range.lowerBound)
        }
        
    }
    
    // MARK:- Adjust dates
    
    /// Creates a new date with adjusted components
    
    func adjust(_ component:DateComponentType, offset:Int) -> Date {
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = offset
        case .minute:
            dateComp.minute = offset
        case .hour:
            dateComp.hour = offset
        case .day:
            dateComp.day = offset
        case .weekday:
            dateComp.weekday = offset
        case .nthWeekday:
            dateComp.weekdayOrdinal = offset
        case .week:
            dateComp.weekOfYear = offset
        case .month:
            dateComp.month = offset
        case .year:
            dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    func numberOfDaysInMonth() -> Int {
        let range = Calendar.current.range(of: Calendar.Component.day, in: Calendar.Component.month, for: self)!
        return range.upperBound - range.lowerBound
    }
    
    func firstDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }
    
    func lastDayOfWeek() -> Int {
        let distanceToStartOfWeek = Date.dayInSeconds * Double(self.component(.weekday)! - 1)
        let distanceToEndOfWeek = Date.dayInSeconds * Double(7)
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - distanceToStartOfWeek + distanceToEndOfWeek
        return Date(timeIntervalSinceReferenceDate: interval).component(.day)!
    }
}

extension Date {
    
    //  let date = Date()
    //  let monthString = date.getMonthName()
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getYearInt() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strMonth = dateFormatter.string(from: self)
        return Int(strMonth) ?? 0000
    }
    
    func getDateInt() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strMonth = dateFormatter.string(from: self)
        return Int(strMonth) ?? 00
    }
    
    func getMonthInt() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let strMonth = dateFormatter.string(from: self)
        return Int(strMonth) ?? 00
    }
    
    func getDayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }

}

/*
 let threeDaysLater = TimeInterval(3.days)
 date.addingTimeInterval(threeDaysLater)
 */

extension Int {
    
    var seconds: Int {
        return self
    }
    
    var minutes: Int {
        return self.seconds * 60
    }
    
    var hours: Int {
        return self.minutes * 60
    }
    
    var days: Int {
        return self.hours * 24
    }
    
    var weeks: Int {
        return self.days * 7
    }
    
    var months: Int {
        return self.weeks * 4
    }
    
    var years: Int {
        return self.months * 12
    }
}

extension Date {
    ///
    ///        Date().quarter -> 3 // date in third quarter of the year.
    ///
    public var quarter: Int {
        let month = Double(Calendar.current.component(.month, from: self))
        let numberOfMonths = Double(Calendar.current.monthSymbols.count)
        let numberOfMonthsInQuarter = numberOfMonths / 4
        return Int(ceil(month/numberOfMonthsInQuarter))
    }
    
    ///
    ///        Date().weekOfYear -> 2 // second week in the year.
    ///
    public var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    ///
    ///        Date().weekOfMonth -> 3 // date is in third week of the month.
    ///
    public var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    ///
    ///     Date().hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    public var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }
    
    ///
    ///     Date().minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    public var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Seconds.
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    public var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentSeconds = Calendar.current.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = Calendar.current.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// SwifterSwift: Check if date is within a weekend period.
    public var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    /// SwifterSwift: Check if date is within a weekday period.
    public var isWorkday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    
    /// SwifterSwift: Check if date is within the current week.
    public var isInCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// SwifterSwift: Check if date is within the current month.
    public var isInCurrentMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// SwifterSwift: Check if date is within the current year.
    public var isInCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    ///     var date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.nearestFiveMinutes // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.nearestFiveMinutes // "5:45 PM"
    ///
    public var nearestFiveMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// SwifterSwift: Nearest ten minutes to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.nearestTenMinutes // "5:50 PM"
    ///
    public var nearestTenMinutes: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// SwifterSwift: Nearest quarter hour to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.nearestQuarterHour // "5:45 PM"
    ///
    public var nearestQuarterHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// SwifterSwift: Nearest half hour to date.
    ///
    ///     var date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.nearestHalfHour // "7:00 PM"
    ///
    public var nearestHalfHour: Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)!
    }
    
    /// SwifterSwift: Nearest hour to date.
    ///
    ///     var date = Date() // "6:17 PM"
    ///     date.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.nearestHour // "7:00 PM"
    ///
    public var nearestHour: Date {
        let min = Calendar.current.component(.minute, from: self)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = Calendar.current.date(from: Calendar.current.dateComponents(components, from: self))!
        
        if min < 30 {
            return date
        }
        return Calendar.current.date(byAdding: .hour, value: 1, to: date)!
    }
}


