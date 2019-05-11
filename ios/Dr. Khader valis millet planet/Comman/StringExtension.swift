//
//  StringExtension.swift
//  SmartCareDoc
//
//  Created by Rahul  Belekar on 14/06/17.
//  Copyright © 2017 Rahul  Belekar. All rights reserved.
//

import UIKit

enum scripting : Int {
    case aSub = -1
    case aSuper = 1
}

extension String {
    func isValidURL() -> URL? {
        if let url = URL(string: self) {
            if UIApplication.shared.canOpenURL(url) {
                return url
            }
        }
        return nil
    }
    
    public var length: Int {
        return self.characters.count
    }
    
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    public var isNumber: Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }
    
    public var isMobileNumber: Bool {
        let regEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: self) ? true : false
    }
    public var isValidPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }

    //
    
    public func formattedNumber(mask: String = "(XXX)-XXX-XXXX") -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask.characters {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    public func formattedName(mask: String = "XXXXXXXXXXXXXXXXXXXXX") -> String {
        let cleanName = self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        
        var result = ""
        var index = cleanName.startIndex
        for ch in mask.characters {
            if index == cleanName.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanName[index])
                index = cleanName.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
    
    func slice(from: String, to: String = "") -> String? {
        if to == "" {
            let value = self.components(separatedBy: from)
            if value.count > 1 {
                return value[1]
            } else {
                return ""
            }
        }
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func superScriptAMPM() -> Array<Character> {
        let char: Array<Character>
        if self.contains("P") {
            char = ["P"]
        } else {
            char = ["A"]
        }
        return char
    }
    
    func isPasswordValid() -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[$@$#!%*?&])[A-Za-z0-9\\d$@$#!%*?&]{6,}")
        return passwordTest.evaluate(with: self)
    }
}

extension NSAttributedString {

    public func underline() -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: range)
        return copy
    }
    
    public func color(_ color: UIColor) -> NSAttributedString {
        guard let copy = self.mutableCopy() as? NSMutableAttributedString else { return self }
        
        let range = (self.string as NSString).range(of: self.string)
        copy.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        return copy
    }
    
    func characterSubscriptAndSuperscript(string:String, characters:[Character], type:scripting, fontSize:CGFloat, scriptFontSize:CGFloat, offSet:Int, length:[Int], alignment:NSTextAlignment)-> NSMutableAttributedString {
        let paraghraphStyle = NSMutableParagraphStyle()
        // Set The Paragraph aligmnet , you can ignore this part and delet off the function
        paraghraphStyle.alignment = alignment
        
        var scriptedCharaterLocation = Int()
        //Define the fonts you want to use and sizes
        let stringFont = UIFont(name: "Oxygen-Regular", size: fontSize) //UIFont.boldSystemFont(ofSize: fontSize)
        let scriptFont = UIFont(name: "Oxygen-Regular", size: scriptFontSize) //UIFont.boldSystemFont(ofSize: scriptFontSize)
        // Define Attributes of the text body , this part can be removed of the function
        let attString = NSMutableAttributedString(string:string, attributes: [NSAttributedString.Key.font:stringFont!,NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.paragraphStyle: paraghraphStyle])
        
        // the enum is used here declaring the required offset
        let baseLineOffset = offSet * type.rawValue
        // enumerated the main text characters using a for loop
        for (i,c) in string.characters.enumerated()
        {
            // enumerated the array of first characters to subscript
            for (theLength,aCharacter) in characters.enumerated()
            {
                if c == aCharacter
                {
                    // Get to location of the first character
                    scriptedCharaterLocation = i
                    //Now set attributes starting from the character above
                    attString.setAttributes([NSAttributedString.Key.font:scriptFont!,
                                             // baseline off set from . the enum i.e. +/- 1
                        NSAttributedString.Key.baselineOffset:baseLineOffset,
                        NSAttributedString.Key.foregroundColor:UIColor.black],
                                            // the range from above location
                        range:NSRange(location:scriptedCharaterLocation,
                                      // you define the length in the length array
                            // if subscripting at different location
                            // you need to define the length for each one
                            length:length[theLength]))
                    
                }
            }
        }
        return attString
    }
    
}
