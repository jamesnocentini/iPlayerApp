//
//  ViewController.swift
//  iPlayerApp
//
//  Created by James Nocentini on 01/10/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var parser: XMLParser!
    var films: [Film] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let feedURLString = "http://feeds.bbc.co.uk/iplayer/categories/films/tv/list"
        let filmsURLRequest = NSURLRequest(URL: NSURL(string: feedURLString)!)

        NSURLConnection.sendAsynchronousRequest(filmsURLRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in

            if error != nil {

            } else {
                let httpResponse = response as NSHTTPURLResponse
                if httpResponse.statusCode == 200 {
                    let parseOperation = XMLParser(data: data)
                }
            }
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "addFilms:", name: NotificationNames.AddFilm.rawValue, object: nil)

    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NotificationNames.AddFilm.rawValue, object: nil)
    }

    func addFilms(notif: NSNotification) {
        assert(NSThread.isMainThread())
        self.films = notif.userInfo![kFilmsResultKey]! as [Film]
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}