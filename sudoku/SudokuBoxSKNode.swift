//
//  SudokuBoxSKNode.swift
//  sudoku
//
//  Created by slee on 2015/12/27.
//  Copyright © 2015年 slee. All rights reserved.
//

import SpriteKit


class SudokuBoxSKNode: SKNode {
    
 let noneditColor = SKColor.blackColor()
 let editCorrectColor = NSColor(red:0.3,green:0.45,blue:0.24,alpha:1)
 let editInCorrectColor = SKColor.blueColor()
 let strokeColor  = SKColor.redColor()
 var correctChangeColor = false;
    
  
    
   
  
    
        override init (){
        
        
        
        super.init()


        
    }
    
  
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
    func setNumValue (num:Int,_ edit:Bool){
        self.setNumValue(num, edit,true)
    }

     func setNumValue (num:Int,_ edit:Bool,_ updatehint:Bool){
        self.setNumValue(num, edit,updatehint,0)
    }
    
    func setNumValue (num:Int,_ edit:Bool,_ updatehint:Bool,_ fillednum: Int){
        
         let lablenode = self.children[0].children[0] as! SKLabelNode
        
        userData!["editable"] = edit
        userData!["correctnum"] = num
        if (userData!["showhint"] == nil) {
            userData!["showhint"] = false
        }
        
        userData!["fillednum"] = 0
        
        if (!edit) {
            lablenode.fontColor = noneditColor
            if (num != 0){
                lablenode.text = String ( num )
            }
        }
        else{
            lablenode.fontColor = editInCorrectColor
            if (Runtime.isDebug()){
                if (fillednum == 0){
                    
                    lablenode.text = ""
                  //  lablenode.text = String ( num )
                }else{
                      userData!["fillednum"] = fillednum
                    lablenode.text = String (fillednum)
                   
                }
            }
            
        }
        
        if (updatehint){
            self.updatehint()
        }
        
        checkcorrect()
    }
    
    
    

    func BuildupBox (rect:CGRect,_ num:Int,_ id:Int,_ edit:Bool){
        let shapenode = SKShapeNode()
        let lablenode = SKLabelNode()
        
        self.userInteractionEnabled = true;
  
        userData = ["id":id]
    //    userData!["editable"] = edit
   //     userData!["correctnum"] = num
        
        
        //let rect = gamescene.frame;
        
        let drawpath = CGPathCreateMutable()
        let drawrect = CGRectMake(-(rect.width)/2+10, -(rect.height)/2+10, (rect.width)-20, (rect.height)-20)
        
        CGPathAddRect(drawpath, nil, drawrect)
        CGPathCloseSubpath(drawpath)
        
       
        lablenode.fontName = "Chalkduster"
        lablenode.fontSize = rect.width * 0.3
        
        
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
        
        
        lablenode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        //CGPathAddLineToPoint(drawpath,nil,-100,-100);
        
        shapenode.name = "1"
        shapenode.path = drawpath;
        shapenode.strokeColor = SKColor .redColor()
       // shapenode.fillColor = noneditColor
        shapenode.lineWidth = 10
        shapenode.lineJoin = CGLineJoin.Round
        
        
       shapenode.position = CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect))
        
        self.addChild(shapenode)
         shapenode.addChild(lablenode)
        
        
        setNumValue(num, edit)

        
        // let action = SKAction.moveByX(100.0, y: 100.0, duration: 10.0)
        //shapenode.runAction(SKAction.repeatActionForever(action))
        // shapenode.runAction(action)
    
       
    }
    
    
    
 
   
    override func mouseDown(theEvent: NSEvent) {
        
        if (!isEditable()) {
            return
        }
        /* Called when a mouse click occurs */
        let node  = self.children[0]
        if node is SKShapeNode {
        let shapenode = node as! SKShapeNode
            if shapenode.strokeColor == noneditColor{
                return
            }
        
            let selectedbox = scene!.userData?["selectedbox"]
            if selectedbox is Int {
                if (selectedbox as! Int != -1){
                let sbnode = scene!.children[selectedbox as! Int] as! SudokuBoxSKNode
                
                let insidenode = sbnode.children[0] as! SKShapeNode
                    insidenode.strokeColor = strokeColor
                    
                }
                
                    
                
                
                    shapenode.strokeColor = noneditColor
                    scene!.userData!["selectedbox"] = userData!["id"]
            }
        }
        
           }
    
    func changetext(theEvent: NSEvent)->Bool{
        if let num = Int (theEvent.characters!) {
            if (num == 0){
                return false
            }
            
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
            node.fontColor = editCorrectColor
            }
            return true
        }
        
        node.fontColor = editInCorrectColor
            return false
        
        
    }
    
    
    func correctChangeColor(isChange: Bool){
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
         node.fontColor = editInCorrectColor
        
    }
    
    

    
    func setSelected(){
        
        let insidenode = self.children[0] as! SKShapeNode
        insidenode.strokeColor = noneditColor
        
    
    }
    
    func setDeselected(){
        
        let insidenode = self.children[0] as! SKShapeNode
        insidenode.strokeColor = strokeColor
        
        
    }
    
    func isEditable() -> Bool{
       
        return userData!["editable"] as! Bool
        
    }
    
    func isCorrect() -> Bool{
        let node = self.children[0].children[0] as! SKLabelNode
        
        if (node.text == nil){
         return false
        }
        
       let num =  Int (node.text!)
       
        
        if num == (userData!["correctnum"] as! Int) {
            return true
           
        }else{
            return false
                    }

    }

    
    func setShowhint(isShowHint :Bool){
        userData!["showhint"] = isShowHint
    }
    
    
    func updatehint(){
        
        
        if self.children[0].children.count > 1 {
            
            
            
            for _ in 1...self.children[0].children.count-1{
                self.children[0].children[1].removeFromParent()
            }
            
        }
        
        if (!isEditable()){
            return;
        }
        
    
   
        
        if (isCorrect() || userData!["showhint"] as! Bool == false) {
            
            
            return
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
        for var i=9+x;i<=89;i+=9{
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
        
       
        let sortarray = checkarray.sort()
        

        var shiftinc: Int = 0;
        
        for i in sortarray{
        
        let hintlablenode = SKLabelNode()
            hintlablenode.text = String (i)
            hintlablenode.fontName = "Futura"
            hintlablenode.fontSize = 15
            
            hintlablenode.fontColor = NSColor(red:0.95,green:0.8,blue:0.9,alpha:1)
        
             var labelpos = CGPointMake(-30, 8)
            
            
            if (shiftinc == 1 ){
                
                labelpos.y -= 15
               
            }else if (shiftinc == 3){
                labelpos.y -= 30
            }
            else if(shiftinc == 2  ){
             
                    
                    labelpos.x +=   15
                
            }else if (shiftinc >= 4){
                labelpos.x +=  CGFloat (shiftinc - 2) * 15

            }
            
                hintlablenode.position = labelpos
            
            ++shiftinc
            
            self.children[0].addChild(hintlablenode)

        }
        
    
        
        
        
        
    }




}
