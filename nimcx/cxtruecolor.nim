import cxglobal,cxconsts,cxprint,terminal,strutils,random

# cxtruecolor.nim
# 
# support variables for experimental cxTrueColor related routines
# cxTrueColor allows unlimited , subject to system memory , generation of truecolors in nim 
# see examples cxtruecolorE1.nim  for usage
#
# Last : 2018-02-27
# 

var cxTrueCol* = newSeq[string]()  # a global for conveniently holding truecolor codes if used
var colorNumber38* = 0             # used as a temp storage of a random truecolor number drawn from the 38 set
var colorNumber48* = 1             # used as a temp storage of a random truecolor number drawn from the 48 set


proc checkTrueColorSupport*(): bool  {.discardable.} = 
     # checkTrueColorSupport 
     try:
        enableTrueColors()
     except:
        discard
     result = true
 
     # below code seems to fail on Ubuntu based systems like Mint , 
     # but works on Debian Testing, openSuse ...
     # so currently not in use
     # 
     # 
     # if $(getEnv("COLORTERM").toLowerAscii in ["truecolor", "24bit"]) == "true":
     #           enableTrueColors()
     #           result = true 
     #      else:
     #          printLnBiCol("[Note] : No trueColor support on this terminal/konsole")
     #          result = false   
     
     

# 
# experimental  section
# truecolors support exceeding colors available from stdlib   
# the generated cxtruecolor numbers are only valid within the context of
# the parameters set in cxTrueColorSet , a call with different params
# will currently give different color numbers  

proc cxTrueColorSet(min:int = 0 ,max:int = 888 , step: int = 12,flag48:bool = false):seq[string] {.inline.} =
   ## cxTrueColorSet
   ## 
   ## generates a seq with truecolors  
   ## defaults are reasonable 843750 colors to choose from 
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
   ##.. code-block:: nim
   ##     printLnTrue("Color me with truecolors ",fgr = rndcol(), bgr = "coldodgerblue") 
   ## 
   ## here there fgr color is drawn from colorNames and the background color from the cxTruecolor set
   ## 
   result = @[]
   for r in countup(min,max,step):
     for g in countdown(max,min,step):
       for b in countup(min,max,step):
          let rbx = "$1;$2;$3m" % [$r,$b,$g]
          result.add("\x1b[38;2;" & rbx)
          if flag48 == true: result.add("\x1b[48;2;" & rbx) 
          
          
proc getCxTrueColorSet*(min:int = 0,max:int = 888,step:int = 12,flag48:bool = false):bool {.discardable.} =
     ## getcxTrueColorSet
     ## 
     ## this function fills the global cxTrueCol seq with truecolor values
     ## and needs to be run once if truecolor functionality exceeding stdlib support required
     ## 
     ##  
     result = false
     if checktruecolorsupport() == true:
           {.hints: on.}
           {.hint    : "\x1b[38;2;154;205;50m \u2691  Processing :" & "\x1b[38;2;255;100;0m getCxTrueColorset ! \xE2\x9A\xAB" &  " " &  "\xE2\x9A\xAB" & spaces(2)  & "\x1b[38;2;154;205;50m \u2691" & spaces(1) .} 
           {.hints: off.}
           cxTrueCol = cxTrueColorSet(min,max,step,flag48) 
           #printLnBiCol("cxTrueCol Length : " & $cxtruecol.len)
           result = true
     else:
           result = false
           printLnErrorMsg("cxTrueCol truecolor scheme can not be used on this terminal/konsole")
           #doFinish() 
   
proc color38*(cxTrueCol:seq[string]) : int =
     # random truecolor ex 38 set
     var lcol = rand(cxTrueCol.len - 1)
     while lcol mod 2 <> 0 : lcol = rand(cxTrueCol.len - 1)
     result = lcol
   
proc color48*(cxTrueCol:seq[string]) : int =
     # random truecolor ex 48 set
     var rcol = rand(cxTrueCol.len - 1)
     while rcol mod 2 == 0 : rcol = rand(cxTrueCol.len - 1)
     result = rcol   

proc color3848*(cxTrueCol:seq[string]) : int =
     # random truecolor ex 38 and 48 set
     result = rand(cxTrueCol.len - 1)
     
proc rndTrueCol*() : auto = 
     ## rndTrueCol
     ## 
     ## returns a random color from the cxtruecolorset for use as 
     ## foreground color in var. print functions
     ## 
     colornumber38 = color38(cxTrueCol)
     result = cxTrueCol[colornumber38]

proc rndTrueColFull*() : auto = 
     ## rndTrueCol
     ## 
     ## returns a random color from the cxtruecolorset for use as 
     ## foreground color in var. print functions
     ## 
     colornumber38 = color3848(cxTrueCol)
     result = cxTrueCol[colornumber38]     
     
    
#  end experimental truecolors     
