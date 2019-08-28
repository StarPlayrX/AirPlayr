//
//  Methods.swift
//  Airplayr
//
//  Created by Todd on 12/29/18.
//  Copyright © 2018 Todd Bruss. All rights reserved.
//

import AVKit

func httpGetHelper(requestedStreamURL: String, mediaArray: [String] ) {
    // Do any additional setup after loading the view.
    
    //var streamURL = requestedStreamURL
    //let request = NSMutableURLRequest(url: NSURL(string: streamURL)! as URL)
    
    let url = URL(string: requestedStreamURL)
    
    if url != nil {
        
        playVideo(url: url!)
        
    }

}

func httpGet(request: NSURLRequest!, callback: @escaping (String, String?) -> Void) {
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest){
        (data, response, error) -> Void in
        if error != nil {
            callback( error!.localizedDescription, error!.localizedDescription)
        } else {
            let result = NSString(data: data!, encoding:
                String.Encoding.ascii.rawValue)!
            callback(result as String, nil)
        }
    }
    task.resume()
}

func playVideo(url: URL) {
    
    DispatchQueue.main.async {
        let player = AVPlayer(url: url)
        
        pv.player = player
       // pv.player?.isClosedCaptionDisplayEnabled = true
        pv.showsFullScreenToggleButton = true
        pv.showsFrameSteppingButtons = true
        pv.controlsStyle = AVPlayerViewControlsStyle.floating
        player.allowsExternalPlayback = true
        //player.pause()
        player.play()
        player.volume = 1.0
        player.isMuted = false
        pv.contentOverlayView?.wantsLayer = true
        pv.contentOverlayView?.layer?.backgroundColor = NSColor.blue.cgColor
        pv.contentOverlayView?.layer?.setNeedsDisplay()
        let iv = NSView()
        iv.layer?.backgroundColor =  NSColor.blue.cgColor
        pv.contentOverlayView!.addSubview(iv)
        let v = pv.contentOverlayView!
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.bottomAnchor.constraint(equalTo:v.bottomAnchor),
            iv.topAnchor.constraint(equalTo:v.topAnchor),
            iv.leadingAnchor.constraint(equalTo:v.leadingAnchor),
            iv.trailingAnchor.constraint(equalTo:v.trailingAnchor),
            ])
       
       
        
        
    }
    
}
