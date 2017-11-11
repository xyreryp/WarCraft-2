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

class OpenGLView: NSOpenGLView {
    var displayLink: CVDisplayLink?
    var currentTime: Int64
    var application: CApplicationData
    var skscene: SKScene

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init?(coder: NSCoder, application: CApplicationData, skscene: SKScene) {
        currentTime = Int64(0.0)
        self.application = application
        self.skscene = skscene
        super.init(coder: coder)

        let attributes: [NSOpenGLPixelFormatAttribute] = [
            UInt32(NSOpenGLPFAAccelerated),
            UInt32(NSOpenGLPFAColorSize), UInt32(32),
            UInt32(NSOpenGLPFADoubleBuffer),
            UInt32(NSOpenGLPFAOpenGLProfile),
            UInt32(NSOpenGLProfileVersion3_2Core),
            UInt32(0),
        ]

        guard let pixelFormat = NSOpenGLPixelFormat(attributes: attributes) else {
            Swift.print("pixelFormat could not be constructed")
            return
        }
        self.pixelFormat = pixelFormat
        guard let context = NSOpenGLContext(format: pixelFormat, share: nil) else {
            Swift.print("context could not be constructed")
            return
        }
        openGLContext = context
        openGLContext?.setValues([1], for: NSOpenGLContext.Parameter.swapInterval)
    }

    deinit {
        CVDisplayLinkStop(displayLink!)
    }

    override func prepareOpenGL() {

        super.prepareOpenGL()

        skscene.scaleMode = .fill
        let cgr = CGraphicResourceContext()
        let rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        application.DViewportRenderer.DrawViewport(surface: skscene, typesurface: cgr, selectrect: rect)

        let displayLinkOutputCallback: CVDisplayLinkOutputCallback = { (_: CVDisplayLink, inNow: UnsafePointer<CVTimeStamp>, _: UnsafePointer<CVTimeStamp>, _: CVOptionFlags, _: UnsafeMutablePointer<CVOptionFlags>, displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn in

            let view = unsafeBitCast(displayLinkContext, to: OpenGLView.self)
            //  Capture the current time in the currentTime property.
            view.currentTime = inNow.pointee.videoTime / Int64(inNow.pointee.videoTimeScale)
            view.renderFrame()

            //  We are going to assume that everything went well, and success as the CVReturn
            return kCVReturnSuccess
        }

        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
        CVDisplayLinkSetOutputCallback(displayLink!, displayLinkOutputCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        CVDisplayLinkStart(displayLink!)

        //  Test render
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        renderFrame()
    }

    func renderFrame() {
        guard let context = self.openGLContext else {
            //  Just a filler error
            Swift.print("oops")
            return
        }

        context.makeCurrentContext()
        CGLLockContext(context.cglContextObj!)

        skscene.removeAllChildren()
        let cgr = CGraphicResourceContext()
        let rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
        application.DViewportRenderer.DrawViewport(surface: skscene, typesurface: cgr, selectrect: rect)

        //  glFlush() is replaced with CGLFlushDrawable() and swaps the buffer being displayed
        CGLFlushDrawable(context.cglContextObj!)
        CGLUnlockContext(context.cglContextObj!)
    }

    //    var displaylink: CVDisplayLink?
    //    var pixelFormat: NSOpenGLPixelFormat?
    //    var openGLContext: NSOpenGLContext?
    //    var application: CApplicationData
    //    var skscene: SKScene
    //
    //    init?(coder: NSCoder, context _: NSOpenGLContext?, application: CApplicationData, skscene: SKScene) {
    //        self.skscene = skscene
    //        self.application = application
    //        // fixme:
    //        super.init(coder: coder)
    //        openGLContext!.makeCurrentContext()
    //        setupDisplayLink()
    //
    //        NotificationCenter.default.addObserver(self, selector: #selector(reshape), name: NSView.globalFrameDidChangeNotification, object: self)
    //    }
    //
    //    required init?(coder: NSCoder, application: CApplicationData, skscene: SKScene) {
    //        self.skscene = skscene
    //        self.application = application
    //        super.init(coder: coder)
    //
    //        let attributes: [NSOpenGLPixelFormatAttribute] = [
    //            UInt32(NSOpenGLPFAAccelerated),
    //            UInt32(NSOpenGLPFAColorSize), UInt32(32),
    //            UInt32(NSOpenGLPFADoubleBuffer),
    //            UInt32(NSOpenGLPFAOpenGLProfile),
    //            UInt32(NSOpenGLProfileVersion3_2Core),
    //            UInt32(0),
    //        ]
    //        pixelFormat = NSOpenGLPixelFormat(attributes: attributes)
    //        openGLContext = NSOpenGLContext(format: pixelFormat!, share: nil)
    //        openGLContext?.setValues([1], for: NSOpenGLContext.Parameter.swapInterval)
    //    }
    //
    //    required init?(coder _: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //
    //    @objc func reshape() {
    //    }
    //
    //    func setupDisplayLink() {
    //    }
    //
    //    override func lockFocus() {
    //        super.lockFocus()
    //        if openGLContext!.view != self {
    //            openGLContext!.view = self
    //        }
    //    }
    //
    //    override func draw(_: NSRect) {
    //        if openGLContext!.view != self {
    //            openGLContext!.view = self
    //        }
    //
    //        if !CVDisplayLinkIsRunning(displaylink!) {
    //            drawView()
    //        }
    //    }
    //
    //    func drawView() {
    //        CGLLockContext(openGLContext!.cglContextObj!)
    //        openGLContext!.makeCurrentContext()
    //
    //        skscene.removeAllChildren()
    //        skscene.scaleMode = .fill
    //        let cgr = CGraphicResourceContext()
    //        let rect: SRectangle = SRectangle(DXPosition: 0, DYPosition: 0, DWidth: 0, DHeight: 0)
    //        application.DViewportRenderer.DrawViewport(surface: skscene, typesurface: cgr, selectrect: rect)
    //
    //        openGLContext!.flushBuffer()
    //        CGLUnlockContext(openGLContext!.cglContextObj!)
    //    }
}
