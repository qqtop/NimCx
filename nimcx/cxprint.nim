
## ::
## 
##     Library     : nimcx.nim
##     
##     Module      : cxprint.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##   
##     Latest      : 2019-04-08 
##
##     Compiler    : Nim >= 0.19.x dev branch
##
##     OS          : Linux
##
##     Description : provides most printing functions for the library
##     
##     Note        : some parts are experimental, the future aim will be 
##           
##                   one smart print function which handles any kind of demand for colors.
##                   
## 
import cxconsts,cxglobal,terminal,strutils,sequtils,colors,macros

proc rainbow*[T](s : T,xpos:int = 1,fitLine:bool = false ,centered:bool = false)  ## forward declaration
proc print*[T](astring:T,fgr:string = termwhite ,bgr:BackgroundColor = bgBlack,xpos:int = 0,fitLine:bool = false ,centered:bool = false,styled : set[Style]= {},substr:string = "")
proc printLn*[T](astring:T,fgr:string = termwhite , bgr:BackgroundColor = bgBlack,xpos:int = 0,fitLine:bool = false,centered:bool = false,styled : set[Style]= {},substr:string = "")
proc printBiCol*[T](s:varargs[T,`$`], colLeft:string = yellowgreen, colRight:string = termwhite,sep:string = ":",xpos:int = 0,centered:bool = false,styled : set[Style]= {}) 
proc printLnBiCol*[T](s:varargs[T,`$`], colLeft:string = yellowgreen, colRight:string = termwhite,sep:string = ":",xpos:int = 0,centered:bool = false,styled : set[Style]= {}) 
proc printRainbow*(astr : string,styled:set[Style] = {})     ## forward declaration
proc hline*(n:int = tw,col:string = white,xpos:int = 0,lt:string = "-") : string {.discardable.} ## forward declaration
proc hlineLn*(n:int = tw,col:string = white,xpos:int = 0,lt:string = "-") : string {.discardable.}## forward declaration
proc printErrorMsg*(atext:string = "",xpos:int = 1):string {.discardable.} 
proc printLnErrorMsg*(atext:string = "",xpos:int = 1):string {.discardable.} 

 

proc print*[T](astring :T,
               fgr     : string     = termwhite,
               bgr     : BackgroundColor,
               xpos    : int        = 0,
               fitLine : bool       = false,
               centered: bool       = false,
               styled  : set[Style] = {},
               substr  : string     = "") =
 
    ## ::
    ##   print
    ##   
    ##   use colornames like darkseagreen , salmon etc as foregroundcolors or use truecolor codes
    ##   
    ##   uses standard terminal Backgroundcolor to cover all situations
    ##
    ##   basically similar to terminal.nim styledWriteLine with more functionality
    ##   
    ##   fgr / bgr  fore and background colors can be set
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
    ##   styleBright = 1,            # bright/bold text
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
    ##    print("The end never comes on time ! ",pastelBlue,styled = {styleReverse,styleItalic})
    ##    print("whats up with truecolors now ? ",cxTrueCol[34567],bgRed,xpos = 10,styled={})
    ##    echo()
    ##
    ## There are many more possibilities using the print and PrintLn statements
    ##
    ##.. code-block:: nim
    ##   
    ##   printLnBiCol("this is a " & rightarrow & "  " & termStrikethrough & "print" &  termclear & " aaah,sorry ",colLeft = goldenrod,colRight = cyan,sep = termclear)
    ##   printLnBiCol(" a printLnBiCol example " & termnegative & "changing color to lime after here" & termclear & " this is lime colored text",colLeft=salmon,colRight = lime,sep=termclear,styled={})
    ##
    ##
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
            npos = centerX() - ($astring).len div 2 - 1
            setCursorXPos(npos)


        if styled != {}:
            var s = $astring
            if substr.len > 0:
                var rx = s.split(substr)
                for x in rx.low.. rx.high:
                    writestyled(rx[x],{})
                    if x != rx.high:
                        case fgr
                        of clrainbow   : printRainbow(substr,styled)
                        else: styledEchoPrint(fgr,styled,substr,bgr)
            else:
                case fgr
                        of clrainbow   : printRainbow($s,styled)
                        else: styledEchoPrint(fgr,styled,s,bgr)
        else:
        
            case fgr
              of clrainbow: rainbow(spaces(1) & $astring,npos)
              else: 
                setBackGroundColor(bgr)
                try:
                    write(stdout,fgr & $astring)
                except:
                    echo astring

        # reset to white/black only if any changes
        if fgr != $fgWhite or bgr != bgBlack:
           setForeGroundColor(fgWhite)
           setBackGroundColor(bgBlack)

           

template rndCxFgrCol*():untyped =  cxColorNames[rndSample(txcol)][0]
    ## rndCxFgrCol
    ## 
    ## returns a random foreground color for cxPrint or cxPrintLn procs
    ## from cxColorNames seq defined in cxconsts.nim
    ## 
    
    
template rndCxBgrCol*():untyped =   
    ## rndCxBgrCol
    ## 
    ## returns a random background color for cxPrint or cxPrintLn procs
    ## from the cxTrueCol seq . defaults to a pool of 421875 colors 
    ## which can be changed , See  getcxTrueColorSet()
    ## 
    colornumber48 = color48(cxTrueCol)
    cxTrueCol[colornumber48]
           

           
proc cxPrint*[T](ss    : T,
             fontcolor : string = "colWhite",
             bgr       : string = black,
             xpos      : int = 0,
             styled    : set[Style] = {styleReverse})  =
             
      ## cxPrint     
      ## 
      ## Experimental
      ## 
      ## note the module base name and function name is the same
      ## 
      ## truecolor print function
      ## 
      ## see cxtruecolorE1.nim  for example usage
      ## 
      ## Fontcolors can be drawn from cxColorNames , a seq specified in cxconsts.nim
      ## Example to specify a fontcolor:
      ## 
      ##  a) a random color as string   :  fontcolor = cxcolornames[rndSample(txcol)][0]
      ##  b) a random color as constant :  fontcolor = cxcolornames[rndSample(txcol)][1]
      ##  c) directly named as string   :  fontcolor = "coldarkslategray"    # a color in cxColorNames string field
      ##  d) directly named as const    :  fontcolor = coldarkslategray      # a color in cxColorNames constant field
      ## 
      ## Backgroundcolors can be drawn from cxTrueColor palette which can be enabled with a call
      ## to getcxTrueColorSet() which generates 421,875 colors
      ## larger color palettes can also be generated with getcxTrueColorSet() 
      ## all palette colors in cxTrueColorSet can be shown with showCxTrueColorPalette()  
      ## Backgroundcolors can also be drawn from the colorNames seq  specified in cxconsts.nim
      ## 
      ## Example to specify a Backgroundcolor :
      ##  
      ##  a) a random background color from cxTrueColor palette :  bgr = rndCxBgrCol() 
      ##  b) a color from the cxTrueColor palette               :  bgr = cxTrueCol[65451])
      ##  c) a specified color from colorNames seq              :  bgr = darkgreen
             
      for xbgr in  0..<txCol.len:
          if cxcolornames[xbgr][0] == toLowerAscii(fontcolor):   # as we are doing styleReverse we set it as backgroundcolor 
             setBackgroundColor cxcolornames[xbgr][1]
      print($ss,fgr = bgr,xpos = xpos,styled=styled) 
      
proc cxPrintLn*[T](ss       : T,
                   fontcolor: string = "colWhite",
                   bgr      : string = black,
                   xpos     : int = 0,
                   styled   : set[Style] = {styleReverse}) =
      ## cxPrintLn
      ## 
      ## truecolor printLn function
      ##           
      ## see cxtruecolorE1.nim  for example usage
      ## 
            
      for xbgr in  0..<txCol.len:
         if cxcolornames[xbgr][0] == toLowerAscii(fontcolor):
            setBackgroundColor cxcolornames[xbgr][1]
      printLn($ss,fgr = bgr,xpos = xpos,styled=styled) 
      
 
proc cxPrint*[T](ss       : T,
                 fontcolor: auto = colWhite,
                 bgr      : string = black,
                 xpos     : int = 0,
                 styled   : set[Style] = {styleReverse}) =
      ## cxPrint
      ## 
      ## Experimental
      ## 
      ## truecolor print function
      ##             
      ## see cxtruecolorE1.nim  for example usage
      ## 
           
      setBackgroundColor fontcolor
      print($ss,fgr = bgr,xpos = xpos,styled = styled)  
      
proc cxPrintLn*[T](ss       : T,
                   fontcolor: auto = colWhite,
                   bgr      : string = "colBlack",
                   xpos     : int = 0,
                   styled   : set[Style] = {styleReverse}) =

      ## cxPrintLn
      ##
      ## 
      ## Experimental
      ## 
      ## truecolor printLn function
      ##     
      ## see cxtruecolorE1.nim  for example usage
      ## 
           
      setBackgroundColor fontcolor
      printLn($ss,fgr = bgr,xpos = xpos,styled=styled)  
    
     
proc printLn*[T](astring:T,
                fgr:string = termwhite,
                bgr:BackgroundColor,
                xpos:int = 0,
                fitLine:bool = false,
                centered:bool = false,
                styled : set[Style] = {},
                substr:string = "") =
    ## :: 
    ##   printLn
    ## 
    ##   with bgr:setBackGroundColor
    ##
    ##   bgr has no effect if styleReverse is used
    ##
    ##   foregroundcolor
    ##   backgroundcolor
    ##   position
    ##   fitLine
    ##   centered
    ##   styled
    ##
    ##   Colornames supported for font colors     : 
    ##     
    ##    -  all
    ##  
    ##   Colornames supported for background color: BackGroundColors
    ##   
    ##   - use styleBright and styleReverse for variouse effects
    ##   
    ##   - if using truecolors from the cxTrueCol pool note the difference between odd and even numbers
    ##
    ## Examples
    ## 
    ##.. code-block:: nim
    ##    import nimcx
    ##    
    ##    printLn("Yes ,  we made it.",clrainbow,brightyellow) # background has no effect with font in  clrainbow
    ##    printLn("Yes ,  we made it.",green,brightyellow)
    ##    # or use it as a replacement of echo
    ##    printLn(red & "What's up ? " & green & "Grub's up ! "
    ##    printLn("No need to reset the original color")
    ##    printLn("Nim does it again",peru,centered = true ,styled = {styleDim,styleUnderscore},substr = "i")
    ##    decho()
    ##
    ##    rainbow("what's up ?",centered = true)
    ##    echo()
    ##    loopy(0..10,printLn(newword(80,80),clrainbow,centered = true,styled={styleReverse}))
    ##    rainbow("Just asked!",centered = true)
    ##    decho()
    ##
    ##    loopy2(0,100,
    ##      block:
    ##        var r = getRndint(0,cxtruecol.len - 1)
    ##        var g = getRndint(0,cxtruecol.len - 1)
    ##        var b = getRndInt(0,cxtruecol.len - 1)
    ##        printLn("Color Test rgb " & fmtx([">6","",">6","",">6"],r,",",g,",",b) & spaces(2) & efb2 * 30 & spaces(2) & cxpad($xloopy,6) ,
    ##                newColor(r,g,b),bgblue,styled = {styleReverse}))
    ##    decho() 
    ##    

    print($(astring) & "\n",fgr,bgr,xpos,fitLine,centered,styled,substr)
    print cleareol

    

proc print2*[T](astring:T,
               fgr:string = termwhite,
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
    ##   required by printfont() , printBiCol2 and printLnBiCol2
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
                        case fgr
                        of clrainbow   : printRainbow(substr,styled)
                        else: styledEchoPrint(fgr,styled,substr,bgBlack)
            else:
                case fgr
                        of clrainbow   : printRainbow($s,styled)
                        else: styledEchoPrint(fgr,styled,s,bgBlack)
        else:
            case fgr
            of clrainbow: rainbow(spaces(1) & $astring,npos)
            else: 
                setBackGroundColor(bgBlack)
                try:
                   styledEchoPrint(fgr,{},$astring,bgBlack)
                except:
                   echo astring

        # reset to white/black 
        setForeGroundColor(fgWhite)
        setBackGroundColor(bgBlack)
              
    
    
proc printLn2*[T](astring:T,
              fgr     : string = termwhite,
              xpos    : int = 0,
              fitLine : bool = false,
              centered: bool = false,
              styled  : set[Style] = {},
              substr  : string = "") =  
    ## 
    ## ::
    ##   printLn2
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
    ##    printLn2("Yes ,  we made it.",clrainbow) 
    ##    printLn2("Yes ,  we made it.",green)
    ##    # or use it as a replacement of echo
    ##    printLn2(red & "What's up ? " & green & "Grub's up ! ")
    ##    printLn2("No need to reset the original color")
    ##    printLn2("Nim does it again",peru,centered = true ,styled = {styleDim,styleUnderscore},substr = "i")
    ##    # To achieve colored text with styleReverse try:
    ##    loopy2(0,30):
    ##        printLn2("The end never comes on time ! ",randcol(),styled = {styleReverse})
    ##        print cleareol
    ##        sleepy(0.1)
    ##
    print2($(astring) & "\n",fgr,xpos,fitLine,centered,styled,substr)
    


proc printy*[T](astring:varargs[T,`$`]) =  
    ## printy
    ##
    ## similar to echo but does not issue new line
    ##
    ##..code-block:: nim
    ##    printy "this is : " ,yellowgreen,1,bgreen,5,bblue," ʈəɽɭάɧɨɽ ʂəɱρʊɽɲά(άɲάʂʈάʂɣά)"
    ##
    for x in astring: write(stdout,x & spaces(1))
    setForeGroundColor(fgWhite)
    setBackGroundColor(bgBlack)
    
  
 
proc rainbow*[T](s : T,
                 xpos:int = 1,
                 fitLine:bool = false,
                 centered:bool = false)  =
    ## rainbow
    ##
    ## multicolored string
    ##
    ## may not work with certain Rune
    ##
    ##.. code-block:: nim
    ##
    ##    # equivalent output
    ##    rainbow("what's up ?",centered = true)
    ##    echo()
    ##    printLn("what's up ?",clrainbow,centered = true)
    ##
    ##
    ##
    var nxpos = xpos
    var astr = $s
    var c = 0
    let aseq = toSeq(0..<colorNames.len)

    for x in 0..<astr.len:
       c = aseq[getRndInt(ma=aseq.len - 1)]
       if centered == false:
          print(astr[x],colorNames[c][1],bgblack,xpos = nxpos,fitLine)
       else:
          # need to calc the center here and increment by x
          nxpos = centerX() - (($astr).len div 2) + (x - 1)
          print(astr[x],colorNames[c][1],bgblack,xpos=nxpos,fitLine)
       inc nxpos



# output  horizontal lines
proc hline*(n:int = tw,
            col:string = white,
            xpos:int = 0,
            lt:string = "-"):string {.discardable.} =
     ## hline
     ##
     ## draw a full line in stated length and color no linefeed will be issued
     ##
     ## defaults full terminal width and white
     ##
     ##.. code-block:: nim
     ##    hline(30,green,xpos=xpos)
     ##
     print(lt * n,col,xpos = xpos)
     result = lt * n     # we return the line string without color and pos formating in case needed


proc hlineLn*(n:int = tw,
              col:string = white,
              xpos:int = 0,
              lt:string = "-"):string {.discardable.} =
     ## hlineLn
     ##
     ## draw a full line in stated length and color a linefeed will be issued
     ##
     ## defaults full terminal width and white
     ##
     ##.. code-block:: nim
     ##    hlineLn(30,green)
     ##
     
     let res = hline(n,col,xpos,lt) 
     result = res & newLine()
     
     



proc dline*(n:int = tw,
            lt:string = "-",
            col:string = termwhite) =
     ## dline
     ##
     ## draw a dashed line with given length in current terminal font color
     ## line char can be changed
     ##
     ##.. code-block:: nim
     ##    dline(30)
     ##    dline(30,"/+")
     ##    dline(30,col= yellow)
     ##
     if lt.len <= n: print(lt * (n div lt.len),col)


proc dlineLn*(n:int = tw,
              lt:string = "-",
              col:string = termwhite) =
     ## dlineLn
     ##
     ## draw a dashed line with given length in current terminal font color
     ## line char can be changed
     ##
     ## and issue a new line
     ##
     ##.. code-block:: nim
     ##    dline(50,":",green)
     ##    dlineLn(30)
     ##    dlineLn(30,"/+/")
     ##    dlineLn(60,col = salmon)
     ##
     if lt.len <= n: print(lt * (n div lt.len),col)
     writeLine(stdout,"")


proc decho*(z:int = 2)  =
    ## decho
    ##
    ## blank lines creator
    ## default = 2 blank lines
    ##
    ##.. code-block:: nim
    ##    decho(10)
    ## to create 10 blank lines
    for x in 0 ..< z: writeLine(stdout,"")


proc printRainbow*(astr : string,styled:set[Style] = {}) =
    ## printRainbow
    ##
    ##
    ## print multicolored string with styles , for available styles see print
    ##
    ## may not work with certain Rune
    ##

    var c = 0
    for x in 0..<astr.len:
        c = rxcol[getRndInt(ma=rxcol.len - 1)]
        print($astr[x],colorNames[c][1],styled = styled)


proc printLnRainbow*[T](s : T,styled:set[Style] = {}) =
    ## printLnRainbow
    ##
    ##
    ## print multicolored string with styles , for available styles see print
    ##
    ## and issues a new line
    ##
    ## may not work with certain Rune
    ##
    ##.. code-block:: nim
    ##  import nimcx  
    ##  loopy(0..100,
    ##      block:
    ##          printLnRainBow(cxpad(" ",tw),{styleReverse})
    ##          printLnRainBow(cxpad(" NimCx " * 18 ,tw - 18),{styleBright})
    ##          sleepy(0.01))
    ##
    ##
    printRainBow($(s) & "\L",styled)


proc printBiCol*[T](s:varargs[T,`$`],
                    colLeft:string = yellowgreen,
                    colRight:string = termwhite,
                    sep:string = ":",
                    xpos:int = 0,
                    centered:bool = false,
                    styled : set[Style]= {}) =
                    
     ## printBiCol
     ##
     ## Notes see printLnBiCol
     ##
     
     {.gcsafe.}:
        var nosepflag:bool = false
        var zz = ""
        for ss in 0 ..< s.len:
            zz = zz & s[ss] & spaces(1)
            
        var z = zz.splitty(sep)  # using splitty we retain the sep on the left side
        # in case sep occures multiple time we only consider the first one
        if z.len > 1:
           for x in 2 ..< z.len:
              # this now should contain the right part to be colored differently
              z[1] = z[1] & z[x]

        else:
            # when the separator is not found
            nosepflag = true
            # no separator so we just execute print with left color
            print(zz,fgr=colLeft,xpos=xpos,centered=centered,styled = styled)

        if nosepflag == false:

                if centered == false:
                    print(z[0],fgr = colLeft,bgr = bgblack,xpos = xpos,styled = styled)
                    print(z[1],fgr = colRight,bgr = bgblack,styled = styled)
                else:  # centered == true
                    let npos = centerX() - (zz).len div 2 - 1
                    print(z[0],fgr = colLeft,bgr = bgblack,xpos = npos,styled = styled)
                    print(z[1],fgr = colRight,bgr = bgblack,styled = styled)




proc printLnBiCol*[T](s:varargs[T,`$`],
                   colLeft : string = yellowgreen,
                   colRight: string = termwhite,
                   sep     : string = ":",
                   xpos    : int = 0,
                   centered: bool = false,
                   styled  : set[Style]= {}) =
                   
     ## printLnBiCol
     ##
     ## input can be varargs which gives much better flexibility
     ## however all parameters need to be specified
     ## also see printLnBiCol3 
     ##
     ## default seperator = ":"  if not found we execute printLn with available params
     ##
     ##.. code-block:: nim
     ##    import nimcx
     ##
     ##    for x  in 0..<3:
     ##       # here our input is varargs so we need to specify all params
     ##        printLnBiCol("Test $1  : Ok " % $1,"this was $1 : what" % $x,23456.789,red,lime,":",0,false,{})
     ##    decho()
     ##    
     ##    for x  in 6..18:
     ##        # here we change the default colors
     ##        printLnBiCol("nice",123,":","check",@[x,x * 2,x * 3],cyan,lime,":",0,false,{})
     ##        
     ##    decho()
     ##    # usage with fmtx the build in format engine
     ##    printLnBiCol(fmtx(["","",">4"],"Good Idea : "," Number",50),yellow,randcol(),":",0,false,{})
     ##    printLnBiCol(fmtx(["","",">4"],"Good Idea : "," Number",50),colLeft = cyan)
     ##    printLnBiCol(fmtx(["","",">4"],"Good Idea : "," Number",50),colLeft=yellow,colRight=randcol())
     ##    printLnBiCol(fmtx(["","",">4"],"Good Idea : "," Number",50),123,colLeft = cyan,colRight=gold,sep=":",xpos=0,centered=false,styled={})
     ##  
     ##    decho()  
     ##    printLnBicol(["TEST VARARGS : ","\n",lime,
     ##      $(createSeqint(20).sampleSeq(8,13)),newLine(2),hotpink,
     ##      $getRndInt(10000,12000),"\n",skyblue,
     ##      showSeq(createSeqint(3),displayflag=false),newLine(2),truetomato,
     ##      $newword(6,getRndInt(7,20)),newLine(2),yellowgreen,
     ##      showSeq(createSeqKatakana(),yellowgreen,displayflag=false),newLine(2),lime,
     ##      "My random float ===> ",ff2(getRndfloat(),5),newLine(2)],
     ##      colLeft=randcol(),randCol())
     ##      
     ##      

     {.gcsafe.}:
        var nosepflag:bool = false
        var zz =""
        for ss in 0 ..< s.len:
            zz = zz & s[ss] & spaces(1)
           
        var z = zz.splitty(sep)  # using splitty we retain the sep on the left side
        # in case sep occures multiple time we only consider the first one
        if z.len > 1:
          for x in 2 ..< z.len:
             z[1] = z[1] & z[x]
        else:
            # when the separator is not found
            nosepflag = true
            # no separator so we just execute printLn with left color
            printLn(zz,fgr=colLeft,xpos=xpos,centered=centered,styled = styled)

        if nosepflag == false:

            if centered == false:
                print(z[0],fgr = colLeft,bgr = bgBlack,xpos = xpos,styled = styled)
                if colRight == clrainbow:   # we currently do this as rainbow implementation has changed
                        printLn(z[1],fgr = randcol(),bgr = bgBlack,styled = styled)
                else:
                        printLn(z[1],fgr = colRight,bgr = bgBlack,styled = styled)

            else:  # centered == true
                let npos = centerX() - zz.len div 2 - 1
                print(z[0],fgr = colLeft,bgr = bgBlack,xpos = npos)
                if colRight == clrainbow:   
                        printLn(z[1],fgr = randcol(),bgr = bgBlack,styled = styled)
                else:
                        printLn(z[1],fgr = colRight,bgr = bgBlack,styled = styled)


proc printBiCol2*[T](s:varargs[T,`$`],
                    colLeft:string = yellowgreen,
                    colRight:string = termwhite,
                    sep:string = ":",
                    xpos:int = 0,
                    centered:bool = false,
                    styled : set[Style]= {}) =
                    
     ## printBiCol2
     ##
     ## Notes see printLnBiCol2
     ##
     
     {.gcsafe.}:
        var nosepflag:bool = false
        var zz = ""
        for ss in 0..<s.len:
            zz = zz & s[ss] & spaces(1)
            
        var z = zz.splitty(sep)  # using splitty we retain the sep on the left side
        # in case sep occures multiple time we only consider the first one
        if z.len > 1:
           for x in 2..<z.len:
              # this now should contain the right part to be colored differently
              z[1] = z[1] & z[x]

        else:
            # when the separator is not found
            nosepflag = true
            # no separator so we just execute print with left color
            print2(zz,fgr=colLeft,xpos=xpos,centered=centered,styled = styled)

        if nosepflag == false:

                if centered == false:
                    print2(z[0],fgr = colLeft,xpos = xpos,styled = styled)
                    print2(z[1],fgr = colRight,styled = styled)
                else:  # centered == true
                    let npos = centerX() - (zz).len div 2 - 1
                    print2(z[0],fgr = colLeft,xpos = npos,styled = styled)
                    print2(z[1],fgr = colRight,styled = styled)


proc printLnBiCol2*[T](s:varargs[T,`$`],
                   colLeft : string = yellowgreen,
                   colRight: string = termwhite,
                   sep     : string = ":",
                   xpos    : int = 0,
                   centered: bool = false,
                   styled  : set[Style]= {}) =
                   
                        
     ## printLnBiCol2    
     ##
     ## this version calls print2 and printLn2 which is suitable when printing multiple columns side by side  
     ## 
     ## default seperator = ":"  if not found we execute printLn with available params
     ##
     ##.. code-block:: nim
     ##    import nimcx
     ##
     ##    for x  in 0..<3:
     ##       # here our input is varargs so we need to specify all params
     ##        printLnBiCol("Test $1  : Ok " % $1,"this was $1 : what" % $2,23456.789,red,lime,":",0,false,{})
     ##    for x  in 4..<6:
     ##        # here we change the default colors
     ##        printLnBiCol("nice",123,":","check",@[1,2,3],cyan,lime,":",0,false,{})
     ##
     ##    # usage with fmtx 
     ##    printLnBiCol2(fmtx(["","",">4"],"Good Idea : "," Number",50),yellow,randcol(),":",0,false,{})
     ##    printLnBiCol2(fmtx(["","",">4"],"Good Idea : "," Number",50),colLeft = cyan)
     ##    printLnBiCol2(fmtx(["","",">4"],"Good Idea : "," Number",50),colLeft=yellow,colRight=randcol())
     ##    printLnBiCol2(fmtx(["","",">4"],"Good Idea : "," Number",50),123,colLeft = cyan,colRight=gold,sep=":",xpos=0,centered=false,styled={})
     ##    
     {.gcsafe.}:
        var nosepflag:bool = false
        var zz =""
        for ss in 0..<s.len:
            zz = zz & s[ss] & spaces(1)
           
        var z = zz.splitty(sep)  # using splitty we retain the sep on the left side
        # in case sep occures multiple time we only consider the first one
        if z.len > 1:
          for x in 2..<z.len:
             z[1] = z[1] & z[x]
        else:
            # when the separator is not found
            nosepflag = true
            # no separator so we just execute printLn with left color
            printLn2(zz,fgr=colLeft,xpos=xpos,centered=centered,styled = styled)

        if nosepflag == false:

            if centered == false:
                print2(z[0],fgr = colLeft,xpos = xpos,styled = styled)
                if colRight == clrainbow:   # we currently do this as rainbow implementation has changed
                        printLn2(z[1],fgr = randcol(),styled = styled)
                else:
                        printLn2(z[1],fgr = colRight,styled = styled)

            else:  # centered == true
                let npos = centerX() - zz.len div 2 - 1
                print2(z[0],fgr = colLeft,xpos = npos)
                if colRight == clrainbow:   
                        printLn2(z[1],fgr = randcol(),styled = styled)
                else:
                        printLn2(z[1],fgr = colRight,styled = styled)


proc printBiCol3*[T](s:openarray[T],
                    colLeft:string = yellowgreen,
                    colRight:string = termwhite,
                    sep:string = ":",
                    xpos:int = 0,
                    centered:bool = false,
                    styled : set[Style]= {}) =
                    
     ## printBiCol3
     ##
     ## Notes see printLnBiCol3
     ##
     
     {.gcsafe.}:
        var nosepflag:bool = false
        var zz = ""
        for ss in 0..<s.len:
            zz = zz & $s[ss] & spaces(1)   #  <---- converting to strings here
            
        var z = zz.splitty(sep)  # using splitty we retain the sep on the left side
        # in case sep occures multiple time we only consider the first one
        if z.len > 1:
           for x in 2 ..< z.len:
              # this now should contain the right part to be colored differently
              z[1] = z[1] & z[x]

        else:
            # when the separator is not found
            nosepflag = true
            # no separator so we just execute print with left color
            print(zz,fgr=colLeft,xpos=xpos,centered=centered,styled = styled)

        if nosepflag == false:

                if centered == false:
                    print(z[0],fgr = colLeft,bgr = bgblack,xpos = xpos,styled = styled)
                    print(z[1],fgr = colRight,bgr = bgblack,styled = styled)
                else:  # centered == true
                    let npos = centerX() - (zz).len div 2 - 1
                    print(z[0],fgr = colLeft,bgr = bgblack,xpos = npos,styled = styled)
                    print(z[1],fgr = colRight,bgr = bgblack,styled = styled)



proc printLnBiCol3*[T](s:openarray[T],
                   colLeft : string = yellowgreen,
                   colRight: string = termwhite,
                   sep     : string = ":",
                   xpos    : int = 0,
                   centered: bool = false,
                   styled  : set[Style]= {}) =
                   
     ## printLnBiCol3
     ##
     ## WIP still in testing
     ##
     ## changes to prev. versions:
     ## using an openarray to pass in the data rather than a varargs in first position has the effect 
     ## of not needing to write all the other params if not needed , the cost is writing
     ## 2 more brackets for the array ... so most likely the sane version
     ## sep moved to behind colors in parameter ordering
     ## and input can be varargs which gives much better flexibility
     ## if varargs are to be printed all parameters need to be specified.
     ##
     ## default seperator = ":"  if not found we execute printLn with available params
     ##
     ##.. code-block:: nim
     ##    import nimcx
     ##
     ##    for x  in 1..30:
     ##       # here our input is an array so we do not need to specify all params unless required
     ##       # and we can make nice tables quickly
     ##        printLnBiCol(["TestA  ", fmtx([">3"],ff2(x)) , ":", fmtx([">10"],ff2(1000.001)),"  ",
     ##                      "TestB  ", ":", fmtx([">13"],ff2(1000.001 * float(x * x),4))],red,lime)
     ##    
      
     {.gcsafe.}:
        
        var nosepflag:bool = false
        var zz = ""
        for ss in 0..<s.len:
            zz = zz & $s[ss] & spaces(1)   # <--- converting to strings here
           
        var z = zz.splitty(sep)  # using splitty we retain the sep on the left side
        # in case sep occures multiple time we only consider the first one
        if z.len > 1:
          for x in 2 ..< z.len:
             z[1] = z[1] & z[x]
        else:
            # when the separator is not found
            nosepflag = true
            # no separator so we just execute printLn with left color
            printLn(zz,fgr=colLeft,xpos=xpos,centered=centered,styled = styled)

        if nosepflag == false:

            if centered == false:
                print(z[0],fgr = colLeft,bgr = bgBlack,xpos = xpos,styled = styled)
                if colRight == clrainbow:   # we currently do this as rainbow implementation has changed
                        printLn(z[1],fgr = randcol(),bgr = bgBlack,styled = styled)
                else:
                        printLn(z[1],fgr = colRight,bgr = bgBlack,styled = styled)

            else:  # centered == true
                let npos = centerX() - zz.len div 2 - 1
                print(z[0],fgr = colLeft,bgr = bgBlack,xpos = npos)
                if colRight == clrainbow:   
                        printLn(z[1],fgr = randcol(),bgr = bgBlack,styled = styled)
                else:
                        printLn(z[1],fgr = colRight,bgr = bgBlack,styled = styled)
                                     
                        
                        
proc printHL*(s     : string,
              substr: string,
              col   : string = termwhite) =
              
      ## printHL
      ##
      ## print and highlight all appearances of a substring 
      ##
      ## with a certain color
      ##
      ##.. code-block:: nim
      ##    printHL("HELLO THIS IS A TEST","T",green)
      ##
      ## this would highlight all T in green
      ##

      let rx = s.split(substr)
      for x in rx.low .. rx.high:
          print(rx[x])
          if x != rx.high:
             print(substr,col)


proc printLnHL*(s      : string,
                substr : string,
                col    : string = lightcyan) =
                
      ## printLnHL
      ##
      ## print and highlight all appearances of a char or substring of a string
      ##
      ## with a certain color and issue a new line
      ##
      ##.. code-block:: nim
      ##    printLnHL("HELLO THIS IS A TEST","T",yellowgreen)
      ##
      ## this would highlight all T in yellowgreen
      ##

      printHL($(s) & "\L",substr,col)


proc cecho*(col: string,
            ggg: varargs[string, `$`] = @[""] )  =
            
      ## cecho
      ##
      ## color echo w/o new line this also automically resets the color attribute
      ##
      ##
      ##.. code-block:: nim
      ##     import nimcx,strfmt
      ##     cechoLn(salmon,"{:<10} : {} ==> {} --> {}".fmt("this ", "zzz ",123 ," color is something else"))
      ##     echo("ok")  # color resetted
      ##     echo(salmon,"{:<10} : {} ==> {} --> {}".fmt("this ", "zzz ",123 ," color is something else"))
      ##     echo("ok")  # still salmon

      case col
       of clrainbow :
                for x in ggg:  rainbow(x)
       else:
         write(stdout)
         write(stdout,ggg)
         
      write(stdout,termwhite)


proc cechoLn*(col    : string, astring: varargs[string, `$`] = @[""] )  =
              
      ## cechoLn
      ##
      ## color echo with new line
      ##
      ## so it is easy to color your output by just replacing
      ##
      ## echo something  with   cechoLn yellowgreen,something
      ##
      ## in your exisiting projects.
      ##
      ##.. code-block:: nim
      ##     import nimcx
      ##     cechoLn(steelblue,"We made it in $1 hours !" % $5)
      ##
      ##
      var z = ""
      for x in astring: z = $(x)
      z = z & "\L"
      cecho(col ,z)


 
      
      
proc printCxLine*(aline:var Cxline) =
     ## printCxLine
     ## 
     ## prints a horizontal line for frames or other use with or without text ,
     ## with or without brackets around the text as specified in an Cxline object
     ## the underlaying CxLine object is still further developed.
     ## cxline object is defined in cxglobal.nim
     ## see cxlineobjectE1.nim for an example
     ## 
     
     case aline.linetype 
       of cxVertical :
#             # not ok yet  difficult to implement due to pos and terminal height considerations
#             # needs to be rethought , maybe create the line horizontal and then print
#             # in required colors vertically or something
#             # 
#             var xpos = aline.startpos
#             var rdotpos = xpos   # this will become the end position if 
#             aline.endpos = aline.startpos + aline.endpos
#              # maybe we should prebuild as horizontal line and then just print downwards
#             var vline = "." # top dot
#             vline = hline(aline.endpos - aline.startpos - 1,lt = aline.linechar)
#             vline = vline & "."
#             # at this point we have a line but no text , so we need to find a better way to 
#             # add text into the line within the top/bottom vals and later print it in desired colors
#             # from startpos down to bottom pos
              discard
                               
       of cxHorizontal :
            # ok
            var xpos = aline.startpos
            var rdotpos = xpos   # this will become the end position 
            aline.endpos = aline.startpos + aline.endpos
            print(".",aline.dotleftcolor,xpos = aline.startpos)
            rdotpos = rdotpos + 1
            hline(aline.endpos - aline.startpos - 1,aline.linecolor,xpos = xpos + 1,lt = aline.linechar)  
            rdotpos = rdotpos + aline.endpos - aline.startpos

            template cxhline(aline:CxLine,bline:CxLineText) =
                ## cxhline
                ## 
                if aline.showbrackets == true:
                    print(bline.textbracketopen,bline.textbracketcolor,xpos = xpos + bline.textpos)  
                    rdotpos = rdotpos + 1
                    print(bline.text,bline.textcolor,styled=bline.textstyle)
                else:   
                    print(bline.text,bline.textcolor,xpos = xpos + bline.textpos,styled=bline.textstyle)
                if aline.showbrackets == true:
                        print(bline.textbracketclose,bline.textbracketcolor)
                        rdotpos = rdotpos + 1 
            
            # we need some reason why to print the cxtextline objects and the current reason is text.len
            # nothing will be shown if text.len == 0
            # printing the first of max 12 cxlinetext object

            if aline.cxlinetext.text.len > 0: cxhline(aline,aline.cxlinetext)
            # printing the 2nd of max 12 cxlinetext object 
            if aline.cxlinetext2.text.len > 0: cxhline(aline,aline.cxlinetext2)                
            # printing the 3rd of max 12 cxlinetext object 
            if aline.cxlinetext3.text.len > 0: cxhline(aline,aline.cxlinetext3)
            # printing the 4th of max 12 cxlinetext object   
            if aline.cxlinetext4.text.len > 0: cxhline(aline,aline.cxlinetext4)
            # printing the 5th of max 12 cxlinetext object   
            if aline.cxlinetext5.text.len > 0: cxhline(aline,aline.cxlinetext5)  
            # printing the 6th of max 12 cxlinetext object   
            if aline.cxlinetext6.text.len > 0: cxhline(aline,aline.cxlinetext6)
            # printing the 7th of max 12 cxlinetext object   
            if aline.cxlinetext7.text.len > 0: cxhline(aline,aline.cxlinetext7)
            # printing the 8th of max 12 cxlinetext object   
            if aline.cxlinetext8.text.len > 0: cxhline(aline,aline.cxlinetext8)                 
            # printing the 9th of max 12 cxlinetext object   
            if aline.cxlinetext9.text.len > 0: cxhline(aline,aline.cxlinetext9) 
            # printing the 10th of max 12 cxlinetext object   
            if aline.cxlinetext10.text.len > 0: cxhline(aline,aline.cxlinetext10)
            # printing the 11th of max 12 cxlinetext object   
            if aline.cxlinetext11.text.len > 0: cxhline(aline,aline.cxlinetext11)     
            # printing the 12th of max 12 cxlinetext object   
            if aline.cxlinetext12.text.len > 0: cxhline(aline,aline.cxlinetext12)
                        
            print("." & aline.newline,aline.dotrightcolor,xpos = aline.endpos - 1)
            

proc doty*(d   :int,
           fgr :string = white,
           bgr :BackgroundColor = bgBlack,
           xpos:int = 1) =
           
     ## doty
     ##
     ## prints number d of widedot ⏺  style dots in given fore/background color
     ##
     ## each dot is of char length 4 added a space in the back to avoid half drawn dots
     ##
     ## if it is available on your system otherwise a rectangle may be shown
     ##
     ##.. code-block:: nim
     ##      import nimcx
     ##      printLnBiCol("Test for  :  doty\n",truetomato,lime,":",0,false,{})
     ##      dotyLn(22 ,lime)
     ##      dotyLn(18 ,salmon,bgBlue)
     ##      dotyLn(centerX(),red)  # full widedotted line
     ##
     ## color clrainbow is not supported and will be in white
     ##

     let astr = $(wideDot.repeat(d))
     print(astring = astr,fgr,bgr,xpos)


proc dotyLn*(d    :int,
             fgr  :string = white,
             bgr  :BackgroundColor = bgBlack,
             xpos :int = 1) =
             
     ## dotyLn
     ##
     ## prints number d of widedot ⏺  style dots in given fore/background color and issues new line
     ## 
     ## may not be available on all systems
     ##
     ## each dot is of char length 4

     ##.. code-block:: nim
     ##      import nimcx
     ##      loopy(0.. 100,loopy(1.. tw div 2, dotyLn(1,randcol(),xpos = rand(tw - 1))))
     ##      printLnBiCol("coloredSnow","d",greenyellow,salmon)

     ##
     ## color clrainbow is not supported and will be in white
     ##
     ##
     doty(d,fgr,bgr,xpos)
     writeLine(stdout,"")



proc printDotPos*(xpos:int,dotCol:string,blink:bool,dottype:string = widedot) =
      ## printDotPos
      ##
      ## prints a widedot at xpos in col dotCol and may blink...
      ##

      curSetx(xpos)
      if blink == true: print(dottype,dotCol,styled = {styleBlink},substr = dottype)
      else: print(dottype,dotCol,styled = {},substr = dottype)

       
# convenience functions for var. messages
# for time/date related see cxtimes.nim      
      
proc printErrorMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Error ] " & atext , colLeft = red ,colRight = lightgoldenrodyellow,sep = "]",xpos = xpos,false,{stylereverse})
 
proc printBErrorMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[      ] " & atext , colLeft = red ,colRight = lightgoldenrodyellow,sep = "]",xpos = xpos,false,{stylereverse})    
     
proc printLnErrorMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Error ] " & atext , colLeft = red ,colRight = lightgoldenrodyellow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnBErrorMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[      ] " & atext , colLeft = red ,colRight = lightgoldenrodyellow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printFailMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Fail  ] " & atext , colLeft = red ,colRight = lightgoldenrodyellow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnFailMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Fail  ] " & atext , colLeft = red ,colRight = lightgoldenrodyellow,sep = "]",xpos = xpos,false,{stylereverse})     
   
proc printAlertMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Alert   ] " & atext , colLeft = truetomato ,colRight = pastelyellow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnAlertMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Alert ] " & atext , colLeft = truetomato ,colRight = pastelyellow,sep = "]",xpos = xpos,false,{stylereverse})        

proc printBAlertMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[        ] " & atext , colLeft = truetomato ,colRight = pastelyellow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnBAlertMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[      ] " & atext , colLeft = truetomato ,colRight = pastelyellow,sep = "]",xpos = xpos,false,{stylereverse})        
     
proc printOKMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[OK    ]" & spaces(1) & atext , colLeft = yellowgreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnOkMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[OK    ]" & spaces(1) & atext , colLeft = yellowgreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})    
    
proc printStatusMsg*(atext:string = "",xpos:int = 1,colLeft=lightseagreen):string {.discardable.} =
     printBiCol3(["[Status]" , spaces(1) , atext] , colLeft = colleft ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnStatusMsg*(atext:string = "",xpos:int = 1,colLeft=lightseagreen):string {.discardable.} =
     printLnBiCol3(["[Status]" , spaces(1) , atext] , colLeft = colLeft ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})    
     
proc printHelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Help  ]" & spaces(1) & atext , colLeft = thistle ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnHelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Help  ]" & spaces(1) & atext , colLeft = palegreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})    
     
#printLnBelpMsg used for inserting more help lines without Help word
proc printBelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[      ]" & spaces(1) & atext , colLeft = thistle ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnBelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[      ]" & spaces(1) & atext , colLeft = thistle ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})    
 
proc printCodeMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Code  ]" & spaces(1) & atext , colLeft = lavender ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})    

proc printLnCodeMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Code  ]" & spaces(1) & atext , colLeft = lavender ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})    
                
proc printPassMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Pass  ]" & spaces(1) & atext , colLeft = yellowgreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
   
proc printLnPassMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Pass  ]" & spaces(1) & atext , colLeft = yellowgreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})

# printInfoMsg and printLnInfoMsg can take two strings for more generic use     
proc printInfoMsg*(info,atext:string = "",colLeft:string = lightslategray ,colRight:string = pastelWhite,xpos:int = 1):string {.discardable.} =
     printBiCol3(["[$1]" % info , spaces(1) , atext] , colLeft = colLeft ,colRight = colRight,sep = "]",xpos = xpos,false,{stylereverse})

proc printLnInfoMsg*(info,atext:string = "",colLeft:string = lightslategray ,colRight:string = pastelWhite,xpos:int = 1):string {.discardable.} =
     printLnBiCol("[$1]" % info & spaces(1) & atext , colLeft = colLeft ,colRight = colRight,sep = "]",xpos = xpos,false,{stylereverse})

# experimental - use printLn3 so that we do not overwrite msg next to each other in case of blocks of printLnmsg2 statements
proc printLnInfoMsg2*(info,atext:string = "",colLeft:string = lightslategray ,colRight:string = pastelWhite,xpos:int = 1):string {.discardable.} =
     printLnBiCol3(["[$1]" % info , spaces(1) , atext] , colLeft = colLeft ,colRight = colRight,sep= "]",xpos = xpos,false,{stylereverse})
     
      
template dprint*[T](s:T) = 
     ## dprint
     ## 
     ## debug print shows contents of s in repr mode
     ## 
     ## usefull for debugging  
     ##
     echo()
     printLn("*** REPR OUTPUT START ***",truetomato,xpos = 1)
     printLn(repr(s) ,xpos = 1)
     printLn("*** REPR OUTPUT END   ***",truetomato,xpos = 1)
     echo()
   
macro pdebug*(n: varargs[typed]): untyped =
  ## pdebug
  ## 
  ## prints variable name and value in debug view mode
  ## 
  ## ex https://stackoverflow.com/questions/47443206/how-to-debug-print-a-variable-name-and-its-value-in-nim
  ## 
  result = newNimNode(nnkStmtList, n)
  for i in 0..n.len-1:
    if n[i].kind == nnkStrLit:
      # pure string literals are written diretly
      result.add(newCall("write", newIdentNode("stdout"), n[i]))
    else:
      # other expressions are written in <expression>: <value> syntax
      result.add(newCall("write", newIdentNode("stdout"), toStrLit(n[i])))
      result.add(newCall("write", newIdentNode("stdout"), newStrLitNode(": ")))
      result.add(newCall("write", newIdentNode("stdout"), n[i]))
    if i != n.len-1:
      # separate by ", "
      result.add(newCall("write", newIdentNode("stdout"), newStrLitNode(", ")))
    else:
      # add newline
      result.add(newCall("writeLine", newIdentNode("stdout"), newStrLitNode("")))     


# end of cxprint.nim      
