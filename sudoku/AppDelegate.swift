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
    

  
    @IBAction func newsudoku(sender: NSMenuItem) {
        
        
        if (skView!.scene as! GameScene).isShowNextGameLogo{
            return
        }
        if (Runtime.isDebug()){
            print ( "New Game")
   
    
        }
               (self.skView!.scene as! GameScene ).newsudoku();
    }
    
    @IBAction func LevelSelect(sender: NSMenuItem) {
        
       
        
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
    
    
    
    
    
    
    
    func setLevelMenu(select : Int){
        
        
       
            menuveryeasy.state = NSOffState
       
            menueasy.state =  NSOffState
            menumed.state =  NSOffState
            menuhard.state =  NSOffState
            menuveryhard.state =  NSOffState

  
        
        switch (menuselectedlevel){
        case 0:
            menuveryeasy.state = NSOffState
        case 1:
            menueasy.state =  NSOffState
        case 2:
            menumed.state =  NSOffState
        case 3:
            menuhard.state =  NSOffState
        case 4:
            menuveryhard.state =  NSOffState
        default:
            break
            
        }
    }
    
    func LevelChange(isNewGame: Bool){
        
        let state = isNewGame ? NSOffState : NSMixedState
        
        
    
            menuveryeasy.state = NSOffState
        
            menueasy.state =  NSOffState
      
            menumed.state =  NSOffState
        
            menuhard.state =  NSOffState
       
            menuveryhard.state =  NSOffState
    
    

    
    
        
        
        if (menuveryeasy.state != NSMixedState && menueasy.state != NSMixedState &&  menumed.state != NSMixedState
            && menuhard.state != NSMixedState && menuveryhard.state != NSMixedState){
       
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
            menuveryeasy.state = NSOnState
        case 1:
            menueasy.state = NSOnState
        case 2:
            menumed.state = NSOnState
        case 3:
            menuhard.state = NSOnState
        case 4:
            menuveryhard.state = NSOnState
        default:
            break
            
        }
        
        
        menuselectedlevel = menuchooselevel
        
        
        AppDelegate.writePreference("selectedgamelevel",menuselectedlevel)
        (skView!.scene as! GameScene).preference["selectedgamelevel"] = menuselectedlevel
        
        (self.skView!.scene as! GameScene).levelresettopreference()

        if (isNewGame){
                 (self.skView!.scene as! GameScene ).newsudoku();
          
        }
        
    }

    
    
    
    
    func ResetLevlMenu(selected : Int){
        
        menuveryeasy.state = NSOffState
        menueasy.state =  NSOffState
        menumed.state =  NSOffState
        menuhard.state =  NSOffState
        menuveryhard.state =  NSOffState
        
        
        switch (selected){
        case 0:
            menuveryeasy.state = NSOnState
        case 1:
            menueasy.state = NSOnState
        case 2:
            menumed.state = NSOnState
        case 3:
            menuhard.state = NSOnState
        case 4:
            menuveryhard.state = NSOnState
        default:
            break
            
        }
        AppDelegate.writePreference("selectedgamelevel",selected)
        (skView!.scene as! GameScene).preference["selectedgamelevel"] = selected

        
        
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
    
    
    @IBAction func hint(sender: NSMenuItem) {
    (self.skView!.scene as! GameScene ).hintonlyselector(sender)
    }
    
    @IBAction func checkcorrectonlyselect(sender: NSMenuItem) {
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
    
    
    @IBAction func incDiff(sender: NSButton) {
        let pref = "increase_level"
        let value = (sender.state == NSOnState) ? true : false
        (skView!.scene as! GameScene).preference[pref] = value
        AppDelegate.writePreference(pref,value)
    }

    @IBAction func autoCorrect(sender: NSButton) {
        if (Runtime.isDebug()){
            print ( "select all input check  @ AppDelegate ")
        }
        
        (self.skView!.scene as! GameScene ).autocheckcorrect(sender)
        
    }
    
    @IBAction func autoHint(sender: NSButton) {
        
        if (Runtime.isDebug()){
            print ( "select hint @ AppDelegate ")
        }
        (self.skView!.scene as! GameScene ).autoshowhint(sender)
        
    }
    
    @IBAction func showDialogselectlevel(sender: NSButton) {
        let pref = "show_select_level_dialog"
        let value = (sender.state == NSOnState) ? true : false
        (skView!.scene as! GameScene).preference[pref] = value
        AppDelegate.writePreference(pref,value)
        
        showDialognexttime.state = Int(value)

    }
    
    
    @IBAction func newGamedialogshowchange(sender: NSButton) {
        showDialogselectlevel(sender)
        pref_showselectleveldialog.state = sender.state
    }
    
    func levelchangeSheetDisplay(){
 
    
        
        
        self.skView.window!.beginSheet(changeLevelSheet,completionHandler: endSheet)
        
        //NSApp.beginSheet(newgamesheet, modalForWindow: sheet, modalDelegate: self, didEndSelector: Selector("endSheet:returnCode"), contextInfo: nil)
    }
    
  
    @IBAction func ColorChange(sender: NSColorWell) {
       setColorValueandChange(AppDelegate.ColorTagToKey(sender.tag),sender.color )
        colorchanged = true
    }
    
    
    @IBAction func ColorChangeDefault(sender: AnyObject) {
        
        
        
        
      
        
        setPreferanceColor(defaultcolor)
        for i in 0...6{
        (skView!.scene as! GameScene).pushcolorchange(AppDelegate.ColorTagToKey(i))
        }
        colorchanged = true
        
    }
    
    @IBAction func changeLevelNewGameButton(sender: NSButtonCell) {
        
        let pref = "newgamestarimmediately"
        let value = true
        (skView!.scene as! GameScene).preference[pref] = value
        AppDelegate.writePreference(pref,value)
        
        changeLevelSheet.sheetParent!.endSheet(changeLevelSheet)
        
        LevelChange(true)
        
    }
    
    
    @IBAction func changeLevelnextgamebutton(sender: NSButtonCell) {
        let pref = "newgamestarimmediately"
        let value = false
        (skView!.scene as! GameScene).preference[pref] = value
        AppDelegate.writePreference(pref,value)
        
        changeLevelSheet.sheetParent!.endSheet(changeLevelSheet)
        LevelChange(false)
    }
    
    
    
    func endSheet(
        returnCode: NSModalResponse) {

            
    

            
    }
    
  // MARK: - Color Preference
    
    func setPreferenceValue(key: String,_ color: SKColor){
    
        
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
    

    
    static func ColorTagToKey(tag: Int)->String{
        
        
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
    
    

    private func setColor(inout set: SKColor,_ value: SKColor){
        let scolor  = CIColor(color: set)
        let vcolor = CIColor(color: value)
        set = SKColor(red: vcolor!.red,green: vcolor!.green,blue: vcolor!.blue,alpha: scolor!.alpha)
        
    }
    
    func setColorValue(key: String,_ color: SKColor){
        
        
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
    
    func setColorValueandChange(key:String,_ color:SKColor){
        setColorValue(key, color)
         (skView!.scene as! GameScene).pushcolorchange(key)
    }
    
    
    
    func setPreferanceColor(dict: CFDictionaryRef){
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
    
    private  func setPreferanceColor(dict: CFDictionaryRef, _ key: String){
        let nsdict :NSDictionary  = dict
        let data = nsdict[key] as! CFData
        let color = AppDelegate.getcolorvalue(data)
        setPreferenceValue(key, color)
        

    }
    
    private static func getcolorvalue(data : CFData)->SKColor{
    
      
        let ndata: NSData = data
        
        
        var u : [UInt8] = Array(count: 4, repeatedValue: 0)
        ndata.getBytes(&u, length: sizeof(UInt8) * 4)
        
    //let u = CFDataGetBytePtr( CFDictionaryGetValue(dict, key).memory as! CFData)
        return SKColor (red: CGFloat (Double(u[0]) / 255.0)
, green: CGFloat (Double(u[1]) / 255.0), blue: CGFloat (Double(u[2]) / 255.0), alpha: CGFloat (1.0))
    
        

    }
    
 
    


    static func ColorPreference()->CFDictionaryRef{
        let returnvalue : CFDictionary = ["edit_stroke":ColorToData(GameScene.editingStrokeColor),
                                            "non_edit":ColorToData(GameScene.noneditColor),
                                            "edit_correct":ColorToData(GameScene.editCorrectColor),
                                             "edit_incorrect":ColorToData(GameScene.editInCorrectColor),
                                                 "stroke":ColorToData(GameScene.strokeColor),
                                             "big_frame":ColorToData(GameScene.bigframecolor),
                                             "hint_num":ColorToData(GameScene.hintcolor)]
    return returnvalue
    
    }
    
    
    


    static func ColorToData(color : SKColor)->CFData{
        
        
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
      
        let data : CFDataRef = CFDataCreate(nil, rgb_u,sizeof(UInt8)*4)
        
        
        
        
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
    
    func preferenceWillClose(aNotification: NSNotification){
        print("Preference Windows Closed")
        if (colorchanged){
            savecolorpreference()
            colorchanged = false
        }
    }
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            
  
            
            
            var preference = [String:AnyObject]()
           // preferencesetup
            
        
          
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "preferenceWillClose:", name: NSWindowWillCloseNotification, object: self.preference)

              preference["lastselectedbox"] = preferencessetup("lastselectedbox", -1) as! Int
            preference["selectedgamelevel"] = preferencessetup("selectedgamelevel", 0) as! Int
            preference["auto_hint"] = preferencessetup("auto_hint", false) as! Bool
            preference["auto_check"] = preferencessetup("auto_check", false) as! Bool
            preference["increase_level"] = preferencessetup("increase_level", true) as! Bool
            preference["show_select_level_dialog"] = preferencessetup("show_select_level_dialog", true) as! Bool
             preference["newgamestarimmediately"] = preferencessetup("show_select_level_dialog", true) as! Bool
            preference["level"] = preferencessetup("level", GameScene.MINLEVEL) as! Int

    //    ["default_color"] = AppDelegate.ColorPreference()

         preference["color"] = preferencessetup("color", defaultcolor)
            
            setPreferanceColor(preference["color"] as! CFDictionaryRef)
           
            
            
            
            CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
            
           // CFPreferencesSetAppValue("IncorrectColor", "SKColor.Blue",kCFPreferencesCurrentApplication)
      
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFit
            scene.backgroundColor = SKColor.whiteColor()
            
            scene.preference = preference

            
            scene.level = preference["level"] as! Int
            
            scene.appDelegate = self
        
          //  scene.levelresettoperformance()


          //  scene.size = CGSize(width:800.0,height:600.0);
            
            self.skView!.presentScene(scene)
            
            
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            self.skView!.ignoresSiblingOrder = true
            
            self.skView!.showsFPS = true
            self.skView!.showsNodeCount = true
            
            
            
            switch (menuselectedlevel){
            case 0:
                menuveryeasy.state = NSOnState
            case 1:
                menueasy.state = NSOnState
            case 2:
                menumed.state = NSOnState
            case 3:
                menuhard.state = NSOnState
            case 4:
                menuveryhard.state = NSOnState
            default:
                break
                
            }
            
            pref_autocheck.state = preference["auto_check"] as! Bool ? NSOnState : NSOffState
            pref_showhint.state = preference["auto_hint"] as! Bool ? NSOnState : NSOffState
            pref_increaseDiff.state = preference["increase_level"] as! Bool ? NSOnState : NSOffState
            pref_showselectleveldialog.state = preference["show_select_level_dialog"] as! Bool ? NSOnState : NSOffState

            
     
            
    
            
            
            
            


            
           
            
            
            
          
            
        
            
          
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        
        return true
    }
    
    func applicationWillTerminate(notification: NSNotification) {
        (self.skView.scene! as! GameScene).savecurrenttable()
        
    }

    

// MARK - Preference
    
    
    static func writePreference(key: String,_ value:CFPropertyList){
        CFPreferencesSetAppValue(key, value,kCFPreferencesCurrentApplication)
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
        
    }
    
    
    
    
    func preferencessetup(key: String,_ defaultvalue: CFPropertyList )->CFPropertyList{
        
        
        let property:CFPropertyList! =  CFPreferencesCopyAppValue(key, kCFPreferencesCurrentApplication)
        
        
        
        
        
        
        // Setdefault all value if no plist
        
        
        
        
        
        
        //CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
        
        
        if (property == nil)  {
            
            
            
            
            CFPreferencesSetAppValue(key, defaultvalue,kCFPreferencesCurrentApplication)
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