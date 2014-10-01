//
//  XMLParser.swift
//  iPlayerApp
//
//  Created by James Nocentini on 01/10/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

import UIKit

class XMLParser: NSObject, NSXMLParserDelegate {
    let data: NSData
    var currentFilm: Film?
    var films: [Film] = []
    var parser: NSXMLParser?
    var accumulatingParsedCharacterData = false
    
    init(data: NSData) {
        self.data = data
        self.parser = NSXMLParser(data: data)!
        
        super.init()
        
        self.parser?.delegate = self
        self.parser?.parse()
        
        self.addFilmsToList(films)
    }
    
    func addFilmsToList(films: [Film]) {
        assert(NSThread.isMainThread())
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationNames.AddFilm.rawValue, object: self, userInfo: [kFilmsResultKey: films])
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        if elementName == kEntryElementName {
            let film = Film()
            self.currentFilm = film
        } else if elementName == kMediaThumbnailElementName {
            let urlAttribute = attributeDict["url"]! as String
            self.currentFilm?.thumbnail = NSURL(string: urlAttribute)
        } else if elementName == kTitleElementName {
            accumulatingParsedCharacterData = true
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if accumulatingParsedCharacterData {
            if let title = self.currentFilm?.title {
                self.currentFilm?.title = title.stringByAppendingString(string)
            } else {
                self.currentFilm?.title = string
            }
        }
        
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String!, qualifiedName qName: String!) {
        if elementName == kEntryElementName {
            films.append(currentFilm!)
        }
        
        accumulatingParsedCharacterData = false
    }
    
}
