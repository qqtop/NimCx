
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
##     Latest      : 2020-04-16 
##
##     Compiler    : Nim >= 1.0.6  or 1.1.1 dev branch
##
##     OS          : Linux
##
##     Description : provides most printing functions for the library
##              
## 
 
import cxconsts,terminal,strutils,sequtils,macros,random

{.hint: "\x1b[38;2;154;205;50m ╭──────────────────────── NIMCX ─────────────────────────────────────╮ " .}
    
{.hint: "\x1b[38;2;154;205;50m \u2691  NimCx     " & "\x1b[38;2;255;215;0m Officially made for Linux only." & 
                spaces(23) & "\x1b[38;2;154;205;50m \u2691 ".}
                
{.hint: "\x1b[38;2;154;205;50m \u2691  Compiling " &
        "\x1b[38;2;255;100;0m cxprint \xE2\x9A\xAB" &
        " " & "\xE2\x9A\xAB" & spaces(41) & "\x1b[38;2;154;205;50m \u2691 ".}
         
{.hint: "\x1b[38;2;154;205;50m ╰──────────────────────── CXPRINT ───────────────────────────────────╯ " .}


randomize()

template tw: int = terminalWidth()

proc print*[T](astring:T,fgr:string = getFg(fgDefault) ,bgr: string = getBg(bgDefault),xpos:int = 0,fitLine:bool = false,centered:bool = false,styled : set[Style]= {})
proc printLn*[T](astring:T,fgr:string = getFg(fgDefault) ,bgr: string = getBg(bgDefault),xpos:int = 0,fitLine:bool = false,centered:bool = false,styled : set[Style]= {})
proc printBiCol*[T](s:varargs[T,`$`], colLeft:string = yellowgreen, colRight:string = termwhite,sep:string = ":",xpos:int = 0,centered:bool = false,styled : set[Style]= {}) 
proc printLnBiCol*[T](s:varargs[T,`$`], colLeft:string = yellowgreen, colRight:string = termwhite,sep:string = ":",xpos:int = 0,centered:bool = false,styled : set[Style]= {}) 
proc printRainbow*(astr : string,styled:set[Style] = {})     ## forward declaration
proc hline*(n:int = tw,col:string = white,xpos:int = 0,lt:string = "-") : string {.discardable.} ## forward declaration
proc hlineLn*(n:int = tw,col:string = white,xpos:int = 0,lt:string = "-") : string {.discardable.} ## forward declaration
proc printErrorMsg*(atext:string = "",xpos:int = 1):string {.discardable.} 
proc printLnErrorMsg*(atext:string = "",xpos:int = 1):string {.discardable.} 


template cxprint*(xpos:int,args:varargs[untyped]) =
    ## cxprint
    ##
    ##
    ## xpos : position  
    ## Calls styledWrite with args given
    ##
    ## remember that first param must be xpos
    ##
    ## Backgroundcolors defined in cxconsts.nim colorNames can be used , that is 
    ## any color ending with xxxxxxbg  like pastelpinkbg
    ##    
    setCursorXPos(xpos)
    stdout.styledWrite(args)  
    
       
template cxprintLn*(xpos:int, args: varargs[untyped]) =
    ## cxprintLn
    ##
    ## print to a certain x position
    ##
    ## xpos : position  
    ## Calls styledEcho with args given
    ## 
    ## Backgroundcolors defined in cxconsts.nim colorNames can be used , that is 
    ## any color ending with xxxxxxbg  like pastelpinkbg
    ## 
    ## remember that first item must be xpos and that wide unicode chars or Rune may not
    ## give desired result if written close to each other
    ##
    ##.. code-block:: nim
    ##   cxprintLn(5,yaleblue,pastelbluebg,"this is a test  ",trueblue,pastelpinkbg,styleReverse,stylebright," needed somme color change"
    ##   cxprintln(0,trueblue,bgwhite," Yes ! ",
    ##             yaleblue,truetomatobg," No ! ",
    ##             trueblue,bgwhite,styleReverse," Yes ! ",
    ##             truetomato,darkslatebluebg,styleBlink,styleBright," Oooh, it blinks too  ! ")
    ##   
    setCursorXPos(xpos)
    styledEcho(args)
    

template cxprintxy*(xpos:int,ypos:int,args:varargs[untyped]) =
    ## cxprint
    ##
    ## print to a certain x , y position in the terminal
    ## xpos : x position 
    ## ypos : y position starting from 0,0
    ## Calls styledWrite with args given
    ##
    ## enough space must be available in terminal window 
    ##
    ## Backgroundcolors defined in cxconsts.nim colorNames can be used , that is 
    ## any color ending with xxxxxxbg  like pastelpinkbg
    ##    
    curSet(xpos,ypos)
    stdout.styledWrite(args)


template cxwrite*(args:varargs[untyped]) =
    ## cxwrite
    ## 
    ## Calls styledWrite with args given
    ##    
    ## Backgroundcolors defined in cxconsts.nim colorNames can be used , that is 
    ## any color ending with xxxxxxbg  like pastelpinkbg
    ## 
    ## x positioning    via cxpos(x)
    ## x,y positioning  via cxPosxy(x,y)   
    ##
    stdout.styledWrite(args)
    
       
template cxwriteLn*(args:varargs[untyped]) =
    ## cxwriteLn
    ##  
    ## Calls styledWriteLine with args given
    ##    
    ## Backgroundcolors defined in cxconsts.nim colorNames can be used , that is 
    ## any color ending with xxxxxxbg  like pastelpinkbg
    ##    
    stdout.styledWriteLine(args)  
       

proc printf*(formatStr: cstring) {.importc, header: "<stdio.h>", varargs.}
     ## printf
     ## 
     ## make C printf function available
     ##  
     ##.. code-block:: nim
     ##   printf("This works %s and this %d,too ", "as expected" ,2)
     ##   


proc print*[T](astring  : T,
               fgr     : string     = getFg(fgDefault),
               bgr     : string     = getBg(bgDefault),
               xpos    : int        = 0,
               fitLine : bool       = false,
               centered: bool       = false,
               styled  : set[Style] = {}) =
               
 
    ## ::
    ##   print
    ##   
    ##   use colornames like darkseagreen , salmon etc as foregroundcolors 
    ##   
    ##   uses colornames like limebg or truebluebg etc as backgroundcolors 
    ##   
    ##   or use original background colors like redbg
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
    ##   also available   cxBright,cxReverse,cxBlink,cxReverseBright
    ##
    ## Example
    ##
    ##.. code-block:: nim
    ##    # To achieve colored text with styleReverse try:
    ##    print("what's up with colors now ? ",trueblue,redbg,xpos = 10,styled={styleBright})
    ##    print("The end never comes on time ! ",yaleblue,limebg,styled = {styleReverse,styleBright,styleItalic})
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
            npos = tw div 2 + 2 - ($astring).len div 2 - 1
            setCursorXPos(npos)

        stdout.styledwrite(fgr,bgr,styled,$astring)

        # reset to white/black only if any changes
        if fgr != getFg(fgDefault) or bgr != getBg(bgDefault):
           setForeGroundColor(fgDefault)
           setBackGroundColor(bgDefault)

      
proc printLn*[T](astring: T,
                fgr:string = getFg(fgDefault),
                bgr:string = getBg(bgDefault),   
                xpos:int = 0,
                fitLine:bool = false,
                centered:bool = false,
                styled : set[Style] = {}) =
    ## :: 
    ##   printLn
    ## 
    ##
    ##   foregroundcolor
    ##   backgroundcolor
    ##   position
    ##   fitLine
    ##   centered
    ##   styled
    ##
    ##   Colornames supported for font colors     :  all
    ##  
    ##   Colornames supported for background color: all colors ending with bg
    ##   
    ##   - use styleBright and styleReverse for various effects
    ##   
    ##
    ## Examples
    ## 
    ##.. code-block:: nim
    ##    import nimcx
    ##    
    ##    printLn("Yes ,  we made it.",green,yellowbg)
    ##    # or use it almost as a replacement of echo
    ##    printLn(red & "What's up ? " & green & "Grub's up ! ")
    ##    printLn("No need to reset the original color")
    ##    printLn("Nim does it again",peru,centered = true ,styled = {styleDim,styleUnderscore})
    ##    decho()
    ##
    ##    echo()
    ##    loopy(0..10,printLn(newword(80,80),limegreen,centered = true,styled={styleReverse}))
    ##    printlnrainbow("Just asked!")
    ##    decho()
    ##
    ##    loopy2(0,100,
    ##     block:
    ##       var r = getRndint(0,cxtruecol.len - 1)
    ##       var g = getRndint(0,cxtruecol.len - 1)
    ##       var b = getRndInt(0,cxtruecol.len - 1)
    ##       printLn("Color Test rgb " & fmtx([">6","",">6","",">6"],r,",",g,",",b) & spaces(2) & efb2 * 30 & spaces(2) & cxpad($xloopy,6) ,
    ##               newColor(r,g,b),rndcol(),styled = {styleReverse}))
    ##    
    ##    

    print($(astring) & "\n",fgr,bgr,xpos,fitLine,centered,styled)
    stdout.write cleareol

# output  horizontal lines
proc hLine*(n:int = tw,
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
     print(lt.repeat(n),col,xpos = xpos)
     result = lt.repeat(n)     # we return the line string without color and pos formating in case needed


proc hLineLn*(n:int = tw,
              col:string = white,
              xpos:int = 0,
              lt:string = "-"):string {.discardable.} =
     ## hLineLn
     ##
     ## draw a full line in stated length and color a linefeed will be issued
     ##
     ## defaults full terminal width and white
     ##
     ##.. code-block:: nim
     ##    hLineLn(30,green)
     ##
     
     let res = hLine(n,col,xpos,lt)
     echo()
     result = res
     

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
     if lt.len <= n: print(lt.repeat(n div lt.len),col)


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
     if lt.len <= n: print(lt.repeat(n div lt.len),col)
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
        c = rxcol[sample(toSeq(1..rxcol.len - 1))]
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



proc splitty(txt: string, sep: string): seq[string] =
          var rx = newSeq[string]()
          let z = txt.split(sep)
          for xx in 0..<z.len:
                 if z[xx] != txt and z[xx] != "":
                         if xx < z.len-1: rx.add(z[xx] & sep)
                         else: rx.add(z[xx])
          result = rx


proc printBiCol*[T](s:varargs[T,`$`],
                    colLeft:string = yellowgreen,
                    colRight:string = termwhite,
                    sep:string = ":",
                    xpos:int = 0,
                    centered:bool = false,
                    styled : set[Style] = {}) =
                    
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
                    print(z[0],fgr = colLeft,bgr = getBg(bgDefault),xpos = xpos,styled = styled)
                    print(z[1],fgr = colRight,bgr = getBg(bgDefault),styled = styled)
                else:  # centered == true
                    let npos = tw div 2 + 2 - (zz).len div 2 - 1
                    print(z[0],fgr = colLeft,bgr = getBg(bgDefault),xpos = npos,styled = styled)
                    print(z[1],fgr = colRight,bgr = getBg(bgDefault),styled = styled)




proc printLnBiCol*[T](s:varargs[T,`$`],
                   colLeft : string = yellowgreen,
                   colRight: string = termwhite,
                   sep     : string = ":",
                   xpos    : int = 0,
                   centered: bool = false,
                   styled  : set[Style] = {}) =
                   
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
     ##      showSeq(createSeqHiragana(),yellowgreen,displayflag=false),newLine(2),lime,
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
                  print(z[0],fgr = colLeft,bgr = getBg(bgDefault),xpos = xpos,styled = styled)
                  printLn(z[1],fgr = colRight,bgr = getBg(bgDefault),styled = styled)

            else:  # centered == true
                  let npos = tw div 2 + 2 - zz.len div 2 - 1
                  print(z[0],fgr = colLeft,bgr = getBg(bgDefault),xpos = npos)
                  printLn(z[1],fgr = colRight,bgr = getBg(bgDefault),styled = styled)
                        
                        
proc printHL*(s     : string,
              substr: string,
              col   : string = termwhite,
              bgr   : string = getBg(bgDefault)) =
              
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
             print(substr,col,bgr)


proc printLnHL*(s      : string,
                substr : string,
                col    : string = lightcyan,
                bgr    : string = getBg(bgDefault)) =
      ## printLnHL
      ##
      ## print and highlight all appearances of a char or substring of a string
      ##
      ## with a certain color and issue a new line
      ##
      ##.. code-block:: nim
      ##    printLnHL("HELLO THIS IS A TEST","T",lime)
      ##
      ## this would highlight all T in lime
      ##

      printHL($(s) & "\L",substr,col,bgr)

   
# cxLine is a experimental line creation object with several properties 
# up to 12 CxlineText objects can be placed into a cxline
# also see printCxLine in cxprint.nim.nim for possible usage

type

          CxLineType* = enum
                    cxHorizontal = "horizontal" # works ok
                    cxVertical = "vertical" # not yet implemented


          CxlineText* = object
                    text*: string # text                               default none
                    textcolor*: string # text color                    default termwhite
                    textstyle*: set[Style] # text styled
                    textpos*: int # position of text from startpos     default 3
                    textbracketopen*: string # open bracket surounding the text     default [
                    textbracketclose*: string # close bracket surrounding the text  default ]
                    textbracketcolor*: string # color of the open,close bracket     default dodgerblue


          Cxline* {.inheritable.} = object # a line type object startpos= = leftdot, endpos == rightdot
                    startpos*: int # xpos leftdot                      default 1
                    endpos*: int # xpos rightdot == width of cxline    default 2
                    toppos*: int # ypos of top dot                     default 1
                    botpos*: int # ypos of bottom dot                  default 1
                    cxlinetext*: CxLinetext # cxlinetext object
                    cxlinetext2*: CxlineText # cxlinetext object
                    cxLinetext3*: CxlineText # cxlinetext object
                    cxlinetext4*: CxlineText # cxlinetext object
                    cxlinetext5*: CxLinetext # cxlinetext object
                    cxlinetext6*: CxlineText # cxlinetext object
                    cxLinetext7*: CxlineText # cxlinetext object
                    cxlinetext8*: CxlineText # cxlinetext object
                    cxlinetext9*: CxLinetext # cxlinetext object
                    cxlinetext10*: CxlineText # cxlinetext object
                    cxLinetext11*: CxlineText # cxlinetext object
                    cxlinetext12*: CxlineText # cxlinetext object
                    showbrackets*: bool # showbrackets trye or false       default true
                    linecolor*: string # color of the line char            default aqua
                    linechar*: string # line char                          default efs2    # see cxconsts.nim
                    dotleftcolor*: string # color of left dot              default yellow
                    dotrightcolor*: string # color of right dot            default magenta
                    linetype*: CxLineType # cxHorizontal,cxVertical,cxS    default cxHorizontal
                    newline*: string # new line char                       default \L

proc newCxlineText*(): CxlineText =
          result.text = ""
          result.textcolor = termwhite
          result.textstyle = {}
          result.textpos = 3
          result.textbracketopen = "["
          result.textbracketclose = "]"
          result.textbracketcolor = dodgerblue

proc newCxLine*(): Cxline =
          ## newCxLine 
          ## 
          ## creates a new cxLine object with some defaults , ready to be changed according to needs
          ##
          result.startpos = 1
          result.endpos = 1
          result.toppos = 1
          result.botpos = 1
          result.cxlinetext = newCxlineText()
          result.cxlinetext2 = newCxlineText()
          result.cxlinetext3 = newCxlineText()
          result.cxlinetext4 = newCxlineText()
          result.cxlinetext5 = newCxlineText()
          result.cxlinetext6 = newCxlineText()
          result.cxlinetext7 = newCxlineText()
          result.cxlinetext8 = newCxlineText()
          result.cxlinetext9 = newCxlineText()
          result.cxlinetext10 = newCxlineText()
          result.cxlinetext11 = newCxlineText()
          result.cxlinetext12 = newCxlineText()
          result.showbrackets = true
          result.linecolor = aqua
          result.linechar = efs2
          result.dotleftcolor = yellow
          result.dotrightcolor = magenta
          result.newline = "\L"
      
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
       
       else:
              discard

proc doty*(d   :int,
           fgr :string = white,
           bgr :string = black, 
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
     ##      dotyLn(18 ,salmon,truetomato,xpos=10)         # using a foregroundcolor as backgroundcolor will color the dots itself
     ##      dotyLn(18 ,yaleblue,truetomatobg,xpos=10)     # backgroundcolor with xxxxbg colors background and dots will be in foregroundcolor
     ##
     let astr = $(wideDot.repeat(d))
     cxprint(xpos,fgr,bgr,astr)


proc dotyLn*(d    :int,
             fgr  :string = white,
             bgr  :string = black, 
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
     ##      dotyLn(18 ,salmon,white,10)
     ##      loopy(0.. 100,loopy(1 .. tw div 2, doty(1,randcol(),rndcol(),xpos = rand(tw - 1))))
     ##
     doty(d=d,fgr=fgr,bgr=bgr,xpos=xpos)
     writeLine(stdout,"")

       
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
      printBiCol("[OK    ]" & spaces(1) & atext , colLeft = limegreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
#      
proc printLnOkMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
      printLnBiCol("[OK    ]" & spaces(1) & atext , colLeft = limegreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})    
#     
proc printStatusMsg*(atext:string = "",xpos:int = 1,colLeft=lightseagreen) =
     cxprint(xpos,colLeft,styleReverse,"[Status]",snow,stylereverse,spaces(1) & atext & spaces(1))
      
proc printLnStatusMsg*(atext:string = "",xpos:int = 1,colLeft=lightseagreen) =
      cxprintln(xpos,colLeft,styleReverse,"[Status]",snow,stylereverse,spaces(1) & atext & spaces(1))
        
proc printHelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Help  ]" & spaces(1) & atext , colLeft = thistle ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnHelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Help  ]" & spaces(1) & atext , colLeft = limegreen ,colRight = pastelyellow,sep = "]",xpos = xpos,false,{stylereverse})    
     
#printLnBelpMsg used for inserting more help lines without Help word
proc printBelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[      ]" & spaces(1) & atext , colLeft = thistle ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
     
proc printLnBelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[      ]" & spaces(1) & atext , colLeft = thistle ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})    
 
proc printCodeMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Code  ]" & spaces(1) & atext , colLeft = lavender ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})    

proc printLnCodeMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Code  ]" & spaces(1) & atext , colLeft = lavender ,colRight = lightgrey,sep = "]",xpos = xpos,false,{stylereverse})    

proc printEelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[End   ]" & spaces(1) & atext , colLeft = truetomato ,colRight = pastelyellow,sep = "]",xpos = xpos,false,{stylereverse})    

proc printLnEelpMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[End   ]" & spaces(1) & atext , colLeft = truetomato ,colRight = pastelyellow,sep = "]",xpos = xpos,false,{stylereverse})         
                
proc printPassMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printBiCol("[Pass  ]" & spaces(1) & atext , colLeft = yellowgreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})
   
proc printLnPassMsg*(atext:string = "",xpos:int = 1):string {.discardable.} =
     printLnBiCol("[Pass  ]" & spaces(1) & atext , colLeft = yellowgreen ,colRight = snow,sep = "]",xpos = xpos,false,{stylereverse})

# printInfoMsg and printLnInfoMsg can take two strings for more generic use     
proc printInfoMsg*(info,atext:string = "",colLeft:string = lightslategray ,colRight:string = pastelWhite,xpos:int = 1):string {.discardable.} =
     printBiCol(["[$1]" % info , spaces(1) , atext] , colLeft = colLeft ,colRight = colRight,sep = "]",xpos = xpos,false,{stylereverse})
# 
proc printLnInfoMsg*(info,atext:string = "",colLeft:string = lightslategray ,colRight:string = pastelWhite,xpos:int = 1):string {.discardable.} =
     printLnBiCol("[$1]" % info & spaces(1) & atext , colLeft = colLeft ,colRight = colRight,sep = "]",xpos = xpos,false,{stylereverse})
   
      
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
    if i != n.len - 1:
      # separate by ", "
      result.add(newCall("write", newIdentNode("stdout"), newStrLitNode(", ")))
    else:
      # add newline
      result.add(newCall("writeLine", newIdentNode("stdout"), newStrLitNode("")))     


if isMainModule:
    cxprintLn(10,yellowgreen,"This is cxprint", red,".nim")
    printLn(CRLF)
    for x in 0..<10:print SP
    printLnRainbow("Rainbow - Temple of the King")
    decho(2)
    printLnInfoMsg("Nimcx","Just a message for a rainy day")
    echo()
# end of cxprint.nim      
