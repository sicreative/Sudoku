//
//  AppDelegate.swift
//  sudoku
//
//  Created by slee on 2015/12/20.
//  Copyright (c) 2015年 slee. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var preference: NSPanel!
    
    
    @IBOutlet weak var changeLevelSheet: NSWindow!

    @IBOutlet weak var window: NSWindow!

  //  @IBOutlet weak var newgamesheet: NSWindow!
    @IBOutlet weak var skView: SKView!
   // @IBOutlet weak var newgameview: NSView!
   
  //  var sheet: NSWindow!
   
    
    @IBOutlet weak var menuveryeasy: NSMenuItem!
    @IBOutlet weak var menueasy: NSMenuItem!
    @IBOutlet weak var menumed: NSMenuItem!
   
    @IBOutlet weak var menuhard: NSMenuItem!
    @IBOutlet weak var menuveryhard: NSMenuItem!
    
 
    
    @IBOutlet weak var pref_increaseDiff: NSButton!
    @IBOutlet weak var pref_autocheck: NSButtonCell!
    @IBOutlet weak var pref_showhint: NSButton!
    @IBOutlet weak var pref_showselectleveldialog: NSButton!
    @IBOutlet weak var showDialognexttime: NSButton!
  
    @IBOutlet weak var CorrectNumColor: NSColorWell!
    
    @IBOutlet weak var IncorrectNumColor: NSColorWell!
    @IBOutlet weak var noneditNumColor: NSColorWell!
    @IBOutlet weak var BigFrameColor: NSColorWell!
    @IBOutlet weak var SmallFrameColor: NSColorWell!
    @IBOutlet weak var SelectedFrameColor: NSColorWell!
    @IBOutlet weak var HintColor: NSColorWell!
    
    
    
    
    
    var menuselectedlevel: Int = 0
    var menuchooselevel: Int = 0
    var colorchanged = false
    
    let defaultcolor :CFDictionary = AppDelegate.ColorPreference()
    

  
    @IBAction func newsudoku(_ sender: NSMenuItem) {
        
        
        if (skView!.scene as! GameScene).isShowNextGameLogo{
            return
        }
        if (Runtime.isDebug()){
            print ( "New Game")
   
    
        }
               (self.skView!.scene as! GameScene ).newsudoku();
    }
    
    @IBAction func LevelSelect(_ sender: NSMenuItem) {
        
       
        
       // if menuselectedlevel == sender.tag {
       //     return
       // }
        
          menuchooselevel = sender.tag

        
        
        
        
        if (skView!.scene as! GameScene).preference["show_select_level_dialog"] as! Bool{
        
          levelchangeSheetDisplay()
            
            return
        
        }

        
             LevelChange((skView!.scene as! GameScene).preference["newgamestarimmediately"] as! Bool)
        
       
        
        
    }
    
    
    
    
    
    
    
    func setLevelMenu(_ select : Int){
        
        
       
        menuveryeasy.state = NSControl.StateValue.off
       
            menueasy.state =  NSControl.StateValue.off
            menumed.state =  NSControl.StateValue.off
            menuhard.state =  NSControl.StateValue.off
            menuveryhard.state =  NSControl.StateValue.off

  
        
        switch (menuselectedlevel){
        case 0:
            menuveryeasy.state = NSControl.StateValue.off
        case 1:
            menueasy.state =  NSControl.StateValue.off
        case 2:
            menumed.state =  NSControl.StateValue.off
        case 3:
            menuhard.state =  NSControl.StateValue.off
        case 4:
            menuveryhard.state =  NSControl.StateValue.off
        default:
            break
            
        }
    }
    
    func LevelChange(_ isNewGame: Bool){
        
        let state = isNewGame ? NSControl.StateValue.off : NSControl.StateValue.mixed
        
        
    
            menuveryeasy.state = NSControl.StateValue.off
        
            menueasy.state =  NSControl.StateValue.off
      
            menumed.state =  NSControl.StateValue.off
        
            menuhard.state =  NSControl.StateValue.off
       
            menuveryhard.state =  NSControl.StateValue.off
    
    

    
    
        
        
        if (menuveryeasy.state != NSControl.StateValue.mixed && menueasy.state != NSControl.StateValue.mixed &&  menumed.state != NSControl.StateValue.mixed
            && menuhard.state != NSControl.StateValue.mixed && menuveryhard.state != NSControl.StateValue.mixed){
       
        switch (menuselectedlevel){
        case 0:
            (self.skView!.scene as! GameScene).changemixedstatenextgame(menuveryeasy);
            menuveryeasy.state = state
        case 1:
            (self.skView!.scene as! GameScene).changemixedstatenextgame(menueasy);
            menueasy.state = state
        case 2:
            (self.skView!.scene as! GameScene).changemixedstatenextgame(menumed);
            menumed.state = state
        case 3:
            (self.skView!.scene as! GameScene).changemixedstatenextgame(menuhard);
            menuhard.state = state
        case 4:
            (self.skView!.scene as! GameScene).changemixedstatenextgame(menuveryhard);
            menuveryhard.state = state
        default:
            break
            
                    }
        }
        
        
        switch (menuchooselevel){
        case 0:
            menuveryeasy.state = NSControl.StateValue.on
        case 1:
            menueasy.state = NSControl.StateValue.on
        case 2:
            menumed.state = NSControl.StateValue.on
        case 3:
            menuhard.state = NSControl.StateValue.on
        case 4:
            menuveryhard.state = NSControl.StateValue.on
        default:
            break
            
        }
        
        
        menuselectedlevel = menuchooselevel
        
        
        AppDelegate.writePreference("selectedgamelevel",menuselectedlevel as CFPropertyList)
        (skView!.scene as! GameScene).preference["selectedgamelevel"] = menuselectedlevel as AnyObject
        
        (self.skView!.scene as! GameScene).levelresettopreference()

        if (isNewGame){
                 (self.skView!.scene as! GameScene ).newsudoku();
          
        }
        
    }

    
    
    
    
    func ResetLevlMenu(_ selected : Int){
        
        menuveryeasy.state = NSControl.StateValue.off
        menueasy.state =  NSControl.StateValue.off
        menumed.state =  NSControl.StateValue.off
        menuhard.state =  NSControl.StateValue.off
        menuveryhard.state =  NSControl.StateValue.off
        
        
        switch (selected){
        case 0:
            menuveryeasy.state = NSControl.StateValue.on
        case 1:
            menueasy.state = NSControl.StateValue.on
        case 2:
            menumed.state = NSControl.StateValue.on
        case 3:
            menuhard.state = NSControl.StateValue.on
        case 4:
            menuveryhard.state = NSControl.StateValue.on
        default:
            break
            
        }
        AppDelegate.writePreference("selectedgamelevel",selected as CFPropertyList)
        (skView!.scene as! GameScene).preference["selectedgamelevel"] = selected as AnyObject

        
        
    }
    
    
    
    
    /*
    @IBAction func checkcorrect(sender: NSMenuItem) {
        if (Runtime.isDebug()){
        print ( "select all input check  @ AppDelegate ")
        }

     //   (self.skView!.scene as! GameScene ).autocheckcorrect(sender)
    }
*/
    //MARK: - Action Response 
    
    
    @IBAction func hint(_ sender: NSMenuItem) {
    (self.skView!.scene as! GameScene ).hintonlyselector(sender)
    }
    
    @IBAction func checkcorrectonlyselect(_ sender: NSMenuItem) {
        if (Runtime.isDebug()){
           print ( "select check only this  @ AppDelegate ")
        }
        
        (self.skView!.scene as! GameScene ).checkcorrectonlyselect(sender)
    }
    
    /*
    @IBAction func showhint(sender: NSMenuItem) {
        if (Runtime.isDebug()){
            print ( "select hint @ AppDelegate ")
        }
      //  (self.skView!.scene as! GameScene ).showhint(sender)
        
    }
*/
    
    
    @IBAction func incDiff(_ sender: NSButton) {
        let pref = "increase_level"
        let value = (sender.state == NSControl.StateValue.on) ? true : false
        (skView!.scene as! GameScene).preference[pref] = value as AnyObject
        AppDelegate.writePreference(pref,value as CFPropertyList)
    }

    @IBAction func autoCorrect(_ sender: NSButton) {
        if (Runtime.isDebug()){
            print ( "select all input check  @ AppDelegate ")
        }
        
        (self.skView!.scene as! GameScene ).autocheckcorrect(sender)
        
    }
    
    @IBAction func autoHint(_ sender: NSButton) {
        
        if (Runtime.isDebug()){
            print ( "select hint @ AppDelegate ")
        }
        (self.skView!.scene as! GameScene ).autoshowhint(sender)
        
    }
    
    @IBAction func showDialogselectlevel(_ sender: NSButton) {
        let pref = "show_select_level_dialog"
        let value = (sender.state == NSControl.StateValue.on) ? true : false
        (skView!.scene as! GameScene).preference[pref] = value as AnyObject
        AppDelegate.writePreference(pref,value as CFPropertyList)
        
        showDialognexttime.state = (value==true ? NSControl.StateValue.on : NSControl.StateValue.off)

    }
    
    
    @IBAction func newGamedialogshowchange(_ sender: NSButton) {
        showDialogselectlevel(sender)
        pref_showselectleveldialog.state = sender.state
    }
    
    func levelchangeSheetDisplay(){
 
    
        
        
        self.skView.window!.beginSheet(changeLevelSheet,completionHandler: endSheet)
        
        //NSApp.beginSheet(newgamesheet, modalForWindow: sheet, modalDelegate: self, didEndSelector: Selector("endSheet:returnCode"), contextInfo: nil)
    }
    
  
    @IBAction func ColorChange(_ sender: NSColorWell) {
       setColorValueandChange(AppDelegate.ColorTagToKey(sender.tag),sender.color )
        colorchanged = true
    }

    
    @IBAction func LinkToPage(_ sender: Any) {
        if let url = URL(string: "https://sitechprog.blogspot.hk"), NSWorkspace.shared.open(url) {
            
        }
    }
    
    
    @IBAction func ColorChangeDefault(_ sender: AnyObject) {
        
        
        
        
      
        
        setPreferanceColor(defaultcolor)
        for i in 0...6{
        (skView!.scene as! GameScene).pushcolorchange(AppDelegate.ColorTagToKey(i))
        }
        colorchanged = true
        
    }
    
    @IBAction func changeLevelNewGameButton(_ sender: NSButtonCell) {
        
        let pref = "newgamestarimmediately"
        let value = true
        (skView!.scene as! GameScene).preference[pref] = value as AnyObject
        AppDelegate.writePreference(pref,value as CFPropertyList)
        
        changeLevelSheet.sheetParent!.endSheet(changeLevelSheet)
        
        LevelChange(true)
        
    }
    
    
    @IBAction func changeLevelnextgamebutton(_ sender: NSButtonCell) {
        let pref = "newgamestarimmediately"
        let value = false
        (skView!.scene as! GameScene).preference[pref] = value as AnyObject
        AppDelegate.writePreference(pref,value as CFPropertyList)
        
        changeLevelSheet.sheetParent!.endSheet(changeLevelSheet)
        LevelChange(false)
    }
    
    
    
    func endSheet(
        _ returnCode: NSApplication.ModalResponse) {

            
    

            
    }
    
  // MARK: - Color Preference
    
    func setPreferenceValue(_ key: String,_ color: SKColor){
    
        
        switch (key){
            case "edit_stroke":
                SelectedFrameColor.color = color
            case "non_edit":
                noneditNumColor.color = color
            case "edit_correct":
                CorrectNumColor.color = color
            case "edit_incorrect":
                IncorrectNumColor.color = color
            case "stroke":
                SmallFrameColor.color = color
            case "big_frame":
                BigFrameColor.color = color
            case "hint_num":
                HintColor.color = color
        default:
            break
            
            
            
            
        }
        
        setColorValue(key, color)
        
    }
    

    
    static func ColorTagToKey(_ tag: Int)->String{
        
        
        switch (tag){
        case 5:
            return "edit_stroke"
        case 2:
            return "non_edit"
        case 0:
            return "edit_correct"
        case 1:
            return "edit_incorrect"
        case 4:
            return "stroke"
        case 3:
            return "big_frame"
        case 6:
            return "hint_num"
        default:
            return ""
            
            
            
            
        }
        
    }
    
    

    fileprivate func setColor(_ set: inout SKColor,_ value: SKColor){
        let scolor  = CIColor(color: set)
        let vcolor = CIColor(color: value)
        set = SKColor(red: vcolor!.red,green: vcolor!.green,blue: vcolor!.blue,alpha: scolor!.alpha)
        
    }
    
    func setColorValue(_ key: String,_ color: SKColor){
        
        
        switch (key){
        case "edit_stroke":
            setColor( &GameScene.editingStrokeColor,color)
        case "non_edit":
            setColor( &GameScene.noneditColor,color)
        case "edit_correct":
            setColor( &GameScene.editCorrectColor,color)
        case "edit_incorrect":
            setColor( &GameScene.editInCorrectColor ,color)
        case "stroke":
            setColor( &GameScene.strokeColor,color)
        case "big_frame":
            setColor( &GameScene.bigframecolor,color)
        case "hint_num":
            setColor( &GameScene.hintcolor,color)
        default:
            break
            
            
            
            
        }
        
       
        
    }
    
    func setColorValueandChange(_ key:String,_ color:SKColor){
        setColorValue(key, color)
         (skView!.scene as! GameScene).pushcolorchange(key)
    }
    
    
    
    func setPreferanceColor(_ dict: CFDictionary){
       // let d =  CFDictionaryGetValue(dict, "color").memory as! CFDictionary
        //let d : NSDictionary = dict
        
        
        //let color = DictToColor(dict,"edit_stroke")
        
        setPreferanceColor(dict,"edit_stroke")
        setPreferanceColor(dict, "non_edit")
        setPreferanceColor(dict, "edit_correct")
        setPreferanceColor(dict, "edit_incorrect")
        setPreferanceColor(dict, "stroke")
        setPreferanceColor(dict, "big_frame")
        setPreferanceColor(dict, "hint_num")
        

    }
    
    fileprivate  func setPreferanceColor(_ dict: CFDictionary, _ key: String){
        let nsdict :NSDictionary  = dict
        let data = nsdict[key] as! CFData
        let color = AppDelegate.getcolorvalue(data)
        setPreferenceValue(key, color)
        

    }
    
    fileprivate static func getcolorvalue(_ data : CFData)->SKColor{
    
      
        let ndata: Data = data as Data
        
        
        var u : [UInt8] = Array(repeating: 0, count: 4)
        (ndata as NSData).getBytes(&u, length: MemoryLayout<UInt8>.size * 4)
        
    //let u = CFDataGetBytePtr( CFDictionaryGetValue(dict, key).memory as! CFData)
        return SKColor (red: CGFloat (Double(u[0]) / 255.0)
, green: CGFloat (Double(u[1]) / 255.0), blue: CGFloat (Double(u[2]) / 255.0), alpha: CGFloat (1.0))
    
        

    }
    
 
    


    static func ColorPreference()->CFDictionary{
        let returnvalue : Dictionary = ["edit_stroke":ColorToData(GameScene.editingStrokeColor),
                                            "non_edit":ColorToData(GameScene.noneditColor),
                                            "edit_correct":ColorToData(GameScene.editCorrectColor),
                                             "edit_incorrect":ColorToData(GameScene.editInCorrectColor),
                                                 "stroke":ColorToData(GameScene.strokeColor),
                                             "big_frame":ColorToData(GameScene.bigframecolor),
                                             "hint_num":ColorToData(GameScene.hintcolor)]
    return returnvalue as CFDictionary
    
    }
    
    
    


    static func ColorToData(_ color : SKColor)->CFData{
        
        
        //var colors = color
       
        
        //var colorp :UnsafeMutablePointer<NSColor>
        
        
     //   colorp.memory = colors
        let ciColor : CIColor = CIColor(color:color)!
        
        var rgb_u :[UInt8] = []
        rgb_u.append(UInt8(Int(ciColor.red * 255.0)))
        rgb_u.append(UInt8(Int(ciColor.green * 255.0)))
        rgb_u.append(UInt8(Int(ciColor.blue * 255.0)))
        rgb_u.append(UInt8(Int(ciColor.alpha * 255.0)))
        
      // var r_uInt8 = UInt8(Int(ciColor.red * 255.0))
      //  var g_uInt8 = UInt8(Int(ciColor.green * 255.0))
      //  var b_uInt8 = UInt8(Int(ciColor.blue * 255.0))
      //   var a_uInt8 = UInt8(Int(ciColor.alpha * 255.0))
      
        let data : CFData = CFDataCreate(nil, rgb_u,MemoryLayout<UInt8>.size*4)
        
        
        
        
//     var key :[CFStringRef] = ["r","g","b","a"]

      //  let key :[CFStringRef] = ["r","g","b","a"]

      //  let value:[CFDataRef] = [CFDataCreate(nil,&r_uInt8,1),CFDataCreate(nil, &g_uInt8, 1),
      //  CFDataCreate(nil,&b_uInt8,1),CFDataCreate(nil, &a_uInt8, 1)]
        
        
     //   var value :[CFDataRef] = [r]
     // var value:[CFNumberRef] = [1,1,1,1]

        
       // let dict: CFDictionary = ["r":"1","g":"2"]
       
        
        
       // colorp[0] = color
        
        
        //     colorp.GetDataSize()
   //  var cf =  CFDataCreate(nil, d,1)
        
     //   var valuecall = kCFTypeDictionaryValueCallBacks
     //   var keycall = kCFTypeDictionaryKeyCallBacks
 
    
      //  let dict:CFDictionaryRef = CFDictionaryCreate(nil, UnsafeMutablePointer(key) , UnsafeMutablePointer(value), value.count, &keycall , &valuecall)
        //   var colorarray:[CFNumberRef] = [NSNumber(double:Double(color.greenComponent))]
    // var colorarray:[CFNumberRef] = [1,2,3,4]
   // var call  = kCFTypeArrayCallBacks
        
     //   let cfarray :CFArrayRef = CFArrayCreate(nil, UnsafeMutablePointer(colorarray), colorarray.count,&call)
        
        return data
    }
    
    
    func savecolorpreference(){
        AppDelegate.writePreference("color", AppDelegate.ColorPreference())
    }
 
    
    // MARK: - Life Cycle
    
    @objc func preferenceWillClose(_ aNotification: Notification){
        print("Preference Windows Closed")
        if (colorchanged){
            savecolorpreference()
            colorchanged = false
        }
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            
  
               UserDefaults.standard.set(false, forKey: "NSFullScreenMenuItemEverywhere")
            
            var preference = [String:AnyObject]()
           // preferencesetup
            
        
          
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.preferenceWillClose(_:)), name: NSWindow.willCloseNotification, object: self.preference)

              preference["lastselectedbox"] = preferencessetup("lastselectedbox", -1 as CFPropertyList) as! Int as AnyObject
            preference["selectedgamelevel"] = preferencessetup("selectedgamelevel", 0 as CFPropertyList) as! Int as AnyObject
            preference["auto_hint"] = preferencessetup("auto_hint", false as CFPropertyList) as! Bool as AnyObject
            preference["auto_check"] = preferencessetup("auto_check", false as CFPropertyList) as! Bool as AnyObject
            preference["increase_level"] = preferencessetup("increase_level", true as CFPropertyList) as! Bool as AnyObject
            preference["show_select_level_dialog"] = preferencessetup("show_select_level_dialog", true as CFPropertyList) as! Bool as AnyObject
             preference["newgamestarimmediately"] = preferencessetup("show_select_level_dialog", true as CFPropertyList) as! Bool as AnyObject
            preference["level"] = preferencessetup("level", GameScene.MINLEVEL as CFPropertyList) as! Int as AnyObject

    //    ["default_color"] = AppDelegate.ColorPreference()

         preference["color"] = preferencessetup("color", defaultcolor)
            
            setPreferanceColor(preference["color"] as! CFDictionary)
           
            
            
            
            CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
            
           // CFPreferencesSetAppValue("IncorrectColor", "SKColor.Blue",kCFPreferencesCurrentApplication)
      
            self.skView!.allowsTransparency = false
           
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFit
           // scene.backgroundColor = .clear
           scene.backgroundColor = NSColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
            
            scene.preference = preference

            
            scene.level = preference["level"] as! Int
            
            scene.appDelegate = self
        
          //  scene.levelresettoperformance()


          //  scene.size = CGSize(width:800.0,height:600.0);
            
            
     
            self.skView!.presentScene(scene)
            
            
            
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
           
            if (Runtime.isDebug()){
            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
            }
            
            
            
            switch (menuselectedlevel){
            case 0:
                menuveryeasy.state = NSControl.StateValue.on
            case 1:
                menueasy.state = NSControl.StateValue.on
            case 2:
                menumed.state = NSControl.StateValue.on
            case 3:
                menuhard.state = NSControl.StateValue.on
            case 4:
                menuveryhard.state = NSControl.StateValue.on
            default:
                break
                
            }
            
            pref_autocheck.state = preference["auto_check"] as! Bool ? NSControl.StateValue.on : NSControl.StateValue.off
            pref_showhint.state = preference["auto_hint"] as! Bool ? NSControl.StateValue.on : NSControl.StateValue.off
            pref_increaseDiff.state = preference["increase_level"] as! Bool ? NSControl.StateValue.on : NSControl.StateValue.off
            pref_showselectleveldialog.state = preference["show_select_level_dialog"] as! Bool ? NSControl.StateValue.on : NSControl.StateValue.off

            
     
            
    
            
            
            
            


            
           
            
            
            
          
            
        
            
          
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        
        return true
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        (self.skView.scene! as! GameScene).savecurrenttable()
        
    }

    

// MARK - Preference
    
    
    static func writePreference(_ key: String,_ value:CFPropertyList){
        CFPreferencesSetAppValue(key as CFString, value,kCFPreferencesCurrentApplication)
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
        
    }
    
    
    
    
    func preferencessetup(_ key: String,_ defaultvalue: CFPropertyList )->CFPropertyList{
        
        
        let property:CFPropertyList! =  CFPreferencesCopyAppValue(key as CFString, kCFPreferencesCurrentApplication)
        
        
        
        
        
        
        // Setdefault all value if no plist
        
        
        
        
        
        
        //CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
        
        
        if (property == nil)  {
            
            
            
            
            CFPreferencesSetAppValue(key as CFString, defaultvalue,kCFPreferencesCurrentApplication)
            return defaultvalue
        }
        
        return property
        
        
        
        //}
        
        //let getselectedgamelevel = propertydict.valueForKey("selectedgamelevel")
        
        /*
        var auto_correct: Bool! = propertydict.valueForKey("auto_correct") as! Bool!
        var auto_showhint: Bool! = propertydict.valueForKey("auto_showhint") as! Bool!
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
        
        if (selectedgamelevel == nil){
        selectedgamelevel = 0
        CFPreferencesSetAppValue("selectedgamelevel", selectedgamelevel,kCFPreferencesCurrentApplication)
        }
        
        if (auto_correct == nil){
        auto_correct = false
        CFPreferencesSetAppValue("auto_correct", auto_correct,kCFPreferencesCurrentApplication)
        }
        
        if (auto_showhint == nil){
        auto_showhint = false
        CFPreferencesSetAppValue("auto_showhint", auto_showhint,kCFPreferencesCurrentApplication)
        }
        
        */
        
        
        
        // CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
        
    }



    
}
