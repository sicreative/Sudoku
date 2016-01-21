
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
    
    let finishedboxfilledColor = NSColor(red:0.8,green:0.8,blue:0.24,alpha:0.8)
    let finishedboxtextColor = NSColor(red:0.2,green:0.2,blue:0.2,alpha:0.8)
    static let MAXLEVEL = 60
    static let MINLEVEL = 3
    
    
    var appDelegate : AppDelegate!
   
    
    private let concurrencySudokuQueue = dispatch_queue_create(
        NSBundle.mainBundle().bundleIdentifier!+".SudokuQueue", DISPATCH_QUEUE_CONCURRENT)
    
    private let concurrencySudokuBackGroundQueue = dispatch_queue_create(NSBundle.mainBundle().bundleIdentifier!+".SudokuBackGroundQueue", dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_BACKGROUND, 0))
    
  //  private var dispatch_source_finished_buildsudoku : dispatch_source_t!
    
    
   private var _isShowNextGame  = false
    
   private var isClosingNextGame = false
    
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
    private var numTotalfillBox: Int = 0;
    
    var selectedlevelchangenexttime = false;

   
    var performance = [String:AnyObject]()
    
    //var numarray:[[Int64]] = []
    
    
    let modelcontroller =  CoreController()

    // MARK: - Level
    
    
    func levelresettoperformance(){
        level = preferenceleveltolevel(performance["selectedgamelevel"] as! Int)
        selectedlevelchangenexttime = true
        AppDelegate.writePreference("level",level)
        
    }
    
    func preferenceleveltolevel(PerformaceLevel: Int)-> Int{
        return 3 + (PerformaceLevel) * 10
    }
    
    
    
    // MARK: - New
    
    
    func newsudoku(){
        
        
        
        
        
       self.scene!.view!.window!.undoManager!.removeAllActions()
        
        
        
        
        
        
        
      

        
        if (userData!["mixedstatemenu"] != nil){
            (userData!["mixedstatemenu"] as! NSMenuItem).state = NSOffState
            
            userData!["mixedstatemenu"] = nil
        }
        
       // let level = 3
      //  makeanswer()
      //   makefilling ();
        
      //  buildsudokutable();
        
        let isReadfromdatabase = readdatabasetable();
        if (!isReadfromdatabase){
            buildsudokutable(false)
            return;
        }
            newsudokubuildednum()
        
        
        
     
        
    }
    
    func newsudokubuildednum(){
        var  numarray :[[Int]] = userData!["numarray"] as! Array
        var  fillingarray :[[Bool]] = userData!["fillingarray"] as! Array
        numTotalfillBox = 0;
        numfilledBox = 0;
        
        for var i=0; i < 9 ; ++i {
            
            for var j=0; j < 9; ++j{
                if (fillingarray[i][j]){
                    ++numTotalfillBox
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
    
    func changemixedstatenextgame(mixedstatemenu: NSMenuItem){
        userData!["mixedstatemenu"] = mixedstatemenu
    }

    // MARK: - Support Undo / Redo
 
  
    
  
 
   
    
    
    @IBAction func undo (sender: NSButtonCell){
        
    }
    
    @IBAction func redo (sender: NSButtonCell){
        
    }
    
    
    // MARK: - Build Sudoku number

    
    
    func buildsudokutable (isRunBackGround : Bool){
        return buildsudokutable(isRunBackGround,self.level)
        
    }
    
    
    
    
    
    
    func buildsudokutable (isRunBackGround : Bool, _ level : Int){
        
        var  numarray :[[Int]] = [[]]
        var  fillingarray :[[Bool]] = [[]]
        

        
      
        let runqueue = isRunBackGround ? concurrencySudokuBackGroundQueue : concurrencySudokuQueue
        
        let buildConcurrencyGroup = dispatch_group_create()
        
        
        if checkwiththislevel(level){
            
            
            readdatabasetable(level)
            newsudokubuildednum()
            
            return
        }
        
        
     
        dispatch_async(runqueue){
            dispatch_group_enter(buildConcurrencyGroup)
               numarray = self.makeanswer()
            
            dispatch_group_leave(buildConcurrencyGroup)
            

       
            }
        
        
        dispatch_async(runqueue){
                dispatch_group_enter(buildConcurrencyGroup)
               fillingarray = self.makefilling ();
                dispatch_group_leave(buildConcurrencyGroup)
            }
            
        
        dispatch_async(runqueue){
                    
                                dispatch_group_notify(buildConcurrencyGroup, self.concurrencySudokuQueue){
                                    
                                    dispatch_barrier_async(runqueue){
      
                                     //   let  numarray :[[Int]] = self.userData!["numarray"] as! Array
                                     //   let  fillingarray :[[Bool]] = self.userData!["fillingarray"] as! Array
                                   
                                    self.databasemodeltable(numarray,fillingarray,level)
                                        if (!isRunBackGround){
                                            self.userData!["numarray"] = numarray
                                            self.userData!["fillingarray"] = fillingarray
                                                self.newsudokubuildednum()
                                        
                                        }
                                        
                                        
                                        if (Runtime.isDebug()){
                                            
                                            
                                            print ( "Finished run build sudoku level: \(level) ,background: \(isRunBackGround)")
                                        }
                                    //    dispatch_source_merge_data(self.dispatch_source_finished_buildsudoku, 1)
                    }
            }
        
            
        }
        
        
        
      
       //  makefilling ();
        
    //    var  fillingarray :[[Bool]] = makefilling ();
        
        
        
        
   //     var  numarray :[[Int]] = userData!["numarray"] as! Array
        
   //     databasemodeltable(numarray,fillingarray)

    }
    
    
    func buildsudokutable (isRunBackGround : Bool, _ level : Int,_ delay : Double){
        
        if (delay <= 0){
            return buildsudokutable(isRunBackGround,level)
        }
        
         let runqueue = isRunBackGround ? concurrencySudokuBackGroundQueue : concurrencySudokuQueue
        
        let int_time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(int_time, runqueue){
            return self.buildsudokutable(isRunBackGround,level)
        }
        
    }
    
    
    
    
    
    
    private func makeanswer()->[[Int]]{
        var buildtrycount = 0
        var lastcount = 0
        
        var numarray : [[Int]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
        
        var step : Int = 0
        
        repeat {
            start: switch step {
            case (0):
                
                while (!makeanswerfirst (&numarray)){
                    if Runtime.isDebug() {buildtrycount++}
                    
                }
                ++step
                
            case (1):
                
                
                while (!makeanswersecond(&numarray)){
                    if Runtime.isDebug() {buildtrycount++}
                }
                ++step
                
                
                
            case (2):
                out: while (!makeanswerthird(&numarray)){
                    if Runtime.isDebug() {
                        if Runtime.isDebug() {buildtrycount++}
                        ++lastcount
                        
                        
                        step = lastcount%4 == 0 ? 0 : 1
                        
                        if (step == 0){
                            numarray = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
                        }else if (step == 1){
                            for var i = 3;i<6;i++ {
                                for var j = 0;j<3;j++ {
                                    numarray[i][j] = 0
                                }
                            }
                            for var i = 3;i<6;i++ {
                                for var j = 6;j<9;j++ {
                                    numarray[i][j] = 0
                                }
                            }
                        }
                        
                        break start
                        
                        
                    }
                }
                
                ++step
                
            default:
                break
                
            }
            
            
        }while ( step<3 )
        
        //userData!["numarray"] = numarray
        if (Runtime.isDebug()){print("Try " + String ( buildtrycount ) + " times for build the Sudoku")}

        
        return numarray
        
    }
    
    
    private func makeanswerfirst(inout numarray: [[Int]])->Bool{
        
        
        
        // numarray = userData!["answerarray"] as! [[Int64]]
        
        var seq = [1,2,3,4,5,6,7,8,9]
        var shuffledcenter = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        var next : Int = 0
        for var i=3; i <  6 ; ++i {
            
            for var j=3; j < 6; ++j{
                numarray[j][i] =  shuffledcenter[next++] as! Int
            }
        }
        var shuffled = shuffledcenter
        var shuffleddown = shuffledcenter
        var shuffledmid = shuffledcenter
        shuffled.removeRange(0...2)
        shuffleddown.removeRange(6...8)
        shuffledmid.removeRange(3...5)
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(shuffled)
        shuffleddown = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(shuffleddown)
        shuffledmid = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(shuffledmid)
        
        
        next=0
        numarray[0][3] = shuffled[next++] as! Int
        numarray[1][3] = shuffled[next++] as! Int
        numarray[2][3] = shuffled[next++] as! Int
        numarray[6][5] = shuffleddown[next++] as! Int
        numarray[7][5] = shuffleddown[next++] as! Int
        numarray[8][5] = shuffleddown[next] as! Int
        
        next=0
        for (var i=0;i<3;i++){
            
            var j = 0;
            while (numarray[0][3] == shuffledmid[j] as! Int || numarray[1][3] == shuffledmid[j] as! Int || numarray[2][3] == shuffledmid[j]as! Int ){
                
                if (shuffledmid.count-1 < ++j) {return false}
            }
            numarray[i][4]=shuffledmid[j] as! Int
            shuffledmid.removeAtIndex(j)
            
            if (shuffledmid.count == 0) {return false}
            
        }
        for (var i=6;i<9;i++){
            
            var j = 0;
            while (numarray[6][5] == shuffledmid[j] as! Int || numarray[7][5] == shuffledmid[j] as! Int || numarray[8][5] == shuffledmid[j]as! Int ){
                
                
                if (shuffledmid.count-1 < ++j) {return false}
                
            }
            numarray[i][4]=shuffledmid[j] as! Int
            shuffledmid.removeAtIndex(j)
            //  if (shuffledmid.count == 0) {return false}
            
        }
        
        
        //      shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        for (var i=0;i<6;i++){
            let index = seq.indexOf(numarray[i][3])
            if (index != nil){
                seq.removeAtIndex(index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        
        for (var i=0;i<3;i++){
            
            let check = shuffled[i] as! Int
            for (var j=6;j<9;j++){
                for (var k=4;k<6;k++){
                    if (numarray[j][k]==check) {return false}
                    
                }
            }
            numarray[i+6][3] = check
            
            
        }
        
        
        
        seq = [1,2,3,4,5,6,7,8,9]
        for (var i=3;i<9;i++){
            let index = seq.indexOf(numarray[i][5])
            if (index != nil){
                seq.removeAtIndex(index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        
        
        for (var i=0;i<3;i++){
            
            let check = shuffled[i] as! Int
            for (var j=0;j<3;j++){
                for (var k=3;k<5;k++){
                    if (numarray[j][k]==check) {return false}
                    
                }
            }
            
            numarray[i][5] = shuffled[i] as! Int
            
            
            
        }
        
        
        
        
        
        
        
        
        
        return true
    }
    
    
    private func makeanswersecond(inout numarray: [[Int]])->Bool{
        
        var seq = [1,2,3,4,5,6,7,8,9]
        
        let transposedshuffledcenter = [numarray[5][3],numarray[5][4],numarray[5][5],numarray[4][3],numarray[4][4],numarray[4][5],numarray[3][3],numarray[3][4],numarray[3][5]]
        
        var up = transposedshuffledcenter
        var down = transposedshuffledcenter
        var mid = transposedshuffledcenter
        
        
        up.removeRange(6...8)
        down.removeRange(0...2)
        mid.removeRange(3...5)
        
        
        var shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(up)
        var shuffleddown = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(down)
        var shuffledmid = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(mid)
        
        
        var next=0
        numarray[3][0] = shuffled[next++] as! Int
        numarray[3][1] = shuffled[next++] as! Int
        numarray[3][2] = shuffled[next++] as! Int
        numarray[5][6] = shuffleddown[next++] as! Int
        numarray[5][7] = shuffleddown[next++] as! Int
        numarray[5][8] = shuffleddown[next] as! Int
        
        next=0
        for (var i=0;i<3;i++){
            
            var j = 0;
            while (numarray[3][0] == shuffledmid[j] as! Int || numarray[3][1] == shuffledmid[j] as! Int || numarray[3][2] == shuffledmid[j]as! Int ){
                
                if (shuffledmid.count-1 < ++j) {return false}
            }
            numarray[4][i]=shuffledmid[j] as! Int
            shuffledmid.removeAtIndex(j)
            
            if (shuffledmid.count == 0) {return false}
            
        }
        for (var i=6;i<9;i++){
            
            var j = 0;
            while (numarray[5][6] == shuffledmid[j] as! Int || numarray[5][7] == shuffledmid[j] as! Int || numarray[5][8] == shuffledmid[j]as! Int ){
                
                
                if (shuffledmid.count-1 < ++j) {return false}
                
            }
            numarray[4][i]=shuffledmid[j] as! Int
            shuffledmid.removeAtIndex(j)
            //  if (shuffledmid.count == 0) {return false}
            
        }
        
        
        //      shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        for (var i=0;i<6;i++){
            let index = seq.indexOf(numarray[3][i])
            if (index != nil){
                seq.removeAtIndex(index!)
            }
            
            
        }
        
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        
        for (var i=0;i<3;i++){
            
            let check = shuffled[i] as! Int
            for (var j=6;j<9;j++){
                for (var k=4;k<6;k++){
                    if (numarray[k][j]==check) {return false}
                    
                }
            }
            numarray[3][i+6] = check
            
            
        }
        
        
        
        seq = [1,2,3,4,5,6,7,8,9]
        for (var i=3;i<9;i++){
            let index = seq.indexOf(numarray[5][i])
            if (index != nil){
                seq.removeAtIndex(index!)
            }
            
            
        }
        
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        
        
        for (var i=0;i<3;i++){
            
            let check = shuffled[i] as! Int
            for (var j=0;j<3;j++){
                for (var k=3;k<5;k++){
                    if (numarray[k][j]==check) {return false}
                    
                }
            }
            
            numarray[5][i] = shuffled[i] as! Int
            
            
            
        }
        
        return true
    }
    
    
    
    
    
    
    
    private func makeanswerthird(inout numarray: [[Int]])->Bool{
        
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
        
        
        
        
        
        start: for var i=0;i<array.count; {
            
            
            
            
            if ( !minuswithnum(&numarray, array[i][0],array[i][1])){
                
                
                ++trydisplaycount
                
                var shuffleseq: [Int] = []
                for i in 1...35 {
                    shuffleseq.append(i)
                }
                
                
                
                if (++repeatcount % 5 == 0){
                    --i
                    if i>max {
                        max = i
                        maxcount = 0
                        
                    }else{
                        ++maxcount
                        i -= maxcount
                    }
                    
                    if (i < 0 || repeatcount % 120 == 0){
                        i = 0
                        
                        //shuffle array
                        
                        
                        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(shuffleseq)
                        
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
                ++i
                
            }
            
            
        }
        
        
        if (Runtime.isDebug()){
            print ( "Try " + String(trydisplaycount) + " for outer Sudoku")
        }
        
        
        
        
        
        
        return true
    }
    
    

    
    func makefilling()->[[Bool]]{
       return makefilling(self.level)
    }
    

    
    
    func makefilling(level: Int)->[[Bool]] {
        
        
        
        
        // var  numarray :[[Int]] = userData!["numarray"] as! Array
        
        // build array for filling information (User input)
        
        
        
        var fillingarray : [[Bool]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:false))
        
        // Dismiss
        var numofdismiss = level + 20
        
        // Add random +/-3 pcs
        
        numofdismiss += rand() % 6 - 3
        
        if (numofdismiss > 70){
            numofdismiss = 70
        }
        
        
        
        //Loop for every 3x3 section and randomly skip one
        
        var section : Int = 4
     
     
        
        srandom (UInt32(NSDate().timeIntervalSinceReferenceDate))
        var sectionvac : [Int] = Array(count:9,repeatedValue:0)
        var max = 0
        
        for _ in 0...numofdismiss {
            
            
            
            
            
            var trycounter = 0;
            while (true) {
                var tempsection = 0
                repeat{
                tempsection = random() % 9
                }while (tempsection == section || sectionvac[tempsection]>=9)
            
            if (max < sectionvac[tempsection]-1 || trycounter > 3) {
                    section = tempsection
                break;
            }
            
            ++trycounter
                
                
            }
            
            ++sectionvac[section]
            
            if sectionvac[section] > max {
                max = sectionvac[section]
            }

            
            let sx : Int = section / 3 * 3
            let sy : Int = section % 3 * 3
        
            
            
            var tempx = 0
            var tempy = 0
            
            repeat{
                tempx = sx + random() % 3
                tempy = sy + random() % 3
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
    
    
    func minuswithnum(inout numarray: [[Int]],_ x:Int,_ y:Int )->Bool{
        
        var array: Set<Int> = []
        
        numarray[x][y] = 0
        
        for var i=0;i<9;++i {
            
            if (numarray[i][y] != 0){
                array.insert(numarray[i][y])}
            
            if (numarray[x][i] != 0){
                
                array.insert(numarray[x][i])}
        }
        
        let sectionx:Int = (x / 3) * 3
        
        let sectiony:Int = (y / 3) * 3
        
        for var i = sectionx;i<sectionx+2;++i{
            for var j=sectiony;j<sectiony+2;++j{
                if numarray[i][j] != 0{
                    array.insert(numarray[i][j])
                }
                
                
            }
        }
        
        
        var seq = [1,2,3,4,5,6,7,8,9]
        for n in array {
            for var i = 0 ;i < seq.count;++i{
                if (seq[i] == n){
                    seq.removeAtIndex(i)
                }
            }
        }
        
        if (seq.count == 0){
            return false
        }
        
        
        let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(seq)
        
        numarray[x][y] = shuffled[0] as! Int
        
        
        return true
    }
    

    


    
    
    // MARK: - Cache Database
    
    
    
    func readdatabasetable()->Bool{
      return  readdatabasetable(level)
        
        
    }
    
    
    func readdatabasetable(level: Int)->Bool{
        
       let tableFetch = NSFetchRequest(entityName: "Sudoku_table")
        
        var sortDescriptors:[NSSortDescriptor] = []
        sortDescriptors.append(NSSortDescriptor(key:"table",ascending: false))
      
        tableFetch.predicate = NSPredicate(format: "level == %d", level)
        
        tableFetch.sortDescriptors = sortDescriptors
        
        do {
            let fetchedtable = try modelcontroller.managedObjectContext.executeFetchRequest(tableFetch) as! [Sudoku_table]
            if Runtime.isDebug(){
                
                if (fetchedtable.count > 0){
                    if (Runtime.isDebug()){
                     print("date:\(fetchedtable[0].table),level:\(fetchedtable[0].level)")
                    }
                    let cardFetch = NSFetchRequest(entityName: "Sudoku_card")
                    
                    var cardsortDescriptors:[NSSortDescriptor] = []
                    cardsortDescriptors.append(NSSortDescriptor(key:"pos",ascending: true))
                    
                    cardFetch.predicate = NSPredicate(format: "table == %@", fetchedtable[0])
                    
                    cardFetch.sortDescriptors = cardsortDescriptors
                    
                    do {
                        let fetchedcard = try modelcontroller.managedObjectContext.executeFetchRequest(cardFetch) as! [Sudoku_card]
                 
                            
                            if (fetchedcard.count == 81){
                                
                                
                            var numarray : [[Int]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
                                var fillingarray : [[Bool]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:false))
                                
                      
                                for var i = 0 ; i < 81 ; ++i {
                                    
                                    fillingarray[i/9][i%9] = (fetchedcard[i].editable==1 ? true:false)
                                    numarray[i/9][i%9] = (fetchedcard[i].num as! Int)
                                    if (Runtime.isDebug()){
                                    print("pos:\(fetchedcard[i].pos as! Int),num:\(fetchedcard[i].num as! Int)")
                                    }
                                }
                                
                                userData!["numarray"] = numarray;
                                userData!["fillingarray"] = fillingarray;
                                
                                modelcontroller.managedObjectContext.deleteObject(fetchedtable[0])
                         

                                        buildsudokutable(true,self.level+1,2)
                                
                               try modelcontroller.managedObjectContext.save()
                                
                                return true
                                

                            }else{
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
                
                
                
            }
        } catch {
            return false
            //fatalError("Failed to found Sudoku_table: \(error)")
        }
        
        return false
        
     //   var  numarray :[[Int]] = userData!["numarray"] as! Array
     //   var  fillingarray :[[Bool]] = userData!["fillingarray"] as! Array
    }
    
    
    func databasemodeltable(numarray : [[Int]],_ filledarray:[[Bool]])->Sudoku_table{
       return  databasemodeltable(numarray, filledarray,self.level)
    }
    
    
    
    func databasemodeltable(numarray : [[Int]],_ filledarray:[[Bool]],_ level : Int)->Sudoku_table{
        
        
        
        
        
        
        
        
        
        
        
        
        let sudoku_table : Sudoku_table =  NSEntityDescription.insertNewObjectForEntityForName("Sudoku_table", inManagedObjectContext: self.modelcontroller.managedObjectContext) as! Sudoku_table
        
        
        sudoku_table.table = NSDate()
        
        var pos = 0;
        
        for i in 0...8{
            for j in 0...8{
                let sudoku_card : Sudoku_card =  NSEntityDescription.insertNewObjectForEntityForName("Sudoku_card",    inManagedObjectContext: self.modelcontroller.managedObjectContext) as! Sudoku_card
                
                sudoku_card.num = numarray[i][j] as NSNumber
                sudoku_card.editable = filledarray[i][j] as NSNumber
                sudoku_card.pos = pos++ as NSNumber
                
                sudoku_table.level = level
                sudoku_table.mutableSetValueForKey("card").addObject(sudoku_card)
                
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
        
        
        return sudoku_table
        
    }
    
    
    func deleteall(entity:String) {
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName(entity, inManagedObjectContext: modelcontroller.managedObjectContext)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try modelcontroller.managedObjectContext.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    modelcontroller.managedObjectContext.deleteObject(result)
                }
                
                try modelcontroller.managedObjectContext.save()
            }
        } catch {
            
            if (Runtime.isDebug()){
                
                
                print ( "failed to delete the entity\(entity)")
            }

            
           
        }
    }
    
    
    func savecurrenttable(){
        
        deleteall("Sudoku_restore")
        
        
      
        
      
        
     
        
        do{
        


        
        for i in 9...89 {
            
            
            let sudoku_restore : Sudoku_restore =  NSEntityDescription.insertNewObjectForEntityForName("Sudoku_restore", inManagedObjectContext: self.modelcontroller.managedObjectContext) as! Sudoku_restore
            let node = children[i] as! SudokuBoxSKNode
            let editable  = node.userData!["editable"] as! NSNumber
            let correctnum = node.userData!["correctnum"] as! NSNumber
            let fillednum  = node.userData!["fillednum"] as! NSNumber
            
            
            sudoku_restore.editable =  editable
            sudoku_restore.num =  correctnum
            sudoku_restore.fillednum = fillednum
            sudoku_restore.pos = (i - 9) as NSNumber
            }

          try modelcontroller.managedObjectContext.save()
        }catch {
            
            if (Runtime.isDebug()){
                
                
                print ( "failed to save current table")
            }
            
            
            
        }
        
        if (Runtime.isDebug()){
            
            
            print ( "Finished save current table")
        }
    }
    
    
    
    private func checkwiththislevel(level: Int)->Bool{
        
        
        let tableFetch = NSFetchRequest(entityName: "Sudoku_table")
        
        var sortDescriptors:[NSSortDescriptor] = []
        sortDescriptors.append(NSSortDescriptor(key:"table",ascending: false))
        
        tableFetch.predicate = NSPredicate(format: "level == %d", level)
        
        tableFetch.sortDescriptors = sortDescriptors
        
        do {
            let fetchedtable = try modelcontroller.managedObjectContext.executeFetchRequest(tableFetch) as! [Sudoku_table]
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

    
    
    
    func retrievecurrenttable(){
        
        let cardFetch = NSFetchRequest(entityName: "Sudoku_restore")
        
        var cardsortDescriptors:[NSSortDescriptor] = []
        cardsortDescriptors.append(NSSortDescriptor(key:"pos",ascending: true))
        
       
        
        cardFetch.sortDescriptors = cardsortDescriptors
        
        do {
            let fetchedcard = try modelcontroller.managedObjectContext.executeFetchRequest(cardFetch) as! [Sudoku_restore]
            
            
            if (fetchedcard.count == 81){
                
                
                var numarray : [[Int]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
                var fillednumarray : [[Int]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:0))
                var fillingarray : [[Bool]] = Array(count:9,repeatedValue: Array(count:9,repeatedValue:false))
                
                
                for var i = 0 ; i < 81 ; ++i {
                    
                    fillingarray[i/9][i%9] = (fetchedcard[i].editable==1 ? true:false)
                    numarray[i/9][i%9] = (fetchedcard[i].num as! Int)
                    fillednumarray[i/9][i%9] = (fetchedcard[i].fillednum as! Int)
                    
                    if (Runtime.isDebug()){
                        print("pos:\(fetchedcard[i].pos as! Int),num:\(fetchedcard[i].num as! Int)")
                    }
                }
                
                userData!["numarray"] = numarray;
                userData!["fillingarray"] = fillingarray;
                
             
                
                
                for var i=0; i < 9 ; ++i {
                    
                    for var j=0; j < 9; ++j{
                        let node = children[9+i*9+j] as! SudokuBoxSKNode
                        if (fillingarray[i][j]){
                            ++numTotalfillBox
                            if (fillednumarray[i][j] > 0){
                                ++numfilledBox
                            }
                        }
                        
                        node.setNumValue(numarray[i][j], fillingarray[i][j],false,fillednumarray[i][j])
                        
                            node.checkcorrect()
                        
                    }
                }
                
                refreshHint()
                
           
                
                
            }
        }catch{
            
            if (Runtime.isDebug()){
                
                
                print ( "failed to retrieve current table")
            }

        }

    }
    
    
    //MARK: - Refreshing

    func refreshHint(){
        self.setAllShowhint(performance["auto_hint"] as! Bool)
        self.updatehint()
    }
    
    
    // MARK: - Startup Process
    
    func buildupcachetable(){
      
            let second : Double = 5
        
           let time = dispatch_time(DISPATCH_TIME_NOW, Int64(second * Double(NSEC_PER_SEC)))
            dispatch_after(time, self.concurrencySudokuBackGroundQueue){
                
                // Build Selected Level Cache
                for i in 0...5{
                    
                  //  let int_time = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                  //  dispatch_after(int_time, self.concurrencySudokuBackGroundQueue){

                    
                    let level =  self.preferenceleveltolevel(i)
                    self.buildsudokutable(true,level,3)
                  //  }
                    
                }
                
                
                // Build Next Level Cache
                
                self.buildsudokutable(true,self.level+1)
                
                // Build This Level Cache
                self.buildsudokutable(true,self.level+1)
                

                
                
            }
            
        
        
        
        
        
        
    }
    
    
    func startupNumRestore(){
    
    
    let restoreFetch = NSFetchRequest(entityName: "Sudoku_restore")
    do {
    let fetchedrestore = try modelcontroller.managedObjectContext.executeFetchRequest(restoreFetch) as! [Sudoku_restore]
        
        if (fetchedrestore.count == 0){
            newsudoku()
            buildupcachetable()
            return
        }
        
        retrievecurrenttable()
       

    } catch {
        fatalError("Failure to open Restore Database: \(error)")
        
        }

        refreshHint()
    
       
    
    
 
    }
   
    func undotext(){
        
    }
    
    // MARK: - LifeCycle

    override func didMoveToView(view: SKView) {
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
        
        
        
    //  let level = 3 + (performance["selectedgamelevel"] as! Int) * 3
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
        
        
        for var i=0; i < 3 ; ++i {
            
            for var j=0; j < 3; ++j{
   
                
                let gapoffsetx = offset + groupgap * CGFloat (i)
                let gapoffsety = 0.75 * offset + groupgap * CGFloat(j)
                
              //  let rect = CGRectMake(gapoffsetx + (CGFloat (i) * stepX), self.frame.maxY - gapoffsety - ( CGFloat (j) * stepY + stepY), stepX, stepY)
            
            let bigrect = CGRectMake(gapoffsetx + (CGFloat (i*3) * stepX),  self.frame.maxY - gapoffsety - ( CGFloat (j*3) * stepY )-stepY*3, stepX*3, stepY*3)
            let drawpath = CGPathCreateWithRoundedRect(bigrect, offset, offset, nil)
            let bigshapenode = SKShapeNode(path: drawpath)
            bigshapenode.fillColor = SKColor.grayColor()
            self.addChild(bigshapenode)
            
                }
            
        }

        
        
        
        for var i=0; i < 9 ; ++i {
            
            for var j=0; j < 9; ++j{
                
 
        

        
       let shapenode = SudokuBoxSKNode()
        
        let gapoffsetx = offset + CGFloat(i / 3) * groupgap
        let gapoffsety = 0.75 * offset + CGFloat(j / 3) * groupgap
                
        let rect = CGRectMake(gapoffsetx + (CGFloat (i) * stepX), self.frame.maxY - gapoffsety - ( CGFloat (j) * stepY + stepY), stepX, stepY)
                
            shapenode.BuildupBox(rect,0,9+i*9+j,false)
         
                
            //    shapenode.BuildupBox(rect,numarray[i][j],9+i*9+j,fillingarray[i][j])

                
                
         self.addChild(shapenode)
                
            }
        }
        
       //  shapenode.position = CGPointMake(800,600)
        
        
        
     
            
        
      
            
            startupNumRestore()
            
             updateAllAutoCheck()
            
      
        
        
        
        
 
         
      
    }
    
    
    
    
    override func willMoveFromView(view: SKView) {
        savecurrenttable()
       
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
        
    }
    
    func finishedcheck(){
    
        
        let second : Double = 1
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(second * Double(NSEC_PER_SEC)))
        
        dispatch_after(time,GlobalMainQueue){
        var correctnum = 0
        for i in 9...89 {
            let node = self.children[i] as! SudokuBoxSKNode
            if node.checkcorrect(){
                ++correctnum
            }
        }

        if correctnum != self.numTotalfillBox {
            return
            }
            
            
            
            
                  self.shownextsudoku()
        }
        
        
        
  
    }
    
    
    func shownextsudoku(){
         _isShowNextGame = true
        let shapenode = SKShapeNode()
        let lablenode = SKLabelNode()
        
        
        
        
        let drawpath = CGPathCreateMutable()
        
        var drawrect = self.calculateAccumulatedFrame()
        
        
        shapenode.position = CGPointMake(drawrect.size.width/2, drawrect.size.height/2)
        drawrect.size.height /= 3
        drawrect.size.width /= 2
        drawrect.origin.x -= drawrect.size.width / 2
        drawrect.origin.y -= drawrect.size.height / 2
        
        
        CGPathAddRoundedRect(drawpath, nil, drawrect,25,25)
        CGPathCloseSubpath(drawpath)
        
        
        lablenode.fontName = "Chalkduster"
        lablenode.fontSize = 48
        lablenode.text = NSLocalizedString("nextgametext", comment: "Next Game Show Text")
        lablenode.color = finishedboxtextColor
        lablenode.position.y -= 50
        
           lablenode.zPosition = 110
        

        lablenode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        //CGPathAddLineToPoint(drawpath,nil,-100,-100);
        
        shapenode.name = "nextgame"
        shapenode.path = drawpath;
        
        shapenode.fillColor = finishedboxfilledColor
        // shapenode.fillColor = noneditColor
        shapenode.lineWidth = 0
        shapenode.lineJoin = CGLineJoin.Round
        
        shapenode.zPosition = 100
        
        shapenode.alpha = 0
       // lablenode.alpha = 0
     
        
        let action = SKAction . fadeInWithDuration(1.5)
        
        
         self.addChild(shapenode)
        shapenode.addChild(lablenode)
        shapenode.runAction(action)
        //lablenode.runAction(action)
     
    
        
       

        
        
 
        
       
    }
    
    
    func startNextGame(){
        if isShowNextGame {
        
            
            let fadeoutAction = SKAction.fadeOutWithDuration(1.5)
            let runaction = SKAction.runBlock(){
                 self.isClosingNextGame = false
            }
            let removeAction = SKAction.removeFromParent()
            let seqAction : [SKAction] = [fadeoutAction,runaction,removeAction]
            
            let action = SKAction.sequence(seqAction)
            
            if (performance["increase_level"] as! Bool){
            if !selectedlevelchangenexttime {
     
                if level < GameScene.MAXLEVEL  {
                  
                
                
                    ++level
                AppDelegate.writePreference("level",level)

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
            
       childNodeWithName("nextgame")!.runAction(action)
         
            
           
            
        
            
                self.isClosingNextGame = true
                 self._isShowNextGame = false
            
            
            newsudoku()
        }
    }
    
    
        // MARK: - User Input
    
    override func mouseDown(theEvent: NSEvent) {
        
        
        
        /* Called when a mouse click occurs */
        
        if isClosingNextGame{
            return
        }
      
        
        if (isShowNextGame){
            
            startNextGame()
                
            
         return
            
        }
        
    }
    
    
        
    
 
    override func keyDown(theEvent: NSEvent) {
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
                            ++numfilledBox
                            }
                        if numfilledBox == numTotalfillBox-1 {
                            break
                            }
                        }
                        
                    }
                    
                    
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
            ++numfilledBox
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
        var stage = 0
        while (!(children[selected] as! SudokuBoxSKNode).isEditable()){
            switch stage % 4{
            case 0:
                ++selected
            case 1:
                selected += 9
            case 2:
                --selected
            
            case 3:
                selected -= 9
            default:
                break
            }
            ++stage
            
        }
        
        (children[selected] as! SudokuBoxSKNode).setSelected()
        
        userData!["selectedbox"] = selected
        
    }
    
    override func moveUp(sender: AnyObject?) {
        shiftcheck(3)
        /*
        let selectedbox = userData!["selectedbox"] as! Int
        if ( selectedbox == -1){
           // selectnearcenter()
            return
        }
        
        if (selectedbox  == 9){
            return
        }
        
        var minus:Int = 1
        while (!((children[selectedbox - minus] as! SudokuBoxSKNode).isEditable())){
            minus += 1
            if ((selectedbox - minus) <= 8){
                
                return
            }
        }
        
        userData!["selectedbox"] = selectedbox - minus
        
        updateselectedbox(selectedbox)
        */
        
        
    }
    
    func shiftcheck(direction : Int)->Int{
        
        func tobox(x:Int,_ y:Int)->Int{
            return x * 9 + y + 9
        }
        
        func frombox(box:Int)->(x:Int,y:Int){
            let b = box - 9
            let x = b / 9
            let y = b % 9
            return (x,y)
        }
        
        func within(x:Int,_ y:Int)->Bool{
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
        
        func matrix (x:Int,_ y:Int,_ direction:Int)->[Int]{
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
    
    override func moveDown(sender: AnyObject?) {
        
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
    
    override func moveLeft(sender: AnyObject?) {
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
    
    override func moveRight(sender: AnyObject?) {
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
    
    

       // MARK: -
    
    func updateselectedbox(previous: Int){
        (children[previous] as! SudokuBoxSKNode).setDeselected()
    (children[userData!["selectedbox"] as! Int] as! SudokuBoxSKNode).setSelected()
        
        
    }
    
    
    

    func checkallboxcorrect()->Int{
        var numofcorrect : Int = 0
        dispatch_async(GlobalMainQueue){
        for i in 9...89 {
            let node = self.children[i] as! SudokuBoxSKNode
            if (node.checkcorrect()){
                ++numofcorrect
            }
        }
        }
        
        return numofcorrect
    }
    
    
    
    
     func autocheckcorrect(sender: NSButton) {
        
        var changecolor = false
        
        if (sender.state == NSOnState){
            //sender.state = NSOnState
              performance["auto_check"] = true
            AppDelegate.writePreference("auto_check", true)
            changecolor = true
           // checkallboxcorrect()
            
            
        }else{
       // sender.state = NSOffState
             performance["auto_check"] = false
             AppDelegate.writePreference("auto_check", false)
            
         
            
        }
        
        for i in 9...89 {
            let node = children[i] as! SudokuBoxSKNode
            node.correctChangeColor(changecolor)
        }

        
        if (Runtime.isDebug()){
            print ( "select all input check  @ GameScene" + String (performance["auto_check"]) )
        }
        
        
        
      
    }
    
    func checkcorrectonlyselect(sender: NSMenuItem) {
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
             (node.children[0].children[0] as! SKLabelNode).fontColor = node.editCorrectColor
        }
        
        let second : Double = 5
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(second * Double(NSEC_PER_SEC)))
        dispatch_after(time, GlobalMainQueue){
          
            if node.correctChangeColor {
                return
            }
            (node.children[0].children[0] as! SKLabelNode).fontColor = node.editInCorrectColor
                
         

            
        
        }

        
        
           // checkallboxcorrect()
        
        
    }
    
    
    
    
   func autoshowhint(sender: NSButton) {
        if (Runtime.isDebug()){
            print ( "select hint @ GameScene ")
        }
        if (sender.state == NSOnState){
         //   sender.state = NSOnState
            performance["auto_hint"] = true
            //userData!["showhint"] = true
            self.setAllShowhint(true)
            
        }else{
         //   sender.state = NSOffState
           performance["auto_hint"] = false

            // userData!["showhint"] = false
              self.setAllShowhint(false)
        }
    
    
     AppDelegate.writePreference("auto_hint", performance["auto_hint"]!)
  
    updatehint()
    }
    
    func setAllShowhint(isShowhint: Bool){
        
        for i in 9...89 {
            let node = children[i] as! SudokuBoxSKNode
            node.setShowhint(isShowhint)
        }
        
    }
    
    
    func updateAllAutoCheck(){
        
        let check = performance["auto_check"] as! Bool
        
        for i in 9...89 {
            let node = self.children[i] as! SudokuBoxSKNode
            node.correctChangeColor(check)
        }
    }

    
    
    
    func updatehint(){
        
        dispatch_async(GlobalMainQueue){

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
    func writeperformance(key: String,_ value:CFPropertyList){
     CFPreferencesSetAppValue(key, value,kCFPreferencesCurrentApplication)
      CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
    }*/

}




