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
  
    
    var menuselectedlevel: Int = 0
    var menuchooselevel: Int = 0
    
    

  
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
        
       
        
        if menuselectedlevel == sender.tag {
            return
        }
        
          menuchooselevel = sender.tag

        
        
        
        
        if (skView!.scene as! GameScene).performance["show_select_level_dialog"] as! Bool{
        
          levelchangeSheetDisplay()
            
            return
        
        }

        
             LevelChange((skView!.scene as! GameScene).performance["newgamestarimmediately"] as! Bool)
        
       
        
        
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
        (skView!.scene as! GameScene).performance["selectedgamelevel"] = menuselectedlevel
        
        (self.skView!.scene as! GameScene).levelresettoperformance()

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
        (skView!.scene as! GameScene).performance["selectedgamelevel"] = selected
        
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
        (skView!.scene as! GameScene).performance[pref] = value
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
        (skView!.scene as! GameScene).performance[pref] = value
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
    
    
    
    
    
    @IBAction func changeLevelNewGameButton(sender: NSButtonCell) {
        
        let pref = "newgamestarimmediately"
        let value = true
        (skView!.scene as! GameScene).performance[pref] = value
        AppDelegate.writePreference(pref,value)
        
        changeLevelSheet.sheetParent!.endSheet(changeLevelSheet)
        
        LevelChange(true)
        
    }
    
    
    @IBAction func changeLevelnextgamebutton(sender: NSButtonCell) {
        let pref = "newgamestarimmediately"
        let value = false
        (skView!.scene as! GameScene).performance[pref] = value
        AppDelegate.writePreference(pref,value)
        
        changeLevelSheet.sheetParent!.endSheet(changeLevelSheet)
        LevelChange(false)
    }
    
    
    
    func endSheet(
        returnCode: NSModalResponse) {

            
    

            
    }
    


 
    
    // MARK: - Life Cycle
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        /* Pick a size for the scene */
        if let scene = GameScene(fileNamed:"GameScene") {
            
     
            
            
            var performance = [String:AnyObject]()
           // preferencesetup
          

            
            performance["selectedgamelevel"] = preferencessetup("selectedgamelevel", 0) as! Int
            performance["auto_hint"] = preferencessetup("auto_hint", false) as! Bool
            performance["auto_check"] = preferencessetup("auto_check", false) as! Bool
            performance["increase_level"] = preferencessetup("increase_level", true) as! Bool
            performance["show_select_level_dialog"] = preferencessetup("show_select_level_dialog", true) as! Bool
             performance["newgamestarimmediately"] = preferencessetup("show_select_level_dialog", true) as! Bool
            performance["level"] = preferencessetup("level", GameScene.MINLEVEL) as! Int

        

            
              
            
            
            CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
            
           // CFPreferencesSetAppValue("IncorrectColor", "SKColor.Blue",kCFPreferencesCurrentApplication)
      
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFit
            scene.backgroundColor = SKColor.whiteColor()
            
            scene.performance = performance

            
            scene.level = performance["level"] as! Int
            
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
            
            pref_autocheck.state = performance["auto_check"] as! Bool ? NSOnState : NSOffState
            pref_showhint.state = performance["auto_hint"] as! Bool ? NSOnState : NSOffState
            pref_increaseDiff.state = performance["increase_level"] as! Bool ? NSOnState : NSOffState
            pref_showselectleveldialog.state = performance["show_select_level_dialog"] as! Bool ? NSOnState : NSOffState

            
     
            
            

            
           
            
            
            
          
            
        
            
          
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