//
//  ViewController.swift
//  AirPlayr
//
//  Created by Todd on 12/17/18.
//  Copyright © 2018 Todd Bruss. All rights reserved.
//

import AVKit
//import AVFoundation

//global reference to our media player
var pv = AVPlayerView()
var ps = NSButton()
var sr = NSButton()
var sl = NSButton()
var pb = Bool()
var st = String()
var seekTime = 30
class AirButtons : NSTitlebarAccessoryViewController {
    
    
    
    @IBOutlet weak var playStream: NSButton!
    @IBOutlet weak var seekRight: NSButton!
    @IBOutlet weak var seekLeft: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ps = playStream
        sr = seekRight
        sl = seekLeft
        
        //hide play stream button
        playStream.isHidden = true
        seekRight.isHidden = true
        seekLeft.isHidden = true
      
    
        
    }
    
    @IBAction func skipHeadRIght(_ sender: Any) {
        if (pv.player != nil) {
            var currentTime = pv.player?.currentTime()
            currentTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(currentTime!) + 30, preferredTimescale: currentTime!.timescale)
            pv.player?.seek(to: currentTime!)
        }
    }
  
    @IBAction func skipHeadLeft(_ sender: Any) {
        if (pv.player != nil) {
            var currentTime = pv.player?.currentTime()
            currentTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(currentTime!) - 30, preferredTimescale: currentTime!.timescale)
            pv.player?.seek(to: currentTime!)
        }
    }
    
}

@available(OSX 10.13, *)
class AirSheet: NSViewController {
    
    @IBOutlet weak var xURL: NSTextFieldCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xURL.stringValue = "http://localhost/2.m3u8"
        //print(pv.player?.currentItem?.accessLog())
        //  print(pv.player?.currentItem?.currentMediaSelection.asset?.availableMetadataFormats)
        //print(pv.player?.currentItem?.currentDate())
        
       // print(pv.player?.currentItem?.timedMetadata)

        if st.count > 0 {
            xURL.stringValue = st
        }
        pb = true
      
    }
    
  
    
    @IBAction func Ok(_ sender: NSButton) {
        let requestedStreamURL = xURL.stringValue
        let mediaArray = ["2160", "1080","720","480","360"]
        httpGetHelper(requestedStreamURL: requestedStreamURL, mediaArray: mediaArray )
        dismiss(self) //close the thing
        pb = false
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(self)
        pb = false
    }
}

class ViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //connect our playerView to our global pv view reference
        pv = playerView
        
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(ViewController.sayHello), userInfo: nil, repeats: true)
    }
    
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        NSApp.hide(self)
        return false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.window?.delegate = self
        
        self.view.window?.showsToolbarButton = true
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.titleVisibility = .hidden
        let styleMask : NSWindow.StyleMask = [ .titled, .fullSizeContentView ]
        self.view.window?.styleMask = styleMask
        
        view.window?.level = .floating

        if let titlebarController = self.storyboard?.instantiateController(withIdentifier: "tb") as? NSTitlebarAccessoryViewController {
            
                titlebarController.layoutAttribute = .right
                // layoutAttribute has to be set before added to window
                self.view.window?.addTitlebarAccessoryViewController(titlebarController)
        }
    }
    
  
    
    //show stop and go light, title bar and full size content view within the title bar
    override func mouseEntered(with event: NSEvent) {
        let styleMask : NSWindow.StyleMask = [ .closable, .resizable, .miniaturizable, .titled, .fullSizeContentView ]
        self.view.window?.styleMask = styleMask
        ps.isHidden = false
        sr.isHidden = false
        sl.isHidden = false
        //Auto Activate window on hover
        NSApp.activate(ignoringOtherApps: true)
    }
    
    
    @objc func sayHello()
    {
        if (pv.player != nil)  {
            print(pv.player?.currentItem?.currentDate())
            print(pv.player?.currentItem?.currentTime())
            pv.contentOverlayView?.makeBackingLayer()
            pv.contentOverlayView?.layer?.backgroundColor = NSColor.blue.cgColor
            pv.contentOverlayView?.layer?.setNeedsDisplay()
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        
        //run only if playbutton is not clicked
        if !pb {
            let styleMask : NSWindow.StyleMask = [ .titled, .fullSizeContentView ]
            self.view.window?.styleMask = styleMask
            ps.isHidden = true
            sr.isHidden = true
            sl.isHidden = true
        }
    }
}
