//
//  GraphicTileset.swift
//  WarCraft2
//
//  Created by Disha Bendre on 10/9/17.
//  Copyright © 2017 UC Davis. All rights reserved.
//

import Foundation
import SpriteKit
import Cocoa
import AppKit

class CGraphicTileset {
    var DSurfaceTileset: CGraphicSurface?
    var DClippingMasks: [CGraphicSurface]
    var DMapping: [String: Int]
    var DTileNames: [String]
    var DGroupNames: [String]
    var DGroupSteps: [String: Int]
    var DTileCount: Int
    var DTileWidth: Int
    var DTileHeight: Int
    var DTileHalfWidth: Int
    var DTileHalfHeight: Int
    var DTileSet: [SKTexture]
    var DTileImageSet: [NSImage]

    init() {
        DSurfaceTileset = nil
        DTileCount = 0
        DTileWidth = 0
        DTileHeight = 0
        DTileHalfWidth = 0
        DTileHalfHeight = 0
        DTileSet = []
        DClippingMasks = []
        DMapping = [:]
        DTileNames = []
        DGroupNames = []
        DGroupSteps = [:]
        DTileImageSet = []
    }

    deinit {}

    func TileWidth() -> Int {
        return DTileWidth
    }

    func TileHeight() -> Int {
        return DTileHeight
    }

    func TileHalfWidth() -> Int {
        return DTileHalfWidth
    }

    func TileHalfHeight() -> Int {
        return DTileHalfHeight
    }

    func ParseGroupName(tilename: inout String, aniname: inout String,
                        anistep: inout Int) -> Bool {
        var LastIndex = tilename.count // get length of string
        if LastIndex <= 0 {
            return false
        }
        repeat {
            LastIndex = LastIndex - 1
            // check of charcter from string is not a digit
            let charIndex = tilename.index(tilename.startIndex, offsetBy: LastIndex)
            let char = tilename[charIndex] // get the value we want to compare to digit
            let s = String(char).unicodeScalars
            let uni = s[s.startIndex]
            let decimalChars = CharacterSet.decimalDigits
            let decimalRange = decimalChars.hasMember(inPlane: UInt8(uni.value))
            // let decimalRange = char.rangeOfCharacter(from: decimalChars)
            if !decimalRange { // no numbers are found
                if LastIndex + 1 == tilename.count {
                    return false
                }
                // extra word for the substring part
                let substrIndex = tilename.index(tilename.startIndex, offsetBy: LastIndex + 1)
                aniname = String(tilename[..<substrIndex])
                anistep = Int(tilename[..<substrIndex])! // this may be incorrect,
                // c++: anistep = std::stoi(tilename.substr(LastIndex+1));
                return true
            }
        } while LastIndex > 0
        return false
    } // end ParseGroupName()

    private func UpdateGroupName() {
        DGroupSteps.removeAll()
        DGroupNames.removeAll()

        for i in 0 ... DTileCount {
            var GroupName: String = ""
            var GroupStep: Int = 0
            var tileIndex: String = String(DTileNames.index(DTileNames.startIndex, offsetBy: i))

            // ParseGroupName returns a bool
            let parseGroupReturn: Bool = ParseGroupName(tilename: &tileIndex,
                                                        aniname: &GroupName, anistep: &GroupStep)
            if parseGroupReturn {
                if DGroupSteps[GroupName] != nil {
                    if DGroupSteps[GroupName]! <= GroupStep {
                        DGroupSteps[GroupName] = GroupStep + 1
                    }
                } else {
                    DGroupSteps[GroupName] = GroupStep + 1
                    DGroupNames.append(GroupName)
                }
            }
        }
    } // end UpdateGroupName()

    func TileCount() -> Int {
        return DTileCount
    } // end TileCount without any parameters

    func TileCount(count: Int) -> Int {
        if 0 > count {
            return DTileCount
        }
        if (DTileWidth <= 0) || (DTileHeight <= 0) {
            return DTileCount
        }
        if count < DTileCount {
            DTileCount = count
            for key in DMapping.keys {
                if DMapping[key]! >= DTileCount {
                    DMapping.removeValue(forKey: key) // remove value
                } // otherwise, go to next iteration
            }
            DTileNames.reserveCapacity(DTileCount)
            UpdateGroupName()
            return DTileCount
        }
        // TODO: Uncomment below function after CreateSurface() is implemented
        //        let TempSurface: CGraphicSurface? // change this
        //        var TempSurface = CreateSurface(DTileWidth, (count * DTileHeight), DSurfaceTileset?.Format()) // TODO: need to finish the GraphicFactory file (swift)
        //        if TempSurface! != nil {
        //            return DTileCount
        //        }

        DTileNames.reserveCapacity(count)
        //       TempSurface?.Copy(srcsurface: DSurfaceTileset!, dxpos: 0, dypos: 0, width: -1, height: -1, sxpos: 0, sypos: 0)
        //       DSurfaceTileset = TempSurface
        DTileCount = count
        return DTileCount
    } // end TileCount()

    @discardableResult
    func ClearTile(index: Int) -> Bool {
        if (0 > index) || (index >= DTileCount) {
            return false
        }
        if DSurfaceTileset != nil {
            return false
        }
        DSurfaceTileset?.Clear(xpos: 0, ypos: (index * DTileHeight),
                               width: DTileWidth, height: DTileHeight)
        return true
    } // end ClearTile()

    func DuplicateTile(destindex: Int, tilename: inout String, srcindex: Int) -> Bool {
        if (0 > srcindex) || (0 > destindex) || (srcindex >= DTileCount) || (destindex >= DTileCount) {
            return false
        }
        if tilename.isEmpty {
            return false
        }
        ClearTile(index: destindex)
        DSurfaceTileset?.Copy(srcsurface: DSurfaceTileset!, dxpos: 0,
                              dypos: (destindex * DTileHeight), width: DTileWidth,
                              height: DTileHeight, sxpos: 0, sypos: srcindex * DTileHeight)

        let arrEntry: String = DTileNames[destindex] // get correct element of array,
        // we know it's a string
        // find this arry in the Map
        if DMapping[arrEntry] != nil { // erase the entry from map if key-value
            // exists in dictionary
            DMapping.removeValue(forKey: arrEntry)
        }
        DTileNames[destindex] = tilename
        DMapping[tilename] = destindex

        return true
    } // end DuplicateTile()

    func DuplicateClippedTile(destindex: Int, tilename: inout String, srcindex: Int,
                              clipindex: Int) -> Bool {
        if (0 > srcindex) || (0 > destindex) || (0 > clipindex) ||
            (srcindex >= DTileCount) || (destindex >= DTileCount) || (clipindex >= DClippingMasks.count) {
            return false
        }
        if tilename.isEmpty {
            return false
        }
        ClearTile(index: destindex)
        DSurfaceTileset?.CopyMaskSurface(srcsurface: DSurfaceTileset!, dxpos: 0,
                                         dypos: (destindex * DTileHeight), masksurface: DClippingMasks[clipindex], sxpos: 0, sypos: (srcindex * DTileHeight))
        let arrEntry: String = DTileNames[destindex]
        if DMapping[arrEntry] != nil {
            DMapping.removeValue(forKey: arrEntry)
        }
        DTileNames[destindex] = tilename
        DMapping[tilename] = destindex

        if destindex >= DClippingMasks.count {
            DClippingMasks.reserveCapacity(destindex + 1)
        }

        // NOTE: uncomment below function after CGraphicFactory.swift is written
        //        DClippingMasks[destindex] = CGraphicFactory.CreateSurface(DTileWidth, DTileHeight, CGraphicSurface::ESurfaceFormat::A1)
        //        DClippingMasks[destindex] = CreateSurface(DTileWidth, DTileHeight, enumeration)
        DClippingMasks[destindex].Copy(srcsurface: DSurfaceTileset!, dxpos: 0, dypos: 0, width: DTileWidth, height: DTileHeight, sxpos: 0, sypos: (destindex * DTileHeight))

        return true
    } // end DuplicateClippedTile()

    func FindTile(tilename: String) -> Int {
        return DMapping[tilename] ?? -1
    } // end FindTile()

    func GroupName(index: Int) -> String {
        if 0 > index {
            return ""
        }
        if DGroupNames.count <= index {
            return ""
        }
        return DGroupNames[index]
    } // end GroupName()

    func GroupSteps(index: Int) -> Int {
        if 0 > index {
            return 0
        }
        if DGroupNames.count <= index {
            return 0
        }
        return DGroupSteps[DGroupNames[index]]!
    } // end GroupSteps()

    func GroupSteps(Groupname: inout String) -> Int {
        if DGroupSteps[Groupname] != nil {
            return DGroupSteps[Groupname]!
        }
        return 0
    }

    func CreateClippingMasks() {
        if DSurfaceTileset != nil {
            DClippingMasks.reserveCapacity(DTileCount)
            for Index in 0 ... DTileCount {
                //                DClippingMasks[Index] = CGraphicFactory.CreateSurface(DTileWidth, DTileHeight, CGraphicSurface::ESurfaceFormat::A1) // uncomment later
                DClippingMasks[Index].Copy(srcsurface: DSurfaceTileset!, dxpos: 0, dypos: 0, width: DTileWidth, height: DTileHeight, sxpos: 0, sypos: (Index * DTileHeight))
            }
        }
    } // end CreateCLippingMasks()

    func TestLoadTileset(source: CDataSource!, assetName: String) -> Bool {
        // use DataSource to Read
        var TempTokens = source.ReadInTiles(fileName: assetName, extensionType: "dat")
        var Tokens = [String]()
        for i in 5 ..< TempTokens.count {
            //            print("loading \(assetName) tilenum \(i)")
            Tokens.append(TempTokens[i])
            DMapping[TempTokens[i]] = i - 5
            DTileNames.append(TempTokens[i])
            //            print("TilesetName: \(TempTokens[i])")
        }
        DTileCount = Tokens.count - 1

        // load the actual image from Assets folder.
        let Tileset = NSImage(named: NSImage.Name(rawValue: assetName))!
        DTileWidth = Int(Tileset.size.width)
        DTileHeight = Int(Tileset.size.height)
        DTileHeight /= DTileCount
        DTileHalfWidth = DTileWidth / 2
        DTileHalfHeight = DTileHeight / 2

        // crop the image into individual tiles
        for i in 1 ... DTileCount {
            let newSize: NSSize
            newSize = NSSize(width: DTileWidth, height: DTileHeight)
            let temp: NSImage = Tileset.crop(size: newSize, index: i)!
            DTileImageSet.append(temp)
            let tempTexture = SKTexture(image: temp)
            DTileSet.append(tempTexture)
        }
        UpdateGroupName()
        return true
    }

    func LoadTileset(source _: CDataSource!) -> Bool {
        if let filepath = Bundle.main.path(forResource: "Terrain", ofType: "dat") {
            do {
                let TempString = try String(contentsOfFile: filepath, encoding: .utf8)
                let TempTokens = TempString.components(separatedBy: .newlines)
                var Tokens = [String]()
                for i in 5 ..< TempTokens.count {
                    Tokens.append(TempTokens[i])
                    DMapping[TempTokens[i]] = i - 5
                    DTileNames.append(TempTokens[i])
                }
                DTileCount = Tokens.count
            } catch {
                print(error)
            }
        }
        let Tileset = #imageLiteral(resourceName: "Terrain")
        DTileWidth = Int(Tileset.size.width)
        DTileHeight = Int(Tileset.size.height)
        DTileHeight /= DTileCount
        DTileHalfWidth = DTileWidth / 2
        DTileHalfHeight = DTileHeight / 2
        for i in 1 ... DTileCount {
            let newSize: NSSize
            newSize = NSSize(width: DTileWidth, height: DTileHeight)
            let temp: NSImage = Tileset.crop(size: newSize, index: i)!
            DTileImageSet.append(temp)
            let tempTexture = SKTexture(image: temp)
            DTileSet.append(tempTexture)
        }

        UpdateGroupName()
        return true
    }

    func DrawTile(skscene: SKScene, xpos: Int, ypos: Int, tileindex: Int) {
        if 0 > tileindex || tileindex >= DTileCount {
            return
        }

        let tempNode = SKSpriteNode(texture: DTileSet[tileindex])

        //        tempNode.anchorPoint = CGPoint(x: 0, y: 1)
        tempNode.position = CGPoint(x: xpos, y: ypos)
        skscene.addChild(tempNode)
    }

    func DrawTile(context: CGraphicResourceContextCoreGraphics, xpos: Int, ypos: Int, width: Int, height: Int, tileindex: Int) {
        if 0 > tileindex || tileindex >= DTileCount {
            return
        }

        let image = DTileImageSet[tileindex]
        let imageRect = CGRect(x: CGFloat(xpos), y: CGFloat(ypos), width: CGFloat(width), height: CGFloat(height))
        context.myContext.draw(image.CGImage, in: imageRect)
    }

    //
    //        surface.Draw(srcsurface: DSurfaceTileset!, dxpos: xpos, dypos: ypos, width: DTileWidth, height: DTileHeight, sxpos: 0, sypos: (tileindex * DTileHeight))
    //    } // end LoadTileset()
    //

    //    func DrawClipped(surface: CGraphicSurface, xpos: Int, ypos: Int, tileindex: Int, rgb: UInt32) {
    //        if 0 > tileindex || tileindex >= DClippingMasks.count {
    //            return
    //        }
    //
    //        // following done through core graphics kit
    //        let ResourceContext: CGraphicResourceContext = surface.CreateResourceContext()
    //        ResourceContext.Fill()
    //        ResourceContext.SetSourceRGB(rgb: rgb)
    //        ResourceContext.MaskSurface(srcsurface: DClippingMasks[tileindex], xpos: xpos, ypos: ypos)
    //    }
}

// https://gist.github.com/MaciejGad/11d8469b218817290ee77012edb46608
extension NSImage {

    /// Returns the height of the current image.
    var height: CGFloat {
        return size.height
    }

    /// Returns the width of the current image.
    var width: CGFloat {
        return size.width
    }

    /// Returns a png representation of the current image.
    var PNGRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }

        return nil
    }

    ///  Copies the current image and resizes it to the given size.
    ///
    ///  - parameter size: The size of the new image.
    ///
    ///  - returns: The resized copy of the given image.
    func copy(size: NSSize) -> NSImage? {
        // Create a new rect with given width and height
        let frame = NSMakeRect(0, 0, size.width, size.height)

        // Get the best representation for the given size.
        guard let rep = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        // Create an empty image with the given size.
        let img = NSImage(size: size)

        // Set the drawing context and make sure to remove the focus before returning.
        img.lockFocus()
        defer { img.unlockFocus() }

        // Draw the new image
        if rep.draw(in: frame) {
            return img
        }

        // Return nil in case something went wrong.
        return nil
    }

    ///  Copies the current image and resizes it to the size of the given NSSize, while
    ///  maintaining the aspect ratio of the original image.
    ///
    ///  - parameter size: The size of the new image.
    ///
    ///  - returns: The resized copy of the given image.
    func resizeWhileMaintainingAspectRatioToSize(size: NSSize) -> NSImage? {
        let newSize: NSSize

        let widthRatio = size.width / width
        let heightRatio = size.height / height

        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(width * widthRatio), height: floor(height * widthRatio))
        } else {
            newSize = NSSize(width: floor(width * heightRatio), height: floor(height * heightRatio))
        }

        return copy(size: newSize)
    }

    ///  Copies and crops an image to the supplied size.
    ///
    ///  - parameter size: The size of the new image.
    ///
    ///  - returns: The cropped copy of the given image.

    // TODO: rewrite - parametes: height, width
    func crop(size: NSSize, index: Int) -> NSImage? {
        // Resize the current image, while preserving the aspect ratio.
        guard let resized = self.resizeWhileMaintainingAspectRatioToSize(size: size) else {
            return nil
        }
        // Get some points to center the cropping area.
        let x = floor((resized.width - size.width) / 2)
        let y = floor(resized.height - CGFloat(index) * size.height)

        // Create the cropping frame.
        let frame = NSMakeRect(x, y, size.width, size.height)

        // Get the best representation of the image for the given cropping frame.
        guard let rep = resized.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        // Create a new image with the new size
        let img = NSImage(size: size)

        img.lockFocus()
        defer { img.unlockFocus() }

        if rep.draw(in: NSMakeRect(0, 0, size.width, size.height),
                    from: frame,
                    operation: NSCompositingOperation.copy,
                    fraction: 1.0,
                    respectFlipped: false,
                    hints: [:]) {
            // Return the cropped image.
            return img
        }

        // Return nil in case anything fails.
        return nil
    }
}

// convert NSImage to CGImage
extension NSImage {
    var CGImage: CGImage {
        var imageRect: CGRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: size.width, height: size.height)
        return cgImage(forProposedRect: &imageRect, context: nil, hints: nil)!
    }
}
