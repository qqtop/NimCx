{.deadCodeElim: on , optimization: speed.}
import cxglobal,cxconsts,cxprint,cxtruecolor
import strutils,terminal,sets

# cxfont.nim
#
# Experimental font building 
# 
# currently removed from nimcx 2019-05-31
# 
# status ok : needs more testing
#
# experimental font, slim numbers , swampfont , dotmatrix ,
# 
# slimfont and  bracketmatrix font 
# 
# 
# try : 
# 
# 
# Last : 2019-06-03  
# 
# 
# Examples :
#     let myfont = createCxFont("bracketmatrix")
#     printCxFontText(@[30,25,29,1,2,3,4],xpos = 2,myfont)   #  prints NIM 1234
#     decho(10)
#     printfont("nimcx")
#     decho(10)
#     printfontfancy("nimcx")
#     decho(10)
#     cx1(10)
#     cx2(20)
#     cx3(30)
#     cx4(40)
#     cx5(50)
#     cx6(60)
#     cx7(70)
#     cx8(80)
#     cx9(90)
#     cxzero(100)
#     decho(10)
#     slimL("cxfont")
#     decho(8)
# 
# 

# type used in slim number printing
type
    T7 = object  
      zx : seq[string]
      
# experimental your results may depend on terminal in use
# 
# suggested : konsole for best effect with truecolor , adjust terminal width 
# 
# and char size for desired effect
# 
proc fprint*[T](astring:T,
               fgr:string = getFg(fgDefault),
               xpos:int = 0,
               fitLine:bool = false,
               centered:bool = false,
               styled : set[Style]= {},
               substr:string = "") =
 
    ## ::
    ##   print2
    ## 
    ##   the old print routine with backgroundcolor set to black only  ,
    ##   
    ##   required by printfont ,fprintln2 , printBiCol2 and printLnBiCol2
    ##
    ##   basically similar to terminal.nim styledWriteLine with more functionality
    ##   
    ##   fgr foreground colors can be set
    ##  
    ##   xpos allows positioning on x-axis
    ##  
    ##   fitLine = true will try to write the text into the current line irrespective of xpos
    ##  
    ##   centered = true will try to center and disregard xpos
    ##   
    ##   styled allows style parameters to be set 
    ##         
    ##   available styles :
    ##  
    ##   styleBright = 1,            # bright text
    ##  
    ##   styleDim,                   # dim text
    ##  
    ##   styleUnknown,               # unknown
    ##  
    ##   styleUnderscore = 4,        # underscored text
    ##  
    ##   styleBlink,                 # blinking/bold text
    ##  
    ##   styleReverse = 7,           # reverses currentforground and backgroundcolor
    ##  
    ##   styleHidden                 # hidden text
    ##  
    ##   styleItalic                 # italic
    ##   
    ##   styleStrikethrough          # strikethrough
    ##     
    ##   for extended colorset background colors use styleReverse
    ##  
    ##   or use 2 or more print statements for the desired effect
    ##
    ## Example
    ##
    ##.. code-block:: nim
    ##    # To achieve colored text with styleReverse try:
    ##    setBackgroundColor(bgRed)
    ##    print2("The end never comes on time ! ",pastelBlue,styled = {styleReverse})
    ##
    {.gcsafe.}:
        var npos = xpos
        if centered == false:
            if npos > 0:  # the result of this is our screen position start with 1
                setCursorXPos(npos)

            if ($astring).len + xpos >= tw:
                if fitLine == true:
                    # force to write on same line within in terminal whatever the xpos says
                    npos = tw - ($astring).len
                    setCursorXPos(npos)

        else:
            # centered == true
            npos = centerX() - (($astring).len div 2) - 1
            setCursorXPos(npos)

        if styled != {}:
            let s = $astring            
            if substr.len > 0:
                let rx = s.split(substr)
                for x in rx.low .. rx.high:
                    writestyled(rx[x],{})
                    if x != rx.high:
                         styledEchoPrint(fgr,styled,substr,bgBlack)
            else:
                   
                    styledEchoPrint(fgr,styled,s,bgBlack)
        else:
           
                setBackGroundColor(bgBlack)
                try:
                   styledEchoPrint(fgr,{},$astring,bgBlack)
                except:
                   echo astring

        # reset to white/black 
        setForeGroundColor(fgWhite)
        setBackGroundColor(bgBlack)
              
    
    
proc fprintln*[T](astring:T,
              fgr     : string = termwhite,
              xpos    : int = 0,
              fitLine : bool = false,
              centered: bool = false,
              styled  : set[Style] = {},
              substr  : string = "") =  
    ## 
    ## ::
    ##   fprintln2
    ## 
    ##  
    ##   foregroundcolor
    ##   best on black backgroundcolor
    ##   position
    ##   fitLine
    ##   centered
    ##   styled
    ##  
    ## Examples
    ##
    ##.. code-block:: nim
    ##    fprintln2("Yes ,  we made it.",clrainbow) 
    ##    fprintln2("Yes ,  we made it.",green)
    ##    # or use it as a replacement of echo
    ##    fprintln2(red & "What's up ? " & green & "Grub's up ! ")
    ##    fprintln2("No need to reset the original color")
    ##    fprintln2("Nim does it again",peru,centered = true ,styled = {styleDim,styleUnderscore},substr = "i")
    ##    # To achieve colored text with styleReverse try:
    ##    loopy2(0,30):
    ##        fprintln2("The end never comes on time ! ",randcol(),styled = {styleReverse})
    ##        print cleareol
    ##        sleepy(0.1)
    ##
    fprint($(astring) & "\n",fgr,xpos,fitLine,centered,styled,substr)
    



template cxZero*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 7)
         echo()
         cxprint(xpos,col,efb2 * 7)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(3) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(3) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(3) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,efb2 * 7)
         curup(6)         
          
template cx1*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
         let xpos = npos+5
         cxprint(xpos,coltop,spaces(4) & efb3 * 2)
         echo()
         cxprint(xpos,col,spaces(3) & efb1 & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(1) & efb1 & spaces(2) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(4) & efs2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(4) & efb2 * 2)
         curup(6) 
           
           
template cx2*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,spaces(2) & efb3 * 4 & spaces(4))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 & efb1 * 4 & efs2 & spaces(2))
         echo()
         cxprint(xpos,col,spaces(6) & efs2 * 1 & spaces(1))
         echo()
         cxprint(xpos,col,spaces(2) & efs2 * 3 & efb1 & spaces(3))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 * 1 & spaces(4) & spaces(2))
         echo()
         cxprintLn(xpos,col,spaces(1) & efb1 * 1 & efb2 * 4 & efb1 * 1 & spaces(2))
         curup(6) 
 
        
           
            
template cx3*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

         let xpos = npos+5
         cxprint(xpos,coltop,spaces(1) & efb3 * 6)
         echo()
         cxprint(xpos,col,spaces(1) & efb2 * 6)
         echo()
         cxprint(xpos,col,spaces(5) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(3) & efs2 * 3 & spaces(1))
         echo()
         cxprint(xpos,col,spaces(5) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(1) & efb2 * 6)
         curup(6)      


template cx4*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos+5
         cxprint(xpos,coltop,spaces(5) & efb3 * 1)
         echo()
         cxprint(xpos,col,spaces(5) & efb2 * 1)
         echo()
         cxprint(xpos,col,spaces(3) & efb1 * 1 & spaces(1) & efs2 & spaces(3))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 * 1 & spaces(3) & efb2)
         echo()
         cxprint(xpos,col,spaces(0) & efs2 * 1 & spaces(1) & efs2 & spaces(1) & efs2 * 4)
         echo()
         cxprintLn(xpos,col,spaces(4) & efb2 * 2)
         curup(6)               
         
              
template cx5*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,spaces(2) & efb3 * 5 & spaces(4))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 & efb1 * 5 & spaces(2))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 * 1 & spaces(7))
         echo()
         cxprint(xpos,col,spaces(1) & efb1 & spaces(0) & efs2 * 2 & spaces(1) & efs2 & spaces(3))
         echo()
         cxprint(xpos,col,spaces(6) & efb1 * 1 & spaces(1))
         echo()
         cxprintLn(xpos,col,spaces(1) & efb1 * 1 & efb2 * 3 & efb1 & spaces(3))
         curup(6)               
                            
              
              
template cx6*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,spaces(2) & efb3 * 4 & spaces(4))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 & efb1 * 4 & spaces(3))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 * 1 & spaces(7))
         echo()
         cxprint(xpos,col,spaces(1) & efb2 & spaces(1) & efs2 * 1 & spaces(1) & efs2 & spaces(3))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 * 1 & spaces(4) & efb1 * 1 & spaces(1))
         echo()
         cxprintLn(xpos,col,spaces(2) & efb1 & efb2 * 2 & efb1 & spaces(3))
         curup(6)               
              
     
              
template cx7*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 7)
         echo()
         cxprint(xpos,col,efb2 * 7)
         echo()
         cxprint(xpos,col,spaces(5) & efs2 * 1 & efb1)
         echo()
         cxprint(xpos,col,spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(4) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(4) & efb2 * 2)
         curup(6)  
 

template cx8*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,col,spaces(2) & efb3 * 4 & spaces(4))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 & efb1 & efb1 * 2 & efb1 & efs2 & spaces(2))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 * 1 & spaces(4) & efs2 * 1 & spaces(1))
         echo()
         cxprint(xpos,col,spaces(2) & efb1 & efs2 * 2 & efb1 * 1 & spaces(1))
         echo()
         cxprint(xpos,col,spaces(1) & efs2 * 1 & spaces(4) & efs2 * 1 & spaces(1))
         echo()
         cxprintLn(xpos,col,spaces(2) & efb1 & efb2 * 2 & efb1 & spaces(3))
         curup(6) 
 
 
 
 
template cx9*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,spaces(1) & efb3 * 6)
         echo()
         cxprint(xpos,col,efs2 & efb1 * 3 & efb2 * 3)
         echo()
         cxprint(xpos,col,spaces(0) & efs2 * 1 & spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(1) & efb1 & efs2 * 3 & efb1 * 2)
         echo()
         cxprint(xpos,col,spaces(5) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(5) & efb2 * 2)
         curup(6)  
 
 
 
proc cx10*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =
         cx1(npos,col,coltop)
         cxzero(npos + 9,col,coltop)
 
 
 
template cxa*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
         let xpos = npos + 5
         cxprint(xpos,coltop,spaces(4) & efb3 * 2 & spaces(3))
         echo()
         cxprint(xpos,col,spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(2) & efb2 * 2 & spaces(2) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(2) & efs2 * 6)
         echo()
         cxprint(xpos,col,spaces(1) & efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(1) & efb2 * 2 & spaces(4) & efb2 * 2)
         curup(6)
        
            
template cxb*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 5)
         echo()
         cxprint(xpos,col,efb2 * 4 & spaces(1) & efb2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2)
         echo()
         cxprint(xpos,col,efb2 * 3 & efs2 & spaces(0) & efs2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2)
         echo()
         cxprintLn(xpos,col,efb2 * 4 & spaces(1) & efb2)
         curup(6)

template cxc*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

         let xpos = npos+5
         cxprint(xpos,coltop,spaces(1) & efb3 * 6)
         echo()
         cxprint(xpos,col,spaces(1) & efb2 * 6)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprint(xpos,col,efs2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(1) & efb2 * 6)
         curup(6)
              
              
template cxd*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 5)
         echo()
         cxprint(xpos,col,efb2 * 4 & spaces(1) & efb2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efs2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2)
         echo()
         cxprintLn(xpos,col,efb2 * 4 & spaces(1) & efb2)
         curup(6)

         
  
template cxe*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 7)
         echo()
         cxprint(xpos,col,efb2 * 7)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 5)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprintLn(xpos,col,efb2 * 7)
         curup(6)  
 
template cxf*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 7)
         echo()
         cxprint(xpos,col,efb2 * 7)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 5)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprintLn(xpos,col,efb2 * 2)
         curup(6)  
 

template cxg*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

        let xpos = npos+5
        cxprint(xpos,coltop,spaces(1) & efb3 * 6)
        echo()
        cxprint(xpos,col,spaces(1) & efb2 * 6)
        echo()
        cxprint(xpos,col,col,efb2 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & spaces(2) & efs2 * 3)
        echo()
        cxprint(xpos,col,efb2 * 2 & spaces(3) & efb2 * 2)
        echo()
        cxprintLn(xpos,col,spaces(1) & efb2 * 6)
        curup(6)
             
template cxh*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
        let xpos = npos + 5
        cxprint(xpos,coltop,efb3 * 2 & spaces(4) & efb3 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & efs2 * 4 & efb2 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
        echo()
        cxprintLn(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
        curup(6)   
 
template cxi*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    

        loopy2(0,2):
           let xpos = xloopy+npos+7
           cxprint(xpos,coltop,efb3)
           echo()
           cxprint(xpos,col,efb2)
           echo()
           cxprint(xpos,col,efb2)
           echo()
           cxprint(xpos,col,efb2)
           echo()
           cxprint(xpos,col,efb2)
           echo()
           cxprintLn(xpos,col,efb2)
           curup(6)
           
             
template cxj*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    

        loopy2(0,2):
           let xpos = xloopy+npos+5
           cxprint(xpos,coltop,spaces(2) & efb3 * 2)
           echo()
           cxprint(xpos,col,spaces(2) & efb2 * 2)
           echo()
           cxprint(xpos,col,spaces(2) & efb2 * 2)
           echo()
           cxprint(xpos,col,spaces(2) & efb2 * 2)
           echo()
           cxprint(xpos,col,efs2 & spaces(1) & efb2 * 2)
           echo()
           cxprintLn(xpos,col,spaces(1) & efb2 & efb2)
           curup(6) 
           
           
           
template cxk*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
         let xpos = npos+5
         cxprint(xpos,coltop,efb3 * 2 & spaces(4) & efb3 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb1 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(2) & efs2 * 2)
         echo() 
         cxprint(xpos,col,efb2 * 2 & efs2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(2) & efs2 * 2)
         echo() 
         cxprintLn(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         curup(6)          
         
template cxl*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprintLn(xpos,col,efb2 * 7)
         curup(6)
              
template cxm*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
        let xpos = npos + 5
        cxprint(xpos,coltop, efb3 * 2 & spaces(5) & efb3 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & efs2 & spaces(3) & efs2 & efb2 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & spaces(1) & efs2 & spaces(1) & efs2 & spaces(1) & efb2 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & spaces(2) & efs2 & spaces(2) & efb2 * 2)
        echo()
        cxprint(xpos,col,efb2 * 2 & spaces(5) & efb2 * 2)
        echo()
        cxprintLn(xpos,col,efb2 * 2 & spaces(5) & efb2 * 2)
        curup(6) 
        
template cxn*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
         let xpos = npos + 5
         
         cxprint(xpos,coltop,efb3 * 2 & spaces(4) & efb3 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & efs2 & spaces(3) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(1) & efs2 & spaces(2) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(2) & efs2 & spaces(1) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(3) & efs2 & efb2 * 2)
         echo()
         cxprintLn(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         curup(6)  
 
template cxo*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,spaces(2) , coltop, efb3 * 4)
         echo()
         cxprint(xpos,spaces(2) ,col, efb2 * 4)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efs2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprintLn(xpos,spaces(2) , col, efb2 * 3 & efb2)
         curup(6) 
          
template cxp*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 5)
         echo()
         cxprint(xpos,col,efb2 * 4 & spaces(1) & efb2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2)
         echo()
         cxprint(xpos,col,efb2 * 3 & efs2 & spaces(0) & efs2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2)
         echo()
         cxprintLn(xpos,col,efb2 * 2)
         curup(6)
   
 
template cxq*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,spaces(2) & efb3 * 4)
         echo()
         cxprint(xpos,col,spaces(2) & efb2 * 3 & efb2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efs2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(3) & efs2 & efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(2) & efb2 * 3 & efb2 & rslash)
         curup(6) 

template cxr*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 5)
         echo()
         cxprint(xpos,col,efb2 * 4 & spaces(1) & efb2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(3) & efb3 & efb2)
         echo()
         cxprint(xpos,col,efb2 * 2 & efs2 * 2 & spaces(0) & efs2 * 1)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(1) & efs2)
         echo()
         cxprintLn(xpos,col,efb2 * 2 & spaces(3) & efb2 * 2)
         curup(6)
 
template cxs*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,spaces(3) & efb3 * 5)
         echo()
         cxprint(xpos,col,spaces(1) & efb1 & spaces(1) & efb1 * 5)
         echo()
         cxprint(xpos,col,efb1 * 1 & spaces(1) & efs2 * 1)
         echo()
         cxprint(xpos,col,spaces(4) & efb1 & efs2 * 1)
         echo()
         cxprint(xpos,col,spaces(5) & efs2 * 2,col)
         echo()
         cxprintLn(xpos,col,efb2 * 5 & efs2 * 1 & efb1 * 1)
         curup(6)  
  
 
template cxt*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 8)
         echo()
         cxprint(xpos,col,efb2 * 8)
         echo()
         cxprint(xpos,col,spaces(3) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(3) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(3) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(3) & efb2 * 2)
         curup(6)   
         
            
         
template cxu*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 2 & spaces(4) & efb3 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efs2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(1) & efb2 * 6)
         curup(6)         
         

         
template cxv*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 2 & spaces(4) & efb3 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(4) & efs2 * 2)
         echo()
         cxprint(xpos,col,spaces(1) & efb2 * 2 & spaces(2) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,spaces(3) & efb2 * 2 ,col)
         curup(6)          
         
         
template cxw*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 2 & spaces(5) & efb3 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(5) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(5) & efb2 * 2)
         echo()
         cxprint(xpos,col,efb2 * 2 & spaces(2) & efs2 & spaces(2) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(1) & efb1 * 2 & spaces(0) & efs2 & spaces(1) & efs2 & spaces(0) & efb1 * 2)
         echo()
         cxprintLn(xpos,col,spaces(2) & efb2 * 2 & spaces(1) & efb2 * 2)
         curup(6)          
 
              
template cxx*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
         let xpos = npos+5
         cxprint(xpos,coltop,spaces(1) & efb3 * 2 & spaces(3) & efb3 * 2 & spaces(1))
         echo()
         cxprint(xpos,col,spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2 & spaces(1))
         echo()
         cxprint(xpos,col,spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2 & spaces(2))
         echo()
         cxprint(xpos,col,spaces(4) & efl1 * 2 & spaces(4))
         echo()
         cxprint(xpos,col,spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2 & spaces(2))
         echo()
         cxprintLn(xpos,col,spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2 & spaces(1))
         curup(6)

                   
template cxy*(npos:int=0,col: string=rndCol(),coltop:string = rndCol()) = 
         let xpos = npos + 5
         cxprint(xpos,coltop,spaces(1) & efb3 * 2 & spaces(3) & efb3 * 2)
         echo()
         cxprint(xpos,col,spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2)
         echo()
         cxprint(xpos,col,spaces(4) & efl1 * 2)
         echo()
         cxprint(xpos,col,spaces(4) & efl1 * 2)
         echo()
         cxprintLn(xpos,col,spaces(3) & efl1 * 4)
         curup(6)
             
 
template cxz*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         cxprint(xpos,coltop,efb3 * 8)
         echo()
         cxprint(xpos,efb2 * 8)
         echo()
         cxprint(xpos,col,spaces(6) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(3) & efb2 * 2)
         echo()
         cxprint(xpos,col,spaces(0) & efb2 * 2)
         echo()
         cxprintLn(xpos,col,efb2 * 8,col)    
         curup(6)
 
 
 
template cxpoint*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
         let xpos = npos+5
         cxprint(xpos,coltop,efb3 * 0)
         echo()
         cxprint(xpos,col,efb2 * 0)
         echo()
         cxprint(xpos,col,efb2 * 0)
         echo()
         cxprint(xpos,col,efb2 * 0)
         echo()
         cxprint(xpos,col,efb3 * 2)
         echo()
         cxprintLn(xpos,col,efb2 * 2)
         curup(6)   
 
 
 
template cxhyphen*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
         let xpos = npos+5
         cxprint(xpos,coltop,efb3 * 0)
         echo()
         cxprint(xpos,col,efb2 * 0)
         echo()
         cxprint(xpos,col,efb3 * 5)
         echo()
         cxprint(xpos,col,efb2 * 5)
         echo()
         cxprint(xpos,col,efb2 * 0)
         echo()
         cxprintLn(xpos,col,efb2 * 0)
         curup(6)    
       
template cxgrid*(npos:int = 0,col:string=rndCol,coltop:string = rndcol) =    
         # for testing purpose only
         let xpos = npos + 5
         let xwd  = 9
         loopy2(0,xwd): 
             print(efb3,coltop,xpos = xpos + xloopy)
         echo()
         loopy2(0,5):
               loopy2(0,xwd) :
                  print(efb2,col,xpos = xpos + xloopy)
               echo()  
         curup(6)
 
proc printFont*(s:string,col:string = rndCol() ,coltop:string = rndCol(), xpos:int = -10) = 
     ## printFont
     ## 
     ## display experimental cxfont
     ## 
     ## search cxTest for example proc printFontTest
     ## 
     ## 

     var npos = xpos
     var ccol = col
     for x in s.toLowerAscii:
        
        npos = npos + 10
        case x 
            of 'a' : 
                     npos = npos - 1
                     cxa(npos,ccol,coltop)
                     npos = npos + 1
            of 'b' : 
                     cxb(npos,ccol,coltop)
                     npos = npos - 1
            of 'c' : cxc(npos,ccol,coltop)
            of 'd' : 
                     cxd(npos,ccol,coltop)
                     npos = npos - 1
            of 'e' : cxe(npos,ccol,coltop)
            of 'f' :
                     cxf(npos,ccol,coltop)
                     npos = npos - 1
            of 'g' : cxg(npos,ccol,coltop)
            of 'h' : cxh(npos,ccol,coltop)
            of 'i' : 
                     npos = npos - 2
                     cxi(npos,ccol,coltop)
                     npos = npos - 4
            of 'j' : 
                     cxj(npos,ccol,coltop)
                     npos = npos - 2
            of 'k' : cxk(npos,ccol,coltop)
            of 'l' : 
                     cxl(npos,ccol,coltop)
                     npos = npos - 1
            of 'm' : 
                     cxm(npos,ccol,coltop)
                     npos = npos + 1
                     
            of 'n' : cxn(npos,ccol,coltop)
            of 'o' : cxo(npos,ccol,coltop)
            of 'p' : 
                     cxp(npos,ccol,coltop)
                     npos = npos - 1
                     
            of 'q' : cxq(npos,ccol,coltop)
            of 'r' : cxr(npos,ccol,coltop)
            of 's' : cxs(npos,ccol,coltop)
            of 't' : cxt(npos,ccol,coltop)
            of 'u' : cxu(npos,ccol,coltop)
            of 'v' : cxv(npos,ccol,coltop)
            of 'w' : 
                     cxw(npos,ccol,coltop)
                     npos = npos + 1
            of 'x' : 
                     npos = npos - 1
                     cxx(npos,ccol,coltop)
            of 'y' : 
                     npos = npos - 2
                     cxy(npos,ccol,coltop)
                     
            of 'z' : cxz(npos,ccol,coltop)
            of '.' : 
                     cxpoint(npos,ccol,coltop)
                     npos = npos - 5
            of '-' : 
                     cxhyphen(npos,ccol,coltop)
                     npos = npos - 3
                     
            of ' ' : npos = npos - 5
            of '1' : 
                     cx1(npos,ccol,coltop)
                     npos = npos - 2
            of '2' : cx2(npos,ccol,coltop)
            of '3' : cx3(npos,ccol,coltop)
            of '4' : cx4(npos,ccol,coltop)
            of '5' : cx5(npos,ccol,coltop)
            of '6' : cx6(npos,ccol,coltop)
            of '7' : 
                     cx7(npos,ccol,coltop)
                     npos = npos - 1
            of '8' : cx8(npos,ccol,coltop)
            of '9' : cx9(npos,ccol,coltop)
            of '0' : cxzero(npos,ccol,coltop)
                      
            else: discard 

            
    
proc printFontFancy*(s:string, coltop1 = rndcol(),xpos:int = -10) = 
     ## printFontFancy
     ## 
     ## display experimental cxfont with every element in rand color
     ## changing of coltop color possible
     ## 
     ## 
     ## 
     var npos = xpos
     #var coltop = rndTrueCol() 
     var coltop = randCol()
     for x in s.toLowerAscii:
        npos += 10
        case x 
            of 'a' : 
                     npos = npos - 1
                     cxa(npos,coltop=coltop)
                     npos = npos + 1
            of 'b' : 
                     cxb(npos,coltop=coltop)
                     npos = npos - 1
            of 'c' : cxc(npos,coltop=coltop)
            of 'd' : 
                     cxd(npos,coltop=coltop)
                     npos = npos - 1
            of 'e' : cxe(npos,coltop=coltop)
            of 'f' :
                     cxf(npos,coltop=coltop)
                     npos = npos - 1
            of 'g' : cxg(npos,coltop=coltop)
            of 'h' : cxh(npos,coltop=coltop)
            of 'i' : 
                     npos = npos - 2
                     cxi(npos,coltop=coltop)
                     npos = npos - 4
            of 'j' : 
                     cxj(npos,coltop=coltop)
                     npos = npos - 2
            of 'k' : cxk(npos,coltop=coltop)
            of 'l' : 
                     cxl(npos,coltop=coltop)
                     npos = npos - 1
            of 'm' : 
                     cxm(npos,coltop=coltop)
                     npos = npos + 1
                     
            of 'n' : cxn(npos,coltop=coltop)
            of 'o' : cxo(npos,coltop=coltop)
            of 'p' : 
                     cxp(npos,coltop=coltop)
                     npos = npos - 1
                     
            of 'q' : cxq(npos,coltop=coltop)
            of 'r' : cxr(npos,coltop=coltop)
            of 's' : cxs(npos,coltop=coltop)
            of 't' : cxt(npos,coltop=coltop)
            of 'u' : cxu(npos,coltop=coltop)
            of 'v' : cxv(npos,coltop=coltop)
            of 'w' : 
                     cxw(npos,coltop=coltop)
                     npos = npos + 1
            of 'x' : 
                     npos = npos - 1
                     cxx(npos,coltop=coltop)
            of 'y' : 
                     npos = npos - 2
                     cxy(npos,coltop=coltop)
                     
            of 'z' : cxz(npos,coltop=coltop)
            of '.' : 
                     cxpoint(npos,coltop=coltop)
                     npos = npos - 5
            of '-' : 
                     cxhyphen(npos,coltop=coltop)
                     npos = npos - 3
                     
            of ' ' : npos = npos - 5
            of '1' : 
                     cx1(npos,coltop=coltop)
                     npos = npos - 2
            of '2' : cx2(npos,coltop=coltop)
            of '3' : cx3(npos,coltop=coltop)
            of '4' : cx4(npos,coltop=coltop)
            of '5' : cx5(npos,coltop=coltop)
            of '6' : cx6(npos,coltop=coltop)
            of '7' : 
                     cx7(npos,coltop=coltop)
                     npos = npos - 1
            of '8' : cx8(npos,coltop=coltop)
            of '9' : cx9(npos,coltop=coltop)
            of '0' : cxzero(npos,coltop=coltop)
                      
            else: discard             
 
proc printNimCx*(npos:int = tw div 2 - 30) =
        ## printNimcx
        ## 
        ##  experiments in block font building , default is center in terminal
        ## 
        #echo()
        var xpos = npos
        cxn(xpos,dodgerblue,coltop=gold)
        cxi(xpos+10,truetomato,coltop=gold)
        cxm(xpos+17,gold,coltop=gold)
        let colc = randCol2("light")
        cxc(xpos+29, colc,coltop=red)
        cxx(xpos+38,coltop=red) 
        #echo()
              

proc printMadeWithNim*(npos:int = tw div 2 - 60) =
        ## printNimcx
        ## 
        ##  experiments in block font building , default is center in terminal
        ## 
        echo()
        var xpos = npos
        cxm(xpos     ,rndCol(),coltop=red)
        cxa(xpos + 10,rndCol(),coltop=red)
        cxd(xpos + 21,rndCol(),coltop=red)
        cxe(xpos + 30,rndCol(),coltop=red)
        
        cxw(xpos + 42,rndCol(),coltop=red)
        cxi(xpos + 52,rndCol(),coltop=red)
        cxt(xpos + 58,rndCol(),coltop=red)
        cxh(xpos + 68,rndCol(),coltop=red)
        
        cxn(xpos + 82,dodgerblue,coltop=gold)
        cxi(xpos + 90,truetomato,coltop=gold)
        cxm(xpos + 96,gold,coltop=gold)
        echo()

proc printNim*(npos:int = tw div 2 - 60) =  
        echo()
        var xpos = npos
        cxn(xpos,brightcyan,coltop=red)
        cxi(xpos + 9,brightcyan,coltop=lime)
        cxm(xpos + 16,brightcyan,coltop=red)
        echo()  
        
# end experimental font   


# printing of slimfonts related routine

proc printSlimNumber*(anumber:string,fgr:string = yellowgreen ,bgr:string = getBg(bgDefault),xpos:int = 1) =
    ## printSlimNumber
    ##
    ## # will shortly be deprecated use:  printSlim
    ##
    ## prints an string in big slim font
    ##
    ## available chars 123456780,.:
    ##
    ##
    ## usufull for big counter etc , a clock can also be build easily but
    ## running in a tight while loop just uses up cpu cycles needlessly.
    ##
    ##.. code-block:: nim
    ##    for x in 990.. 1005:
    ##         cleanScreen()
    ##         printSlimNumber($x)
    ##         sleep(750)
    ##    echo()
    ##
    ##    printSlimNumber($23456345,blue)
    ##    decho(2)
    ##    printSlimNumber("1234567:345,23.789",fgr=salmon,xpos=20)
    ##    sleep(1500)
    ##    import times
    ##    cleanScreen()
    ##    decho(2)
    ##    printSlimNumber($getClockStr(),fgr=salmon,xpos=20)
    ##    decho(5)
    ##
    ##    for x in rxCol:
    ##       printSlimNumber($x,colorNames[x][1])
    ##       curup(3)
    ##       sleep(500)
    ##    curdn(3)

    var asn = newSeq[string]()
    var printseq = newSeq[seq[string]]()
    for x in anumber: asn.add($x)
    for x in asn:
      case  x
        of "0": printseq.add(snumber0)
        of "1": printseq.add(snumber1)
        of "2": printseq.add(snumber2)
        of "3": printseq.add(snumber3)
        of "4": printseq.add(snumber4)
        of "5": printseq.add(snumber5)
        of "6": printseq.add(snumber6)
        of "7": printseq.add(snumber7)
        of "8": printseq.add(snumber8)
        of "9": printseq.add(snumber9)
        of ":": printseq.add(scolon)
        of ",": printseq.add(scomma)
        of ".": printseq.add(sdot)
        else: discard

    for x in 0.. 2:
        curSetx(xpos)
        for y in 0..<printseq.len:
            print(" " & printseq[y][x],fgr,bgr)
        writeLine(stdout,"")



proc slimN(x:int):T7 =
  # supporting slim number printing
  var nnx : T7
  case x
    of 0: nnx.zx = snumber0
    of 1: nnx.zx = snumber1
    of 2: nnx.zx = snumber2
    of 3: nnx.zx = snumber3
    of 4: nnx.zx = snumber4
    of 5: nnx.zx = snumber5
    of 6: nnx.zx = snumber6
    of 7: nnx.zx = snumber7
    of 8: nnx.zx = snumber8
    of 9: nnx.zx = snumber9
    else: discard
  result = nnx


proc slimC(x:string):T7 =
  # supporting slim chars printing
  var nnx:T7
  case x
    of ".": nnx.zx = sdot
    of ",": nnx.zx = scomma
    of ":": nnx.zx = scolon
    of " ": nnx.zx = sblank
    else : discard
  result = nnx


proc prsn(x:int,fgr:string = termwhite,xpos:int = 0) =
     # print routine for slim numbers
     for x in slimN(x).zx: fprintln(x,fgr = fgr,xpos = xpos)

proc prsc(x:string,fgr:string = termwhite,xpos:int = 0) =
     # print routine for slim chars
     for x in slimc(x).zx: fprintln($x,fgr = fgr,xpos = xpos)


proc printSlim* (ss:string = "", frg:string = termwhite,xpos:int = 0,align:string = "left") =
    ## printSlim
    ##
    ## prints available slim numbers and slim chars
    ##
    ## right alignment : the string will be written left of xpos position
    ## left  alignment : the string will be written right of xpos position
    ##
    ## make sure enough space is available left or right of xpos
    ##
    ##.. code-block:: nim
    ##      printSlim($"82233.32",salmon,xpos = 25,align = "right")
    ##      decho(3)
    ##      printSlim($"33.87",salmon,xpos = 25,align = "right")
    ##      ruler(25,lime)
    ##      decho(3)
    ##      printSlim($"82233.32",peru,xpos = 25)
    ##      decho(3)
    ##      printSlim($"33.87",peru,xpos = 25)
    ##

    var npos = xpos
    #if we want to right align we need to know the overall length, which needs a scan
    var sswidth = 0
    if align.toLowerAscii() == "right":
      for x in ss:
         if $x in slimCharSet:
           sswidth = sswidth + 1
         else:
           sswidth = sswidth + 3

    for x in ss:
      if $x in slimcharset:
        prsc($x ,frg, xpos = npos - sswidth)
        npos = npos + 1
        curup(3)
      else:
        var mn:int = parseInt($x)
        prsn(mn ,frg, xpos = npos - sswidth)
        npos = npos + 3
        curup(3)


# routines for slimL another attempt for slimfonts
# EXPERIMENTAL:
# TODO: starting pos adjustment not yet working as expected
   
# let slimletters = """   
#      __   __   ___  __   ___  ___  ___ _  _ _  _ _  _ _    _  _ _  _  __ 
#     |__| |__] |    |  \ |___ |___ | __ |__| |  | |_/  |    |\/| |\ | |  | 
#     |  | |__] |___ |__/ |___ |    |__] |  | | _| | \_ |___ |  | | \| |__| 
#                                                                                   
#      __   __   __   __  ___ _  _ _  _ _ _ _ _  _ _   _  __   
#     |__] |  | |__/ [__   |  |  | |  | | | |  \/   \_/    /  
#     |    |_\| |  \ ___]  |  |__|  \/  |_|_| _/\_   |    /__   
#                                                                                                                                             
# """

#var xpos = -101  # just initialize xpos as a global int # maybe not needed 
 
proc printSlimL(sl:seq[string],col:string = dodgerblue,xpos:int = 1,adjuster:int = 0) =
 ## printslimL
 ## 
 ## single slimfont printing used by slimL
 ##  
 for x in 0..<sl.len: fprintln(sl[x],col,xpos=(xpos + adjuster),styled={styleBright})
 curup(3)

proc slimL*(astring:string ,col:string = truetomato,xpos:int = 5,adjuster:int = 0) =
    ## slimL
    ## 
    ## prints slimfont strings 
    ## 
    ## 
    var slpos = xpos
    
    for x in astring.tolowerascii():
       case x 
          of 'a' : printSlimL(sla,col,xpos=slpos)
          of 'b' : printSlimL(slb,col,xpos=slpos)
          of 'c' : printSlimL(slc,col,xpos=slpos)
          of 'd' : printSlimL(sld,col,xpos=slpos)
          of 'e' : printSlimL(sle,col,xpos=slpos)
          of 'f' : printSlimL(slf,col,xpos=slpos)
          of 'g' : printSlimL(slg,col,xpos=slpos)
          of 'h' : printSlimL(slh,col,xpos=slpos)
          of 'i' : 
                   printSlimL(sli,col,xpos=slpos)
                   slpos = slpos - 4     
          of 'j' : 
                   printSlimL(slj,col,xpos=slpos)
                   slpos = slpos - 2  
          of 'k' : printSlimL(slk,col,xpos=slpos)      
          of 'l' : printSlimL(sll,col,xpos=slpos)
          of 'm' : 
                   printSlimL(slm,col,xpos=slpos)
                   slpos = slpos + 1   
          of 'n' : printSlimL(sln,col,xpos=slpos)
          of 'o' : printSlimL(slo,col,xpos=slpos)
          of 'p' : printSlimL(slp,col,xpos=slpos)
          of 'q' : printSlimL(slq,col,xpos=slpos)
          of 'r' : printSlimL(slr,col,xpos=slpos)
          of 's' : printSlimL(sls,col,xpos=slpos)
          of 't' :  
                   printSlimL(slt,col,xpos=slpos)
                   slpos = slpos - 1   
          of 'u' : printSlimL(slu,col,xpos=slpos)
          of 'v' : printSlimL(slv,col,xpos=slpos) 
          of 'w' : 
                   printSlimL(slw,col,xpos=slpos)
                   slpos = slpos + 1                  
          of 'x' : printSlimL(slx,col,xpos=slpos)
          of 'y' : printSlimL(sly,col,xpos=slpos)
          of 'z' : printSlimL(slz,col,xpos=slpos)
          # TODO: numbers WIP
          of '1' : 
                   printSlimL(sl1,col,xpos=slpos)
                   slpos = slpos - 1  
          of '6' : printSlimL(sl6,col,xpos=slpos)
          

          else   : discard

       slpos = xpos + slpos

        
# routines for dotmatrix font
# see dotmatrixraw in cxconsts
        
let cxfonts = toHashSet(["dotmatrix","bracketmatrix","sideways","swamp"])

proc printCxFontLetter*(n:int,xpos:int,cxfont:seq[seq[string]],color:string,vertstepping:int) =
  for y in 0 ..< cxfont[n].len:
        fprintln(cxfont[n][y].replace("@","").replace("$",""),color,xpos = xpos,styled={styleBright}) 
  curup(vertstepping)
  
  
# Note swap needs curup(7) so need to pass in the fontname to enable a sitch ..  


proc printCxFontText*(textseq:seq[int],xpos:int = 2,cxfont:seq[seq[string]],color:string = randcol(),vertstepping:int=9,kerning:int = 19) = 
  ## printCxFontText
  ## 
  ## printtext in fonts dotmatrix,bracketmatrix,sideways,swamp
  ## 
  ## swamp needs vertstepping = 7 and kerning >= 15 
  ## 
  var nxpos = xpos
  for achar in textseq:
      printCxFontLetter(achar,nxpos,cxfont,color,vertstepping)
      nxpos = nxpos + kerning
  decho(5)

  
proc createCxFont*(name:string):seq[seq[string]] =
   if name in cxfonts:
     case name 
     
       of "dotmatrix":
                var c = dotmatrixraw.replace("_",".").replace("(","|").replace(")","|")
                var cs = c.splitlines()
                #echo "cs len : ",cs.len
                var cdotmatrixfont = newSeq[seq[string]]()
                var caseq = newseq[string]()
                for x in 0 .. cs.len - 1:
                  if cs[x].contains("@@") == true:
                      cdotmatrixfont.add(caseq)
                      caseq = @[]
                  else:    
                      caseq.add(cs[x])
                result = cdotmatrixfont  
                
       of "bracketmatrix":    # the original font in dotmatrixraw
                #echo dotmatrixraw   # prints ok
                var bs = dotmatrixraw.splitlines()
                #for x in 0 .. bs.len - 1: fprintln(bs[x],rndcol())   # ok
                #echo "bs len : ",bs.len
                var dotmatrixfont = newSeq[seq[string]]()
                var aseq = newseq[string]()
                for x in 0 .. bs.len - 1:
                    if bs[x].contains("@@") == true:
                       dotmatrixfont.add(aseq)
                       aseq = @[]
                    else:    
                       aseq.add(bs[x])
                result = dotmatrixfont    
                
       of "sideways":    # the original font in sidewaysraw
                #echo dotmatrixraw   # prints ok
                var ss = sidewaysraw.splitlines()
                #for x in 0 .. ss.len - 1: fprintln(ss[x],rndcol())   # ok
                #echo "ss len : ",ss.len
                var sidewaysfont = newSeq[seq[string]]()
                var sseq = newseq[string]()
                for x in 0 .. ss.len - 1:
                    if ss[x].contains("##") == true:
                       sidewaysfont.add(sseq)
                       sseq = @[]
                    else:    
                       sseq.add(ss[x].replace("#",""))
                result = sidewaysfont    
      
       of "swamp":    # the original font in swampraw
               
                var sw = swampraw.splitlines()
                #for x in 0 .. ss.len - 1: fprintln(ss[x],rndcol())   # ok
                #echo "ss len : ",ss.len
                var swampfont = newSeq[seq[string]]()
                var swseq = newseq[string]()
                for x in 0 .. sw.len - 1:
                    if sw[x].contains("##") == true:
                       swampfont.add(swseq)
                       swseq = @[]
                    else:    
                       swseq.add(sw[x].replace("#",""))
                result = swampfont                     
                
                
proc showCxFont*(name:string) =
     if name in cxfonts:
       case name 
          of "dotmatrix":
             decho(5)
             var cdotmatrixfont = createCxFont(name)
             #echo "dotmatrixfont len : ", cdotmatrixfont.len   
             var xpos = 2
             for x in 0 ..< cdotmatrixfont.len:
                for y in 0 ..< cdotmatrixfont[x].len:
                   printlnBiCol(cdotmatrixfont[x][y].replace("@","").replace("$","") & cxlpad(":" & $x,3),colLeft=randcol(),colRight = lightgrey,xpos = xpos)                                         
                curup(9)
                xpos = xpos + 27
                if xpos > 110: 
                    xpos = 2
                    decho(12)
             decho(5)
             
          of "bracketmatrix":
             var dotmatrixfont = createCxFont(name)
             #echo "bracketmatrix len : ", dotmatrixfont.len   
             #echo dotmatrixfont[5]
             var xpos = 2
             for x in 0 ..< dotmatrixfont.len:
                for y in 0 ..< dotmatrixfont[x].len:
                   printlnBiCol(dotmatrixfont[x][y].replace("@","").replace("$","") & cxlpad(":" & $x,3),colLeft=randcol(),colRight = lightgrey,xpos = xpos)                                                                                 
                curup(9)
                xpos = xpos + 27
                if xpos > 110: 
                  xpos = 2
                  decho(12)
             decho(5)
             
          of "sideways":   
             var sidewaysfont = createCxFont(name)
             #echo "bracketmatrix len : ", dotmatrixfont.len   
             #echo dotmatrixfont[5]
             var xpos = 2
             for x in 0 ..< sidewaysfont.len:
                for y in 0 ..< sidewaysfont[x].len:
                   printLnBiCol(sidewaysfont[x][y] & cxlpad(":" & $x,3),colLeft=randcol(),colRight = lightgrey,xpos = xpos)                                                                                 
                curup(5)
                xpos = xpos + 27
                if xpos > 110: 
                  xpos = 2
                  decho(9)
             decho(5)
             
          of "swamp":   
             var swampfont = createCxFont(name)
             #echo "bracketmatrix len : ", dotmatrixfont.len   
             #echo dotmatrixfont[5]
             var xpos = 2
             for x in 0 ..< swampfont.len:
                for y in 0 ..< swampfont[x].len:
                   printlnBiCol(swampfont[x][y] & cxlpad(":" & $x,5),colLeft=randcol(),colRight = lightgrey,xpos = xpos)                                                                                 
                curup(7)
                xpos = xpos + 27
                if xpos > 110: 
                  xpos = 2
                  decho(9)
             decho(5)   
             
       
# example usage for dotmatrix fonts
      
        
proc dotMatrixFontTest*() =
    ## dotMatrixFontTest
    ## 
    ## The current way to use fonts swamp
    ##  
    ## is to run similar as below .
    ## 
    ## for dotmatrix     use dotMatrixTyper
    ## 
    ## for bracketmatrix use bracketMatrixTyper
    ##
    ##.. code-block:: nim 
    ##  import nimcx 
    ##  showCxFont("dotmatrix")   # or "bracketmatrix"
    ## 
    ## note the numbers next to the required characters
    ## 
    ## and then 
    ## 
    ##.. code-block:: nim
    ##    let myfont = createCxFont("dotmatrix")
    ##    # lets print <NIM>123
    ##    printCxFontText(@[12,30,25,29,14,1,2,3],xpos = 2,myfont) 
    ## 
    ##    
    ## Alternatively compile cxmatrixfontE1.nim which calls this function
    ##             
    showCxFont("bracketmatrix")  
    decho(10)
    showCxFont("dotmatrix") 
    decho(10)
    showCxFont("sideways") 
    decho(10)
    showCxFont("swamp") 
    decho(10)
    
    let myfont = createCxFont("dotmatrix")
    printCxFontText(@[51,62,67,60,48,67,65,56,71],xpos = 1,myfont)  # dotmatrix
    decho(5)
    printCxFontText(@[12,30,25,29,14,0,1,2,3,4],xpos = 2,myfont)    # <NIM>01234
    decho(12)
    
    let myotherfont = createCxFont("bracketmatrix")
    printCxFontText(@[49,65,48,50,58,52,67],xpos = 1, myotherfont) # bracket
    decho(4)
    printCxFontText(@[60,48,67,65,56,71],xpos = 60,myotherfont)    # matrix
    decho(5)
    printCxFontText(@[12,30,25,29,14,5,6,7,8,9],xpos = 2,myotherfont)  # <NIM>56789
    decho(10)
    
    
    let mysidewaysfont = createCxFont("sideways")
    printCxFontText(@[41],xpos = 3,mysidewaysfont)  # N
    decho(3)
    printCxFontText(@[36],xpos = 3,mysidewaysfont)  # I
    decho(3)
    printCxFontText(@[40],xpos = 3,mysidewaysfont)  # M
    decho(3)
    printCxFontText(@[16],xpos = 3,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[14],xpos = 3,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[15],xpos = 3,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[22],xpos = 3,mysidewaysfont)  # 2
    decho(3)
    curup(25)
    printCxFontText(@[30,25,29,19,40],xpos = 50,myfont)
    decho(5)
    printCxFontText(@[60,48,67,65,56,71],xpos = 40,myotherfont)
    curup(18)
    let dl = tw - 12
    printCxFontText(@[41],xpos = dl,mysidewaysfont)  # N
    decho(3)
    printCxFontText(@[36],xpos = dl,mysidewaysfont)  # I
    decho(3)
    printCxFontText(@[40],xpos = dl,mysidewaysfont)  # M
    decho(3)
    printCxFontText(@[16],xpos = dl,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[14],xpos = dl,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[15],xpos = dl,mysidewaysfont)  # 2
    decho(3)
    printCxFontText(@[22],xpos = dl,mysidewaysfont)  # 2
    decho(3)
    
    decho(5)
    let myswampfont = createCxFont("swamp")
    printCxFontText(@[59,47,66,64,55,70],xpos = 30,myswampfont,vertstepping=7,kerning = 15)  # swamp needs vertstepping 7 to avoid steps...
    decho(12)
    


proc dotMatrixTyper*(s:string,xpos:int = 1,color:string = randcol()) =
  ## prints the entered string in dotmatrix font
  ## 
  ## no checking as to terminalwidth is done so adjust terminal width and char sizes accordingly
  ## 
  ##  will be positioned at top right of last character
  ## 
  ##.. code-block:: nim
  ##  # example for dotMatrixTyper and bracketMatrixTyper 
  ##  import nimcx 
  ##  decho(5)
  ##  dotMatrixTyper("NIMCX - ")
  ##  decho(8)
  ##  bracketMatrixTyper("bracketmatrix")
  ##  decho(12)
  
  var nxpos = xpos
  let myfont = createCxFont("dotmatrix")
  for x in s:
    
    case $x
      of "0" : printCxFontText(@[0],xpos = nxpos,cxfont=myfont,color=color) 
      of "1" : printCxFontText(@[1],xpos = nxpos,cxfont=myfont,color=color)
      of "2" : printCxFontText(@[2],xpos = nxpos,cxfont=myfont,color=color)
      of "3" : printCxFontText(@[3],xpos = nxpos,cxfont=myfont,color=color)
      of "4" : printCxFontText(@[4],xpos = nxpos,cxfont=myfont,color=color)
      of "5" : printCxFontText(@[5],xpos = nxpos,cxfont=myfont,color=color)
      of "6" : printCxFontText(@[6],xpos = nxpos,cxfont=myfont,color=color)
      of "7" : printCxFontText(@[7],xpos = nxpos,cxfont=myfont,color=color)
      of "8" : printCxFontText(@[8],xpos = nxpos,cxfont=myfont,color=color)
      of "9" : printCxFontText(@[9],xpos = nxpos,cxfont=myfont,color=color)
      of ":" : printCxFontText(@[10],xpos = nxpos,cxfont=myfont,color=color)
      of ";" : printCxFontText(@[11],xpos = nxpos,cxfont=myfont,color=color)
      of "<" : printCxFontText(@[12],xpos = nxpos,cxfont=myfont,color=color)
      of "=" : printCxFontText(@[13],xpos = nxpos,cxfont=myfont,color=color)
      of ">" : printCxFontText(@[14],xpos = nxpos,cxfont=myfont,color=color)
      of "?" : printCxFontText(@[15],xpos = nxpos,cxfont=myfont,color=color)
      of "@" : printCxFontText(@[16],xpos = nxpos,cxfont=myfont,color=color)
      of "A" : printCxFontText(@[17],xpos = nxpos,cxfont=myfont,color=color)  
      of "B" : printCxFontText(@[18],xpos = nxpos,cxfont=myfont,color=color) 
      of "C" : printCxFontText(@[19],xpos = nxpos,cxfont=myfont,color=color) 
      of "D" : printCxFontText(@[20],xpos = nxpos,cxfont=myfont,color=color)
      of "E" : printCxFontText(@[21],xpos = nxpos,cxfont=myfont,color=color)
      of "F" : printCxFontText(@[22],xpos = nxpos,cxfont=myfont,color=color)
      of "G" : printCxFontText(@[23],xpos = nxpos,cxfont=myfont,color=color)
      of "H" : printCxFontText(@[24],xpos = nxpos,cxfont=myfont,color=color)
      of "I" : printCxFontText(@[25],xpos = nxpos,cxfont=myfont,color=color)
      of "J" : printCxFontText(@[26],xpos = nxpos,cxfont=myfont,color=color)
      of "K" : printCxFontText(@[27],xpos = nxpos,cxfont=myfont,color=color)
      of "L" : printCxFontText(@[28],xpos = nxpos,cxfont=myfont,color=color)
      of "M" : printCxFontText(@[29],xpos = nxpos,cxfont=myfont,color=color)
      of "N" : printCxFontText(@[30],xpos = nxpos,cxfont=myfont,color=color)
      of "O" : printCxFontText(@[31],xpos = nxpos,cxfont=myfont,color=color)
      of "P" : printCxFontText(@[32],xpos = nxpos,cxfont=myfont,color=color)
      of "Q" : printCxFontText(@[33],xpos = nxpos,cxfont=myfont,color=color)
      of "R" : printCxFontText(@[34],xpos = nxpos,cxfont=myfont,color=color)
      of "S" : printCxFontText(@[35],xpos = nxpos,cxfont=myfont,color=color)
      of "T" : printCxFontText(@[36],xpos = nxpos,cxfont=myfont,color=color)
      of "U" : printCxFontText(@[37],xpos = nxpos,cxfont=myfont,color=color)
      of "V" : printCxFontText(@[38],xpos = nxpos,cxfont=myfont,color=color)
      of "W" : printCxFontText(@[39],xpos = nxpos,cxfont=myfont,color=color)
      of "X" : printCxFontText(@[40],xpos = nxpos,cxfont=myfont,color=color)
      of "Y" : printCxFontText(@[41],xpos = nxpos,cxfont=myfont,color=color)
      of "Z" : printCxFontText(@[42],xpos = nxpos,cxfont=myfont,color=color)
      of "[" : printCxFontText(@[43],xpos = nxpos,cxfont=myfont,color=color)
      of "\\" : printCxFontText(@[44],xpos = nxpos,cxfont=myfont,color=color)
      of "]" : printCxFontText(@[45],xpos = nxpos,cxfont=myfont,color=color)
      of "^" : printCxFontText(@[46],xpos = nxpos,cxfont=myfont,color=color)
      of "'" : printCxFontText(@[47],xpos = nxpos,cxfont=myfont,color=color)
      of "a" : printCxFontText(@[48],xpos = nxpos,cxfont=myfont,color=color)  
      of "b" : printCxFontText(@[49],xpos = nxpos,cxfont=myfont,color=color) 
      of "c" : printCxFontText(@[50],xpos = nxpos,cxfont=myfont,color=color) 
      of "d" : printCxFontText(@[51],xpos = nxpos,cxfont=myfont,color=color)
      of "e" : printCxFontText(@[52],xpos = nxpos,cxfont=myfont,color=color)
      of "f" : printCxFontText(@[53],xpos = nxpos,cxfont=myfont,color=color)
      of "g" : printCxFontText(@[54],xpos = nxpos,cxfont=myfont,color=color)
      of "h" : printCxFontText(@[55],xpos = nxpos,cxfont=myfont,color=color)
      of "i" : printCxFontText(@[56],xpos = nxpos,cxfont=myfont,color=color)
      of "j" : printCxFontText(@[57],xpos = nxpos,cxfont=myfont,color=color)
      of "k" : printCxFontText(@[58],xpos = nxpos,cxfont=myfont,color=color)
      of "l" : printCxFontText(@[59],xpos = nxpos,cxfont=myfont,color=color)
      of "m" : printCxFontText(@[60],xpos = nxpos,cxfont=myfont,color=color)
      of "n" : printCxFontText(@[61],xpos = nxpos,cxfont=myfont,color=color)
      of "o" : printCxFontText(@[62],xpos = nxpos,cxfont=myfont,color=color)
      of "p" : printCxFontText(@[63],xpos = nxpos,cxfont=myfont,color=color)
      of "q" : printCxFontText(@[64],xpos = nxpos,cxfont=myfont,color=color)
      of "r" : printCxFontText(@[65],xpos = nxpos,cxfont=myfont,color=color)
      of "s" : printCxFontText(@[66],xpos = nxpos,cxfont=myfont,color=color)
      of "t" : printCxFontText(@[67],xpos = nxpos,cxfont=myfont,color=color)
      of "u" : printCxFontText(@[68],xpos = nxpos,cxfont=myfont,color=color)
      of "v" : printCxFontText(@[69],xpos = nxpos,cxfont=myfont,color=color)
      of "w" : printCxFontText(@[70],xpos = nxpos,cxfont=myfont,color=color)
      of "x" : printCxFontText(@[71],xpos = nxpos,cxfont=myfont,color=color)
      of "y" : printCxFontText(@[72],xpos = nxpos,cxfont=myfont,color=color)
      of "z" : printCxFontText(@[73],xpos = nxpos,cxfont=myfont,color=color)
      of "{" : printCxFontText(@[74],xpos = nxpos,cxfont=myfont,color=color)
      of "|" : printCxFontText(@[75],xpos = nxpos,cxfont=myfont,color=color)
      of "}" : printCxFontText(@[76],xpos = nxpos,cxfont=myfont,color=color)
      of "~" : printCxFontText(@[77],xpos = nxpos,cxfont=myfont,color=color)
      #of "AE" : printCxFontText(@[78],xpos = nxpos,cxfont=myfont,color=color)   # some german umlaut need to be done for german keyboard
      of "Ö" : printCxFontText(@[79],xpos = nxpos,cxfont=myfont,color=color)
      #of "UE" : printCxFontText(@[80],xpos = nxpos,cxfont=myfont,color=color)
      #of "ae" : printCxFontText(@[81],xpos = nxpos,cxfont=myfont,color=color)
      of "ö" : printCxFontText(@[82],xpos = nxpos,cxfont=myfont,color=color)
      #of "ue" : printCxFontText(@[83],xpos = nxpos,cxfont=myfont,color=color)
      of "!" : printCxFontText(@[84],xpos = nxpos,cxfont=myfont,color=color)
      of "$" : printCxFontText(@[87],xpos = nxpos,cxfont=myfont,color=color)
      of "%" : printCxFontText(@[88],xpos = nxpos,cxfont=myfont,color=color)
      of "&" : printCxFontText(@[89],xpos = nxpos,cxfont=myfont,color=color)
      of "(" : printCxFontText(@[91],xpos = nxpos,cxfont=myfont,color=color)
      of ")" : printCxFontText(@[92],xpos = nxpos,cxfont=myfont,color=color)
      of "*" : printCxFontText(@[93],xpos = nxpos,cxfont=myfont,color=color)
      of "+" : printCxFontText(@[94],xpos = nxpos,cxfont=myfont,color=color)
      of "," : printCxFontText(@[95],xpos = nxpos,cxfont=myfont,color=color)
      of "-" : printCxFontText(@[96],xpos = nxpos,cxfont=myfont,color=color)
      of "." : printCxFontText(@[97],xpos = nxpos,cxfont=myfont,color=color)
      of "/" : printCxFontText(@[98],xpos = nxpos,cxfont=myfont,color=color)
      of " " : 
               curdn(5)
               nxpos = nxpos - 15
      else:discard
    nxpos = nxpos + 19  
    curup(5)       
    
    
    

proc bracketMatrixTyper*(s:string,xpos:int = 1,color:string = randcol()) =
  ## prints the entered string in bracketmatrix font
  ## 
  ## no checking as to terminalwidth is done so adjust terminal width and char sizes accordingly
  ## 
  ##  will be positioned at top right of last character
  ## 

  
  var nxpos = xpos
  let myfont = createCxFont("bracketmatrix")
  for x in s:
    
    case $x
      of "0" : printCxFontText(@[0],xpos = nxpos,cxfont=myfont,color = color) 
      of "1" : printCxFontText(@[1],xpos = nxpos,cxfont=myfont,color=color)
      of "2" : printCxFontText(@[2],xpos = nxpos,cxfont=myfont,color=color)
      of "3" : printCxFontText(@[3],xpos = nxpos,cxfont=myfont,color=color)
      of "4" : printCxFontText(@[4],xpos = nxpos,cxfont=myfont,color=color)
      of "5" : printCxFontText(@[5],xpos = nxpos,cxfont=myfont,color=color)
      of "6" : printCxFontText(@[6],xpos = nxpos,cxfont=myfont,color=color)
      of "7" : printCxFontText(@[7],xpos = nxpos,cxfont=myfont,color=color)
      of "8" : printCxFontText(@[8],xpos = nxpos,cxfont=myfont,color=color)
      of "9" : printCxFontText(@[9],xpos = nxpos,cxfont=myfont,color=color)
      of ":" : printCxFontText(@[10],xpos = nxpos,cxfont=myfont,color=color)
      of ";" : printCxFontText(@[11],xpos = nxpos,cxfont=myfont,color=color)
      of "<" : printCxFontText(@[12],xpos = nxpos,cxfont=myfont,color=color)
      of "=" : printCxFontText(@[13],xpos = nxpos,cxfont=myfont,color=color)
      of ">" : printCxFontText(@[14],xpos = nxpos,cxfont=myfont,color=color)
      of "?" : printCxFontText(@[15],xpos = nxpos,cxfont=myfont,color=color)
      of "@" : printCxFontText(@[16],xpos = nxpos,cxfont=myfont,color=color)
      of "A" : printCxFontText(@[17],xpos = nxpos,cxfont=myfont,color=color)  
      of "B" : printCxFontText(@[18],xpos = nxpos,cxfont=myfont,color=color) 
      of "C" : printCxFontText(@[19],xpos = nxpos,cxfont=myfont,color=color) 
      of "D" : printCxFontText(@[20],xpos = nxpos,cxfont=myfont,color=color)
      of "E" : printCxFontText(@[21],xpos = nxpos,cxfont=myfont,color=color)
      of "F" : printCxFontText(@[22],xpos = nxpos,cxfont=myfont,color=color)
      of "G" : printCxFontText(@[23],xpos = nxpos,cxfont=myfont,color=color)
      of "H" : printCxFontText(@[24],xpos = nxpos,cxfont=myfont,color=color)
      of "I" : printCxFontText(@[25],xpos = nxpos,cxfont=myfont,color=color)
      of "J" : printCxFontText(@[26],xpos = nxpos,cxfont=myfont,color=color)
      of "K" : printCxFontText(@[27],xpos = nxpos,cxfont=myfont,color=color)
      of "L" : printCxFontText(@[28],xpos = nxpos,cxfont=myfont,color=color)
      of "M" : printCxFontText(@[29],xpos = nxpos,cxfont=myfont,color=color)
      of "N" : printCxFontText(@[30],xpos = nxpos,cxfont=myfont,color=color)
      of "O" : printCxFontText(@[31],xpos = nxpos,cxfont=myfont,color=color)
      of "P" : printCxFontText(@[32],xpos = nxpos,cxfont=myfont,color=color)
      of "Q" : printCxFontText(@[33],xpos = nxpos,cxfont=myfont,color=color)
      of "R" : printCxFontText(@[34],xpos = nxpos,cxfont=myfont,color=color)
      of "S" : printCxFontText(@[35],xpos = nxpos,cxfont=myfont,color=color)
      of "T" : printCxFontText(@[36],xpos = nxpos,cxfont=myfont,color=color)
      of "U" : printCxFontText(@[37],xpos = nxpos,cxfont=myfont,color=color)
      of "V" : printCxFontText(@[38],xpos = nxpos,cxfont=myfont,color=color)
      of "W" : printCxFontText(@[39],xpos = nxpos,cxfont=myfont,color=color)
      of "X" : printCxFontText(@[40],xpos = nxpos,cxfont=myfont,color=color)
      of "Y" : printCxFontText(@[41],xpos = nxpos,cxfont=myfont,color=color)
      of "Z" : printCxFontText(@[42],xpos = nxpos,cxfont=myfont,color=color)
      of "[" : printCxFontText(@[43],xpos = nxpos,cxfont=myfont,color=color)
      of "\\" : printCxFontText(@[44],xpos = nxpos,cxfont=myfont,color=color)
      of "]" : printCxFontText(@[45],xpos = nxpos,cxfont=myfont,color=color)
      of "^" : printCxFontText(@[46],xpos = nxpos,cxfont=myfont,color=color)
      of "'" : printCxFontText(@[47],xpos = nxpos,cxfont=myfont,color=color)
      of "a" : printCxFontText(@[48],xpos = nxpos,cxfont=myfont,color=color)  
      of "b" : printCxFontText(@[49],xpos = nxpos,cxfont=myfont,color=color) 
      of "c" : printCxFontText(@[50],xpos = nxpos,cxfont=myfont,color=color) 
      of "d" : printCxFontText(@[51],xpos = nxpos,cxfont=myfont,color=color)
      of "e" : printCxFontText(@[52],xpos = nxpos,cxfont=myfont,color=color)
      of "f" : printCxFontText(@[53],xpos = nxpos,cxfont=myfont,color=color)
      of "g" : printCxFontText(@[54],xpos = nxpos,cxfont=myfont,color=color)
      of "h" : printCxFontText(@[55],xpos = nxpos,cxfont=myfont,color=color)
      of "i" : printCxFontText(@[56],xpos = nxpos,cxfont=myfont,color=color)
      of "j" : printCxFontText(@[57],xpos = nxpos,cxfont=myfont,color=color)
      of "k" : printCxFontText(@[58],xpos = nxpos,cxfont=myfont,color=color)
      of "l" : printCxFontText(@[59],xpos = nxpos,cxfont=myfont,color=color)
      of "m" : printCxFontText(@[60],xpos = nxpos,cxfont=myfont,color=color)
      of "n" : printCxFontText(@[61],xpos = nxpos,cxfont=myfont,color=color)
      of "o" : printCxFontText(@[62],xpos = nxpos,cxfont=myfont,color=color)
      of "p" : printCxFontText(@[63],xpos = nxpos,cxfont=myfont,color=color)
      of "q" : printCxFontText(@[64],xpos = nxpos,cxfont=myfont,color=color)
      of "r" : printCxFontText(@[65],xpos = nxpos,cxfont=myfont,color=color)
      of "s" : printCxFontText(@[66],xpos = nxpos,cxfont=myfont,color=color)
      of "t" : printCxFontText(@[67],xpos = nxpos,cxfont=myfont,color=color)
      of "u" : printCxFontText(@[68],xpos = nxpos,cxfont=myfont,color=color)
      of "v" : printCxFontText(@[69],xpos = nxpos,cxfont=myfont,color=color)
      of "w" : printCxFontText(@[70],xpos = nxpos,cxfont=myfont,color=color)
      of "x" : printCxFontText(@[71],xpos = nxpos,cxfont=myfont,color=color)
      of "y" : printCxFontText(@[72],xpos = nxpos,cxfont=myfont,color=color)
      of "z" : printCxFontText(@[73],xpos = nxpos,cxfont=myfont,color=color)
      of "{" : printCxFontText(@[74],xpos = nxpos,cxfont=myfont,color=color)
      of "|" : printCxFontText(@[75],xpos = nxpos,cxfont=myfont,color=color)
      of "}" : printCxFontText(@[76],xpos = nxpos,cxfont=myfont,color=color)
      of "~" : printCxFontText(@[77],xpos = nxpos,cxfont=myfont,color=color)
      #of "AE" : printCxFontText(@[78],xpos = nxpos,cxfont=myfont,color=color)   # some german umlaut need to be done for german keyboard
      of "Ö" : printCxFontText(@[79],xpos = nxpos,cxfont=myfont,color=color)
      #of "UE" : printCxFontText(@[80],xpos = nxpos,cxfont=myfont,color=color)
      #of "ae" : printCxFontText(@[81],xpos = nxpos,cxfont=myfont,color=color)
      of "ö" : printCxFontText(@[82],xpos = nxpos,cxfont=myfont,color=color)
      #of "ue" : printCxFontText(@[83],xpos = nxpos,cxfont=myfont,color=color)
      of "!" : printCxFontText(@[84],xpos = nxpos,cxfont=myfont,color=color)
      of "$" : printCxFontText(@[87],xpos = nxpos,cxfont=myfont,color=color)
      of "%" : printCxFontText(@[88],xpos = nxpos,cxfont=myfont,color=color)
      of "&" : printCxFontText(@[89],xpos = nxpos,cxfont=myfont,color=color)
      of "(" : printCxFontText(@[91],xpos = nxpos,cxfont=myfont,color=color)
      of ")" : printCxFontText(@[92],xpos = nxpos,cxfont=myfont,color=color)
      of "*" : printCxFontText(@[93],xpos = nxpos,cxfont=myfont,color=color)
      of "+" : printCxFontText(@[94],xpos = nxpos,cxfont=myfont,color=color)
      of "," : printCxFontText(@[95],xpos = nxpos,cxfont=myfont,color=color)
      of "-" : printCxFontText(@[96],xpos = nxpos,cxfont=myfont,color=color)
      of "." : printCxFontText(@[97],xpos = nxpos,cxfont=myfont,color=color)
      of "/" : printCxFontText(@[98],xpos = nxpos,cxfont=myfont,color=color)
      of " " : 
               curdn(5)
               nxpos = nxpos - 15
      else:discard
    nxpos = nxpos + 19  
    curup(5)       
    

    
# end of dotmatrix and bracketmatrix related functions        

