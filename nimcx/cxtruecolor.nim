import cxglobal,cxconsts,cxprint,cxutils,terminal,strutils,random

# cxtruecolor.nim   
#
# Experimental -- you might be transported to Orion on a oneway ticket 
#                 for free by using this module. You also might run out of memory fast.
# 
# 
# support variables and functions for experimental cxTrueColor related routines
# cxTrueColor allows unlimited , subject to system memory , generation of truecolors in nim 
# 
# see examples cxtruecolorE1.nim for experimental usage
# 
# NOTE:
# 
# KDE/konsole or similar terminal to see all truecolors needed.
# the standard gnome terminal ,terminator etc etc currently not able to show all colors
# 
# Now all cxtruecolor functions need one  call to
# getCxTrueColorSet()  and compilation with -d:cxTrueCol 
# eg. nim c -r -d:cxTruecol cxtruecolor.nim
# then it will work like expected
#
# Last : 2019-05-31
# 
# 
type
  CXRGB* = tuple[R: int, G: int, B: int,cxCol:string]  # the idea for the cxCol field is to give interesting colors a name
  
var cxTrueCol* = newSeq[string]()  # a global for conveniently holding truecolor codes if used  if above works maybe this can be deprecated
var cxRGB* = newSeq[CXRGB]()       # a global holding rgb color values if used

var colorNumber38* = 0             # used as a temp storage of a random truecolor number drawn from the 38 set
var colorNumber48* = 1             # used as a temp storage of a random truecolor number drawn from the 48 set


proc cxRGBCol*(acol:CXRGB) : string = 
     ## cxRGBcol  
     ## 
     ## returns a color build from rgb values passed in via CXRGB type tuple 
     ## 
     ## Note the colCol string value of the cxRGB type is not used here
     ## 
     result = "\x1b[38;2;" & "$1;$2;$3m" % [$acol[0],$acol[1],$acol[2]]
       
proc cxRndRGB*():string = 
     ## cxRndRGB
     ##
     ## returns a random color string useable by var. print procs
     ## 
     ## suitable only for terminals supporting truecolor like konsole
     ## 
     ## other terminals will display some bland color most of the time
     ## 
     ## use rndCol() or randCol() instead.
     ##
     ## 
     result = cxRGBCol((getrndint(0,25000),getrndint(0,25000),getrndint(0,25000),""))

proc checkTrueColorSupport*(): bool {.discardable.} = 
     # checkTrueColorSupport 
     try:
        enableTrueColors()
     except:
        discard
     result = true

# 
# experimental  section  will be removed
# 
# truecolors support exceeding colors available from stdlib   
# the generated cxtruecolor numbers are only valid within the context of
# the parameters set in cxTrueColorSet , a call with different params
# will give different color numbers   
# Call
# getCxTrueColorSet()
# and
# compilation with -d:cxTrueCol 
# then it will work like expected
# 
# overall still needs a better way to select desired colors or colorsets
# also larger pallettes while possible need lots of memory if preloaded and increased compilation time
# 


proc cxTrueColorSet(min:int = 0 ,max:int = 888 , step: int = 12,flag48:bool = false):seq[string] {.inline.} =
   ## cxTrueColorSet
   ## 
   ## generates a seq with truecolors  
   ## defaults are reasonable 421875 colors to choose from . Run showCxTrueColorPalette() to get a taste.
   ## 
   ## the colors are stored as numbers with odd for 38 types and even for 48 types
   ## 38 types refers to: "\x1b[38;2;....m"
   ## 48 types refers to: "\x1b[48;2;....m"
   ## colors, the main difference currently is that 48 types write in color on
   ## reversed background color , overall it seems best and fastest to use 38 types only
   ## with styleReverse , but font color for any text will be in one color only.
   ## so depending on what the desired outcome is a little experimentation
   ## will be needed for the right combination, styleBright also works 
   ## with certain truecolors now directly availabe in Nim stdlib the best usage
   ## for extended truecolors is something like so 
   ## 
  
   # could be mixed up anywhich way to create interesting palettes rgb,bgr etc
   result = @[]
   cxRGB = @[]
   for r in countup(min,max,step):
     for g in countup(min,max,step):
       for b in countup(min,max,step):
          let rbx = "$1;$2;$3m" % [$r,$g,$b]
          result.add("\x1b[38;2;" & rbx)
          cxRGB.add((r,g,b,rbx))
          if flag48 == true: result.add("\x1b[48;2;" & rbx) 
          
          
proc getCxTrueColorSet*(min:int = 0,max:int = 888,step:int = 12,flag48:bool = false):bool {.discardable.} =
     ## getcxTrueColorSet
     ## 
     ## this function fills the global cxTrueCol seq with truecolor values
     ## now all cxtruecolor stuff needs a call to
     ## getCxTrueColorSet()
     ## and
     ## compilation with -d:cxTrueCol 
     ## then it will work like expected
     ##  
     result = false
     if checktruecolorsupport() == true:
           when defined(cxTrueCol):
              {.hints: on.}
              {.hint    : "\x1b[38;2;154;205;50m \u2691 NimCx loading :" & "\x1b[38;2;255;100;0m cxTrueCol  \xE2\x9A\xAB" & " " & "\xE2\x9A\xAB" & spaces(2) & "\x1b[38;2;154;205;50m \u2691" & spaces(1) .} 
              {.hints: off.}
              cxTrueCol = cxTrueColorSet(min,max,step,flag48)
              printLnBiCol("cxTrueCol Length : " & $cxtruecol.len)
           else:
              #{.hints: off.}  
              {.hint    : "\x1b[38;2;154;205;50m \u2691 NimCx :" & "\x1b[38;2;255;100;0m cxTrueCol not loaded, Compile with -d:cxTrueCol to preload.  \xE2\x9A\xAB" & " " & "\xE2\x9A\xAB" & spaces(2) & "\x1b[38;2;154;205;50m \u2691" & spaces(1) .} 
              #cxTrueCol = @[]
           echo()
           result = true
     else:
           result = false
           cxprintln(2,white,bgred,"cxTrueCol truecolor scheme can not be used on this terminal/konsole")
           #doFinish() 
   
proc color38*(cxTrueCol:seq[string]) : int {.inline.} =
     # random truecolor ex 38 set
     var lcol = rand(cxTrueCol.len - 1)
     while lcol mod 2 <> 0 : lcol = rand(cxTrueCol.len - 1)
     result = lcol
   
proc color48*(cxTrueCol:seq[string]) : int {.inline.} =
     # random truecolor ex 48 set
     result = 1
     if cxTrueCol.len > 1:
        var rcol = rand(cxTrueCol.len - 1)
        while rcol mod 2 == 0 : rcol = rand(cxTrueCol.len - 1)
        result = rcol   

proc color3848*(cxTrueCol:seq[string]) : int {.inline.} =
     # random truecolor ex 38 and 48 set
     result = rand(cxTrueCol.len - 1)
     
proc rndTrueCol*() : auto {.inline.}  = 
     ## rndTrueCol
     ## 
     ## returns a random color from the cxtruecolorset for use as 
     ## foreground color in var. print functions
     ##   
     colornumber38 = color38(cxTrueCol)
     result = cxTrueCol[colornumber38]


proc rndTrueCol2*() : auto {.inline.} = 
     ## rndTrueCol2
     ## 
     ## returns a  color from the cxtruecolorset for use as 
     ## background color in var. print functions
     ## 
     colornumber48 = color48(cxTrueCol)
     result = cxTrueCol[colornumber48]     
     
proc rndTrueColFull*() : auto {.inline.} = 
     ## rndTrueCol
     ## 
     ## returns a random color from the cxtruecolorset for use as 
     ## foreground color in var. print functions
     ## 
     colornumber38 = color3848(cxTrueCol)
     result = cxTrueCol[colornumber38]     
     
proc checkCxTrueColor*(n:int):int =
     ## checkCxTrueColor
     ## 
     ## returns n if available in cxtruecol else returns cxtruecol.max
     ## 
     result = n
     if n > cxTrueCol.len:
       #{.warning : " Color Number requested not available. Using max color from cxTrueCol set".}
       result = cxTrueCol.len
   
proc showCxTrueColorPalette*() =
     ## showCxTrueColorPalette
       
     let msgxpos = 5
     if cxTrueCol.len > 0:
              let cxtlen = $(cxTruecol.len)
              var testLine = newcxline()
              var rgx = 0
              for lcol in countup(0,cxTruecol.len - 1,2): # note step size 2 so we only select 38 type colors
                    if lcol mod 255 == 0 : inc rgx
                 
                    let bcol  = color38(cxTrueCol)
                    let dlcol = color38(cxTrueCol)
                    let drcol = color38(cxTrueCol)
                    testLine.startpos = 3  
                    testLine.endpos = 127
                    testLine.linecolor        = cxTrueCol[lcol]
                    testLine.dotleftcolor     = cxTrueCol[dlcol]
                    testLine.dotrightcolor    = cxTrueCol[drcol]
                                        
                    testLine.cxlinetext.textpos = 5
                    testLine.cxlinetext.textbracketcolor = cxTrueCol[bcol]
                    testLine.cxlinetext.text = fmtx(["<20","<14",">8",""], "Testing" ,"cxTruecolor : " ,$lcol," of " & cxtlen & spaces(1))
                    testLine.cxlinetext.textcolor = cxTrueCol[lcol]  # change this to tcol to have text in a random truecolor
                    testLine.cxlinetext.textstyle = {styleReverse}
                    
                    testLine.cxlinetext2.textpos = 65
                    testLine.cxlinetext2.textbracketcolor = cxTrueCol[bcol]
                    testLine.cxlinetext2.text = fmtx(["<55"], "RGX " & $cxrgb[lcol])
                    testLine.cxlinetext2.textcolor = cxTrueCol[lcol]  # change this to tcol to have text in a random truecolor
                    testLine.cxlinetext2.textstyle = {styleReverse}
                    
                    testLine.newline = "\L"                  # need a new line character here or we overwrite 
                    printCxLine(testLine)
              
              decho(2)
              #printLnInfoMsg("Note            " , cxpad("cxTrueColor Value can be used like so ",96),xpos = msgxpos)
              #printLnInfoMsg("                " , cxpad("""as foregroundcolor : printLn2("say something  ",fgr = cxTruecol[421874])""",96),xpos = msgxpos)
              echo()
              #printLnInfoMsg("Palette Entries " , ff2(cxTruecol.len),xpos = msgxpos)   
     else:        
              echo()
              #printLnInfoMsg("Palette Entries " , ff2(cxTruecol.len),xpos = msgxpos)   
              #printLnInfoMsg("Note            " , cxpad("cxTrueCol is not loaded. ",96),xpos = msgxpos)
              #printLnInfoMsg("                " , cxPad("compile with -d:cxTrueCol",96),xpos = msgxpos)   
              decho(2) 
      
#  end experimental cxtruecolors     
