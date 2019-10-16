//
//  SudokuBoxSKNode.swift
//  sudoku
//
//  Created by slee on 2015/12/27.
//  Copyright © 2015年 slee. All rights reserved.
//
import Cocoa
import SpriteKit


class SudokuBoxSKNode: SKNode {
    
// let editingStrokeColor = SKColor.blackColor()
// let noneditColor = SKColor.blackColor()
// let editCorrectColor = NSColor(red:0.3,green:0.45,blue:0.24,alpha:1)
// let editInCorrectColor = SKColor.blueColor()
// let strokeColor  = NSColor(red:0.8,green:0.1,blue:0.1,alpha:0.8)
 var correctChangeColor = false;
    
    var hintpoints = [CGPoint]();

    
  
    
   
  
    
        override init (){
        
        
        
        super.init()


        
    }
    
  
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
   
 
    
    func setNumValue (_ num:Int,_ edit:Bool){
        self.setNumValue(num, edit,true)
    }

     func setNumValue (_ num:Int,_ edit:Bool,_ updatehint:Bool){
        self.setNumValue(num, edit,updatehint,0)
    }
    
    func setNumValue (_ num:Int,_ edit:Bool,_ updatehint:Bool,_ fillednum: Int){
        
         let lablenode = self.children[0].children[0] as! SKLabelNode
        
        userData!["editable"] = edit
        userData!["correctnum"] = num
        if (userData!["showhint"] == nil) {
            userData!["showhint"] = false
        }
        
        userData!["fillednum"] = 0
        
        if (!edit) {
            lablenode.fontColor = GameScene.noneditColor
     
            if (num != 0){
                lablenode.text = String ( num )
            }
        }
        else{
            lablenode.fontColor = GameScene.editInCorrectColor
          
                if (fillednum == 0){
                    
                    lablenode.text = ""
                  //  lablenode.text = String ( num )
                }else{
                      userData!["fillednum"] = fillednum
                    lablenode.text = String (fillednum)
                   
                }
            
            
        }
        
        if (updatehint){
            self.updatehint()
        }
        
        checkcorrect()
        
    }
    
    
    

    func BuildupBox (_ rect:CGRect,_ num:Int,_ id:Int,_ edit:Bool){
        let shapenode = SKShapeNode()
        let lablenode = SKLabelNode()
        
        self.isUserInteractionEnabled = true;
        userData = ["id": id]
        //userData = ["selectedbox":  -1]

//        userData =
    //    userData!["id"] = id
        
    //    userData!["editable"] = edit
   //     userData!["correctnum"] = num
        
        
        //let rect = gamescene.frame;
        
        let drawpath = CGMutablePath()
        let drawrect = CGRect(x: -(rect.width)/2+10, y: -(rect.height)/2+10, width: (rect.width)-20, height: (rect.height)-20)
        
      
        
        drawpath.addRect(drawrect)
        
      //  CGPathAddRect(drawpath, nilpointer, drawrect)
        drawpath.closeSubpath()
        
       
        lablenode.fontName = "Chalkduster"
        lablenode.fontSize = rect.width * 0.3
        
        lablenode.zPosition = 10
        
        
        /*
        if (!edit) {
            lablenode.fontColor = noneditColor
            if (num != 0){
             lablenode.text = String ( num )
            }
            }
        else{
            lablenode.fontColor = editInCorrectColor
            if (Runtime.isDebug()){
                if (num != 0){
                    lablenode.text = String ( num )
                }
            }
        
        }*/
        
        
        lablenode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        //CGPathAddLineToPoint(drawpath,nil,-100,-100);
        
        shapenode.name = "1"
        shapenode.path = drawpath;
        shapenode.strokeColor = GameScene.strokeColor
       // shapenode.fillColor = noneditColor
        shapenode.lineWidth = 10
        shapenode.lineJoin = CGLineJoin.round
        
        
       shapenode.position = CGPoint(x: rect.midX,y: rect.midY)
        
        self.addChild(shapenode)
         shapenode.addChild(lablenode)
        
        
        setNumValue(num, edit)

        
        // let action = SKAction.moveByX(100.0, y: 100.0, duration: 10.0)
        //shapenode.runAction(SKAction.repeatActionForever(action))
        // shapenode.runAction(action)
    
       updatetextfadeIn()
        
        
        
        var shiftinc: Int = 0;
        
        for _ in 0...9{
            
            
            
            var labelpos = CGPoint(x: -30, y: 8)
            
            
            if (shiftinc == 1 ){
                
                labelpos.y -= 15
                
            }else if (shiftinc == 3){
                labelpos.y -= 30
            }
            else if(shiftinc == 2  ){
                
                
                labelpos.x +=   15
                
            }else if (shiftinc >= 7){
                labelpos.x +=  CGFloat (4) * 15
                labelpos.y -= CGFloat (shiftinc - 6) * 15
            }
                
                
            else if (shiftinc >= 4){
                
                labelpos.x +=  CGFloat (shiftinc - 2) * 15
                
            }
            
            
            hintpoints.append(labelpos)
            
            shiftinc += 1
            
            //self.children[0].addChild(hintlablenode)
            
        }
        

    }
    
    
    
   
    override func mouseDown(with theEvent: NSEvent) {
        
        if ((scene! as! GameScene).isShowNextGameLogo){
            return
        }
        
        if (!isEditable()) {
            return
        }
        /* Called when a mouse click occurs */
        let node  = self.children[0]
        if node is SKShapeNode {
        let shapenode = node as! SKShapeNode
            if shapenode.strokeColor == GameScene.editingStrokeColor{
                return
            }
        
            let selectedbox = scene!.userData?["selectedbox"]
            if selectedbox is Int {
                if (selectedbox as! Int != -1){
                let sbnode = scene!.children[selectedbox as! Int] as! SudokuBoxSKNode
                
              //  let insidenode = sbnode.children[0] as! SudokuBoxSKNode
                    sbnode.setDeselected()
                }
                
                    
                
                
                   setSelected()
                    scene!.userData!["selectedbox"] = userData!["id"]
            }
        }
        
    }
    
    

    
    
    
    func undochangetext(_ num : Int){
        
        
        
        
        
        let undoM =        self.scene!.view!.window!.undoManager!
        
        
        
        let id = (userData!["id"] as! Int) - 9
        
        let last = self.userData?["fillednum"] as! Int
        
        undoM.registerUndo(withTarget: self, handler: { target->Void in
            target.undochangetext(last)
        })
        
      //  ((undoM.prepare(withInvocationTarget: self)) as! SudokuBoxSKNode).undochangetext(userData!["fillednum"] as! Int)
      
        
  undoM.setActionName(String (format: NSLocalizedString("undochangetext", comment: "Menu Undo Text"),id%9+1,id/9+1))

        
        if (userData!["fillednum"] as! Int == 0){
            (self.scene as! GameScene).numfilledBox += 1
        }
        
        userData!["fillednum"] = num
        
        let node = self.children[0].children[0] as! SKLabelNode
       
        
        if (num==0){
        node.text = ""
            (self.scene as! GameScene).numfilledBox -= 1
        }else{
        node.text = String (num)
        }
        
        checkcorrect()
        updatehint()

    }

    
    func changetext(_ theEvent: NSEvent)->Bool{
        if let num = Int (theEvent.characters!) {
            if (num == 0){
                return false
            }
            
            
        
           // let undo : NSUndoManager = (self.parent as! GameScene).windowWillReturnUndoManager()!
            let undoM = self.scene!.view!.window!.undoManager!
            
           
            
            let id = (userData!["id"] as! Int) - 9
            
            let last = userData!["fillednum"] as! Int
           
            undoM.registerUndo(withTarget: self, handler: {(target)->Void in
                target.undochangetext(last) })
            
          
                
            
       
         //   let l = undoM.prepare(withInvocationTarget: self)
            
         //       (l as! SudokuBoxSKNode).undochangetext(userData!["fillednum"] as! Int)
            undoM.setActionName(String (format: NSLocalizedString("undochangetext", comment: "Menu Undo Text"),id%9+1,id/9+1))
           
            
      
            
            
            
            
     
   
            
       
            
            userData!["fillednum"] = num
            
            let node = self.children[0].children[0] as! SKLabelNode
            
            
            
            
            
            
            
            // var fillingarray = scene!.userData?["fillingarray"] as! [[Int]]
            //let x = (userData!["id"] as! Int - 9) / 9
            //let y = userData!["id"] as! Int % 9

            //fillingarray[x][y] = num
            
            //scene!.userData?["fillingarray"] = fillingarray
            
              node.text = String (num)
            
          //  node.fontColor = editInCorrectColor
        
          //  (scene! as! GameScene).updatehint()
            
            //if performance["auto_check"] as! Bool {
               checkcorrect()
            //}
      
            
            return true
        }
        return false
    }
    
    func checkcorrect()->Bool{
        
        if !isEditable() {
            return false
        }
       let node = self.children[0].children[0] as! SKLabelNode
       // let num =  Int (node.text!)
        //let numarray = scene!.userData?["numarray"] as! [[Int]]
        //var fillingarray = scene!.userData?["fillingarray"] as! [[Int]]
     
        //let x = (userData!["id"] as! Int - 9) / 9
        //let y = userData!["id"] as! Int % 9

        
        if (isCorrect()) {
            if (correctChangeColor){
            node.fontColor = GameScene.editCorrectColor
            }
            return true
        }
        
        node.fontColor = GameScene.editInCorrectColor
            return false
        
        
    }
    
    
    func correctChangeColor(_ isChange: Bool){
        if (!isEditable()){
             correctChangeColor = false
            return
        }
        
        if (isChange){
            correctChangeColor = true
            checkcorrect()
            return
        }
        
        correctChangeColor = false
        let node = self.children[0].children[0] as! SKLabelNode
         node.fontColor = GameScene.editInCorrectColor
        
    }
    
    

    
    func setSelected(){
        
        let insidenode = self.children[0] as! SKShapeNode
        insidenode.strokeColor = GameScene.editingStrokeColor
        
    
    }
    
    func setDeselected(){
        
        let insidenode = self.children[0] as! SKShapeNode
        insidenode.strokeColor = GameScene.strokeColor
        
        
    }
    
    func isEditable() -> Bool{
       
        return userData!["editable"] as! Bool
        
    }
    
    func isCorrect() -> Bool{
        //let node = self.children[0].children[0] as! SKLabelNode
        
       // if (node.text == nil){
        // return false
//}
        
       let num = userData!["fillednum"] as! Int
        
     //  let num =  Int (node.text!)
       
        if num == 0 {
            return false
        }
        
        if num == (userData!["correctnum"] as! Int) {
            return true
           
        }else{
            return false
                    }

    }

    
    func setShowhint(_ isShowHint :Bool){
        userData!["showhint"] = isShowHint
    }
    
    func setShowhintonlyonce(){
        
    }
    
    
    func updatehint(){
        return updatehint(false)
    }
    
    
    func updatehint(_ show:Bool){
        
        
        
        
        /*
        
        
        if self.children[0].children.count > 1 {
        
        
        
        for _ in 1...self.children[0].children.count-1{
        self.children[0].children[1].removeFromParent()
        }
        
        
        
        }*/
        
       
        
        
        if !show{
            if (!isEditable() || isCorrect() || userData!["showhint"] as! Bool == false ) {
                
                
                
                
                while children[0].children.count > 1 {
                    children[0].children[children[0].children.count-1].removeFromParent()
                }
                
                
                return
            }
            
        }
        
        if (!isEditable()){
            
            return;
        }
        
        
        let id = userData!["id"] as! Int
        
        var checkarray: Set<Int> = [1,2,3,4,5,6,7,8,9]
        
        let x : Int = id % 9
        let y : Int = id / 9
        
        let nodegroup : [SKNode] = self.parent!.children
        //insert y axis
        for i in y * 9...y*9+8{
            let node = nodegroup[i] as! SudokuBoxSKNode
            if (!node.isEditable() || node.isCorrect()){
                
                
                checkarray.remove(node.userData!["correctnum"] as! Int)
                
            }
            
        }
        
        //insert x axis
        for i in stride(from:9+x, to:89, by: 9) {
      //  for var i=9+x;i<=89;i+=9{
            let node = nodegroup[i] as! SudokuBoxSKNode
            if (!node.isEditable() || node.isCorrect()){
                checkarray.remove(node.userData!["correctnum"] as! Int)
            }
            
        }
        
        //insert the big box section
        let sx : Int = x / 3 * 3
        let sy : Int = (y - 1) / 3 * 3
        
        let sectionfirst : Int =  sy * 9 + sx + 9
        
        
        for i in 0...2 {
            for j in 0...2{
                let node = nodegroup[sectionfirst+i*9+j] as! SudokuBoxSKNode
                if (!node.isEditable() || node.isCorrect()){
                    checkarray.remove(node.userData!["correctnum"] as! Int)
                    
                }
            }
        }
        
        
        
        
        let sortarray = checkarray.sorted()
        
        
        
        
        //        var shiftinc: Int = 0;
        
        
        for i in 0...sortarray.count{
            
            
            if i < sortarray.count  {
                
                if (i < children[0].children.count-1){
                    (children[0].children[i+1] as! SKLabelNode).text = String(sortarray[i])
                }else{
                    let hintlablenode = SKLabelNode()
                    hintlablenode.text = String (sortarray[i])
                    hintlablenode.fontName = "Futura"
                    hintlablenode.fontSize = 15
                    
                    hintlablenode.fontColor = GameScene.hintcolor
                    
                    hintlablenode.position = hintpoints[i]
                    self.children[0].addChild(hintlablenode)
                    
                }
                
            }else{
                while (  i < children[0].children.count-1){
                    
                    children[0].children[children[0].children.count-1].removeFromParent()
                }
            }
        }
        
        
        /*
        
        let hintlablenode = SKLabelNode()
        hintlablenode.text = String (i)
        hintlablenode.fontName = "Futura"
        hintlablenode.fontSize = 15
        
        hintlablenode.fontColor = GameScene.hintcolor
        
        var labelpos = CGPointMake(-30, 8)
        
        
        if (shiftinc == 1 ){
        
        labelpos.y -= 15
        
        }else if (shiftinc == 3){
        labelpos.y -= 30
        }
        else if(shiftinc == 2  ){
        
        
        labelpos.x +=   15
        
        }else if (shiftinc >= 7){
        labelpos.x +=  CGFloat (4) * 15
        labelpos.y -= CGFloat (shiftinc - 6) * 15
        }
        
        
        else if (shiftinc >= 4){
        
        labelpos.x +=  CGFloat (shiftinc - 2) * 15
        
        }
        
        hintlablenode.position = labelpos
        
        ++shiftinc
        
        self.children[0].addChild(hintlablenode)
        
        }*/
        
        
        
        if self.children[0].children[0].hasActions() {
            if self.children[0].children.count <= 1 {
                return
            }
            for i in 1...self.children[0].children.count-1 {
                let node = self.children[0].children[i]
                
                
                
                if node.hasActions(){
                    return
                    //node.removeAllActions()
                }
                self.children[0].children[i].run(SKAction.fadeAlpha(to: node.alpha, duration: 1.2))
                node.alpha = 0
            }
        }
        
        
    }
    
    func updatetextfadeIn(){
         let node = self.children[0].children[0]
        
        
     //   node.alpha = 0
      if node.hasActions(){
            return
            //node.removeAllActions()
        }
        node.run(SKAction.fadeAlpha(to: node.alpha, duration: 1.2))
        node.alpha = 0
        }
    
    
    func updatecolor(_ key: String){
        switch (key){
            
            
        case "non_edit":
            if (!isEditable()){
                let node = self.children[0].children[0] as! SKLabelNode
                node.fontColor = GameScene.noneditColor
              // node.text = String (userData!["correctnum"] as! Int)
                

            }
           
            
        case "edit_correct":
        
            
               checkcorrect()
            
            
        case "edit_incorrect":
               checkcorrect()
            
        case "stroke":
            if (scene!.userData!["selectedbox"] as! Int != userData!["id"] as! Int){
                setDeselected()}
            
        case "hint_num":
            if self.children[0].children.count <= 1 {
                return }
            for i in 1...self.children[0].children.count-1{
                let node = self.children[0].children[i] as! SKLabelNode
                node.fontColor = GameScene.hintcolor
            }
        
        default:
            break
        }
        
    }




}
