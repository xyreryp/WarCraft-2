| Priority     | Status | FileName (.h)                                              | FileName (.cpp)                 | FileName  (Swift)                                        |
|--------------|--------|------------------------------------------------------------|---------------------------------|----------------------------------------------------------|
|              |        | AIPlayer.h                                                 | AIPlayer.cpp                    |                                                          |
|              |        | ApplicationData.h                                          | ApplicationData.cpp             |                                                          |
|              |        | ApplicationMode.h                                          |                                 |                                                          |
|              |        | ApplicationPath.h                                          | ApplicationPath.cpp             |                                                          |
| :red_circle: | [⋅]    | AssetDecoratedMap.h                                        | AssetDecoratedMap.cpp           |                                                          |
| :red_circle: | [⋅]    | AssetRenderer.h                                            | AssetRenderer.cpp               |                                                          |
|              |        |                                                            | BasicCapabilities.cpp           |                                                          |
|              |        | BattleMode.h                                               | BattleMode.cpp                  |                                                          |
|              |        | Bevel.h                                                    | Bevel.cpp                       |                                                          |
|              |        |                                                            | BuildCapabilities.cpp           |                                                          |
|              |        |                                                            | BuildingUpgradeCapabilities.cpp |                                                          |
|              |        | ButtonRenderer.h                                           | ButtonRenderer.cpp              |                                                          |
|              |        | ButtonMenuMode.h                                           | ButtonMenuMode.cpp              |                                                          |
|              |        | CommentSkipLineDataSource.h                                | CommentSkipLineDataSource.cpp   | CommentSkipLineDataSource.swift                          |
|              |        | CursorSet.h                                                | CursorSet.cpp                   |                                                          |
|              |        | DataContainer.h                                            |                                 | DataContainer.swift                                      |
|              |        | DataSink.h                                                 |                                 | DataSink.swift                                           |
|              |        | DataSource.h                                               |                                 | DataSource.swift                                         |
|              |        | Debug.h                                                    | Debug.cpp                       |                                                          |
|              |        | EditOptionsMode.h                                          | EditOptionsMode.cpp             |                                                          |
|              |        | EditRenderer.h                                             | EditRenderer.cpp                |                                                          |
|              |        | EndOfBattleMode.h                                          | EndOfBattleMode.cpp             |                                                          |
| :red_circle: | [⋅]    | FileDataContainer.h                                        | FileDataContainer.cpp           |   May not be necessary because it deals with reading from a directory but we already have access to everything in our project folder without using this class |
| :red_circle: | [⋅]    | FileDataSink.h                                             | FileDataSink.cpp                |                                                          |
| :red_circle: | [.]    | FileDataSource.h                                           | FileDataSource.cpp              |                                                          |
|              |        | FogRenderer.h                                              | FogRenderer.cpp                 |                                                          |
|              |        | FontTileset.h                                              | FontTileset.cpp                 |                                                          |
|              |        | GUIApplication.h                                           | GUIFactoryGTK3.cpp              |                                                          |
|              |        | GUIBox.h                                                   |                                 |                                                          |
|              |        | GUIContainer.h                                             |                                 |                                                          |
|              |        | GUICursor.h                                                |                                 |                                                          |
|              |        | GUIDisplay.h                                               |                                 |                                                          |
|              |        | GUIDrawingArea.h                                           |                                 |                                                          |
|              |        | GUIEvent.h                                                 |                                 |                                                          |
|              |        | GUIFactory.h                                               |                                 |                                                          |
|              |        | GUIFactoryGTK3.h                                           |                                 |                                                          |
|              |        | GUIFileChooserDialog.h                                     |                                 |                                                          |
|              |        | GUILabel.h                                                 |                                 |                                                          |
|              |        | GUIMenu.h                                                  |                                 |                                                          |
|              |        | GUIMenuBar.h                                               |                                 |                                                          |
|              |        | GUIMenuItem.h                                              |                                 |                                                          |
|              |        | GUIMenuShell.h                                             |                                 |                                                          |
|              |        | GUIWidget.h                                                |                                 |                                                          |
|              |        | GUIWindow.h                                                |                                 |                                                          |
|              |        | GameDataTypes.h                                            |                                 | GameDataTypes.swift                                      |
|              |        | GameModel.h                                                | GameModel.cpp                   |                                                          |
| :red_circle: | [⋅]    | GraphicFactory.h                                           |                                 | GraphicFactory.swift                                     |
| :red_circle: | [⋅]    | GraphicFactoryCairo.h                                      | GraphicFactoryCairo.cpp         | GraphicFactoryCoreGraphics.swift                         |
| :red_circle: | [⋅]    | GraphicMulticolorTileset.h                                 | GraphicMulticolorTileset.cpp    |                                                          |
| :red_circle: | [⋅]    | GraphicRecolorMap.h                                        | GraphicRecolorMap.cpp           |                                                          |
|              |        | GraphicResourceContext.h                                   |                                 | GraphicResourceContext.swift                             |
| :red_circle: | [⋅]    | GraphicSurface.h                                           |                                 | GraphicSurface.swift                                     |
| :red_circle: | [⋅]    | GraphicTileset.h                                           | GraphicTileset.cpp              |                                                          |
|              |        | IOChannel.h                                                |                                 |                                                          |
|              |        | IOEvent.h                                                  |                                 | HandlingMouseClicks.swift, IOEvent.swift                 |
|              |        | IOFactory.h                                                |                                 |                                                          |
|              |        | IOFactoryGlib.h                                            | IOFactoryGlib.cpp               |                                                          |
|              |        | InGameMenuMode.h                                           | InGameMenuMode.cpp              |                                                          |
|              |        | LineDataSource.h                                           | LineDataSource.cpp              | LineDataSource.swift                                     |
|              |        | ListViewRenderer.h                                         | ListViewRenderer.cpp            | ListViewRenderer.swift                                   |
|              |        | MainMenuMode.h                                             | MainMenuMode.cpp                | MainMenuViewController.swift,MainWindowController.swift  |
| :red_circle: | [⋅]    | MapRenderer.h                                              | MapRenderer.cpp                 | MapRenderer.swift                                        |
|              |        | MapSelectionMode.h                                         | MapSelectionMode.cpp            |                                                          |
|              |        | MemoryDataSource.h                                         | MemoryDataSource.cpp            |                                                          |
|              |        | MiniMapRenderer.h                                          | MiniMapRenderer.cpp             |                                                          |
|              |        | MultiPlayerOptionsMenuMode.h                               | MultiPlayerOptionsMenuMode.cpp  | MultiPlayerGameOptionsViewController.swift               |
|              |        | NetworkOptionsMode.h                                       | NetworkOptionsMode.cpp          | NetworkOptionsMenuViewController.swift                   |
|              |        | OptionsMenuMode.h                                          | OptionsMenuMode.cpp             | OptionsMenuViewController.swift                          |
|              | [⋅]    | Path.h                                                     | Path.cpp                        |                                                          |
|              |        | PeriodicTimeout.h                                          | PeriodicTimeout.cpp             |                                                          |
|              |        | PixelType.h                                                | PixelType.cpp                   | PixelPosition.swift                                      |
|              |        | PlayerAIColorSelectMode.h                                  | PlayerAIColorSelectMode.cpp     |                                                          |
|              |        | PlayerAsset.h                                              | PlayerAsset.cpp                 |                                                          |
|              |        | PlayerCommand.h                                            |                                 | PlayerCommand.swift                                      |
|              |        | Position.h                                                 | Position.cpp                    | Position.swift                                           |
|              |        | RandomNumberGenerator.h                                    |                                 | RandomNumberGenerator.swift                              |
|              |        | Rectangle.h                                                |                                 | Rectangle.swift                                          |
| :red_circle: | [⋅]    | ResourceRenderer.h                                         | ResourceRenderer.cpp            |                                                          |
|              |        | RouterMap.h                                                | RouterMap.cpp                   |                                                          |
|              |        | SoundClip.h                                                | SoundClip.cpp                   |                                                          |
|              |        | SoundEventRenderer.h                                       | SoundEventRenderer.cpp          | SoundManager.swift                                       |
|              |        | SoundLibraryMixer.h                                        | SoundLibraryMixer.cpp           | SoundOptionsMenuViewController.swift                     |
|              |        | SoundOptionsMode.h                                         | SoundOptionsMode.cpp            | SplashViewController.swift                               |
|              |        |                                                            | TrainCapabilities.cpp           | TilePosition.swift                                       |
| :red_circle: | [⋅]    | TerrainMap.h                                               | TerrainMap.cpp                  | TerrainMap.swift                                         |
|              |        | TextFormatter.h                                            | TextFormatter.cpp               | TextFormatter.swift                                                               |
|              |        | Tokenizer.h                                                | Tokenizer.cpp                   | Tokenizer.swift                                          |
|              |        | UnitActionRenderer.h                                       | UnitActionRenderer.cpp          |                                                          |
|              |        | UnitDescriptionRenderer.h                                  | UnitDescriptionRenderer.cpp     |                                                          |
|              |        |                                                            | UnitUpgradeCapabilities.cpp     |                                                          |
| :red_circle: | [.]    | ViewportRenderer.h                                         | ViewportRenderer.cpp            | ViewportRenderer.swift                                                         |
|              |        | VisibilityMap.h                                            | VisibilityMap.cpp               | VisibilityMap.swift                                      |
|              |        |                                                            | Main.cpp                        |                                                          |
