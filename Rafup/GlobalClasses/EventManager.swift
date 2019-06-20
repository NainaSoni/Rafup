//
//  EventHelper.swift
//  Truxx
//
//  Created by Ashish on 20/07/15.
//  Copyright (c) 2015 Ashish. All rights reserved.
//

import UIKit
import EventKit

//TODO:- let calendar = Calendar(identifier: .iso8601)

typealias EventManagerHandler = (_ result: Any?, _ error: Error?) -> Void

class EventManager: NSObject {
    
//    static let sharedInstance = EventManager()
    //MARK: Shared Instance
    static let shared : EventManager = {
        let instance = EventManager()
        // setup code
        return instance
    }()
    
    let eventStore = EKEventStore()

    var calendar: EKCalendar?

    func loadCalendars() -> [EKCalendar] {
        let calendars = eventStore.calendars(for: .event) // Grab every calendar the user has
        return calendars
    }
 
    func createCalendar(title: String) {
        
        let calendars = loadCalendars()
        var exists: Bool = false
        for calendar in calendars { // Search all these calendars
            printDebug("calendarIdentifier \(calendar.calendarIdentifier)")
            if calendar.title == title {
                exists = true
                self.calendar = calendar
            }
        }
        
        if !exists {
            let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
            newCalendar.title = title
            //newCalendar.source = eventStore.defaultCalendarForNewEvents.source
            
            // Filter the available sources and select the "Local" source to assign to the new calendar's
            // source property
            newCalendar.source = eventStore.sources.filter{
                (source: EKSource) -> Bool in
                source.sourceType.rawValue == EKSourceType.local.rawValue
                }.first!

            // Save the calendar using the Event Store instance
            do {
                try eventStore.saveCalendar(newCalendar, commit: true)
                calendar = newCalendar
            } catch {
                printDebug(error.localizedDescription)
            }
        }
    }
    
    func checkAuthorizationStatus() -> EKAuthorizationStatus {
        
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch status {
            
        case .notDetermined:
            // This happens on first-run
            requestAccess()
        case .authorized:
            // User has access
            printDebug("User has access to calendar")
            //self.checkCalendar()
        case .restricted, .denied:
            // We need to help them give us permission
            noPermission()
        }
        
        return status
    }
    
    func requestAccess() {
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if granted && error == nil {
                DispatchQueue.main.async {
                    printDebug("User has access to calendar")
                    //self.checkCalendar()
                }
            } else {
                DispatchQueue.main.async{
                    self.noPermission()
                }
            }
        })
    }
    
    func noPermission() {
        printDebug("User has to change settings...goto settings to view access")
    }

    func loadEvents(from startDate: Date, to endDate: Date) -> [EKEvent] {
        
        // Use an event store instance to create and properly configure an NSPredicate
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [eventStore.defaultCalendarForNewEvents!])
        let existingEvents = eventStore.events(matching: predicate)
        
        return existingEvents
    }
    
    func addEvent(title: String, description: String?, startDate: Date, endDate: Date, handler: EventManagerHandler? = nil) -> () {
        
        let status = checkAuthorizationStatus()
        guard status == EKAuthorizationStatus.authorized else {
            
            noPermissionAlert()
            return
        }
        let existingEvents = loadEvents(from: startDate, to: endDate)
        
        guard existingEvents.count == 0 else {
            let kEventExist = NSError(domain: Constants.kAppDisplayName, code: 1000005, userInfo: [NSLocalizedDescriptionKey : "You have already added this event."])

            handler?(false, kEventExist)
            return
        }
        /*for singleEvent in existingEvents {
            if singleEvent.title == title && singleEvent.startDate == startDate {
                // Event exist
                return
            }
        }*/
        let newEvent = EKEvent(eventStore: self.eventStore)
        newEvent.calendar = self.eventStore.defaultCalendarForNewEvents
        newEvent.title = title
        newEvent.startDate = startDate
        newEvent.endDate = endDate
        newEvent.notes = description
        
        let alarm = EKAlarm(relativeOffset: -10800) // 3 hours before in seconds
        newEvent.alarms = [alarm]
        
        do {
            try self.eventStore.save(newEvent, span: .thisEvent)
            handler?(true, nil)
        } catch {
            handler?(false, error)
            return
        }
    }
    
    func noPermissionAlert(_ sender: UIViewController? = UIApplication.topViewController()) {
        
        let message = "Please allow us the calendar permissions to store the event, go to your Settings\nApp > Privacy > Calendars"
        let alertController = UIAlertController(title: "Calendar permissions is disabled", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler:nil))
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            let SettingUrl = URL(string: UIApplicationOpenSettingsURLString)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(SettingUrl!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                _ = UIApplication.shared.openURL(SettingUrl!)
            }
            
            UIApplication.shared.open(SettingUrl!, options: [:], completionHandler: nil)
        }
        alertController.addAction(settingsAction)
        sender!.present(alertController, animated: true, completion: nil)
    }
}
