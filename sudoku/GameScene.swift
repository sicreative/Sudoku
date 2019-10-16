
//
//  GameScene.swift
//  sudoku
//
//  Created by slee on 2015/12/20.
//  Copyright (c) 2015年 slee. All rights reserved.
//

import SpriteKit
import GameKit






class GameScene: SKScene {
    
    
    
    static var editingStrokeColor = SKColor.black
    static var noneditColor = SKColor.black
    
    
    

    
    
    static var editCorrectColor = SKColor(red:0.1,green:0.4,blue:0.1,alpha:1)
    static var editInCorrectColor = SKColor.blue
    static var strokeColor  = SKColor(red:0.8,green:0.1,blue:0.1,alpha:0.8)
   static var bigframecolor = SKColor(red:0.5,green:0.5,blue:0.5,alpha:0.7)
   static var hintcolor = SKColor(red:0.95,green:0.8,blue:0.9,alpha:1)
    
    
    
   let finishedboxfilledColor = NSColor(red:0.8,green:0.8,blue:0.4,alpha:0.8)
   let finishedboxtextColor = NSColor(red:0.2,green:0.2,blue:0.2,alpha:0.8)
       let buildgameboxfilledColor = NSColor(red:0.24,green:0.8,blue:0.24,alpha:0.8)
      let buildgameboxtextColor = NSColor(red:0.2,green:0.2,blue:0.2,alpha:0.8)
    static let MAXLEVEL = 60
    static let MINLEVEL = 3
    
    
    var appDelegate : AppDelegate!
   
    
  //  private let concurrencySudokuQueue = dispatch_queue_create(
  //      NSBundle.mainBundle().bundleIdentifier!+".SudokuQueue", DISPATCH_QUEUE_CONCURRENT)
    
    fileprivate let concurrencySudokuBackGroundQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".SudokuBackGroundQueue", qos:.background, attributes: .concurrent, autoreleaseFrequency: .never)
    
  //  private var dispatch_source_finished_buildsudoku : dispatch_source_t!
    
    
   fileprivate var _isShowNextGame  = false
    
   fileprivate var isClosingNextGame = false
    
    var isShowNextGame: Bool{
        get {
            return _isShowNextGame
        }
        
       
        
    }
    
    
    var isShowNextGameLogo: Bool{
        if _isShowNextGame || isClosingNextGame {
            return true
        }else{
            return false
        }
    }
    
    
    

    

     var level: Int = MINLEVEL;
    var numfilledBox: Int = 0;
    fileprivate var numTotalfillBox: Int = 0;
    
    var selectedlevelchangenexttime = false;

   
    var preference = [String:AnyObject]()
    
    //var numarray:[[Int64]] = []
    
    
    let modelcontroller =  CoreController()

    // MARK: - Level
    
    
    func levelresettopreference(){
        level = preferenceleveltolevel(preference["selectedgamelevel"] as! Int)
        selectedlevelchangenexttime = true
        AppDelegate.writePreference("level",level as CFPropertyList)
        
    }
    
    func preferenceleveltolevel(_ PerformaceLevel: Int)-> Int{
        return 3 + (PerformaceLevel) * 10
    }
    
    
    
    // MARK: - New
    
    
    func newsudoku(){
        
        isClosingNextGame = true
        
    
       
        
       self.scene!.view!.window!.undoManager!.removeAllActions()
        
        
        
        
             showstartsudoku()
   


        
        if (userData!["mixedstatemenu"] != nil){
            (userData!["mixedstatemenu"] as! NSMenuItem).state = NSControl.StateValue.off
            if level == preferenceleveltolevel((userData!["mixedstatemenu"] as! NSMenuItem).tag) {
                (userData!["mixedstatemenu"] as! NSMenuItem).state = NSControl.StateValue.on
            }
            userData!["mixedstatemenu"] = nil
        }
        
       // let level = 3
      //  makeanswer()
      //   makefilling ();
        
      //  buildsudokutable();
        
        let isReadfromdatabase = readdatabasetable();
        if (!isReadfromdatabase){
            buildsudokutable(false)
           
        }else{
            newsudokubuildednum()
        }
        
        
       
        
    
        
        let fadeoutAction = SKAction.fadeOut(withDuration: 1.5)
        let runaction = SKAction.run(){
            
        }
        let removeAction = SKAction.removeFromParent()
        let seqAction : [SKAction] = [fadeoutAction,runaction,removeAction]
        
        let action = SKAction.sequence(seqAction)
        
 
        
        childNode(withName: "buildgame")!.run(action)
        
        
     
        
    }
    
    func newsudokubuildednum(){
      
        var  numarray :[[Int]] = userData!["numarray"] as! Array
        var  fillingarray :[[Bool]] = userData!["fillingarray"] as! Array
        numTotalfillBox = 0;
        numfilledBox = 0;
        
        for i in 0 ... 8  {
            
            for j in 0 ... 8{
                if (fillingarray[i][j]){
                    numTotalfillBox += 1
                }
               let node = children[9+i*9+j] as! SudokuBoxSKNode
                
                node.setNumValue(numarray[i][j], fillingarray[i][j],false)
               
            }
        }
        updatetextfadeout()
        updateAllAutoCheck()
        refreshHint()
        
        checkselectedbox()
        selectnearcenter()
    
     
        
        for i in 0...5 {
            if level ==  preferenceleveltolevel(i)-1{
                buildsudokutable(true, level-1, 15.0)
                
                break;
            }
            
        }
   

       // let int_time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
       // dispatch_after(int_time, GlobalMainQueue){
            self.isClosingNextGame = false
       // }
        
    
        
      //  self.updatehint()
    }
    
    
    func checkselectedbox(){
        if userData!["selectedbox"] as! Int == -1{
            return
        }
        
        let selected = children[userData!["selectedbox"] as! Int] as! SudokuBoxSKNode
        if !selected.isEditable() {
            
            userData!["selectedbox"] = -1;
            selected.setDeselected()

            
        }
    }
    
    func changemixedstatenextgame(_ mixedstatemenu: NSMenuItem){
        userData!["mixedstatemenu"] = mixedstatemenu
    }

    // MARK: - Support Undo / Redo
 
  
    
  
 
   
    
    
    @IBAction func undo (_ sender: NSButtonCell){
        
    }
    
    @IBAction func redo (_ sender: NSButtonCell){
        
    }
    
    
    // MARK: - Build Sudoku number

    
    
    func buildsudokutable (_ isRunBackGround : Bool){
        return buildsudokutable(isRunBackGround,self.level)
        
    }
    
    
    
    
    
    
    func buildsudokutable (_ isRunBackGround : Bool, _ level : Int){
        
        var  numarray :[[Int]] = [[]]
        var  fillingarray :[[Bool]] = [[]]
        
        
        

       //let qos = isRunBackGround ? QOS_CLASS_BACKGROUND : QOS_CLASS_USER_INITIATED
        let runqueue = isRunBackGround ? concurrencySudokuBackGroundQueue : DispatchQueue.main
     // let runqueue = concurrencySudokuQueue
      //  let runqueue = isRunBackGround ? concurrencySudokuBackGroundQueue : concurrencySudokuQueue
        
        let buildConcurrencyGroup = DispatchGroup()
        
        
        if checkwiththislevel(level){
            
            if !isRunBackGround{
            readdatabasetable(level)
            newsudokubuildednum()
            }
            
            return
        }
        
        
     
        runqueue.async{
            buildConcurrencyGroup.enter()
               numarray = self.makeanswer()
            
            buildConcurrencyGroup.leave()
            

       
            }
        
        
        runqueue.async{
                buildConcurrencyGroup.enter()
               fillingarray = self.makefilling ();
                buildConcurrencyGroup.leave()
            }
            
        
 
        
        runqueue.async{
            
                                buildConcurrencyGroup.notify(queue: runqueue){
                                    
                                   
                                    
                                  //  dispatch_barrier_sync(runqueue){
      
                                     //   let  numarray :[[Int]] = self.userData!["numarray"] as! Array
                                     //   let  fillingarray :[[Bool]] = self.userData!["fillingarray"] as! Array
                                   
                                        if (!isRunBackGround){
                                            
                                          //  dispatch_sync(dispatch_get_main_queue()){
                                            
                                        //    objc_sync_enter(self)
                                            self.userData!["numarray"] = numarray
                                            self.userData!["fillingarray"] = fillingarray

                                            
                                         //   objc_sync_exit(self)
                                            
                                            
                                           
                                                self.newsudokubuildednum()
                                          // }
                                            return
                                        }
                                             self.databasemodeltable(numarray,fillingarray,level)
                                        
                                        
                                        
                                        if (Runtime.isDebug()){
                                            
                                            
                                            print ( "Finished run build sudoku level: \(level) ,background: \(isRunBackGround)")
                                        }
                                 }
                                    //    dispatch_source_merge_data(self.dispatch_source_finished_buildsudoku, 1)
                    //}
            
        
    
            
        }
        
        
        
      
       //  makefilling ();
        
    //    var  fillingarray :[[Bool]] = makefilling ();
        
        
        
        
   //     var  numarray :[[Int]] = userData!["numarray"] as! Array
        
   //     databasemodeltable(numarray,fillingarray)

    }
    
    
    func buildsudokutable (_ isRunBackGround : Bool, _ level : Int,_ delay : Double){
        
        if (delay <= 0){
            return buildsudokutable(isRunBackGround,level)
        }
        
        let runqueue = concurrencySudokuBackGroundQueue
        
        // let runqueue = isRunBackGround ? concurrencySudokuBackGroundQueue : concurrencySudokuQueue
        
        let int_time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        runqueue.asyncAfter(deadline: int_time){
            return self.buildsudokutable(isRunBackGround,level)
        }
        
    }
    
    
    
    
    
    
    fileprivate func makeanswer()->[[Int]]{
        var buildtrycount = 0
        var lastcount = 0
        
        var numarray : [[Int]] = Array(repeating: Array(repeating: 0,count: 9),count: 9)
        
        var step : Int = 0
        
        repeat {
            start: switch step {
            case (0):
                
                while (!makeanswerfirst (&numarray)){
                    if Runtime.isDebug() {buildtrycount += 1}
                    
                }
                step += 1
                
            case (1):
                
                
                while (!makeanswersecond(&numarray)){
                    if Runtime.isDebug() {buildtrycount += 1}
                }
                step += 1
                
                
                
            case (2):
                out: while (!makeanswerthird(&numarray)){
                    
                        if Runtime.isDebug() {buildtrycount += 1}
                        lastcount+=1
                        
                        
                        step = lastcount%4 == 0 ? 0 : 1
                        
                        if (step == 0){
                            numarray = Array(repeating: Array(repeating: 0,count: 9),count: 9)
                        }else if (step == 1){
                            for i in 3 ..< 6 {
                                for j in 0 ..< 3 {
                                    numarray[i][j] = 0
                                }
                            }
                            for i in 3 ..< 6 {
                                for j in 6 ..< 9 {
                                    numarray[i][j] = 0
                                }
                            }
                        }
                        
                        break start
                        
                        
                    
                }
                
                step += 1
                
            default:
                break
                
            }
            
            
        }while ( step<3 )
        
        //userData!["numarray"] = numarray
        if (Runtime.isDebug()){print("Try " + String ( buildtrycount ) + " times for build the Sudoku")}

        
        return numarray
        
    }
    
    
    fileprivate func makeanswerfirst(_ numarray: inout [[Int]])->Bool{
        
        
        
        // numarray = userData!["answerarray"] as! [[Int64]]
        
        var seq = [1,2,3,4,5,6,7,8,9]
        var shuffledcenter = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: seq)
        var next : Int = 0
        for i in 3...5  {
            
            for j in 3...5{
               
                numarray[j][i] =  shuffledcenter[next] as! Int
                 next += 1
            }
        }
        var shuffled = shuffledcenter
        var shuffleddown = shuffledcenter
        var shuffledmid = shuffledcenter
        shuffled.removeSubrange(0...2)
        shuffleddown.removeSubrange(6...8)
        shuffledmid.removeSubrange(3...5)
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: shuffled)
        shuffleddown = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: shuffleddown)
        shuffledmid = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: shuffledmid)
        
        
        next=0
       
        numarray[0][3] = shuffled[next] as! Int
         next+=1
        numarray[1][3] = shuffled[next] as! Int
         next+=1
        numarray[2][3] = shuffled[next] as! Int
         next+=1
        numarray[6][5] = shuffleddown[next] as! Int
         next+=1
        numarray[7][5] = shuffleddown[next] as! Int
         next+=1
        numarray[8][5] = shuffleddown[next] as! Int
        
        next=0
        for i in 0 ..< 3{
            
            var j = 0;
            while (numarray[0][3] == shuffledmid[j] as! Int || numarray[1][3] == shuffledmid[j] as! Int || numarray[2][3] == shuffledmid[j]as! Int ){
                j+=1;
                if (shuffledmid.count-1 < j) {return false}
            }
            numarray[i][4]=shuffledmid[j] as! Int
            shuffledmid.remove(at: j)
            
            if (shuffledmid.count == 0) {return false}
            
        }
        for i in 6 ... 8{
            
            var j = 0;
            while (numarray[6][5] == shuffledmid[j] as! Int || numarray[7][5] == shuffledmid[j] as! Int || numarray[8][5] == shuffledmid[j]as! Int ){
                
                j+=1
                if (shuffledmid.count-1 < j) {return false}
                
            }
            numarray[i][4]=shuffledmid[j] as! Int
            shuffledmid.remove(at: j)
            //  if (shuffledmid.count == 0) {return false}
            
        }
        
        
        //      shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        for i in 0 ... 5{
            let index = seq.index(of: numarray[i][3])
            if (index != nil){
                seq.remove(at: index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: seq)
        
        
        for i in 0 ..< 3 {
            
            let check = shuffled[i] as! Int
            for j in 6 ..< 9 {
                for k in 4 ..< 6{
                    if (numarray[j][k]==check) {return false}
                    
                }
            }
            numarray[i+6][3] = check
            
            
        }
        
        
        
        seq = [1,2,3,4,5,6,7,8,9]
        for i in 3 ..< 9{
            let index = seq.index(of: numarray[i][5])
            if (index != nil){
                seq.remove(at: index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: seq)
        
        
        
        for i in 0 ..< 3{
            
            let check = shuffled[i] as! Int
            for j in 0 ..< 3{
                for k in 0..<5{
                    if (numarray[j][k]==check) {return false}
                    
                }
            }
            
            numarray[i][5] = shuffled[i] as! Int
            
            
            
        }
        
        
        
        
        
        
        
        
        
        return true
    }
    
    
    fileprivate func makeanswersecond(_ numarray: inout [[Int]])->Bool{
        
        var seq = [1,2,3,4,5,6,7,8,9]
        
        let transposedshuffledcenter = [numarray[5][3],numarray[5][4],numarray[5][5],numarray[4][3],numarray[4][4],numarray[4][5],numarray[3][3],numarray[3][4],numarray[3][5]]
        
        var up = transposedshuffledcenter
        var down = transposedshuffledcenter
        var mid = transposedshuffledcenter
        
        
        up.removeSubrange(6...8)
        down.removeSubrange(0...2)
        mid.removeSubrange(3...5)
        
        
        var shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: up)
        var shuffleddown = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: down)
        var shuffledmid = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: mid)
        
        
        var next=0
        numarray[3][0] = shuffled[next] as! Int
        next+=1
        numarray[3][1] = shuffled[next] as! Int
         next+=1
        numarray[3][2] = shuffled[next] as! Int
         next+=1
        numarray[5][6] = shuffleddown[next] as! Int
         next+=1
        numarray[5][7] = shuffleddown[next] as! Int
         next+=1
        numarray[5][8] = shuffleddown[next] as! Int
        
        next=0
        for i in 0..<3{
            
            var j = 0;
            while (numarray[3][0] == shuffledmid[j] as! Int || numarray[3][1] == shuffledmid[j] as! Int || numarray[3][2] == shuffledmid[j]as! Int ){
                j+=1
                if (shuffledmid.count-1 < j) {return false}
            }
            numarray[4][i]=shuffledmid[j] as! Int
            shuffledmid.remove(at: j)
            
            if (shuffledmid.count == 0) {return false}
            
        }
        for i in 6 ..< 9{
            
            var j = 0;
            while (numarray[5][6] == shuffledmid[j] as! Int || numarray[5][7] == shuffledmid[j] as! Int || numarray[5][8] == shuffledmid[j]as! Int ){
                
                    j+=1
                if (shuffledmid.count-1 < j) {return false}
                
            }
            numarray[4][i]=shuffledmid[j] as! Int
            shuffledmid.remove(at: j)
            //  if (shuffledmid.count == 0) {return false}
            
        }
        
        
        //      shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        for i in 0 ..< 6{
            let index = seq.index(of: numarray[3][i])
            if (index != nil){
                seq.remove(at: index!)
            }
            
            
        }
        
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: seq)
        
        
        for i in 0 ..< 3{
            
            let check = shuffled[i] as! Int
            for j in 6 ..< 9{
                for k in 4 ..< 6{
                    if (numarray[k][j]==check) {return false}
                    
                }
            }
            numarray[3][i+6] = check
            
            
        }
        
        
        
        seq = [1,2,3,4,5,6,7,8,9]
        for i in 3 ..< 9{
            let index = seq.index(of: numarray[5][i])
            if (index != nil){
                seq.remove(at: index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: seq)
        
        
        
        for i in 0 ..< 3{
            
            let check = shuffled[i] as! Int
            for j in 0 ..< 3{
                for k in 3 ..< 5{
                    if (numarray[k][j]==check) {return false}
                    
                }
            }
            
            numarray[5][i] = shuffled[i] as! Int
            
            
            
        }
        
        return true
    }
    
    
    
    
    
    
    
    fileprivate func makeanswerthird(_ numarray: inout [[Int]])->Bool{
        
        //var checkarray :Set<Int> = [numarray[2][3],numarray[2][4],numarray[2][5],numarray[3][2],numarray[4][2],numarray[5][2]]
        var array = [[2,2],[6,6],[2,6],[6,2],
            [1,2],[1,1],[2,1],
            [7,6],[7,7],[6,7],
            [6,1],[7,1],[7,2],
            [2,7],[1,7],[1,6],
            [2,0],[1,0],[0,0],[0,1],[0,2],
            [6,8],[7,8],[8,8],[8,7],[8,6],
            [8,2],[8,1],[8,0],[7,0],[6,0],
            [0,6],[0,7],[0,8],[1,8],[2,8]]
        
        
        
        
        //  let array = [(2,2),(6,2)]
        
        
        var trydisplaycount = 0
        
        var repeatcount = 0
        
        var max = 0
        var maxcount = 0
        
        
        var shuffleseq: [Int] = []
        for i in 1...35 {
            shuffleseq.append(i)
        }
        
    
        var count = 0
        
       repeat {
            
            
            
            
            if ( !minuswithnum(&numarray, array[count][0],array[count][1])){
                
                
                trydisplaycount += 1
                
           
                repeatcount += 1
                
                
                if (repeatcount % 5 == 0){
                    count -= 1
                    if count>max {
                        max = count
                        maxcount = 0
                        
                    }else{
                        maxcount += 1
                        count -= maxcount
                    }
                    
                    if (count < 0 || repeatcount % 120 == 0){
                        count = 0
                        
                        //shuffle array
                        
                        
                        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: shuffleseq)
                        
                        //shuffle 10 set
                        for i in 0...9{
                            let tmp = array[shuffled[i*2] as! Int]
                            array[shuffled[i*2] as! Int] = array[shuffled[i*2+1] as! Int]
                            array[shuffled[i*2+1] as! Int] = tmp
                        }
                        
                        
                        
                    }
                    if (repeatcount >= 600){
                        maxcount = 0
                        
                        //break start
                        return false
                    }
                }
                
            }else{
                count += 1
                
            }
            
            
        } while (count<array.count)
        
        
        if (Runtime.isDebug()){
            print ( "Try " + String(trydisplaycount) + " for outer Sudoku")
        }
        
        
        
        
        
        
        return true
    }
    
    

    
    func makefilling()->[[Bool]]{
       return makefilling(self.level)
    }
    

    
    
    func makefilling(_ level: Int)->[[Bool]] {
        
        
        
        
        // var  numarray :[[Int]] = userData!["numarray"] as! Array
        
        // build array for filling information (User input)
        
        
        
        var fillingarray : [[Bool]] = Array(repeating: Array(repeating: false,count: 9),count: 9)
        
        // Dismiss
        var numofdismiss = level + 20
        
        // Add random +/-3 pcs
        
        numofdismiss += Int(arc4random() % 6) - 3
        
        if (numofdismiss > 70){
            numofdismiss = 70
        }
        
        
        
        //Loop for every 3x3 section and randomly skip one
        
        var section : Int = 4
     
     
        
        srandom (UInt32(Date().timeIntervalSinceReferenceDate))
        var sectionvac : [Int] = Array(repeating: 0,count: 9)
        var max = 0
        
        for _ in 0...numofdismiss {
            
            
            
            
            
            var trycounter = 0;
            while (true) {
                var tempsection = 0
                repeat{
                tempsection = Int(arc4random_uniform(9))
                }while (tempsection == section || sectionvac[tempsection]>=9)
            
            if (max < sectionvac[tempsection]-1 || trycounter > 3) {
                    section = tempsection
                break;
            }
            
            trycounter += 1
                
                
            }
            
            sectionvac[section] += 1
            
            if sectionvac[section] > max {
                max = sectionvac[section]
            }

            
            let sx : Int = section / 3 * 3
            let sy : Int = section % 3 * 3
        
            
            
            var tempx = 0
            var tempy = 0
            
            repeat{
                tempx = sx + Int(arc4random_uniform(3))
                tempy = sy + Int(arc4random_uniform(3))
            }while fillingarray[tempx][tempy]
            
        
            
            fillingarray[tempx][tempy] = true;
            
            
            
            
        }
        
        if (Runtime.isDebug()){
            print ( "Finished Filling array")
        }

        
        
       //  userData!["fillingarray"] = fillingarray
        return fillingarray
        
    }
    
    var test = 0;
    
   /*
    func finishedbuildsudokunum(){
        
    
        if (Runtime.isDebug()){
            if test++ == 5{
            print ( "Finished build sudoku num - \(dispatch_source_get_data(dispatch_source_finished_buildsudoku))")
            }
            }

    }
    */
    
    
    func minuswithnum(_ numarray: inout [[Int]],_ x:Int,_ y:Int )->Bool{
        
        var array: Set<Int> = []
        
        numarray[x][y] = 0
        
         for i in 0...8{
      //  for i in 0 ..< 9 += 1 {
            
            if (numarray[i][y] != 0){
                array.insert(numarray[i][y])}
            
            if (numarray[x][i] != 0){
                
                array.insert(numarray[x][i])}
        }
        
        let sectionx:Int = (x / 3) * 3
        
        let sectiony:Int = (y / 3) * 3
        
        for i in sectionx ... sectionx+2{
        
       // for i in sectionx ..< sectionx+2 += 1{
            for j in sectiony ..< sectiony+3{
           // for j in sectiony ..< sectiony+2 += 1{
                if numarray[i][j] != 0{
                    array.insert(numarray[i][j])
                }
                
                
            }
        }
        
        
        var seq = [1,2,3,4,5,6,7,8,9]
        for n in array {
            
            seq.remove(at: seq.index(of: n)!);
            /*
            
            for var i = 0 ;i < seq.count;++i{
                if (seq[i] == n){
                    seq.removeAtIndex(i)
                }
            }*/

        }
        
        if (seq.count == 0){
            return false
        }
        
        
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: seq)
        
        numarray[x][y] = shuffled[0] as! Int
        
        
        return true
    }
    

    


    
    
    // MARK: - Cache Database
    
    
    
    func readdatabasetable()->Bool{
      return  readdatabasetable(level)
        
        
    }
    
    
    func readdatabasetable(_ level: Int)->Bool{
        
       let tableFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sudoku_table")
        
        var sortDescriptors:[NSSortDescriptor] = []
        sortDescriptors.append(NSSortDescriptor(key:"table",ascending: false))
      
        tableFetch.predicate = NSPredicate(format: "level == %d", level)
        
        tableFetch.sortDescriptors = sortDescriptors
        
        
       
        
        do {
            let fetchedtable = try modelcontroller.managedObjectContext.fetch(tableFetch) as! [Sudoku_table]
          //  if Runtime.isDebug(){
                
                if (fetchedtable.count > 0){
                    if (Runtime.isDebug()){
                     print("date:\(String(describing: fetchedtable[0].table)),level:\(String(describing: fetchedtable[0].level))")
                    }
                    let cardFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sudoku_card")
                    
                    var cardsortDescriptors:[NSSortDescriptor] = []
                    cardsortDescriptors.append(NSSortDescriptor(key:"pos",ascending: true))
                    
                    cardFetch.predicate = NSPredicate(format: "table == %@", fetchedtable[0])
                    
                    cardFetch.sortDescriptors = cardsortDescriptors
                    
                    
                      
                    
                    
                    do {
                        let fetchedcard = try self.modelcontroller.managedObjectContext.fetch(cardFetch) as! [Sudoku_card]
                 
                            
                            if (fetchedcard.count == 81){
                                
                                
                            var numarray : [[Int]] = Array(repeating: Array(repeating: 0,count: 9),count: 9)
                                var fillingarray : [[Bool]] = Array(repeating: Array(repeating: false,count: 9),count: 9)
                                
                      
                                for i in 0  ... 80 {
                                    
                                    fillingarray[i/9][i%9] = (fetchedcard[i].editable==1 ? true:false)
                                    numarray[i/9][i%9] = (fetchedcard[i].num as! Int)
                                    if (Runtime.isDebug()){
                                    print("pos:\(fetchedcard[i].pos as! Int),num:\(fetchedcard[i].num as! Int)")
                                    }
                                }
                              //  objc_sync_enter(self)
                                self.userData!["numarray"] = numarray;
                                self.userData!["fillingarray"] = fillingarray;
                             //   objc_sync_exit(self)
                             
                                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                                privateMOC.parent = self.modelcontroller.managedObjectContext
                                
                                privateMOC.perform {
                          
                            self.modelcontroller.managedObjectContext.delete(fetchedtable[0])
                                    do{
                                try self.modelcontroller.managedObjectContext.save()
                                    }catch{
                                        
                                    }
                                }

                                if self.preference["increase_level"] as! Bool{
                                    
                                        self.buildsudokutable(true,self.level+1,2)
                                }else
                                {
                                    self.buildsudokutable(true,self.level,2)
                                    
                                }
                                
                                return true
                                

                            }else{
                                
                                let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                                privateMOC.parent = self.modelcontroller.managedObjectContext
                                
                                privateMOC.perform {
                                
                                self.modelcontroller.managedObjectContext.delete(fetchedtable[0])
                                    do{
                                try self.modelcontroller.managedObjectContext.save()
                                    }catch{
                                        
                                    }
                                }
                                return false
                        }
                        
                        
                    }
                    catch{
                        return false
                        // fatalError("Failed to found Sudoku_card: \(error)")
                    }
                      
                    
                    
                }else{
                    return false
                        }
                
                        
                
            
        
        } catch {
            return false
            //fatalError("Failed to found Sudoku_table: \(error)")
        }
        
        
        
     //   var  numarray :[[Int]] = userData!["numarray"] as! Array
     //   var  fillingarray :[[Bool]] = userData!["fillingarray"] as! Array
    }
    
    
    func databasemodeltable(_ numarray : [[Int]],_ filledarray:[[Bool]])->Sudoku_table{
       return  databasemodeltable(numarray, filledarray,self.level)
    }
    
    
    
    
    
    func databasemodeltable(_ numarray : [[Int]],_ filledarray:[[Bool]],_ level : Int)->Sudoku_table{
        
        
        
        
        
        
        
        
        
        
        
        
        let sudoku_table : Sudoku_table =  NSEntityDescription.insertNewObject(forEntityName: "Sudoku_table", into: self.modelcontroller.managedObjectContext) as! Sudoku_table
        
        
        sudoku_table.table = Date()
        
        
        
        var pos = 0;
        
        
        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = self.modelcontroller.managedObjectContext
        
        privateMOC.perform {
         sudoku_table.level = level as NSNumber
        
        for i in 0...8{
            for j in 0...8{
                let sudoku_card : Sudoku_card =  NSEntityDescription.insertNewObject(forEntityName: "Sudoku_card",    into: self.modelcontroller.managedObjectContext) as! Sudoku_card
                
                sudoku_card.num = numarray[i][j] as NSNumber
                sudoku_card.editable = filledarray[i][j] as NSNumber
                pos += 1
                sudoku_card.pos = pos as NSNumber
                
               
                sudoku_table.mutableSetValue(forKey: "card").add(sudoku_card)
                
            }
        }
        
        
        
        // sudoku_table.table = NSDate()
        
        
        
        //sudoku_table.mutableSetValueForKey("card").addObject(sudoku_card)
        
        
        
        
        
        
        /*
        
        let sudoku_tableFetch = NSFetchRequest(entityName: "Sudoku_table")
        
        do {
        let fetchedSudoku_table = try modelcontroller.managedObjectContext.executeFetchRequest(sudoku_tableFetch) as! [Sudoku_table]
        fetchedSudoku_table.endIndex
        } catch {
        fatalError("Failed to fetch employees: \(error)")
        }
        
        
        
        
        let sudoku_cardFetch = NSFetchRequest(entityName: "Sudoku_card")
        
        
        do {
        var fetchedSudoku_card = try modelcontroller.managedObjectContext.executeFetchRequest(sudoku_cardFetch) as! [Sudoku_card]
        var sudoku_card = Sudoku_card();
        sudoku_card.card = 1;
        
        
        
        } catch {
        fatalError("Failed to fetch employees: \(error)")
        }
        
        
        */
        
        
        
        do {
            try self.modelcontroller.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        }
        
        return sudoku_table
        
    }
    
    
    func deleteall(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: modelcontroller.managedObjectContext)
        fetchRequest.includesPropertyValues = false
        
        
      //  let privateMOC = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
      //  privateMOC.parentContext = self.modelcontroller.managedObjectContext
        
      //  privateMOC.performBlock {
        
        
        do {
            if let results = try self.modelcontroller.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    self.modelcontroller.managedObjectContext.delete(result)
                }
                
                try self.modelcontroller.managedObjectContext.save()
            }
        } catch {
            
            if (Runtime.isDebug()){
                
                
                print ( "failed to delete the entity\(entity)")
            }

            
            
        }
        //}
    }
    
    
    func savecurrenttable(){
        
        deleteall("Sudoku_restore")
        
        
      
        
      
        if isShowNextGameLogo{
            return
        }
     
      
        
        
        
  
 
        do{
        for i in 9...89 {
            
            
            let sudoku_restore : Sudoku_restore =  NSEntityDescription.insertNewObject(forEntityName: "Sudoku_restore", into: self.modelcontroller.managedObjectContext) as! Sudoku_restore
            let node = self.children[i] as! SudokuBoxSKNode
            let editable  = node.userData!["editable"] as! NSNumber
            let correctnum = node.userData!["correctnum"] as! NSNumber
            let fillednum  = node.userData!["fillednum"] as! NSNumber
            
            
            sudoku_restore.editable =  editable
            sudoku_restore.num =  correctnum
            sudoku_restore.fillednum = fillednum
            sudoku_restore.pos = (i - 9) as NSNumber
            }

          try self.modelcontroller.managedObjectContext.save()
        }catch {
            
            if (Runtime.isDebug()){
                
                
                print ( "failed to save current table")
            }
            
            
            
        
        
        if (Runtime.isDebug()){
            
            
            print ( "Finished save current table")
                    }
        
        }
        
        
        
        
           AppDelegate.writePreference("lastselectedbox",userData!["selectedbox"] as! Int as CFPropertyList)
        
    }
        
    
    
    
    fileprivate func checkwiththislevel(_ level: Int)->Bool{
        
        
        let tableFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sudoku_table")
        
        var sortDescriptors:[NSSortDescriptor] = []
        sortDescriptors.append(NSSortDescriptor(key:"table",ascending: false))
        
        tableFetch.predicate = NSPredicate(format: "level == %d", level)
        
        tableFetch.sortDescriptors = sortDescriptors
        
        do {
            let fetchedtable = try modelcontroller.managedObjectContext.fetch(tableFetch) as! [Sudoku_table]
            if fetchedtable.count == 0{
                
                return false
            }
            
        }catch{
            fatalError("Failed to found Sudoku_table: \(error)")
        }
        
        if Runtime.isDebug(){
            print("Database with this \(level).")
        }
        return true
        
    }

    
    
    
    func retrievecurrenttable()->Bool{
        
        let cardFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Sudoku_restore")
        
        
        
        var cardsortDescriptors:[NSSortDescriptor] = []
        cardsortDescriptors.append(NSSortDescriptor(key:"pos",ascending: true))
        
        
        
        cardFetch.sortDescriptors = cardsortDescriptors
        
        do {
            let fetchedcard = try modelcontroller.managedObjectContext.fetch(cardFetch) as! [Sudoku_restore]
            
            
            if (fetchedcard.count == 81){
                
                
                var numarray : [[Int]] = Array(repeating: Array(repeating: 0,count: 9),count: 9)
                var fillednumarray : [[Int]] = Array(repeating: Array(repeating: 0,count: 9),count: 9)
                var fillingarray : [[Bool]] = Array(repeating: Array(repeating: false,count: 9),count: 9)
                
                
                for i in 0  ... 80 {
                    
                    fillingarray[i/9][i%9] = (fetchedcard[i].editable==1 ? true:false)
                    numarray[i/9][i%9] = (fetchedcard[i].num as! Int)
                    fillednumarray[i/9][i%9] = (fetchedcard[i].fillednum as! Int)
                    
                    if (Runtime.isDebug()){
                        print("pos:\(fetchedcard[i].pos as! Int),num:\(fetchedcard[i].num as! Int)")
                    }
                }
                
                userData!["numarray"] = numarray
                userData!["fillingarray"] = fillingarray
                
                userData!["selectedbox"] =  preference["lastselectedbox"]
                (children[userData!["selectedbox"] as! Int] as! SudokuBoxSKNode).setSelected()
                
                
                
                for i in 0 ... 8 {
                    
                    for j in 0 ... 8{
                        let node = children[9+i*9+j] as! SudokuBoxSKNode
                        if (fillingarray[i][j]){
                            numTotalfillBox += 1
                            if (fillednumarray[i][j] > 0){
                                numfilledBox += 1
                            }
                        }
                        
                        node.setNumValue(numarray[i][j], fillingarray[i][j],false,fillednumarray[i][j])
                        
                        node.checkcorrect()
                        
                    }
                }
                
                refreshHint()
                
                
                return true
                
                
            }else{
                return false
            }
        }catch{
            
            if (Runtime.isDebug()){
                
                
                print ( "failed to retrieve current table")
                
            }
            return false
            
        }
    }
    
    
    //MARK: - Refreshing

    func refreshHint(){
        self.setAllShowhint(preference["auto_hint"] as! Bool)
        self.updatehint()
    }
    
    
    // MARK: - Startup Process
    
    func buildupcachetable(){
      
            let second : Double = 10
        
           let time = DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            self.concurrencySudokuBackGroundQueue.asyncAfter(deadline: time){
                
                // Build Selected Level Cache
                for i in 0...4{
                    
                  //  let int_time = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                  //  dispatch_after(int_time, self.concurrencySudokuBackGroundQueue){

                    
                    let level =  self.preferenceleveltolevel(i)
                    self.buildsudokutable(true,level,Double(3 * (i + 1)))
                  //  }
                    
                }
                
                
                // Build Next Level Cache
                
                //self.buildsudokutable(true,self.level+1,3)
                
                // Build This Level Cache
                //self.buildsudokutable(true,self.level+1,3)
                

                
                
            }
            
        
        
        
        
        
        
    }
    
    
    func startupNumRestore(){
    
    
        
        if (!retrievecurrenttable()){
            newsudoku()
            buildupcachetable()
            return
        }


        refreshHint()
    
       
    
    
 
    }
   
    func undotext(){
        
    }
    
    // MARK: - LifeCycle

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
/*
        dispatch_source_finished_buildsudoku = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, concurrencySudokuQueue)
        
        dispatch_source_set_event_handler(dispatch_source_finished_buildsudoku){
            
            self.finishedbuildsudokunum();
        }
        
         dispatch_resume(dispatch_source_finished_buildsudoku)
        
  */
        
       
     
       
        userData = NSMutableDictionary()
   
        
        
        userData!["selectedbox"] = -1
        
        
        
       
        
        //userData!["allcheckcorrect"] = false
        //userData!["showhint"] = false
     
        
        
      //  userData!["showhint"] = false
       // var numarray: [[Int]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
        
   //   buildsudokutable ()
        
        
        
    //  let level = 3 + (preference["selectedgamelevel"] as! Int) * 3
            // numarray = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
        
      //  var  fillingarray :[[Int]] = userData!["fillingarray"] as! Array

        
       // databasemodeltable(numarray,fillingarray)
        
        
        let offset :CGFloat = 10
        let groupgap :CGFloat = 15

        let maxX :CGFloat = self.frame.maxX
        let maxY  :CGFloat =  self.frame.maxY
        let minX  :CGFloat =  self.frame.minX
        let minY  :CGFloat = self.frame.minY
        let stepX  :CGFloat =  (maxX-minX-offset*2-groupgap*2)/9
        let stepY  :CGFloat =  (maxY-minY-offset*2*0.75-groupgap*2)/9
        
        
        for i in 0...2 {
            
            for j in 0...2{
   
                
                let gapoffsetx = offset + groupgap * CGFloat (i)
                let gapoffsety = 0.75 * offset + groupgap * CGFloat(j)
                
              //  let rect = CGRectMake(gapoffsetx + (CGFloat (i) * stepX), self.frame.maxY - gapoffsety - ( CGFloat (j) * stepY + stepY), stepX, stepY)
            
            let bigrect = CGRect(x: gapoffsetx + (CGFloat (i*3) * stepX),  y: self.frame.maxY - gapoffsety - ( CGFloat (j*3) * stepY )-stepY*3, width: stepX*3, height: stepY*3)
            let drawpath = CGPath(roundedRect: bigrect, cornerWidth: offset, cornerHeight: offset, transform: nil)
            let bigshapenode = SKShapeNode(path: drawpath)
            bigshapenode.fillColor = GameScene.bigframecolor
            self.addChild(bigshapenode)
            
                }
            
        }

        
        
        
        for i in 0 ... 8 {
            
            for j in 0 ... 8{
                
 
        

        
       let shapenode = SudokuBoxSKNode()
        
        let gapoffsetx = offset + CGFloat(i / 3) * groupgap
        let gapoffsety = 0.75 * offset + CGFloat(j / 3) * groupgap
                
        let rect = CGRect(x: gapoffsetx + (CGFloat (i) * stepX), y: self.frame.maxY - gapoffsety - ( CGFloat (j) * stepY + stepY), width: stepX, height: stepY)
                
            shapenode.BuildupBox(rect,0,9+i*9+j,false)
         
                
            //    shapenode.BuildupBox(rect,numarray[i][j],9+i*9+j,fillingarray[i][j])

                
            
                
         self.addChild(shapenode)
                
            }
        }
        
       //  shapenode.position = CGPointMake(800,600)
        
        
        
     
            
        
      
            
            startupNumRestore()
            
             updateAllAutoCheck()
            
      
        
        
        
        
 
         
      
    }
    
    
    
    
    override func willMove(from view: SKView) {
       
            
        
        
        savecurrenttable()
        
       
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        
        
        
    }
    
    func finishedcheck(){
    
        
        let second : Double = 1
        
        let time = DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        GlobalMainQueue.asyncAfter(deadline: time){
        var correctnum = 0
        for i in 9...89 {
            let node = self.children[i] as! SudokuBoxSKNode
            if node.checkcorrect(){
                correctnum += 1
            }
        }

        if correctnum != self.numTotalfillBox {
            return
            }
            
            
            
            
                  self.shownextsudoku()
        }
        
        
        
  
    }
    
    
    func showstartsudoku(){
       // _isShowNextGame = true
        let shapenode = SKShapeNode()
        let lablenode = SKLabelNode()
        
        
        
        
        let drawpath = CGMutablePath()
        
        var drawrect = self.calculateAccumulatedFrame()
        
        
        shapenode.position = CGPoint(x: drawrect.size.width/2, y: drawrect.size.height/2)
        drawrect.size.height /= 3
        drawrect.size.width /= 2
        drawrect.origin.x -= drawrect.size.width / 2
        drawrect.origin.y -= drawrect.size.height / 2
        
        
        drawpath.__addRoundedRect(transform: nil, rect: drawrect,cornerWidth: 25,cornerHeight: 25)
        drawpath.closeSubpath()
        
        
        lablenode.fontName = "Chalkduster"
        lablenode.fontSize = 48
        lablenode.text = NSLocalizedString("buildgametext", comment: "Build Game Text")
        lablenode.color = buildgameboxtextColor
        lablenode.position.y -= 50
        
        lablenode.zPosition = 110
        
        
        lablenode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        //CGPathAddLineToPoint(drawpath,nil,-100,-100);
        
        shapenode.name = "buildgame"
        shapenode.path = drawpath;
        
        shapenode.fillColor = buildgameboxfilledColor
        // shapenode.fillColor = noneditColor
        shapenode.lineWidth = 0
        shapenode.lineJoin = CGLineJoin.round
        
        shapenode.zPosition = 100
        
        
        // lablenode.alpha = 0
        
        
        
       // let action = SKAction.fadeAlpha(to: shapenode.alpha, duration: 1.5)
      // shapenode.alpha = 0
        
        self.addChild(shapenode)
        shapenode.addChild(lablenode)
     //   shapenode.run(action)
        //lablenode.runAction(action)
        
        
        
        
        
        
        
        
        
        
    }
    
    
    func shownextsudoku(){
         _isShowNextGame = true
        let shapenode = SKShapeNode()
        let lablenode = SKLabelNode()
        
        
        
        
        let drawpath = CGMutablePath()
        
        var drawrect = self.calculateAccumulatedFrame()
        
        
        shapenode.position = CGPoint(x: drawrect.size.width/2, y: drawrect.size.height/2)
        drawrect.size.height /= 3
        drawrect.size.width /= 2
        drawrect.origin.x -= drawrect.size.width / 2
        drawrect.origin.y -= drawrect.size.height / 2
        
        
        drawpath.__addRoundedRect(transform: nil, rect: drawrect,cornerWidth: 25,cornerHeight: 25)
        drawpath.closeSubpath()
        
        
        lablenode.fontName = "Chalkduster"
        lablenode.fontSize = 48
        lablenode.text = NSLocalizedString("nextgametext", comment: "Next Game Show Text")
        lablenode.color = finishedboxtextColor
        lablenode.position.y -= 50
        
           lablenode.zPosition = 110
        

        lablenode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        //CGPathAddLineToPoint(drawpath,nil,-100,-100);
        
        shapenode.name = "nextgame"
        shapenode.path = drawpath;
        
        shapenode.fillColor = finishedboxfilledColor
        // shapenode.fillColor = noneditColor
        shapenode.lineWidth = 0
        shapenode.lineJoin = CGLineJoin.round
        
        shapenode.zPosition = 100
        
       
       // lablenode.alpha = 0
     
        
        
        let action = SKAction.fadeAlpha(to: shapenode.alpha, duration: 1.5)
         shapenode.alpha = 0
        
         self.addChild(shapenode)
        shapenode.addChild(lablenode)
        shapenode.run(action)
        //lablenode.runAction(action)
     
    
        
       

        
        
 
        
       
    }
    
    
    func startNextGame(){
        if isShowNextGame {
        
            if self.childNode(withName: "nextgame")!.hasActions(){
                return
            }
            
            self.isClosingNextGame = true
            self._isShowNextGame = false
            
            let fadeoutAction = SKAction.fadeOut(withDuration: 1.5)
            let runaction = SKAction.run(){
                
            }
            let removeAction = SKAction.removeFromParent()
            let seqAction : [SKAction] = [fadeoutAction,runaction,removeAction]
            
            let action = SKAction.sequence(seqAction)
            
            if (preference["increase_level"] as! Bool){
            if !selectedlevelchangenexttime {
     
                if level < GameScene.MAXLEVEL  {
                  
                
                
                    level += 1
                AppDelegate.writePreference("level",level as CFPropertyList)

            for i in 0...5 {
                if level ==  preferenceleveltolevel(i){
                    appDelegate.ResetLevlMenu(i)
                    break;
                                }
                
                            }
                    }
            }else{
            selectedlevelchangenexttime = false
                }
            
            }
            
       childNode(withName: "nextgame")!.run(action)
         
            
           
            
        
            
    
            
            
            newsudoku()
        }
    }
    
    
        // MARK: - User Input
    
    override func mouseDown(with theEvent: NSEvent) {
        
        
        
        /* Called when a mouse click occurs */
        
        if isClosingNextGame{
            return
        }
      
        
        if (isShowNextGame){
            
            startNextGame()
                
            
         return
            
        }
        
    }
    
    
        
    
 
    override func keyDown(with theEvent: NSEvent) {
        // if (!userData["editable"]){
        //  return
        //      }
        
        if isClosingNextGame{
            return
        }
        
        if isShowNextGame{
            startNextGame()
            return
            
        }
        
      
   
        
        if (Runtime.isDebug()){
            let char = theEvent.characters!
            
            
           
            
                if (char == "t"){
                    
                    for i in 9...89 {
                        let node = self.children[i] as! SudokuBoxSKNode
                        node.updatehint()
                        if node.userData!["fillednum"] as! Int == 0 && node.userData!["editable"] as! Bool == true {
                            
                            node.userData!["fillednum"] = node.userData!["correctnum"]
                           (node.children[0].children[0] as! SKLabelNode).text = String (node.userData!["fillednum"] as! Int)
                            node.checkcorrect()
                            node.updatehint()
                            numfilledBox += 1
                            }
                        if numfilledBox == numTotalfillBox-1 {
                            break
                            }
                        }
                        
                    }
 
                    
                }

        
 
        
        if userData!["selectedbox"] as! Int == -1{
                return
        }
        
            
        

       

    
        
        
        var nonfill = false
        let node = children[userData!["selectedbox"] as! Int ] as! SudokuBoxSKNode
        
      
       // undoM.prepareWithInvocationTarget(self).undochangetext(node.userData!["fillednum"] as! Int)
       // undoM.setActionName("Num Change")
        
       // undoM.undo()
        
        
        if (node.userData!["fillednum"] as! Int == 0){
            nonfill = true
                   }
        
        if (!node.changetext(theEvent)){
            
            interpretKeyEvents([theEvent])
        }else{
        
     
            
            
            
            if nonfill {
            numfilledBox += 1
            }
            
            if (numTotalfillBox == numfilledBox){
                finishedcheck()
            }

        }
        updatehint()
        
    }
    
    func selectnearcenter(){
        
        let selectedbox = userData!["selectedbox"] as! Int
        if ( selectedbox != -1){
           (children[selectedbox] as! SudokuBoxSKNode).setDeselected()
         
        }
      
        var selected = 49
        var step = 0
        var stepcount = 0
        var turn = 0
        while (!(children[selected] as! SudokuBoxSKNode).isEditable()){
            
            switch turn {
        
            case 0:
                selected += 1
            case 1:
                selected += 9
            case 2:
                selected -= 1
            
            case 3:
                selected -= 9
               
            default:
                break
            }
            
            if (stepcount == step){
                stepcount = 0
                turn += 1
                if turn == 4 {
                    turn = 0
                }
                if turn  == 2 {
                    step += 1
                }
            }else{
                stepcount += 1
            }
            
            
        }
        
        (children[selected] as! SudokuBoxSKNode).setSelected()
        
        userData!["selectedbox"] = selected
        
    }
    

    
    func shiftcheck(_ direction : Int)->Int{
        
        func tobox(_ x:Int,_ y:Int)->Int{
            return x * 9 + y + 9
        }
        
        func frombox(_ box:Int)->(x:Int,y:Int){
            let b = box - 9
            let x = b / 9
            let y = b % 9
            return (x,y)
        }
        
        func within(_ x:Int,_ y:Int)->Bool{
            if x < 0{
                return false}
            if y < 0{
                return false}
            if x > 9{
                return false}
            if y > 9{
                return false}
            
            return true
        }
        
        func matrix (_ x:Int,_ y:Int,_ direction:Int)->[Int]{
            var raw :[[Int]] = []
            for i in 1...8{
                raw.append([i,0])
                for j in 1...i{
                    raw.append([i,j])
                    raw.append([i,-j])
                }
            }
            
            var trans_matrix :[[Int]] = []
            switch (direction){
            case 0:  //0 Left
                trans_matrix = [[1,0],[0,1]]
            case 1:  //90 Down
                trans_matrix = [[0,-1],[1,0]]
            case 2:  //180 Right
                trans_matrix = [[-1,0],[0,-1]]
            case 3:  //270 Up
                trans_matrix = [[0,1],[-1,0]]
            default:
                break
            }
            
            var checkpos :[Int] = []
            for i in raw {
                let z = i[0] * trans_matrix[0][0] + i[1] * trans_matrix[0][1] + x
                let j = i[0] * trans_matrix[1][0] + i[1] * trans_matrix[1][1] + y
                
                if (z >= 9 || j >= 9 || z < 0 || j < 0){
                continue;
                }
                
                
                
                checkpos.append(tobox(z,j))
                
                
            }
            
            
            
            return checkpos
            
            
        }
       
        
        
        
        
        
        let selectedbox = userData!["selectedbox"] as! Int
       
        let matrixbox = frombox(selectedbox)
        
        let keypath = matrix(matrixbox.x,matrixbox.y,direction)
       
        
        var boxnum = -1;
        
        for i in keypath {
            let box = children[i] as! SudokuBoxSKNode
            if box.isEditable(){
                boxnum = i
                break
            }
        }
        
        if (boxnum == -1){
            return -1
        }
        /*
        
        var add:Int = 1
        while (!((children[selectedbox + add] as! SudokuBoxSKNode).isEditable())){
        add += 1
        
        if (add+selectedbox >=  90){
        return
        }
        }
        
        */
        
        userData!["selectedbox"] = boxnum
        
        updateselectedbox(selectedbox)
        
        
        return boxnum
    
    
    }
    
    override func moveUp(_ sender: Any?) {
        shiftcheck(3)
        
        
        
    }
    
    override func moveDown(_ sender: Any?) {
        
         shiftcheck(1)
        /*
        
        let selectedbox = userData!["selectedbox"] as! Int
        if ( selectedbox == -1){
            //selectnearcenter()
            return
        }
        
        if (selectedbox == 89){
            return
        }
        
       */
        /*
        var boxnum = -1;
        
        for i in result {
            let box = children[i] as! SudokuBoxSKNode
            if box.isEditable(){
               boxnum = i
                break
            }
        }
        
        if (boxnum == -1){
                return
        }*/
        /*
        
        var add:Int = 1
        while (!((children[selectedbox + add] as! SudokuBoxSKNode).isEditable())){
            add += 1
          
            if (add+selectedbox >=  90){
                return
            }
        }
        
        */
        /*
        userData!["selectedbox"] = boxnum
        
        updateselectedbox(selectedbox)
        */
    }
    
    override func moveLeft(_ sender: Any?) {
        shiftcheck(2)
        /*
        let selectedbox = userData!["selectedbox"] as! Int
        if ( selectedbox == -1){
           // selectnearcenter()
            return
        }
        
        //if (selectedbox  < 18){
        //return
        //}
        
        
        var minus:Int = 0
        
        repeat {
            minus += 9
            if (selectedbox - minus < 9){
                minus -= 82 }
            
            if (selectedbox - minus >= 90){
                return
            }
            
            //return
        }while !((children[selectedbox - minus] as! SudokuBoxSKNode).isEditable())
        
        
        
        userData!["selectedbox"] = selectedbox - minus
        
        updateselectedbox(selectedbox)*/
        
    }
    
    override func moveRight(_ sender: Any?) {
        shiftcheck(0)
        /*
        let selectedbox = userData!["selectedbox"] as! Int
        if ( selectedbox == -1){
          //  selectnearcenter()
            return
        }
        
        // if (selectedbox >= 81){
        //     return
        // }
        
        var add:Int = 0
        repeat{
            add += 9
            
            
            if (add+selectedbox >= 90){
                add -= 82
            }
            if (add+selectedbox <= 8){
                return
            }
        }while !((children[selectedbox + add] as! SudokuBoxSKNode).isEditable())
        
        userData!["selectedbox"] = selectedbox + add
        
        updateselectedbox(selectedbox)*/
        
    }
    
    

       // MARK: - Menu and Checking 
    
   
    
    func updateselectedbox(_ previous: Int){
        (children[previous] as! SudokuBoxSKNode).setDeselected()
    (children[userData!["selectedbox"] as! Int] as! SudokuBoxSKNode).setSelected()
        
        
    }
    
    
    

    func checkallboxcorrect()->Int{
        var numofcorrect : Int = 0
        DispatchQueue.main.async{
        for i in 9...89 {
            let node = self.children[i] as! SudokuBoxSKNode
            if (node.checkcorrect()){
                numofcorrect += 1
            }
        }
        }
        
        return numofcorrect
    }
    
    
    func hintonlyselector(_ sender: NSMenuItem){
        let selected = userData!["selectedbox"] as! Int
        
        if (selected == -1){
            return
        }
        
        let node = children[selected] as! SudokuBoxSKNode
        
        node.updatehint(true)
        

    }
    
     func autocheckcorrect(_ sender: NSButton) {
        
        var changecolor = false
        
        if (sender.state == NSControl.StateValue.on){
            //sender.state = NSOnState
              preference["auto_check"] = true as AnyObject
            AppDelegate.writePreference("auto_check", true as CFPropertyList)
            changecolor = true
           // checkallboxcorrect()
            
            
        }else{
       // sender.state = NSOffState
             preference["auto_check"] = false as AnyObject
             AppDelegate.writePreference("auto_check", false as CFPropertyList)
            
         
            
        }
        
        for i in 9...89 {
            let node = children[i] as! SudokuBoxSKNode
            node.correctChangeColor(changecolor)
        }

        
        if (Runtime.isDebug()){
            print ( "select all input check  @ GameScene" + String (describing: preference["auto_check"]) )
        }
        
        
        
      
    }
    
    func checkcorrectonlyselect(_ sender: NSMenuItem) {
        if (Runtime.isDebug()){
            print ( "select check only this  @ GameScene")
        }
        
        let selected = userData!["selectedbox"] as! Int
        
        if (selected == -1){
            return
        }
        
        let node = children[selected] as! SudokuBoxSKNode
        
        if node.correctChangeColor {
             return
        }
        
            
        if node.checkcorrect(){
             (node.children[0].children[0] as! SKLabelNode).fontColor = GameScene.editCorrectColor
        }
        
        let second : Double = 5
        
        let time = DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        GlobalMainQueue.asyncAfter(deadline: time){
          
            if node.correctChangeColor {
                return
            }
            (node.children[0].children[0] as! SKLabelNode).fontColor = GameScene.editInCorrectColor
                
         

            
        
        }

        
        
           // checkallboxcorrect()
        
        
    }
    
    
    
    
   func autoshowhint(_ sender: NSButton) {
        if (Runtime.isDebug()){
            print ( "select hint @ GameScene ")
        }
        if (sender.state == NSControl.StateValue.on){
         //   sender.state = NSOnState
            preference["auto_hint"] = true as AnyObject
            //userData!["showhint"] = true
            self.setAllShowhint(true)
            
        }else{
         //   sender.state = NSOffState
           preference["auto_hint"] = false as AnyObject

            // userData!["showhint"] = false
              self.setAllShowhint(false)
        }
    
    
     AppDelegate.writePreference("auto_hint", preference["auto_hint"]!)
  
    updatehint()
    }
    
    func setAllShowhint(_ isShowhint: Bool){
        
        for i in 9...89 {
            let node = children[i] as! SudokuBoxSKNode
            node.setShowhint(isShowhint)
        }
        
    }
    
    
    func updateAllAutoCheck(){
        
        let check = preference["auto_check"] as! Bool
        
        for i in 9...89 {
            
            let node = self.children[i] as! SudokuBoxSKNode
            node.correctChangeColor(check)
        }
    }

    
    
    
    func updatehint(){
        
        GlobalMainQueue.async{

        for i in 9...89 {
            let node = self.children[i] as! SudokuBoxSKNode
            node.updatehint()
            }
        }
    }
    
    
    func updatetextfadeout(){
        for i in 9...89 {
            let node = self.children[i] as! SudokuBoxSKNode
            node.updatetextfadeIn()
        }
    }
    
    /*
    func writepreference(key: String,_ value:CFPropertyList){
     CFPreferencesSetAppValue(key, value,kCFPreferencesCurrentApplication)
      CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
    }*/
    
    
    
    
    
    func pushcolorchange(_ key: String){
        
        
        switch (key){
        
       
        case "non_edit":
            fallthrough
 
        case "edit_correct":
            fallthrough
        case "edit_incorrect":
            fallthrough
        case "stroke":
            fallthrough
        case "hint_num":
            for i in 9...89 {
                
               let node = children[i] as! SudokuBoxSKNode
                node.updatecolor(key)
            }
            

        case "big_frame":
            for i in 0...8 {
            let bigshapenode = children[i] as! SKShapeNode
            bigshapenode.fillColor = GameScene.bigframecolor
               
            }
       
            
        case "edit_stroke":
            
            let selected = userData!["selectedbox"] as! Int
            if selected == -1 {
                return
            }
            let node = children[selected] as! SudokuBoxSKNode
            node.setSelected()
            
        default:
            break
            
            
            
            
        }
        
    
        
    }
    
    
    
    
    

}




