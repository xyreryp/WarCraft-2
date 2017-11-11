//
//  OpenGLView.swift
//  WarCraft2
//
//  Created by Yepu Xie on 11/10/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import Cocoa
import OpenGL
import GLKit
import SpriteKit

class OpenGLView: NSView {
    var displaylink: CVDisplayLink?
    var pixelFormat: NSOpenGLPixelFormat?
    var openGLContext: NSOpenGLContext?
    var application: CApplicationData
    var skscene: SKScene

    init?(coder: NSCoder, context _: NSOpenGLContext?, application: CApplicationData, skscene: SKScene) {
        self.skscene = skscene
        self.application = application
        super.init(coder: coder)
        openGLContext!.makeCurrentContext()
        setupDisplayLink()

        NotificationCenter.default.addObserver(self, selector: #selector(reshape), name: NSView.globalFrameDidChangeNotification, object: self)
    }

    required init?(coder: NSCoder, application: CApplicationData, skscene: SKScene) {
        self.skscene = skscene
        self.application = application
        super.init(coder: coder)

        let attributes: [NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAAccelerated),
            UInt32(NSOpenGLPFAColorSize), UInt32(32),
            UInt32(NSOpenGLPFADoubleBuffer),
            UInt32(NSOpenGLPFAOpenGLProfile),
            UInt32(NSOpenGLProfileVersion3_2Core),
            UInt32(0),
        ]
        pixelFormat = NSOpenGLPixelFormat(attributes: attributes)
        openGLContext = NSOpenGLContext(format: pixelFormat!, share: nil)
        openGLContext?.setValues([1], for: NSOpenGLContext.Parameter.swapInterval)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func reshape() {
    }

    func setupDisplayLink() {
    }

    override func lockFocus() {
        super.lockFocus()
        if openGLContext!.view != self {
            openGLContext!.view = self
        }
    }

    override func draw(_: NSRect) {
        if openGLContext!.view != self {
            openGLContext!.view = self
        }


        if !CVDisplayLinkIsRunning(displaylink!) {
            drawView()
        }
    }

    func drawView() {
        CGLLockContext(openGLContext!.cglContextObj!)
        openGLContext!.makeCurrentContext()

        skscene.removeAllChildren()
        skscene.scaleMode = .fill
        let cgr = CGraphicResourceContext()
        let rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        application.DViewportRenderer.DrawViewport(surface: skscene, typesurface: cgr, selectrect: rect)

        openGLContext!.flushBuffer()
        CGLUnlockContext(openGLContext!.cglContextObj!)
    }
}
