//
//  TrailerViewController.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 2/25/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController {

    var trailerUrl: URL!
    
    @IBOutlet weak var trailerWebView: WKWebView!
    
    @IBAction func closeTrailer(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Place the URL in a URL Request.
        let request = URLRequest(url: trailerUrl!)
        // Load Request into WebView.
        trailerWebView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
