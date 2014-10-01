//
//  ViewController.swift
//  iPlayerApp
//
//  Created by James Nocentini on 01/10/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    var parser: XMLParser!
    var films: [Film] = []

    @IBOutlet weak var tableView: UITableView!

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
        films = notif.userInfo![kFilmsResultKey]! as [Film]
        films.sort({ $0.title < $1.title })
        tableView.reloadData()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellReuseIdentifier) as UITableViewCell?

        if let cell = cell {

        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kCellReuseIdentifier)
        }

        cell!.textLabel!.text = films[indexPath.row].title

        return cell!
    }

}