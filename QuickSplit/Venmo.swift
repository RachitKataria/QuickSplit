//
//  Venmo.swift
//  QuickSplit
//
//  Created by Andrew Jiang on 11/12/16.
//  Copyright © 2016 Rachit Kataria. All rights reserved.
//

import UIKit

struct Venmo {
    static func buildVenmoChargeAppURL(recipients: [String], amount: Double, note: String) -> String {
        var URL = "venmo://paycharge?txn=charge&audience=friends"
        URL += "&recipients=" + recipients.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        URL += "&amount=" + String(amount)
        URL += "&note=" + note.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return URL
    }
    
    static func buildVenmoPayAppURL(recipients: [String], amount: Double, note: String) -> String {
        var URL = "venmo://paycharge?txn=pay&audience=friends"
        URL += "&recipients=" + recipients.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        URL += "&amount=" + String(amount)
        URL += "&note=" + note.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return URL
    }
    
    static func buildVenmoChargeURL(recipients: [String], amount: Double, note: String) -> String {
        var URL = "https://venmo.com/?txn=charge&audience=friends"
        URL += "&recipients=" + recipients.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        URL += "&amount=" + String(amount)
        URL += "&note=" + note.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return URL
    }
    
    static func buildVenmoPayURL(recipients: [String], amount: Double, note: String) -> String {
        var URL = "https://venmo.com/?txn=pay&audience=friends"
        URL += "&recipients=" + recipients.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        URL += "&amount=" + String(amount)
        URL += "&note=" + note.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return URL
    }
    
    static func openVenmoCharge(recipients: [String], amount: Double, completion: @escaping ((Bool) -> Void) = {_ in }) -> Void {
        let chargeAppURL = buildVenmoChargeAppURL(recipients: recipients, amount: amount, note: "via Split");
        let chargeURL = buildVenmoChargeURL(recipients: recipients, amount: amount, note: "via Split");
        UIApplication.shared.open(URL(string: chargeAppURL)!, options: [:], completionHandler: {(opened: Bool) -> Void in
            if !opened { UIApplication.shared.open(URL(string: chargeURL)!, options: [:], completionHandler: completion) }
            else { completion(opened) }
        });
    }
    
    static func openVenmoPay(recipients: [String], amount: Double, completion: @escaping ((Bool) -> Void) = {_ in }) -> Void {
        let payAppURL = buildVenmoPayAppURL(recipients: recipients, amount: amount, note: "via Split");
        let payURL = buildVenmoPayURL(recipients: recipients, amount: amount, note: "via Split");
        UIApplication.shared.open(URL(string: payAppURL)!, options: [:], completionHandler: {(opened: Bool) -> Void in
            if !opened { UIApplication.shared.open(URL(string: payURL)!, options: [:], completionHandler: completion) }
            else { completion(opened) }
        });
    }
}
