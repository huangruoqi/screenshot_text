//
//  stApp.swift
//  st
//
//  Created by Ruoqi Huang on 9/10/23.
//

import SwiftUI
import Magnet
import CoreGraphics


@main
struct stApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    var imageView: NSImageView?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Register your hotkeys using Magnet
        if let keyCombo = KeyCombo(key: .a, cocoaModifiers: [.command]) {
            let hotKey = HotKey(identifier: "CommandA", keyCombo: keyCombo, target: self, action: #selector(handleHotkey))
            hotKey.register()
        }
    }
    
    @objc func handleHotkey(hotKey: HotKey) {
        let screenBounds = CGDisplayBounds(CGMainDisplayID())
        if let imageRef = CGWindowListCreateImage(screenBounds, .optionOnScreenOnly, kCGNullWindowID, .bestResolution) {
            let image = NSImage(cgImage: imageRef, size: NSSize(width: CGFloat(imageRef.width), height: CGFloat(imageRef.height)))
            let bitmapRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)!
            let color = bitmapRepresentation.colorAt(x: 0, y: 0)
            let windowRect = NSRect(x: 100, y: 100, width: image.size.width, height: image.size.height)
            self.window = NSWindow(contentRect: windowRect, styleMask: [.titled, .closable], backing: .buffered, defer: false)
            self.imageView = NSImageView(frame: windowRect)
            self.imageView?.image = image
            self.window?.contentView?.addSubview(self.imageView!)
            self.window?.makeKeyAndOrderFront(nil)
        }
        

    }
}
