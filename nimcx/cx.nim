#Compiler options
{.deadCodeElim: on, optimization: speed.}
#{.passC: "-msse -msse2 -msse3 -mssse3 -march=native -mtune=native -flto".}
#{.passL: "-msse -msse2 -msse3 -mssse3 -flto".}
#{.deadCodeElim: on, checks: off, hints: off, warnings: off, optimization: size.}
#  {.noforward: on.}   # future feature
## ::
## 
##     Library     : nimcx.nim
##     
##     Module      : cx.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##
##     Version     : 0.9.9
##
##     ProjectStart: 2015-06-20
##   
##     Latest      : 2018-01-26
##
##     Compiler    : Nim >= 0.17.x dev branch
##
##     OS          : Linux
##
##     Description :
##
##                   nimcx.nim is a collection of simple procs and templates
##
##                   for easy colored display in a linux terminal and also contains
##                   
##                   a wide selection of utility functions and useable snippets. 
##                   
##                   Currently the library consists of cx.nim , cxconsts.nim and cxutils.nim , 
##                   
##                   all files are automatically imported with : import nimcx
##                   
##                   Some procs may mirror functionality available in stdlib moduls and will be deprecated if
##                   
##                   similar or better appear in the stdlib. Overtime more procs will be pushed into
##                   
##                   cxutils.nim and the upcoming cxsnippets.nim and not longer imported via cxnim to
##                   
##                   keep everything small and usefull.
##
##
##     Usage       : import nimcx
##
##     Project     : `NimCx <https://github.com/qqtop/NimCx>`_
##
##     Docs        : `Documentation <https://qqtop.github.io/cx.html>`_
##
##     Tested      : OpenSuse Tumbleweed  
##       
##                   Terminal set encoding to UTF-8  
##
##                   with var. terminal font : hack,monospace size 9.0 - 15  tested
##
##                   xterm,bash,st ,zsh  terminals support truecolor ok
##
##
##     Related     :
##
##                  * see examples
##
##                  * demo library: cxDemo.nim   (rough demos lib)
##
##                  * tests       : cxTest.nim   (run some rough demos from cxDemo)
##
##
##     Programming : qqTop
##
##     Note        : mileage may vary depending on the available
##
##                   unicode libraries and terminal support in your system
##
##                   terminal x-axis position start with 1
##
##                   proc fmtx a simple formatting utility has been added and works with strformat too
##
##
##     Installation: nimble install nimcx
##
##
##     Optional    : xclip  (linux clipboard utility)
##                 
##                   unicode font libraries as needed 
##
##     In progress : moving some of the non core procs to module cxutils.nim 
##                   
##                   moving constants to cxconsts.nim
##                   
##                   improving experimental cxtruecolor related procs .
##                   
##     Latest      : changed time date related code to work with newest times.nim 
## 
##                   added more procs for truecolor support see cxPrint etc.
##                  
##
##     Funding     : Here are the options :
##     
##                   You are happy              ==> send BTC to : 194KWgEcRXHGW5YzH1nGqN75WbfzTs92Xk
##                   
##                   You are not happy          ==> send BTC to : 194KWgEcRXHGW5YzH1nGqN75WbfzTs92Xk
##                 
##                   You are in any other state ==> send BTC to : 194KWgEcRXHGW5YzH1nGqN75WbfzTs92Xk
##                                       
##                   
##                        

import times,random,cxconsts,os,strutils,strformat,parseutils, parseopt, hashes, tables, sets, strmisc
import osproc,macros,posix,terminal,math,stats,json,streams,options,memfiles
import sequtils,httpclient,rawsockets,browsers,intsets, algorithm,stats
import unicode ,typeinfo, typetraits ,cpuinfo,colors,encodings,distros
export times,strutils,strformat,sequtils,unicode,streams,hashes,terminal,colors,cxconsts,random
export options,json,httpclient,stats


# Profiling       
#import nimprof  # nim c -r --profiler:on --stackTrace:on cx

# Memory usage
# --profiler:off, --stackTrace:on -d:memProfiler  

# for debugging intersperse with dprint(someline)
# or see the stacktrace with writeStackTrace()
# or compile with  --debugger:on 

#const someGcc = defined(gcc) or defined(llvm_gcc) or defined(clang)  # idea for backend info ex nimforum

var someGcc = "" 
if defined(gcc) : someGcc = "gcc"
# below needs to be tested    
elif defined(llvm_gcc):  someGcc = "llvm_gcc"
elif defined(clang): someGcc = "clang"
elif defined(cpp) : someGcc = "c++ target"
else: someGcc = "undefined"    

when defined(macosx):
  {.warning : " \u2691 CX is only tested on Linux ! Your mileage may vary".}

when defined(windows):
  {.hint    : "Time to switch to Linux !".}
  {.hint    : "CX does not support Windows at this stage , you are on your own !".}

when defined(posix):
  {.hint    : "\x1b[38;2;154;205;50m \u2691  NimCx      :" &  "\x1b[38;2;255;215;0m Officially works on Linux only." & spaces(13) & "\x1b[38;2;154;205;50m \u2691".}
  {.hint    : "\x1b[38;2;154;205;50m \u2691  Compiling  :" &  "\x1b[38;2;255;100;0m Please wait , Nim will be right back ! \xE2\x9A\xAB" &  " " &  "\xE2\x9A\xAB" & spaces(2)  & "\x1b[38;2;154;205;50m \u2691".} 
  {.hints: off.}   # turn on off as per requirement
  
  
const CXLIBVERSION* = "0.9.9"

let cxstart* = epochTime()  # simple execution timing with one line see doFinish()
randomize()                 # seed rand number generator 

type
     NimCxError* = object of Exception         
     # to be used like so
     # raise newException(NimCxError, "didn't do stuff")
     #
     # or something like this
     # 
     # proc checkoktype[T](a: T) =
     #   when (T is ref or T is ptr or T is cstring):
     #     raise newException(NimCxError, "This type not supported here")
     #     # or exit during compile already
     #     #  {.fatal: "This type not supported here".}
     #   else:
     #     discard
     # 
     # 
     #
     

# type used in slim number printing
type
    T7 = object  
      zx : seq[string]
      
# type used in getRandomPoint
type
    RpointInt*   = tuple[x, y : int]
    RpointFloat* = tuple[x, y : float]

# type used in Benchmark
type
    Benchmarkres* = tuple[bname,cpu,epoch,repeats:string,fastest : float]
    
# used to store all benchmarkresults   
var benchmarkresults* =  newSeq[Benchmarkres]()


type
    CxTimer* =  object {.packed.}
      name* : string
      start*: float
      stop  : float
      lap*  : seq[float]
      
     
# type used in for cxtimer
type
    Cxtimerres* = tuple[tname:string,
                        start:float,
                        stop :float,
                        lap  :seq[float]]

# used to store all cxtimer results 
var cxtimerresults* =  newSeq[Cxtimerres]() 

# #start timer experimental
# # under consideration use different setup to get rid of globals like cxtimerresults    
# 
# type 
#      CxRtes* = object
#          cxRtimerres* : seq[Cxtimerres]
#      
# proc newCxtimerresults*(acxtimer:Cxtimer): CxRtes =
#         
#         result.cxRtimerres.add(acxtimer)    # hmm need to rethink this
# 
# # try to use it
# # 
# var globalTimer = newCxtimerresults()
# globalTimer.start = epochTime()
# # 
# ## end timer experimental

type
  Cxcounter* =  object
      value*: int

proc newCxCounter*():ref(Cxcounter) =
    ## newCxcounter
    ## 
    ## set up a new cxcounter
    ## 
    ## simple counter with add,dec and reset procs
    ## 
    ##.. code-block:: nim
    ## var counter1 = newCxcounter()
    ## counter1.add   # add 1
    ## counter1.dec   # dec 1
    ## counter1.reset # set to 0
    ## echo counter1.value # show current value
    ## 
    result =  (ref CxCounter)(value : 0)
    
proc  add*(co:ref Cxcounter) = inc co.value 
proc  dec*(co:ref Cxcounter) = dec co.value
proc  reset*(co:ref CxCounter) = co.value = 0  

# support variables for experimental cxTrueColor related routines
# cxTrueColor allows unlimited , subject to system memory , generation of truecolors in nim 
# see examples cxtruecolorE1.nim  for usage
var cxTrueCol* = newSeq[string]()  # a global for conveniently holding truecolor codes if used
var colorNumber38* = 0             # used as a temp storage of a random truecolor number drawn from the 38 set
var colorNumber48* = 1             # used as a temp storage of a random truecolor number drawn from the 48 set

   
type 

     CxLineType*  = enum
         cxHorizontal = "horizontal"        # works ok
         cxVertical   = "vertical"          # not yet implemented
         
# cxLine is a line creation object with several properties
type
     Cxline* {.inheritable.} = object       # a line type object startpos= = leftdot, endpos == rightdor
        startpos*: int                      # xpos of the leftdot                 default 1
        endpos*  : int                      # xpos of the rightdot                default 2
        toppos*  : int                      # ypos of top dot                     default 1
        botpos*  : int                      # ypos of bottom dot                  default 1
        text*    : string                   # text                                default none
        textcolor* : string                 # text color                          default termwhite
        textstyle* : set[Style]             # text styled
        textpos* : int                      # position of text from startpos      default 3
        textbracketopen*  : string          # open bracket surounding the text    default [
        textbracketclose* : string          # close bracket surrounding the text  default ]
        textbracketcolor* : string          # color of the open,close bracket     default dodgerblue
        linecolor* : string                 # color of the line char              default aqua
        linechar*  : string                 # line char                           default efs2    # see cxconsts.nim
        dotleftcolor* : string              # color of left dot                   default yellow
        dotrightcolor*: string              # color of right dot                  default magenta
        linetype*  : CxLineType             # cxHorizontal,cxVertical,cxS         default cxHorizontal  
        newline*   : string                 # new line char                       default \L
        
proc newCxLine*():Cxline =
     ## newCxLine 
     ## 
     ## creates a new cxLine object with some defaults , ready to be changed according to needs
     ## 
     result.startpos  = 1         
     result.endpos    = 2
     result.toppos    = 1
     result.botpos    = 1
     result.text      = ""
     result.textcolor = termwhite
     result.textstyle = {}
     result.textpos   = 3
     result.textbracketopen  = "["
     result.textbracketclose = "]"
     result.textbracketcolor = dodgerblue
     result.linecolor     = aqua
     result.linechar      = efs2
     result.dotleftcolor  = yellow
     result.dotrightcolor = magenta
     result.newline       = "\L"
        
        
        
converter toTwInt(x: cushort): int = result = int(x)  
  

proc getTerminalWidth*() : int =
        ## getTerminalWidth
        ##
        ## get linux terminal width in columns
        ## a terminalwidth function is now incorporated in Nim dev after 2016-09-02
        ## which maybe is slightly slower than the one presented here
        ## 
       
        type WinSize = object
            row, col, xpixel, ypixel: cushort
        const TIOCGWINSZ = 0x5413
        proc ioctl(fd: cint, request: culong, argp: pointer)
             {.importc, header: "<sys/ioctl.h>".}
        var size: WinSize
        ioctl(0, TIOCGWINSZ, addr size)
        result = toTwInt(size.col)


template tw* : int = getTerminalwidth() ## tw , a global where latest terminal width is always available 

proc getTerminalHeight*() : int =
        ## getTerminalHeight
        ##
        ## get linux terminal height in rows
        ##

        type WinSize = object
            row, col, xpixel, ypixel: cushort
        const TIOCGWINSZ = 0x5413
        proc ioctl(fd: cint, request: culong, argp: pointer)
            {.importc, header: "<sys/ioctl.h>".}
        var size: WinSize
        ioctl(0, TIOCGWINSZ, addr size)
        result = toTwInt(size.row)


template th* : int = getTerminalheight() ## th , a global where latest terminal height is always available 


# forward declarations
proc ff*(zz:float,n:int = 5):string
proc ff2*(zz:float,n:int = 3):string
proc ff2*(zz:int64,n:int = 0):string
proc rainbow*[T](s : T,xpos:int = 1,fitLine:bool = false ,centered:bool = false)  ## forward declaration
proc print*[T](astring:T,fgr:string = termwhite ,bgr:BackgroundColor = bgBlack,xpos:int = 0,fitLine:bool = false ,centered:bool = false,styled : set[Style]= {},substr:string = "")
proc printLn*[T](astring:T,fgr:string = termwhite , bgr:BackgroundColor = bgBlack,xpos:int = 0,fitLine:bool = false,centered:bool = false,styled : set[Style]= {},substr:string = "")
proc printBiCol*[T](s:varargs[T,`$`], colLeft:string = yellowgreen, colRight:string = termwhite,sep:string = ":",xpos:int = 0,centered:bool = false,styled : set[Style]= {}) 
proc printLnBiCol*[T](s:varargs[T,`$`], colLeft:string = yellowgreen, colRight:string = termwhite,sep:string = ":",xpos:int = 0,centered:bool = false,styled : set[Style]= {}) 
proc printRainbow*(s : string,styled:set[Style] = {})     ## forward declaration
proc hline*(n:int = tw,col:string = white,xpos:int = 1,lt:string = "-") : string {.discardable.} ## forward declaration
proc hlineLn*(n:int = tw,col:string = white,xpos:int = 1,lt:string = "-") : string {.discardable.}## forward declaration
proc spellInteger*(n: int64): string                      ## forward declaration
proc splitty*(txt:string,sep:string):seq[string]          ## forward declaration
proc doFinish*()


proc waitOn*(alen:int = 1) = 
     ## waiton
     ## 
     ## stops program to wait for one or more keypresses. default = 1
     ## 
     discard readBuffer(stdin,cast[pointer](newString(1)),alen)
    
proc rndSample*[T](asq:seq[T]):T =
     ## rndSample  
     ## returns one rand sample from a sequence
     randomize()
     result = rand(asq)     
     
proc rndRGB*():auto = 
   # rndRGB
   # 
   # returns a random RGB value from colors available in colorNames 
   # see cxconsts.nim for available values
   # 
   var cln = newSeq[int]()
   for x in 0..<colorNames.len: cln.add(x)
   let argb =  extractRgb(parsecolor(colorNames[rand(cln)][0]))   #rndsample
   result =  rgb(argb.r,argb.g,argb.b)

# char converters
converter toInt(x: char): int = result = ord(x)
converter toChar(x: int): char = result = chr(x)  
   
template `<>`* (a, b: untyped): untyped =
  ## unequal operator 
  ## 
  ## 
  ## 
  not (a == b)
        
       
proc `[]`*[T; U](a: seq[T], x: Slice[U]): seq[T] =
     # used by sampleSeq
     var al = ord(x.b) - ord(x.a) + 1
     if al >= 0:
        newSeq(result, al)
        for i in 0..<al: result[i] = a[(ord(x.a) + i)]
     else:
        result = @[]
        

proc sampleSeq*[T](x: seq[T], a:int, b: int) : seq[T] = 
     ## sampleSeq
     ##
     ## based on an idea in nim playground
     ## 
     ## returns a continuous subseq a..b from an array or seq if a >= b
     ## 
     ## 
     ##.. code-block:: nim
     ##    import nimcx
     ##    let x = createSeqInt(20)
     ##    echo x
     ##    echo x.sampleseq(4,8)
     ##    echo x.sampleSeq(4,8).rndSample()    # get one randly selected value from the subsequence
     ##    
     
     result =  x[a..b]
     
     
proc checkTrueColorSupport*(): bool  {.discardable.} =
     # checkTrueColorSupport
     # 
     # checks for truecolor support in a linux terminal 
     # if supported the nim truecolors will be enabled
     # 
     if $(getEnv("COLORTERM").toLowerAscii in ["truecolor", "24bit"]) == "true":
          enableTrueColors()
          result = true 
     else:
         printLnBiCol("[Note] : No trueColor support on this terminal/konsole")
         result = false
     
proc cxtoLower*(c: char): char = 
     ## cxtoLower
     ## 
     ## same as toLowerAscii()
     ## 
     result = c
     if c in {'A'..'Z'}: result = chr(ord(c) + (ord('a') - ord('A')))
  

###########################################################################
# experimental 
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
     for b in countdown(max,min,step):
       for g in countup(min,max,step):
          let rbx = "$1;$2;$3m" % [$r,$b,$g]
          result.add("\x1b[38;2;" & rbx)
          if flag48 == true: result.add("\x1b[48;2;" & rbx) 
          
          
proc getCxTrueColorSet*(min:int = 0,max:int = 888,step:int = 12,flag48:bool = false):bool {.discardable.} =
     ## getcxTrueColorSet
     ## 
     ## this function fills the global cxTrueCol seq with truecolor values
     ## and needs to be run once if truecolor functionality exceeding stdlib support 
     ## needs to be used 
     ## this function is not called within cx.nim to keep size and memory needs low.
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
          printLnBicol("Error : cxTrueCol truecolor scheme can not be used on this terminal/konsole",colLeft=red,styled = {stylereverse})
          doFinish() 
   
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
    ## foregroundcolor in var. print functions
    ## 
    colornumber38 = color38(cxTrueCol)
    result = cxTrueCol[colornumber38]
   

proc rndTrueCol2*() : auto = 
    ## rndTrueCol
    ## 
    ## returns a random color from the cxtruecolorset for use as 
    ## foregroundcolor in var. print functions
    ## 
    colornumber48 = color48(cxTrueCol)
    result = cxTrueCol[colornumber48]
    
    
#  end experimental truecolors     
#################################################################################################################### 
 
proc stripper*(str:string): string =
  # stripper
  # strip controlcodes "\ba\x00b\n\rc\fd\xc3"
  result = ""
  for ac in str:
    if ord(ac) in 32..126:
      result.add ac
 
   

template loopy*[T](ite:T,st:untyped) =
     ## loopy
     ##
     ## the lazy programmer's quick simple for-loop template
     ##
     ##.. code-block:: nim
     ##       loopy(0..<10,printLn("The house is in the back.",randcol()))
     ##
     for x in ite: st

     
template loopy2*(mi:int = 0,ma:int = 5,st:untyped) =
     ## loopy2
     ##
     ## the advanced version of loopy the simple for-loop template
     ## which also injects the loop counter xloopy if loopy2() was called with parameters
     ## if called without parameters xloopy will not be injected .
     ## 
     ##.. code-block:: nim
     ##   loopy2(1,10):2
     ##      printLnBiCol(xloopy , "  The house is in the back.",randcol(),randcol(),":",0,false,{})
     ##      printLn("Some integer : " , getRndInt())
     ##
     for xloopy {.inject.} in mi..<ma: st  
     
      
     
template cxtoday*:string = getDateStr() 
     ## today
     ## 
     ## returns date string
     ## 


proc streamFile*(filename:string,mode:FileMode): FileStream = newFileStream(filename, mode)    
     ## streamFile
     ##
     ## creates a new filestream opened with the desired filemode
     ##
     ##

proc uniform*(a,b: float) : float {.inline.} =
      ## uniform
      ## 
      ## returns a rand float uniformly distributed between a and  b
      ## 
      ##.. code-block:: nim
      ##   import nimcx,stats
      ##   import "rand-0.5.3/rand"
      ##   proc quickTest() =
      ##        var ps : Runningstat
      ##        var  n = 100_000_000
      ##        printLnBiCol("Each test loops : " & $n & " times\n\n")
      ##
      ##        for x in 0..<n: ps.push(uniform(0.00,100.00))
      ##        printLn("uniform",salmon) 
      ##        showStats(ps) 
      ##        ps.clear 
      ##        for x in 0..<n: ps.push(getRandomFloat() * 100)
      ##        curup(15) 
      ##        printLn("getRandomFloat * 100",salmon,xpos = 30)
      ##        showStats(ps,xpos = 30) 
      ##    
      ##        ps.clear 
      ##        for x in 0..<n: ps.push(getRndInt(0,100))
      ##        curup(15) 
      ##        printLn("getRndInt",salmon,xpos = 60)
      ##        showStats(ps,xpos = 60) 
      ##      
      ##   quickTest() 
      ##   doFinish()
      ##   
      ##    
      result = a + (b - a) * float(rand(b))

  
template `*`*(s:string,n:int):string =
    # returns input string  n times mimicking python
    s.repeat(n)    
    

   
proc getRndInt*(mi:int = 0 , ma: int = int.high):int  {.noInit,inline.} =
    ## getRndInt
    ##
    ## returns a rand int between mi and < ma
    ## so for 0 or 1 we need rand(0..2)
    var maa = ma
    if ma == 1: maa = 2
    result = rand(mi..maa)

  

proc getRndBool*():bool = 
      if getRndInt(0,1) == 0:
         result = false
      else:
         result = true
    
    
template colPaletteIndexer*(colx:seq[string]):auto =  toSeq(colx.low.. colx.high) 

template colPaletteLen*(coltype:string): auto =
         ##  colPaletteLen
         ##  
         ##  returns the len of a colPalette 
         ##  
         var ts = newseq[string]()         
         for x in 0..<colorNames.len:
            if colorNames[x][0].startswith(coltype) or colorNames[x][0].contains(coltype):
               ts.add(colorNames[x][1])           
         colPaletteIndexer(ts).len  


template colPalette*(coltype:string,n:int): auto =
         ## ::
         ##   colPalette
         ## 
         ##   returns a specific color from the palette which can be used in print statements
         ##   
         ##   if n > larger than palette length the first palette entry will be used
         ##   
         ##.. code-block:: nim
         ##     import nimcx
         ##     cleanScreen()       
         ##     decho(2)
         ##     var mycol = "light"
         ##     mycol = mycol.lowerCase()
         ##     let somesample = aPaletteSample(mycol)
         ##     printLn($somesample & "th color of the " & mycol & " palette  ( index starts with 0 )", colPalette(mycol,somesample)) 
         ##     printLn("Name of the " & $somesample & "th entry : " & colPaletteName(mycol,somesample))
         ##     echo()
         ##     printLn("Random color of the " & mycol & " palette ", colPalette(mycol,aPaletteSample(mycol))) 
         ##     printLn("Length of " & mycol & " palette: " & $colPaletteLen(mycol) & " ( index starts with 0 )" )
         ##     echo()
         ##     loopy2(0,colPaletteLen(mycol)):
         ##         printLn("Here we go " & rightarrow * 3 & spaces(2) & colPaletteName(mycol,xloopy), colPalette(mycol,xloopy))
         ##    doFinish()
         ##
         var m = n
         var ts = newseq[string]()         
         for colx in 0..<colorNames.len:
            if colorNames[colx][0].startswith(coltype) or colorNames[colx][0].contains(coltype):
               ts.add(colorNames[colx][1])
         if m > colPaletteLen(coltype): m = 0
         ts[m]
 
 
template colorsPalette*(coltype:string): auto =
         ## ::
         ##   colPalette
         ## 
         ##   returns a colorpalette which can be used to iterate over
         ##    
         ##.. code-block:: nim
         ##    import nimcx
         ##    let z = "The big money waits in the bank" 
         ##    printLn(z,colPalette("pastel",getRndInt(0,colPaletteLen("pastel") - 1)),black)
         ##    rainbow2(z & "\n",centered = false,colorset = colorsPalette("medium"))
         ##    rainbow2("what's up ?\n",centered = true,colorset = colorsPalette("light"))
         ##    doFinish()
         ##    
         ##    
               
         var pal = newseq[(string,string)]()         
         for colx in 0..<colorNames.len:
            if colorNames[colx][0].startswith(coltype) or colorNames[colx][0].contains(coltype):
              pal.add((colorNames[colx][0],colorNames[colx][1]))
              
         if pal.len < 1:
           printLn("Error : colorsPalette",red)
           printLn("Desired filter may not be available",red)
           printLn("        Try:  medium , dark, light, blue, yellow etc.",red)  
           doFinish()   
         pal
  
 
 
template colPaletteName*(coltype:string,n:int): auto =
         ## ::
         ##
         ## returns the actual name of the palette entry n
         ## eg. "mediumslateblue"
         ## see example at colPalette
         ##
         var ts = newseq[string]()  
         # build the custom palette ts       
         for colx in 0..<colorNames.len:
            if colorNames[colx][0].startswith(coltype) or colorNames[colx][0].contains(coltype):
              ts.add(colorNames[colx][0])
         
         # simple error handling to avoid indexerrors if n too large we try 0
         # if this fails too something will error out
         var m = n
         if m > colPaletteLen(coltype): m = 0
         ts[m] 
 

template aPaletteSample*(coltype:string):int = 
     ## aPaletteSample
     ## 
     ##  returns an rand entry (int) from a palette
     ##  see example at colPalette
     ## 
     var coltypen = coltype.toLowerAscii()
     var b = newSeq[int]()
     for x in 0..<colPaletteLen(coltypen): b.add(x)
     rand(b)   #rndSample
     

template randCol2*(coltype:string): auto =
         ## ::
         ##   randCol2    -- experimental
         ##   
         ##   returns a rand color based on a palette
         ##   
         ##   palettes are filters into colorNames
         ##   
         ##   coltype examples : "red","blue","medium","dark","light","pastel" etc..
         ##   
         ##.. code-block:: nim
         ##    loopy(0..5,printLn("Random blue shades",randcol2("blue")))
         ##
         ##   
         var coltypen = coltype.toLowerAscii()
         if coltypen == "black":      # no black
            coltypen = "darkgray"
         var ts = newSeq[string]()         
         for x in 0..<colorNames.len:
            if colorNames[x][0].startswith(coltypen) or colorNames[x][0].contains(coltypen):
               ts.add(colorNames[x][1])
         if ts.len == 0: ts.add(colorNames[getRndInt(0,colorNames.len - 1)][1]) # incase of no suitable string we return standard randcol     
         ts[rand(colPaletteIndexer(ts))]  #rndsample
         

template randCol*(): string = rand(colorNames)[1]
   ## randCol
   ##
   ## get a randcolor from colorNames , no filter is applied 
   ##
   ##.. code-block:: nim
   ##    # print a string 6 times in a rand color selected from colorNames
   ##    loopy(0..5,printLn("Hello Random Color",randCol()))
   ##
   ##


template rndCol*(r:int = getRndInt(0,254) ,g:int = getRndInt(0,254), b:int = getRndInt(0,254)) :string = "\x1b[38;2;" & $r & ";" & $b & ";" & $g & "m"
    ## rndCol
    ## 
    ## return a randcolor from the whole rgb spectrum in the ranges of RGB [0..254]
    ## expect this colors maybe a bit more drab than the colors returned from randCol()
    ## 
    ##.. code-block:: nim
    ##    # print a string 6 times in a rand color selected from rgb spectrum
    ##    loopy(0..5,printLn("Hello Random Color",rndCol()))
    ##
    ##
    
   
template randPastelCol*: string = rand(pastelset)
   ## randPastelCol
   ##
   ## get a randcolor from pastelSet
   ##
   ##.. code-block:: nim
   ##    # print a string 6 times in a rand color selected from pastelSet
   ##    loopy(0..5,printLn("Hello Random Color",randPastelCol()))
   ##
   ##
 

# procs lifted from an early version of terminal.nim as they are currently not exported from there
proc styledEchoProcessArg(s: string) = write stdout, s
proc styledEchoProcessArg(style: Style) = setStyle({style})
proc styledEchoProcessArg(style: set[Style]) = setStyle style
proc styledEchoProcessArg(color: ForegroundColor) = setForegroundColor color
proc styledEchoProcessArg(color: BackgroundColor) = setBackgroundColor color


# macros

macro styledEchoPrint*(m: varargs[untyped]): typed =
  ## partially lifted from an earler macro in terminal.nim and removed new line
  ## currently used in print
  ##
  let m = callsite()
  result = newNimNode(nnkStmtList)

  for i in countup(1, m.len - 1):
      result.add(newCall(bindSym"styledEchoProcessArg", m[i]))

  result.add(newCall(bindSym"write", bindSym"stdout", newStrLitNode("")))
  result.add(newCall(bindSym"resetAttributes"))


# templates

template upperCase*(s:string):string = toUpperAscii(s)
  ## upperCase
  ## 
  ## upper cases a string
  ## 

template lowerCase*(s:string):string = toLowerAscii(s)
  ## lowerCase
  ## 
  ## lower cases a string
  ## 

template currentLine* = 
   ## currentLine
   ## 
   ## simple template to return line number , maybe usefull for debugging 
   print("[",truetomato)
   print(rightarrow,dodgerblue)
   var pos:tuple[filename: string, line: int] = ( "",  -1)
   pos = instantiationInfo()
   printBiCol(pos.filename & "  ln:" & $(pos.line),yellow,white,":",0,false,{})
   curBk(1)
   print("]",truetomato)
   echo()



template hdx*(code:typed,frm:string = "+",width:int = tw,nxpos:int = 0):typed =
   ## hdx
   ##
   ## a simple sandwich frame made with + default or any string passed in
   ##
   ## width and xpos can be adjusted
   ##
   ##.. code-block:: nim
   ##    hdx(printLn("Nice things happen randly",yellowgreen,xpos = 9),width = 35,nxpos = 5)
   ##
   var xpos = nxpos
   var lx = repeat(frm,width div frm.len)
   printLn(lx,xpos = xpos)
   cursetx(xpos + 2)
   code
   printLn(lx,xpos = xpos)
   echo()
   

proc isBlank*(val:string):bool {.inline.} =
   ## isBlank
   ## 
   ## returns true if a string is blank
   ## 
   return val == nil or val == ""


proc isEmpty*(val:string):bool {.inline.} =
   ## isEmpty
   ## 
   ## returns true if a string is empty if spaces are removed
   ## 

   return isNil(val) or val.strip() == ""


proc getRandomSignI*(): int = 
    ## getRandomSignI
    ## 
    ## returns -1 or 1 integer  to have a rand positive or negative multiplier
    ##  
    result = 1
    if 0 == getRndInt(0,1):  result = -1
   

    
proc getRandomSignF*():float = 
    ## getRandomSignF
    ## 
    ## returns -1.0 or 1.0 float  to have a rand positive or negative multiplier
    ##  
    result = 1.0
    if 0 == getRndInt(0,1) : result = -1.0   
    
       


proc fmtengine[T](a:string,astring:T):string =
     ## fmtengine - used internally
     ## ::
     ##   simple string formater to right or left align within given param
     ##   also can take care of floating point precision
     ##   called by fmtx to process alignment requests
     ##
     var okstring = $astring
     var op  = ""
     var dg  = "0"
     var pad = okstring.len
     var dotflag = false
     var textflag = false
     var df = ""

     if a.startswith("<") or a.startswith(">"):
           textflag = false
     elif isdigit($a[0]):
           textflag = false
     else: textflag = true

     for x in a:

        if isDigit(x) and dotflag == false:
             dg = dg & $x

        elif isDigit(x) and dotflag == true:
             df = df & $x

        elif $x == "<" or $x == ">" :
                op = op & x
        else:
            # we got a char to print so add it to the okstring
            if textflag == true and dotflag == false:
               okstring = okstring & $x

        if $x == ".":
              # a float wants to be formatted
              dotflag = true

     pad = parseInt(dg)

     if dotflag == true and textflag == false:
               # floats should now be shown with thousand seperator
               # like 1,234.56  instead of 1234.56
               
               # if df is nil we make it zero so no valueerror occurs
               if df.strip(true,true).len == 0: df = "0"
               # in case of any edge cases throwing an error  
               try:
                  okstring = ff2(parseFloat(okstring),parseInt(df))       
               except ValueError:   
                  printLn("Error , invalid format string dedected.",red)
                  printLn("Showing exception thrown : ",peru)
                  echo()
                  raise            

     var alx = spaces(max(0,pad - okstring.len))

     case op
       of "<"  :   okstring = okstring & alx 
       of ">"  :   okstring = alx & okstring
       else: discard

     # this cuts the okstring to size for display , not wider than dg parameter passed in
     # if the format string is "" no op no width than this will not be attempted
     if okstring.len > parseInt(dg) and parseInt(dg) > 0:
        var dps = ""
        for x in 0..<parseInt(dg):  
            dps = dps & okstring[x]
        okstring = dps
     result = okstring



proc fmtx*[T](fmts:openarray[string],fstrings:varargs[T,`$`]):string =
     ## fmtx
     ## 
     ## ::
     ##   simple format utility similar to strfmt to accommodate our needs
     ##   implemented :  right or left align within given param and float precision
     ##   returns a string and seems to work fine with strformat 
     ##
     ##   Some observations:
     ##
     ##   If text starts with a digit it must be on the right side...
     ##   Function calls must be executed on the right side
     ##
     ##   Space adjustment can be done with any "" on left or right side
     ##   an assert error is thrown if format block left and data block right are imbalanced
     ##   the "" acts as suitable placeholder
     ##
     ##   If one of the operator chars are needed as a first char in some text put it on the right side
     ##
     ##   Operator chars : <  >  .
     ##
     ##   <12  means align left and pad so that max length = 12 and any following char will be in position 13
     ##   >12  means align right so that the most right char is in position 12
     ##   >8.2 means align a float right so that most right char is position 8 with precision 2
     ##
     ##   Note that thousand separators are counted as position so 123456 needs 
     ##   echo fmtx(["<10.2"],123456)    --->  123,456.00
     ## 
     ## 
     ##
     ## Examples :
     ##
     ##.. code-block:: nim
     ##    import nimcx
     ##    echo fmtx(["","","<8.3",""," High : ","<8","","","","","","","",""],lime,"Open : ",unquote("1234.5986"),yellow,"",3456.67,red,showRune("FFEC"),white," Change:",unquote("-1.34 - 0.45%"),"  Range : ",lime,@[123,456,789])
     ##    echo fmtx(["","<18",":",">15","","",">8.2"],salmon,"nice something",steelblue,123,spaces(5),yellow,456.12345676)
     ##    echo()
     ##    showRuler()
     ##    for x in 0.. 10: printlnBiCol(fmtx([">22",">10"],"nice something :",x ))
     ##    echo()
     ##    printLnBiCol(fmtx(["",">15.3f"],"Result : ",123.456789),lime,red,":",0,false,{})  # formats the float to a string with precision 3 the f is not necessary
     ##    echo()
     ##    echo fmtx([">22.3"],234.43324234)  # this formats float and aligns last char to pos 22
     ##    echo fmtx(["22.3"],234.43324234)   # this formats float but ignores position as no align operator given
     ##    printLnBiCol(fmtx([">15." & $getRndInt(2,4),":",">10"],getRndFloat() * float(getRndInt(50000,500000)),spaces(5),getRndInt(12222,10000000)))
     ##
     
     var okresult = ""
     # if formatstrings count not same as vararg count we bail out some error about fmts will be shown
     doassert(fmts.len == fstrings.len)
     # now iterate and generate the desired output
     for cc in 0..<fmts.len:
         okresult = okresult & fmtengine(fmts[cc],fstrings[cc])
     result = okresult

     
     
proc showRune*(s:string) : string {.discardable.} =
     ## showRune
     ## ::
     ##   utility proc to show a single unicode char given in hex representation
     ##   note that not all unicode chars may be available on all systems
     ##
     ## Example
     ## 
     ##.. code-block :: nim
     ##      for x in 10.. 55203: printLnBiCol($x & " : " & showRune(toHex(x)))
     ##      print(showRune("FFEA"),lime)
     ##      print(showRune("FFEC"),red)
     ##
     ##
     result = $Rune(parseHexInt(s))
     
     


proc unquote*(s:string):string =
      ## unquote
      ##
      ## remove any double quotes from a string
      ##
      result = s.multiReplace(($'"',""))
      

proc cleanScreen*() =
      ## cleanScreen
      ##
      ## very fast clear screen proc with escape seqs
      ##
      ## similar to terminal.eraseScreen() but cleans the terminal window more completely at times
      ##
      write(stdout,"\e[H\e[J")



proc centerX*() : int = tw div 2
     ## centerX
     ##
     ## returns an int with terminal center position
     ##
     ##

proc centerPos*(astring:string) =
     ## centerpos
     ##
     ## tries to move cursor so that string is centered when printing
     ##
     ##.. code-block:: nim
     ##    var s = "Hello I am centered"
     ##    centerPos(s)
     ##    printLn(s,gray)
     ##
     ##
     setCursorXPos(stdout,centerX() - astring.len div 2 - 1)



proc checkColor*(colname: string): bool =
     ## checkColor
     ##
     ## returns true if colname is a known color name in colorNames
     ## string and 
     ##
     result = false
     for x in  colorNames:
          if x[0] == colname or x[1] == colname:
             result = true
     

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
    ##    print("The end never comes on time ! ",pastelBlue,styled = {styleReverse})
    ##    print("whats up with truecolors now ? ",cxTrueCol[34567],bgRed,xpos = 10styled={})
    ##    echo()
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
                        #else: styledEchoPrint(fgr,styled,substr,termwhite) # orig
                        else: styledEchoPrint(fgr,styled,substr,bgr)
            else:
                case fgr
                        of clrainbow   : printRainbow($s,styled)
                        #else: styledEchoPrint(fgr,styled,s,termwhite)
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

           
proc cxPrint*[T](ss    :T,
             fontcolor : string = "colWhite",
             bgr       : string = black,
             xpos      : int = 1,
             styled    : set[Style] = {styleReverse})  =
             
      ## cxPrint     
      ## 
      ## Experimental
      ## 
      ## truecolor print function
      ## 
      ## see cxtruecolE1.nim  for example usage
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
      ## larger color palettes can be generated with getcxTrueColorSet() 
      ## all palette colors in cxTrueColorSet can be shown with showCxTrueColorPalette()  
      ## Backgroundcolors can also be drawn from the colorNames seq  specified in cxconsts.nim
      ## 
      ## Example to specify a Backgroundcolor :
      ##  
      ##  a) a random background color from cxTrueColor palette :  bgr = rndtruecol2() 
      ##  b) a color from the cxTrueColor palette               :  bgr = cxTrueCol[65451])
      ##  c) a specified color from colorNames seq              :  bgr = darkgreen
      
      var s = $ss  
   
      for xbgr in  0..<txCol.len:
          if cxcolornames[xbgr][0] == toLowerAscii(fontcolor):   # as we are doing styleReverse we set it as backgroundcolor 
             setBackgroundColor cxcolornames[xbgr][1]
              
      print(s,fgr = bgr,xpos = xpos,styled=styled) 
      
proc cxPrintLn*[T](ss       : T,
                   fontcolor: string = "colWhite",
                   bgr      : string = black,
                   xpos     : int = 1,
                   styled   : set[Style] = {styleReverse}) =
      ## cxPrintLn
      ## 
      ## truecolor printLn function
      ##           
      ## see cxtruecolE1.nim  for example usage
      ## 
      
      let s = $ss
      for xbgr in  0..<txCol.len:
         if cxcolornames[xbgr][0] == toLowerAscii(fontcolor):
            setBackgroundColor cxcolornames[xbgr][1]
      printLn(s,fgr = bgr,xpos = xpos,styled=styled) 
      
 
proc cxPrint*[T](ss       : T,
                 fontcolor: auto = colWhite,
                 bgr      : string = black,
                 xpos     : int = 1,
                 styled   : set[Style] = {styleReverse}) =
      ## cxPrint
      ## 
      ## Experimental
      ## 
      ## truecolor print function
      ##             
      ## see cxtruecolE1.nim  for example usage
      ## 
      
      let s = $ss
      setBackgroundColor fontcolor
      print(s,fgr = bgr,xpos = xpos,styled=styled)  
      
proc cxPrintLn*[T](ss       : T,
                   fontcolor: auto = colWhite,
                   bgr      : string = "colBlack",
                   xpos     : int = 1,
                   styled   : set[Style] = {styleReverse}) =

      ## cxPrintLn
      ##
      ## 
      ## Experimental
      ## 
      ## truecolor printLn function
      ##     
      ## see cxtruecolE1.nim  for example usage
      ## 
      
      let s = $ss
      setBackgroundColor fontcolor
      printLn(s,fgr = bgr,xpos = xpos,styled=styled)  
            
       

proc print2*[T](astring:T,fgr:string = termwhite,xpos:int = 0,fitLine:bool = false ,centered:bool = false,styled : set[Style]= {},substr:string = "") =
 
    ## ::
    ##   print2
    ## 
    ##   the old print routine with backgroundcolor set to black only  , required by printfont proc
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
    ##    print("The end never comes on time ! ",pastelBlue,styled = {styleReverse})
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
                        #else: styledEchoPrint(fgr,styled,substr,termwhite) # orig
                        else: styledEchoPrint(fgr,styled,substr,bgBlack)
            else:
                case fgr
                        of clrainbow   : printRainbow($s,styled)
                        #else: styledEchoPrint(fgr,styled,s,termwhite)
                        else: styledEchoPrint(fgr,styled,s,bgBlack)
        else:
        
            case fgr
            of clrainbow: rainbow(spaces(1) & $astring,npos)
            else: 
                setBackGroundColor(bgBlack)
                try:
                    #write(stdout,fgr & $astring)
                    styledEchoPrint(fgr,{},$astring,bgBlack)
                except:
                    echo astring

        # reset to white/black only if any changes
        #if fgr != $fgWhite or bgr != bgBlack:
        setForeGroundColor(fgWhite)
        setBackGroundColor(bgBlack)
           
           


proc print*[T](ss:varargs[T,`$`],
           fgr : string = termwhite ,
           bgr : BackgroundColor = bgBlack,
           xpos: int = 0,
           sep : string = spaces(1)) =
           
   ## print
   ## 
   ## a print routine which allows printing of varargs in desired color , position and separator
   ## 
   ## no newline is added
   ## 
   ## sep must not be wider than 1 , if it is wider the comma will be used as default otherwise default will be 1 space
   ## 
   ##.. code-block:: nim
   ##    import nimcx
   ##    
   ##    print("TEST VARARGS : ",createSeqint(20).sampleSeq(8,13),getRndInt(10000,12000),createSeqint(3),newword(6,10),ff2(getRndfloat(),4),$(hiragana().sampleSeq(8,13)),randcol(),bblack,0,"") 
   ##    echo()
   ##    
   ##    
   var ssep = sep
   if ssep.len > 1:
      ssep = ","
   var oldxlen = 0
   for x in 0..<ss.len:
      if x == ss.len - 1:
         print(ss[x],fgr,bgr,xpos = xpos + oldxlen)
      else:
         print(ss[x] & ssep,fgr,bgr,xpos = xpos + oldxlen)
      oldxlen =  oldxlen + ss[x].len + 1
                

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
    ##   original with bgr:string
    ##   
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
    ##   Colornames supported for background color:
    ##  
    ##     - white,red,green,blue,yellow,cyan,magenta,black 
    ##     - brightwhite,brightred,brightgreen,brightblue,brightyellow,
    ##     - brightcyan,brightmagenta,brightblack
    ##
    ## Examples
    ##
    ##.. code-block:: nim
    ##    import nimcx
    ##    printLn("Yes ,  we made it.",clrainbow,brightyellow) # background has no effect with font in  clrainbow
    ##    printLn("Yes ,  we made it.",green,brightyellow)
    ##    # or use it as a replacement of echo
    ##    printLn(red & "What's up ? " & green & "Grub's up ! "
    ##    printLn("No need to reset the original color")
    ##    printLn("Nim does it again",peru,centered = true ,styled = {styleDim,styleUnderscore},substr = "i")
    ##    # To achieve colored text with styleReverse try:
    ##    loopy2(0,30):
    ##        printLn("The end never comes on time ! ",randcol(),bRed,styled = {styleReverse})
    ##        sleepy(0.5)
    ##
    print2($(astring) & "\L",fgr,xpos,fitLine,centered,styled,substr)
    

proc printLn*[T](astring:T,fgr:string = termwhite , bgr:BackgroundColor,xpos:int = 0,fitLine:bool = false,centered:bool = false,styled : set[Style]= {},substr:string = "") =
    ## :: 
    ##   printLn
    ## 
    ##   with bgr:setBackGroundColor
    ##
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
    ##    printLn("Yes ,  we made it.",clrainbow,brightyellow) # background has no effect with font in  clrainbow
    ##    printLn("Yes ,  we made it.",green,brightyellow)
    ##    # or use it as a replacement of echo
    ##    printLn(red & "What's up ? " & green & "Grub's up ! "
    ##    printLn("No need to reset the original color")
    ##    printLn("Nim does it again",peru,centered = true ,styled = {styleDim,styleUnderscore},substr = "i")
    ##

    print($(astring) & "\L",fgr,bgr,xpos,fitLine,centered,styled,substr)
    print cleareol


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
    
  
 
proc rainbow*[T](s : T,xpos:int = 1,fitLine:bool = false,centered:bool = false)  =
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
       c = aseq[getRndInt(ma=aseq.len)]
       if centered == false:
          print(astr[x],colorNames[c][1],bgblack,xpos = nxpos,fitLine)
       else:
          # need to calc the center here and increment by x
          nxpos = centerX() - ($astr).len div 2  + x - 1
          print(astr[x],colorNames[c][1],bgblack,xpos=nxpos,fitLine)
       inc nxpos



# output  horizontal lines
proc hline*(n:int = tw,col:string = white,xpos:int = 1,lt:string = "-"):string {.discardable.} =
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
     result = lt * n     # new we return the line string without color and pos formating in case needed


proc hlineLn*(n:int = tw,col:string = white,xpos:int = 1,lt:string = "-"):string {.discardable.} =
     ## hlineLn
     ##
     ## draw a full line in stated length and color a linefeed will be issued
     ##
     ## defaults full terminal width and white
     ##
     ##.. code-block:: nim
     ##    hlineLn(30,green)
     ##
     result = hline(n,col,xpos,lt) & "/n"
     



proc dline*(n:int = tw,lt:string = "-",col:string = termwhite) =
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
     if lt.len <= n: print(lt * (n div lt.len))


proc dlineLn*(n:int = tw,lt:string = "-",col:string = termwhite) =
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
     if lt.len <= n: print(lt * (n div lt.len))
     writeLine(stdout,"")


proc decho*(z:int = 1)  =
    ## decho
    ##
    ## blank lines creator
    ##
    ##.. code-block:: nim
    ##    decho(10)
    ## to create 10 blank lines
    for x in 0..<z: writeLine(stdout,"")


# simple navigation mostly mirrors terminal.nim functions

template curUp*(x:int = 1) =
     ## curUp
     ##
     ## mirrors terminal cursorUp
     cursorUp(stdout,x)


template curDn*(x:int = 1) =
     ## curDn
     ##
     ## mirrors terminal cursorDown
     cursorDown(stdout,x)


template curBk*(x:int = 1) =
     ## curBkn
     ##
     ## mirrors terminal cursorBackward
     cursorBackward(stdout,x)


template curFw*(x:int = 1) =
     ## curFw
     ##
     ## mirrors terminal cursorForward
     cursorForward(stdout,x)


template curSetx*(x:int) =
     ## curSetx
     ##
     ## mirrors terminal setCursorXPos
     setCursorXPos(stdout,x)


template curSet*(x:int = 0,y:int = 0) =
     ## curSet
     ##
     ## mirrors terminal setCursorPos
     ##
     ##
     setCursorPos(x,y)


template clearup*(x:int = 80) =
     ## clearup
     ##
     ## a convenience proc to clear monitor x rows
     ##
     erasescreen(stdout)
     curup(x)


proc curMove*(up:int=0,dn:int=0,fw:int=0,bk:int=0) =
     ## curMove
     ##
     ## conveniently move the cursor to where you need it
     ##
     ## relative of current postion , which you app need to track itself
     ##
     ## setting cursor off terminal will wrap output to next line
     ##
     curup(up)
     curdn(dn)
     curfw(fw)
     curbk(bk)

proc sleepy*[T:float|int](secs:T) =
  ## sleepy
  ##
  ## imitates sleep but in seconds
  ## suitable for shorter sleeps
  ##
  var milsecs = (secs * 1000).int
  sleep(milsecs)

# Var. convenience procs for colorised data output
# these procs have similar functionality


proc printRainbow*(s : string,styled:set[Style] = {}) =
    ## printRainbow
    ##
    ##
    ## print multicolored string with styles , for available styles see print
    ##
    ## may not work with certain Rune
    ##
    ##.. code-block:: nim
    ##    printRainBow("WoW So Nice",{styleUnderScore})
    ##    printRainBow("  --> No Style",{})
    ##

    var astr = s
    var c = 0
    for x in 0..<astr.len:
        c = rxcol[getRndInt(ma=rxcol.len)]
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
    ##    printLnRainBow("WoW So Nice",{styleUnderScore})
    ##    printLnRainBow("Aha --> No Style",{})
    ##
    printRainBow($(s) & "\L",styled)


proc printBiCol*[T](s:varargs[T,`$`], colLeft:string = yellowgreen, colRight:string = termwhite,sep:string = ":",xpos:int = 0,centered:bool = false,styled : set[Style]= {}) =
     ## printBiCol
     ##
     ## Notes see printLnBiCol
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
     ## changes to prev. versions:
     ## sep moved to behind colors in parameter ordering
     ## and input can be varargs which gives much better flexibility
     ## if varargs are to be printed all parameters need to be specified.
     ##
     ## default seperator = ":"  if not found we execute printLn with available params
     ##
     ##.. code-block:: nim
     ##    import nimcx
     ##
     ##    for x  in 0..<3:
     ##       # here our input is varargs so weneed to specify all params
     ##        printLnBiCol("Test $1  : Ok " % $1,"this was $1 : what" % $2,23456.789,red,lime,":",0,false,{})
     
     ##    for x  in 4..<6:
     ##        # here we change the default colors
     ##        printLnBiCol("nice",123,":","check",@[1,2,3],cyan,lime,":",0,false,{})
     ##
     ##    # usage with fmtx 
     ##    printLnBiCol(fmtx(["","",">4"],"Good Idea : "," Number",50),yellow,randcol(),":",0,false,{})
     ##    printLnBiCol(fmtx(["","",">4"],"Good Idea : "," Number",50),colLeft = cyan)
     ##    printLnBiCol(fmtx(["","",">4"],"Good Idea : "," Number",50),colLeft=yellow,colRight=randcol())
     ##    printLnBiCol(fmtx(["","",">4"],"Good Idea : "," Number",50),123,colLeft = cyan,colRight=gold,sep=":",xpos=0,centered=false,styled={})
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
      for x in rx.low.. rx.high:
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


proc cechoLn*(col    : string,
              astring: varargs[string, `$`] = @[""] )  =
              
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
     ## prints a horizontal or vertical line for frames with text as specified in an Cxline object
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
            print(aline.textbracketopen,aline.textbracketcolor,xpos = xpos + aline.textpos)  
            rdotpos = rdotpos + 1
            print(aline.text,aline.textcolor,styled=aline.textstyle)
            print(aline.textbracketclose,aline.textbracketcolor)
            rdotpos = rdotpos + 1
            print("." & aline.newline,aline.dotrightcolor,xpos = rdotpos - 3)
            
               
       else:
       
           printLnBiCol("Error  : Wrong linetype specified ",red,black,":",xpos = 3,false,{})
           quit(1)
      
      
      
      
proc showColors*() =
  ## showColors
  ##
  ## display all colorNames in color !
  ##
  for x in colorNames:
     print(fmtx(["<22"],x[0]) & spaces(2) & "▒".repeat(10) & spaces(2) & "⌘".repeat(10) & spaces(2) & "ABCD abcd 1234567890 --> " & " Nim Colors  " , x[1],bgBlack)
     printLn(fmtx(["<23"],"  " & x[0]) ,x[1],styled = {styleReverse},substr =  fmtx(["<23"],"  " & x[0]))
     sleepy(0.015)
  decho(2)



macro dotColors*(): untyped =
  ## dotColors
  ## 
  ## another way to show all colors
  ##  
  result = parseStmt"""for x in colornames : printLn(widedot & x[0],x[1])"""



proc doty*(d:int,fgr:string = white, bgr:BackgroundColor = bgBlack,xpos:int = 1) =
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
     ##      dotyLn(18 ,salmon,blue)
     ##      dotyLn(centerX(),red)  # full widedotted line
     ##
     ## color clrainbow is not supported and will be in white
     ##

     let astr = $(wideDot.repeat(d))
     if fgr == clrainbow: print(astring = astr,white,bgr,xpos)
     else: print(astring = astr,fgr,bgr,xpos)


proc dotyLn*(d:int,fgr:string = white, bgr:BackgroundColor = bgBlack,xpos:int = 1) =
     ## dotyLn
     ##
     ## prints number d of widedot ⏺  style dots in given fore/background color and issues new line
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



proc printDotPos*(xpos:int,dotCol:string,blink:bool) =
      ## printDotPos
      ##
      ## prints a widedot at xpos in col dotCol and may blink...
      ##

      curSetx(xpos)
      if blink == true: print(wideDot,dotCol,styled = {styleBlink},substr = wideDot)
      else: print(wideDot,dotCol,styled = {},substr = wideDot)


proc drawRect*(h:int = 0 ,w:int = 3, frhLine:string = "_", frVLine:string = "|",frCol:string = darkgreen,dotCol = truetomato,xpos:int = 1,blink:bool = false) =
      ## drawRect
      ##
      ## a simple proc to draw a rectangle with corners marked with widedots.
      ## widedots are of len 4.
      ##
      ##
      ## h  height
      ## w  width
      ## frhLine framechar horizontal
      ## frVLine framechar vertical
      ## frCol   color of line
      ## dotCol  color of corner dotCol
      ## xpos    topleft start position
      ## blink   true or false to blink the dots
      ##
      ##
      ##.. code-block:: nim
      ##    import nimcx
      ##    clearUp(18)
      ##    curSet()
      ##    drawRect(15,24,frhLine = "+",frvLine = wideDot , frCol = randCol(),xpos = 8)
      ##    curup(12)
      ##    drawRect(9,20,frhLine = "=",frvLine = wideDot , frCol = randCol(),xpos = 10,blink = true)
      ##    curup(12)
      ##    drawRect(9,20,frhLine = "=",frvLine = wideDot , frCol = randCol(),xpos = 35,blink = true)
      ##    curup(10)
      ##    drawRect(6,14,frhLine = "~",frvLine = "$" , frCol = randCol(),xpos = 70,blink = true)
      ##    decho(5)
      ##    doFinish()
      ##
      ##

      # topline
      printDotPos(xpos,dotCol,blink)
      print(frhLine.repeat(w - 3),frcol)
      if frhLine == widedot: printDotPos(xpos + w * 2 - 1 ,dotCol,blink)
      else: printDotPos(xpos + w,dotCol,blink)
      writeLine(stdout,"")
      # sidelines
      for x in 2.. h:
         print(frVLine,frcol,xpos = xpos)
         if frhLine == widedot: print(frVLine,frcol,xpos = xpos + w * 2 - 1)
         else: print(frVLine,frcol,xpos = xpos + w)
         writeLine(stdout,"")
      # bottom line
      printDotPos(xpos,dotCol,blink)
      print(frhLine.repeat(w - 3),frcol)
      if frhLine == widedot:printDotPos(xpos + w * 2 - 1 ,dotCol,blink)
      else: printDotPos(xpos + w,dotCol,blink)

      writeLine(stdout,"")


# Var. date and time handling procs mainly to provide convenience for
# date format yyyy-MM-dd handling

proc validdate*(adate:string):bool =
      ## validdate
      ##
      ## try to ensure correct dates of form yyyy-MM-dd
      ##
      ## correct : 2015-08-15
      ##
      ## wrong   : 2015-08-32 , 201508-15, 2015-13-10 etc.
      ##
      let m30 = @["04","06","09","11"]
      let m31 = @["01","03","05","07","08","10","12"]
      let xdate = parseInt(aDate.multiReplace(("-","")))
      # check 1 is our date between 1900 - 3000
      if xdate >= 19000101 and xdate < 30010101:
          let spdate = aDate.split("-")
          if parseInt(spdate[0]) >= 1900 and parseInt(spdate[0]) <= 3001:
              if spdate[1] in m30:
                  #  day max 30
                  if parseInt(spdate[2]) > 0 and parseInt(spdate[2]) < 31:
                    result = true
                  else:
                    result = false

              elif spdate[1] in m31:
                  # day max 31
                  if parseInt(spdate[2]) > 0 and parseInt(spdate[2]) < 32:
                    result = true
                  else:
                    result = false

              else:
                    # so its february
                    if spdate[1] == "02" :
                        # check leapyear
                        if isleapyear(parseInt(spdate[0])) == true:
                            if parseInt(spdate[2]) > 0 and parseInt(spdate[2]) < 30:
                              result = true
                            else:
                              result = false
                        else:
                            if parseInt(spdate[2]) > 0 and parseInt(spdate[2]) < 29:
                              result = true
                            else:
                              result = false


proc day*(aDate:string) : string =
   ## day,month year extracts the relevant part from
   ##
   ## a date string of format yyyy-MM-dd
   ##
   aDate.split("-")[2]

proc month*(aDate:string) : string =
    var asdm = $(parseInt(aDate.split("-")[1]))
    if len(asdm) < 2: asdm = "0" & asdm
    result = asdm


proc year*(aDate:string) : string = aDate.split("-")[0]
     ## Format yyyy

# 
# proc intervalsecs*(startDate,endDate:string) : float =
#       ## interval procs returns time elapsed between two dates in secs,hours etc.
#       #  since all interval routines call intervalsecs error message display also here
#       #
#       if validdate(startDate) and validdate(endDate):
#           var f     = "yyyy-MM-dd"
#           result = toSeconds(toTime(endDate.parse(f)))  - toSeconds(toTime(startDate.parse(f)))
#       else:
#           printLn("Error: " &  startDate & "/" & endDate & " --> Format yyyy-MM-dd required",red)
#           #result = -0.0
#           
# 
# proc intervalmins*(startDate,endDate:string) : float =
#            result = intervalsecs(startDate,endDate) / 60
#           
# 
# proc intervalhours*(startDate,endDate:string) : float =
#          result = intervalsecs(startDate,endDate) / 3600
#         
# proc intervaldays*(startDate,endDate:string) : float =
#           result = intervalsecs(startDate,endDate) / 3600 / 24
#           
# proc intervalweeks*(startDate,endDate:string) : float =
#           result = intervalsecs(startDate,endDate) / 3600 / 24 / 7
#           
# proc intervalmonths*(startDate,endDate:string) : float =
#           result = intervalsecs(startDate,endDate) / 3600 / 24 / 365  * 12
#           
# proc intervalyears*(startDate,endDate:string) : float =
#           result = intervalsecs(startDate,endDate) / 3600 / 24 / 365
          
proc compareDates*(startDate,endDate:string) : int =
     # dates must be in form yyyy-MM-dd
     # we want this to answer
     # s == e   ==> 0
     # s >= e   ==> 1
     # s <= e   ==> 2
     # -1 undefined , invalid s date
     # -2 undefined . invalid e and or s date
     if validdate(startDate) and validdate(enddate):
        let std = startDate.multiReplace(("-",""))
        let edd = endDate.multiReplace(("-",""))
        if std == edd: 
          result = 0
        elif std >= edd:
          result = 1
        elif std <= edd:
          result = 2
        else:
          result = -1
     else:
          result = -2




proc fx(nx:DateTime):string =
        result = nx.format("yyyy-MM-dd")


proc plusDays*(aDate:string,days:int):string =
   ## plusDays
   ##
   ## adds days to date string of format yyyy-MM-dd  or result of getDateStr()  or today()
   ##
   ## and returns a string of format yyyy-MM-dd
   ##
   ## the passed in date string must be a valid date or an error message will be returned
   ##
   if validdate(aDate) == true:
      var rxs = ""
      let tifo = parse(aDate,"yyyy-MM-dd") # this returns a DateTime type
      var myinterval = initInterval()
      myinterval.days = days
      rxs = fx(tifo + myinterval)
      result = rxs
   else:
      cechoLn(red,"Date error : ",aDate)
      result = "Error"


proc minusDays*(aDate:string,days:int):string =
   ## minusDays
   ##
   ## subtracts days from a date string of format yyyy-MM-dd  or result of getDateStr() or today()
   ##
   ## and returns a string of format yyyy-MM-dd
   ##
   ## the passed in date string must be a valid date or an error message will be returned
   ##

   if validdate(aDate) == true:
      var rxs = ""
      let tifo = parse(aDate,"yyyy-MM-dd") # this returns a DateTime type
      var myinterval = initInterval()
      myinterval.days = days
      rxs = fx(tifo - myinterval)
      result = rxs
   else:
      cechoLn(red,"Date error : ",aDate)
      result = "Error"



proc createSeqDate*(fromDate:string,toDate:string):seq[string] = 
     ## createSeqDate
     ## 
     ## creates a seq of dates in format yyyy-MM-dd 
     ## 
     ## from fromDate to toDate
     ##  

     var aresult = newSeq[string]()
     var aDate = fromDate
     while compareDates(aDate,toDate) == 2 : 
         if validDate(aDate) == true: 
            aresult.add(aDate)
         aDate = plusDays(aDate,1)  
     result = aresult    
         
     

  
proc cxTimeZone*(amode:string = "long"):string = 
   ## cxTimeZone
   ##
   ## returns a string with the actual timezone offset in hours as seen from UTC 
   ## 
   ## default long gives results parsed from getLocalTime 
   ## like : UTC +08:00
   ##
  
   var mode = amode
   var okmodes = @["long","short"]
   if mode in okmodes == false:
      mode = "long"
   
   if mode == "long":
        var ltt = $now()
        result = "UTC" & $ltt[(($ltt).len - 6)..($ltt).len]     
            

proc createSeqDate*(fromDate:string,days:int = 1):seq[string] = 
     ## createSeqDate
     ## 
     ## creates a seq of dates in format yyyy-MM-dd 
     ## 
     ## from fromDate to fromDate + days
     ## 
     var aresult = newSeq[string]()
     var aDate = fromDate
     var toDate = plusDays(adate,days)
     while compareDates(aDate,toDate) == 2 : 
         if validDate(aDate) == true: 
            aresult.add(aDate)
         aDate = plusDays(aDate,1)  
     result = aresult    
         

proc getRndDate*(minyear:int = parseint(year(cxtoday)) - 50,maxyear:int = parseint(year(cxtoday)) + 50):string =  
         ## getRndDate
         ## 
         ## returns a valid rand date between 1900 and 3001 in format 2017-12-31
         ## 
         ## default currently set to  between  +/- 50 years of today
         ## 
         ##.. code-block:: nim
         ##    import nimcx
         ##    loopy2(0,100): echo getRndDate(2016,2025)
         ##    
         ##    
         var okflag = false
         var mminyear = minyear 
         var mmaxyear = maxyear + 1
         if mminyear < 1900: mminyear = 1900
         if mmaxyear > 3001: mmaxyear = 3001
                 
         while okflag == false:
            
             var mmd = $getRndInt(1,13)
             if mmd.len == 1:
                mmd = "0" & $mmd
            
             var ddd = $getRndInt(1,32)
             if ddd.len == 1:
                ddd = "0" & $ddd
            
             var nd = $getRndInt(mminyear,mmaxyear) & "-" & mmd & "-" & ddd
             if validDate(nd) == false:
                 okflag = false
             else : 
                 okflag = true
                 result = nd


proc printSlimNumber*(anumber:string,fgr:string = yellowgreen ,bgr:BackgroundColor = bgBlack,xpos:int = 1) =
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


proc prsn(x:int,fgr:string = termwhite,bgr:BackgroundColor = bgBlack,xpos:int = 0) =
     # print routine for slim numbers
     for x in slimN(x).zx: printLn(x,fgr = fgr,bgr = bgr,xpos = xpos)

proc prsc(x:string,fgr:string = termwhite,bgr:BackgroundColor = bgBlack,xpos:int = 0) =
     # print routine for slim chars
     for x in slimc(x).zx: printLn($x,fgr = fgr,bgr = bgr,xpos = xpos)


proc printSlim* (ss:string = "", frg:string = termwhite,bgr:BackgroundColor = bgBlack,xpos:int = 0,align:string = "left") =
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
        prsc($x ,frg,bgr, xpos = npos - sswidth)
        npos = npos + 1
        curup(3)
      else:
        var mn:int = parseInt($x)
        prsn(mn ,frg,bgr, xpos = npos - sswidth)
        npos = npos + 3
        curup(3)



# Framed headers with var. colorising options

proc superHeader*(bstring:string) =
      ## superheader
      ##
      ## a framed header display routine
      ##
      ## suitable for one line headers , overlong lines will
      ##
      ## be cut to terminal window width without ceremony
      ##
      ## for box with or without intersections see drawBox
      ##
      var astring = bstring
      # minimum default size that is string max len = 43 and
      # frame = 46
      let mmax = 43
      var mddl = 46
      ## max length = tw-2
      let okl = tw - 6
      let astrl = astring.len
      if astrl > okl :
        astring = astring[0.. okl]
        mddl = okl + 5
      elif astrl > mmax :
          mddl = astrl + 4
      else :
          # default or smaller
          let n = mmax - astrl
          for x in 0..<n:
              astring = astring & " "
          mddl = mddl + 1

      # some framechars choose depending on what the system has installed
      #let framechar = "▒"
      let framechar = "⌘"
      #let framechar = "⏺"
      #let framechar = "~"
      let pdl = framechar.repeat(mddl)
      # now show it with the framing in yellow and text in white
      # really want a terminal color checker to avoid invisible lines
      echo()
      printLn(pdl,yellowgreen)
      print(spaces(1))
      printLn(astring,dodgerblue)
      printLn(pdl,yellowgreen)
      echo()



proc superHeader*(bstring:string,strcol:string,frmcol:string) =
        ## superheader
        ##
        ## a framed header display routine
        ##
        ## suitable for one line headers , overlong lines will
        ##
        ## be cut to terminal window size without ceremony
        ##
        ## the color of the string can be selected, available colors
        ##
        ## green,red,cyan,white,yellow and for going completely bonkers the frame
        ##
        ## can be set to clrainbow too .
        ##
        ##.. code-block:: nim
        ##    import nimcx
        ##
        ##    superheader("Ok That's it for Now !",clrainbow,white)
        ##    echo()
        ##
        var astring = bstring
        # minimum default size that is string max len = 43 and
        # frame = 46
        let mmax = 43
        var mddl = 46
        let okl = tw - 6
        let astrl = astring.len
        if astrl > okl :
          astring = astring[0.. okl]
          mddl = okl + 5
        elif astrl > mmax :
            mddl = astrl + 4
        else :
            # default or smaller
            let n = mmax - astrl
            for x in 0..<n:
                astring = astring & spaces(1)
            mddl = mddl + 1

        let framechar = "⌘"
        #let framechar = "~"
        let pdl = framechar.repeat(mddl)
        # now show it with the framing in yellow and text in white
        # really want to have a terminal color checker to avoid invisible lines
        echo()

        # frame line
        proc frameline(pdl:string) =
            print(pdl,frmcol)
            echo()

        proc framemarker(am:string) =
            print(am,frmcol)

        proc headermessage(astring:string)  =
            print(astring,strcol)


        # draw everything
        frameline(pdl)
        #left marker
        framemarker(framechar & spaces(1))
        # header message sring
        headermessage(astring)
        # right marker
        framemarker(spaces(1) & framechar)
        # we need a new line
        echo()
        # bottom frame line
        frameline(pdl)
        # finished drawing


proc tupleToStr*(xs: tuple): string =
     ## tupleToStr
     ##
     ## tuple to string unpacker , returns a string
     ##
     ## code ex nim forum
     ##
     ##.. code-block:: nim
     ##    echo tupleToStr((1,2))         # prints (1, 2)
     ##    echo tupleToStr((3,4))         # prints (3, 4)
     ##    echo tupleToStr(("A","B","C")) # prints (A, B, C)
     
     result = "("
     for x in xs.fields:
       if result.len > 1:
           result.add(", ")
       result.add($x)
     result.add(")")
     



# Var. internet related procs

proc getIpInfo*(ip:string):JsonNode =
     ## getIpInfo
     ##
     ## use ip-api.com free service limited to abt 250 requests/min
     ##
     ## exceeding this you will need to unlock your wan ip manually at their site
     ##
     ## the JsonNode is returned for further processing if needed
     ##
     ## and can be queried like so
     ##
     ##.. code-block:: nim
     ##   var jj = getIpInfo("208.80.152.201")
     ##   echo mpairs(jz)
     ##   echo jj["city"].getstr
     ##
     ##
    
     var zcli = newHttpClient()
     if ip != "":
        try: 
          result = parseJson(zcli.getContent("http://ip-api.com/json/" & ip))
        except OSError:
            discard


proc showIpInfo*(ip:string) =
      ## showIpInfo
      ##
      ## Displays details for a given IP
      ##
      ## Example:
      ##
      ##.. code-block:: nim
      ##    showIpInfo("208.80.152.201")
      ##    showIpInfo(getHosts("bbc.com")[0])
      ##
      try:
        var jj:JsonNode = getIpInfo(ip)
        decho(2)
        printLn("Ip-Info for " & ip,lightsteelblue)
        dlineln(40,col = yellow)
        for x in jj.mpairs() :
            echo fmtx(["<15","",""],$x.key ," : " ,unquote($x.val))
        printLnBiCol(fmtx(["<15","",""],"Source"," : ","ip-api.com"),yellowgreen,salmon,":",0,false,{})
      except:
          printLnBiCol("IpInfo   : unavailable",lightgreen,red,":",0,false,{})  

proc localIp*():string =
   # localIp
   # 
   # returns current machine ip
   # 

   result =  execCmdEx("ip route | grep src").output.split("src")[1].strip()
  


proc localRouterIp*():string = 
   # localRouterIp
   # 
   # returns current router ip
   # 
   let res = execCmdEx("ip route list | awk ' /^default/ {print $3}'")
   result = $res[0]
   

proc showLocalIpInfo*() =
     printLnBiCol("Machine : " & localIp())
     printLnBiCol("Router  : " & localRouterIp())
   
proc getHosts*(dm:string):seq[string] =
    ## getHosts
    ##
    ## returns IP addresses inside a seq[string] for a domain name and
    ##
    ## may resolve multiple IP pointing to same domain
    ##
    ##.. code-block:: Nim
    ##    import nimcx
    ##    var z = getHosts("bbc.co.uk")
    ##    for x in z:
    ##      echo x
    ##    doFinish()
    ##
    ##
    var rx = newSeq[string]()
    try:
      for i in getHostByName(dm).addrList:
        if i.len > 0:
          var s = ""
          var cc = 0
          for c in i:
              if s != "":
                  if cc == 3:
                    s.add(",")
                    cc = 0
                  else:
                    cc += 1
                    s.add('.')
              s.add($int(c))
          var ss = s.split(",")
          for x in 0..<ss.len:
              rx.add(ss[x])

        else:
          rx = @[]
    except:
           rx = @[]
    var rxs = rx.toSet # removes doubles
    rx = @[]
    for x in rxs:
        rx.add(x)
    result = rx


proc showHosts*(dm:string) =
    ## showHosts
    ##
    ## displays IP addresses for a domain name and
    ##
    ## may resolve multiple IP pointing to same domain
    ##
    ##.. code-block:: Nim
    ##    import nimcx
    ##    showHosts("bbc.co.uk")
    ##    doFinish()
    ##
    ##
    cechoLn(yellowgreen,"Hosts Data for " & dm)
    let z = getHosts(dm)
    if z.len < 1:
         printLn("Nothing found or not resolved",red)
    else:
       for x in z:
         printLn(x)

proc pingy*(dest:string,pingcc:int = 3,col:string = termwhite) = 
        ## pingy
        ## 
        ## small utility to ping some server
        ## 
        ##.. code-block:: nim 
        ##    pingy("yahoo.com",4,dodgerblue)   # 4 pings and display progress in some color
        ##    pingy("google.com",8,aqua)
        ## 
 
        let pingc = $pingcc
        let (outp,err) = execCmdEx("which ping")
        let outp2 = quoteshellposix(strip(outp,true,true))
        
        if err > 0:
            printLnBiCol("Error : " & $err,red,termwhite,":",0,false,{})
            
        else:        
               
            printLnBiCol("Pinging : " & dest,yellowgreen,truetomato,":",0,false,{})
            printLnBiCol("Expected: " & pingc & " pings")
            printLn("")
            let p = startProcess(outp2,args=["-c",pingc,dest] , options={poParentStreams})
            printLn($p.waitForExit(parseInt(pingc) * 1000 + 500),truetomato)
            decho(2)
            
            
proc cxPortCheck*(cmd:string = "lsof -i") =
     ## cxPortCheck
     ## 
     ## runs a linux system command to see what the ports are listening to
     ## 
     if not cmd.startsWith("lsof") :  # do not allow any old command here
        printLnBiCol("cxPortCheck Error: Wrong command --> $1" % cmd,colLeft=red)
        doFinish()
     let pc = execCmdEx(cmd)  
     let pcl = pc[0].splitLines()
     printLn(pcl[0],yellowgreen,styled={styleUnderscore})
     for x in 1..pcl.len:
        if pcl[x].contains("UDP "):
           var pclt = pcl[x].split(" ")
           echo()
           print(pclt[0] & spaces(1),sandybrown)
           for xx in 1..<pclt.len:
               if pclt[xx].contains("IPv4") :
                  print(pclt[xx],dodgerblue,styled={styleReverse})
                  print(spaces(1))
               elif pclt[xx].contains("IPv6") :
                  print(pclt[xx],truetomato,styled={styleReverse})
                  print(spaces(1))   
               elif pclt[xx].contains("UDP") :
                  print(pclt[xx],sandybrown,styled={styleReverse})
                  print(spaces(1))
               elif pclt[xx].contains("root") :
                  print(pclt[xx],darkred,styled={styleReverse})
                  print(spaces(1))   
               else:
                  print(pclt[xx],skyblue)
                  print(spaces(1))
               if xx == pclt.len: echo() 

        elif pcl[x].contains("TCP "):
           var pclt = pcl[x].split(" ")
           echo()
           print(pclt[0] & spaces(1),lime)
           for xx in 1..<pclt.len:
               if pclt[xx].contains("IPv4") :
                  print(pclt[xx],dodgerblue,styled={styleReverse})
                  print(spaces(1))
               elif pclt[xx].contains("IPv6") :
                  print(pclt[xx],truetomato,styled={styleReverse})
                  print(spaces(1))   
               elif pclt[xx].contains("TCP") :
                  print(pclt[xx],pastelblue,styled={styleReverse})
                  print(spaces(1))
               elif pclt[xx].contains("root") :
                  print(pclt[xx],darkred,styled={styleReverse})
                  print(spaces(1))   
                  
               else:
                  print(pclt[xx],pastelpink)
                  print(spaces(1))
               if xx == pclt.len: echo()   
        else:
           #printLn(x)
           discard
            
template quickList*[T](c:int,d:T,cw:int = 7 ,dw:int = 15) =
      ## quickList
      ## 
      ## a simple template which allows listing of 2 columns in format count data
      ## 
      ## cw and dw are column width adjuster 
      ## 
      ##.. code-block:: nim
      ##    import nimcx      
      ##    var z = createSeqFloat(1000000,4)
      ##    for x in 0..<z.len:
      ##        quicklist(x,ff2(z[x] * 100000,4),dw = 22)

      let fms1 = ">" & $cw
      let fms2 = ">" & $dw
      echo fmtx([fms1,"",fms2],c,spaces(1),d)


template doSomething*(secs:int,body:untyped) =
  ## doSomething
  ## 
  ## execute some code for a certain amount of seconds
  ## 
  ##.. code-block:: nim
  ##    doSomething(10,myproc())  # executes my proc for ten secs   , obviously this will fail if your proc uses sleep...
  ## 
  let mytime = now() #getTime().getLocalTime()
  while toTime(now()) < toTime(mytime) + secs.seconds : 
      body  

proc reverseMe*[T](xs: openarray[T]): seq[T] =
  ## reverseMe
  ##
  ## reverse a sequence
  ##
  ##.. code-block:: nim
  ##
  ##    var z = @["nice","bad","abc","zztop","reverser"]
  ##    printLn(z,lime)
  ##    printLn(z.reverseMe,red)
  ##

  result = newSeq[T](xs.len)
  for i, x in xs:
     result[xs.high - i] = x


proc reverseText*(text:string):string = 
  ## reverseText
  ## 
  ## reverses words in a sentence
  ## 
  for line in text.splitLines: result = line.split(" ").reversed.join(" ")

proc reverseString*(text:string):string = 
  ## reverseString
  ## 
  ## reverses chars in a word   
  ## 
  ## 
  ##..code-block:: nim
  ## 
  ##    var s = "A text to reverse could be this example 12345.0"
  ##    echo "Original      : " & s  
  ##    echo "reverseText   : " & reverseText(s)
  ##    echo "reverseString : " & reverseString(s)
  ##    # check if back to original is correct
  ##    assert s == reverseString(reverseString(s))
  ##    
   
  for x in reverseMe(text): result = result & x



# Convenience procs for rand data creation and handling
proc createSeqBool*(n:int = 10): seq[bool] {.inline.} =
     # createSeqBool
     # 
     # returns a seq of rand bools
     # 
     result = newSeq[bool]()
     for x in 0..<n: result.add(getRndBool())
            

proc createSeqInt*(n:int = 10,mi:int = 0,ma:int = 1000) : seq[int] {.inline.} =
    ## createSeqInt
    ##
    ## convenience proc to create a seq of rand int with
    ##
    ## default length 10
    ##
    ## gives @[4556,455,888,234,...] or similar
    ##
    ##.. code-block:: nim
    ##    # create a seq with 50 rand integers ,of set 100.. 2000
    ##    # including the limits 100 and 2000
    ##    echo createSeqInt(50,100,2000)

    # result = newSeqofCap[int](n)  # slow use if memory considerations are of top importance
    result = newSeq[int]()          # faster
    case  mi <= ma
        of true : result.add(newSeqWith(n,getRndInt(mi,ma)))
        of false: print("Error : Wrong parameters for min , max ",red)



proc sum*[T](aseq: seq[T]): T = foldl(aseq, a + b)
     ## sum
     ##
     ## returns sum of float or int seqs
     ## 
     ## same effect as math.sum
     ##

proc product*[T](aseq: seq[T]):T = foldl(aseq, a * b)
     ## product
     ##
     ## returns product of float or int seqs 
     ##
     ## if a seq contains a 0 element than result will be 0
     ## 
    
proc ff*(zz:float,n:int = 5):string =
     ## ff
     ##
     ## formats a float to string with n decimals
     ##
     result = $formatFloat(zz,ffDecimal,precision = n)



proc ff2*(zz:float , n:int = 3):string =
  ## ff2
  ## 
  ## formats a float into form 12,345,678.234 that is thousands separators are shown
  ## 
  ## 
  ## precision is after comma given by n with default set to 3
  ## 
  ##.. code-block:: nim
  ##    import nimcx
  ##    
  ##    # floats example
  ##    for x in 1.. 2000:
  ##       # generate some positve and negative rand float
  ##       var z = getrandfloat() * 2345243.132310 * getRandomSignF()
  ##       printLnBiCol(fmtx(["",">6","",">20"],"NZ ",$x," : ",ff2(z)))
  ##  
  ##       
     
  if abs(zz) < 1000 == true:   #  number less than 1000 so no 1000 seps needed
    result = ff(zz,n)
    
  else: 
        let c = rpartition($zz,".")
        var cnew = ""
        for d in c[2]:
              if cnew.len < n:
                  cnew = cnew & d
        result = ff2(parseInt(c[0])) & c[1] & cnew



proc ff2*(zz:int64 , n:int = 0):string =
  ## ff2
  ## 
  ## formats a integer into form 12,345,678 that is thousands separators are shown
  ## 
  ## precision is after comma given by n with default set to 0
  ## in context of integer this means display format could even show 
  ## a 0 after comma part if needed
  ## 
  ## ff2(12345,0)  ==> 12,345     # display an integer with thousands seperator as we know it
  ## ff2(12345,1)  ==> 12,345.0   # display an integer but like a float with 1 after comma pos
  ## ff2(12345,2)  ==> 12,345.00  # display an integer but like a float with 2 after comma pos
  ## 
  ## 
  ##.. code-block:: nim
  ##    import nimcx
  ##    
  ##    # int example
  ##    for x in 1.. 20:
  ##       # generate some positve and negative rand integer
  ##       var z = getRndInt(50000,100000000) * getRandomSignI()
  ##       printLnBiCol(fmtx(["",">6","",">20.0"],"NIM ",$x," : ",z))
  ##       
  ##       
  
  var sc = 0
  var nz = ""
  var zrs = ""
  let zs = split($zz,".")
  let zrv = reverseme(zs[0])
 
  for x in 0..<zrv.len: 
     zrs = zrs & $zrv[x]
 
  for x in 0..<zrs.len:
    if sc == 2:
        nz = "," & $zrs[x] & nz
        sc = 0
    else:
        nz = $zrs[x] & nz
        inc sc     
       
  if nz.startswith(",") == true:
     nz = strip(nz,true,false,{','})
  elif nz.startswith("-,") == true:
     nz = nz.multiReplace(("-,","-"))
     
  result = nz


proc getRandomFloat*(mi:float = -1.0 ,ma:float = 1.0):float =
     ## getRandomFloat
     ##
     ## convenience proc so we do not need to import rand in calling prog
     ##
     ## to get positive or negative rand floats multiply with getRandomSignF
     ## 
     ## Note: changed so to get positive and or negative floats
     ## 
     ##.. code-block:: nim
     ##    echo  getRandomFloat() * 10000.00 * getRandomSignF()
     ##
     result = rand(-1.0..float(1.0))

proc getRndFloat*(mi:float = -1.0 ,ma:float = 1.0):float  {.noInit,inline.} =  rand(mi..ma)
     ## getRndFloat
     ##
     ## same as getrandFloat()
     ##

proc createSeqFloat*(n:int = 10,prec:int = 3) : seq[float] =
     ## createSeqFloat
     ##
     ## convenience proc to create an unsorted seq of rand floats with
     ##
     ## default length ma = 10 ( always consider how much memory is in the system )
     ##
     ## prec enables after comma precision up to 16 positions after comma
     ##
     ## this is on a best attempt basis and may not work all the time
     ##
     ## default after comma positions is prec = 3 max
     ##
     ## form @[0.34,0.056,...] or similar
     ##
     ##.. code-block:: nim
     ##    # create a seq with 50 rand floats
     ##    echo createSeqFloat(50)
     ##
     ##
     ##.. code-block:: nim
     ##    # create a seq with 50 rand floats formated
     ##    echo createSeqFloat(50,3)
     ##
     var ffnz = prec
     if ffnz > 16: ffnz = 16
     result = newSeq[float]()
     for wd in 0..<n:
       var x = 0   
       while  x < prec:
            let afloat = parseFloat(ff2(getRndFloat(),prec))
            if ($afloat).len > prec + 2:
               x = x - 1
               if x < 0:
                     x = 0
            else:
               inc x 
               result.add(afloat)
               
            if result.len == n : break   
         
       if result.len == n : break
       
       
       
       
proc seqLeft*[T](it : seq[T] , n: int) : seq[T] =
    ## seqLeft
    ## 
    ## returns a new seq with n left end elements of the original seq 
    try:
        result = it
        if it.len >= n: result = it[0..<n]
    except RangeError:
        discard


proc seqRight*[T](it : seq[T] , n: int) : seq[T] =
    ## seqRight
    ## 
    ## returns a new seq with n right end elements of the original seq 
   
    try:
        result = it
        if n <= it.len : result = it[it.len - n..<it.len]
    except RangeError:
        discard        
        
proc seqHighLite*[T](b:seq[T],b1:seq[T],col:string=gold) =
   ## seqHighLite
   ## 
   ## displays the passed in seq with highlighting of subsequence
   ## 
   ##.. code-block:: nim
   ##   import nimcx
   ##   var b = createSeqInt(30,1,10)
   ##   seqHighLite(b,@[5,6])   # subseq will be highlighted if found
   ## 
   ## 
   var bs:string = $b1
   bs = bs.replace("@[","")
   bs.removesuffix(']')
   printLn(b,col,styled = {styleReverse},substr = bs)       
       
       
template bitCheck*(a, b: untyped): bool =
    ## bitCheck
    ## 
    ## check bitsets as suggested by araq
    ##  
    (a and (1 shl b)) != 0       
       
# Misc. routines
     

proc nimcat*(curFile:string,countphrase : varargs[string,`$`] = "")=
    ## nimcat
    ## 
    ## a simple file lister which shows all rows and some stats as well as allows counting of tokens
    ## a file name without extension will be assuemed to be .nim ... it is the nimcat afterall
    ## countphrase is case sensitive
    ## this proc uses memslices and memfiles for speed
    ##  
    ##  
    ##.. code-block: nim
    ## 
    ##   nimcat("notes.txt")                   # show all lines
    ##   nimcat("bigdatafile.csv")
    ##   nimcat("/data5/notes.txt",countphrase = "nice" , "hanya", 88) # also count how often a token appears in the file
    ## 
    var ccurFile = curFile
    let (dir, name, ext) = splitFile(ccurFile)
    if ext == "": ccurFile = ccurFile & ".nim"
   
    if not fileExists(ccurfile):
            echo()
            printLnBiCol("Error : " , ccurfile , " not found !",red,white,":",0,false,{})
            printLn(spaces(8) & " Check path and filename")
            echo()
            discard
       
    else :   
    
            decho(2)
            dlineLn()
            echo()
        
            
            var phraseinline = newSeqWith(countphrase.len, newSeq[int](0))  # holds the line numbers where a phrase to be counted was found
            var line = ""
            var c = 1
            #if not isNil(fs):
            for line in memSlices(memfiles.open(ccurFile)):
                    echo yellowgreen, align($c, 6),termwhite,":",spaces(1),wordwrap($line,maxLineWidth = tw - 8,splitLongWords = false,newLine = "\x0D\x0A" & spaces(8))
                    if ($line).len > 0:
                      var lc = 0
                      for mc in 0..<countphrase.len:
                          lc = ($line).count(countphrase[mc])
                          if lc > 0: phraseinline[mc].add(c)
                    
                    inc c

            echo() 
            printLnBiCol("File       : " & ccurFile)
            printLnBiCol("Lines Shown: " & ff2(c - 1))
            
            var maxphrasewidth = 0
            
            for x in  countphrase:
                  if x.len > maxphrasewidth: maxphrasewidth = x.len
                
            if countphrase.len > 0:
              println("\nPhraseCount stats :    \n",gold,styled={styleUnderScore})
              for x in 0..<countphrase.len:
                    printLnBiCol(fmtx(["<" & $maxphrasewidth,"",""],countphrase[x]," : " & rightarrow & " Count: ",phraseinline[x].len))
                    printLnBiCol("Lines : " , phraseinline[x],"\n" ,colLeft = cyan ,colRight = termwhite ,sep = ":",0,false,{})
            
  

        
proc checkHash*[T](kata:string,hsx:T)  =
  ## checkHash
  ## 
  ## checks hash of a string and print status
  ## 
  if hash(kata) == hsx:
        printLnBiCol("Hash Status : ok")
  else:
        printLnBiCol("Hash Status : fail",red,termwhite,":",0,false{})


proc verifyHash*[T](kata:string,hsx:T):bool  =
  ## verifyHash
  ## 
  ## checks hash of a string and returns true or false
  ## 
  result = false
  if hash(kata) == hsx: result = true
       
        
proc createHash*(kata:string):auto = 
    ## createHash
    ## 
    ## returns hash of a string
    ##  
    ## Example
    ##  
    ##.. code-block:: nim
    ##    var zz = readLineFromStdin("Hash a string  : ")
    ##    # var zz = readPasswordFromStdin("Hash a string  : ")   # to do not show input string
    ##    var ahash = createHash(zz)
    ##    echo ahash
    ##    checkHash(zz, ahash)
    ##    
    ##    
    result = hash(kata)   


template repeats(count: int, statements: untyped) =
  for i in 0..<count:
      statements

proc checkspeed(ztb:float):float =
         result = epochTime() - ztb
         
    
template benchmark*(benchmarkName: string, repeatcount:int = 1,code: typed) =
  ## benchmark
  ## 
  ## a quick benchmark template showing cpu and epoch times with repeat looping param
  ## suitable for in program ttiming of procs 
  ## for in depth benchmarking use the nimbench module available via nimble
  ## 
  ## 
  ##.. code-block:: nim
  ##    benchmark("whatever",1000):
  ##        printLn("Kami makan tiga kali setiap hari.",randcol())
  ##
  ##
  ##.. code-block:: nim
  ##          import nimcx,algorithm
  ##
  ##          proc doit() =
  ##              var s = createSeqFloat(10,9)
  ##              var c = 0
  ##              s.sort(system.cmp,order = Descending)
  ##              for x in s:
  ##                  inc c 
  ##                  printLnBiCol(fmtx([">4","<6","<f15.7"],$c," :",$x))
  ##
  ##          template cxcounter(bx:int):int =
  ##                  inc bx
  ##                  bx
  ##
  ##          var x = 0
  ##          benchmark("doit",10000):
  ##                  doit()
  ##                  hline(30)
  ##                  printLn( " " & uparrow & " Run " & $cxcounter(x),greenyellow)
  ##                  echo()
  ##                  
  ##          showBench() 
  ##  
  ##    
  ##    
  
  var zbres:Benchmarkres
  let t0 = epochTime()
  let t1 = cpuTime()
  zbres.fastest = 100000000.0  # some large int to init
  repeats(repeatcount):
      #var t2 = epochTime()
      code
      #var fstt = checkspeed(t2)
      #if fstt < zbres.fastest : zbres.fastest = fstt
  let elapsed  = epochTime() - t0
  let elapsed1 = cpuTime()   - t1
  zbres.epoch  = ff(elapsed,4)  
  zbres.cpu = ff(elapsed1,4) 
  zbres.bname = benchmarkName
  zbres.repeats = $repeatcount
  benchmarkresults.add(zbres)
  
    
template benchmark*(benchmarkName: string,code: typed) =
  ## benchmark
  ## 
  ## a quick benchmark template showing cpu and epoch times without repeat
  ## 
  ##.. code-block:: nim
  ##    benchmark("whatever"):
  ##      let z = 0.. 1000
  ##      loopy(z,printLn("Kami makan tiga kali setiap hari.",randcol()))
  ##
  ##
  ##.. code-block:: nim
  ##
  ##   proc doit() =
  ##      var s = createSeqFloat(10,9)
  ##      var c = 0
  ##      s.sort(system.cmp,order = Descending)
  ##      for x in s:
  ##           inc c 
  ##           printLnBiCol(fmtx([">4","<6","<f15.7"],$c," :",$x))
  ##
  ##    benchmark("doit"):
  ##      for x in 0.. 100:
  ##          doit()
  ##          hline(30)
  ##          printLn(" " & $x,randcol())
  ##          echo()
  ##          
  ##    showBench() 
  ##    
  ##    
  
  var zbres:Benchmarkres
  let t0 = epochTime()
  let t1 = cpuTime()
  let repeatcount = 1
  repeats(repeatcount):
      code
  let elapsed  = epochTime() - t0
  let elapsed1 = cpuTime()   - t1
  zbres.epoch  = ff(elapsed,4)  
  zbres.cpu = ff(elapsed1,4) 
  zbres.bname = benchmarkName
  zbres.repeats = $repeatcount
  benchmarkresults.add(zbres)
  

proc showBench*() =
 ## showBench
 ## 
 ## Displays results of all benchmarks

 var bnamesize = 0
 var epochsize = 0
 var cpusize = 0 
 var repeatsize = 0
 for x in  benchmarkresults:
   var aa11 =  spaces(1) & dodgerblue & "[" & salmon & x.bname & dodgerblue & "]"  
   if len(aa11) > bnamesize: bnamesize = len(aa11)
   if bnamesize < 13 : bnamesize = 13
   if len(x.epoch) > epochsize: epochsize = len(x.epoch) - bnamesize + 50
   if len(x.cpu) > cpusize: cpusize = len(x.cpu) + 26
   if len(x.repeats) > repeatsize: repeatsize = len(x.repeats)
   
 if benchmarkresults.len > 0: 
    for x in benchmarkresults:
       echo()
       let tit = fmtx(["","<$1" % $(bnamesize - len(gold) * 3),"","<30","<20"],spaces(1),"BenchMark",spaces(4),"Timing" ,"Iters : $1" % x.repeats)
       
       if parseInt(x.repeats) > 0:
          printLn(tit,greenyellow, styled = {styleUnderScore},substr = tit)
          echo()
       else:
          printLn(tit,red,styled = {styleUnderScore},substr = tit)
      
       let aa1 =  spaces(1) & gold & "[" & salmon & x.bname & gold & "]"  
       let bb1 =  cornflowerblue & "Epoch Time : " & oldlace & x.epoch & " secs" 
       let cc1 =  cornflowerblue & "Cpu Time   : " & oldlace & x.cpu & " secs"
       var dd1 = ""
       var ee1 = ""
       
       if parseFloat(x.epoch) > 0.00: 
          dd1 = "Iters/sec : " & ff2(parsefloat(x.repeats)/parsefloat(x.epoch))
       else :
          dd1 = "Iters/sec : Inf"
       
       if parseFloat(x.cpu) > 0.00:   
          ee1 = "Iters/sec : " & ff2(parsefloat(x.repeats)/parsefloat(x.cpu))
       else:
          ee1 = "Iters/sec : Inf"
         
       printLn(fmtx(["<$1" % $bnamesize,"","<70","<90"],aa1,spaces(3),bb1 ,dd1))
       printLn(fmtx(["<$1" % $bnamesize,"","<70","<50"],aa1,spaces(3),cc1,ee1))

    echo()
    benchmarkresults = @[]
    printLn("Benchmark results finished. Results cleared.",goldenrod)
 else:
    printLn("Benchmark results emtpy. Nothing to show",red)   


proc newCxtimer*(aname:string = "cxtimer"):ref(CxTimer) =
     ## newCxtimer
     ## 
     ## set up a new cxtimer
     ## 
     ## simple timer with starttimer,stoptimer,laptimer,resettimer functionality
     ## 
     ##.. code-block:: nim
     ##   
     ## # Example for newcxtimer usage
     ## var ct  = newCxtimer("TestTimer1")   # create a cxtimer with name TestTimer1
     ## var ct2 = newCxtimer()               # create a cxtimer which will have default name cxtimer
     ## ct.startTimer                        # start a timer
     ## ct2.startTimer
     ## loopy2(0,2):
     ##    sleepy(1)
     ##    ct2.laptimer                      # take a laptime for a timer
     ## ct.stopTimer                         # stop a timer
     ## ct2.stopTimer
     ## saveTimerResults(ct)                 # save current state of a timer
     ## saveTimerResults(ct2)
     ## echo()
     ## showTimerResults()                   # display status of all timers
     ## ct2.resetTimer                       # reset a particular timer 
     ## clearTimerResults()                  # clear timer result of default timer
     ## clearTimerResults("TestTimer1")      # clear timer results of a particular timer
     ## clearAllTimerResults()               # clear all timer results
     ## showTimerResults()
     ## dprint cxtimerresults                # dprint is a simple repr utility
     ## 
     ## 
     
     var aresult = (ref(CxTimer))(name:aname)
     aresult.start = 0
     aresult.stop = 0
     aresult.lap = @[]
     result = aresult
   
proc  startTimer*(co:ref(CxTimer)) = co.start = epochTime()
proc  lapTimer*(co:ref(CxTimer)):auto {.discardable.}  =
               var tdf = epochTime() - co.start
               co.lap.add(tdf)
               result = tdf
proc  stopTimer*(co: ref(CxTimer))  = co.stop = epochTime()
proc  resetTimer*(co: ref(CxTimer)) = 
      co.start = 0.0
      co.stop = 0.0
      co.lap = @[]
proc  duration*(co:ref(CxTimer)):float {.discardable.} = co.stop - co.start       

proc saveTimerResults*(b:ref(CxTimer)) =
     ## saveTimerResults
     ## 
     ## saves the current state of a cxtimer
     ## 
     var bb:Cxtimerres
     var c = b
     if  b.name == "": c.name = "cxtimer"   # give it a default name
     bb.tname = c.name
     bb.start = c.start
     bb.stop = c.stop
     bb.lap = c.lap
     cxtimerresults.add(bb)

proc showTimerResults*(aname:string) =  
     ## showTimerResults  
     ## 
     ## shows results for a particular timer name
     ## 
     var bname = aname
     if bname == "": bname = "cxtimer"    # if no name given we assume defaultname cxtimer 
     echo()
     loopy2(0,cxtimerresults.len):
       var b = cxtimerresults[xloopy]
       if b.tname == bname:
          printLnBiCol("Timer    : " & $(b.tname))
          printLnBiCol("Start    : " & $fromUnix(int(b.start)))
          printLnBiCol("Stop     : " & $fromUnix(int(b.stop)))
          printLnBiCol("Laptimes : ")
          if b.lap.len > 0:
             printLnBiCol("Laptimes : ")
             loopy2(0,b.lap.len):
                printLnBiCol(fmtx([">7","",""],$(xloopy + 1), " : " , $b.lap[xloopy]),xpos = 8)
             echo()
          else:
             printLnBiCol("Laptimes : none recorded")
          printLnBiCol("Duration : " & $(b.stop - b.start) & " secs.")   
               
             
               
proc showTimerResults*() =  
     ## showTimerResults  
     ## 
     ## shows results for all timers
     ## 
     echo()
     loopy2(0,cxtimerresults.len):
       var b = cxtimerresults[xloopy]
       echo()
       printLnBiCol("Timer    : " & $(b.tname))
       printLnBiCol("Start    : " & $fromUnix(int(b.start)))
       printLnBiCol("Stop     : " & $fromUnix(int(b.stop)))
       if b.lap.len > 0:
          printLnBiCol("Laptimes : ")
          loopy2(0,b.lap.len):
             printLnBiCol(fmtx([">7","",""],$(xloopy + 1), " : " , $b.lap[xloopy]),xpos = 8)
          echo()
       else:
          printLnBiCol("Laptimes : none recorded")
       printLnBiCol("Duration : " & $(b.stop - b.start) & " secs.")
       
       
proc clearTimerResults*(aname:string = "",quiet:bool = true,xpos:int = 3) =
     ## clearTimerResults
     ## 
     ## clears cxtimerresults of one named timer or if aname == "" of timer cxtimer
     ## 
     ##  
     var bname = aname
     if bname == "": bname = "cxtimer"    # if no name given we assume defaultname cxtimer 
     loopy2(0,cxtimerresults.len):
        if cxtimerresults[xloopy].tname == bname:
               if quiet == false:
                  echo()
                  print("Timer deleted : " ,goldenrod,xpos = xpos)
                  printLn(cxtimerresults[xloopy].tname ,tomato)
                  echo()
               cxtimerresults.delete(xloopy)  
               
        else:
               discard
       
proc clearAllTimerResults*(quiet:bool = true,xpos:int = 3) =
     ## clearAllTimerResults
     ## 
     ## clears cxtimerresults for all timers , set quiet to false to show feedback
     ## 
     ##  
     cxtimerresults = @[] 
     echo()
     if quiet == false:
        print("Timer deleted : " , goldenrod,xpos = xpos)
        printLn("all",tomato)
             
    
proc `$`*[T](some:typedesc[T]): string = name(T)
proc typeTest*[T](x:T):  T {.discardable.} =
     # used to determine the field types in the temp sqllite table used for sorting
     printLnBiCol("Type     : " & $type(x))
     printLnBiCol("Value    : " & $x)
     
proc typeTest2*[T](x:T): T {.discardable.}  =
     # same as typetest but without showing values (which may be huge in case of seqs)
     printLnBiCol("Type       : " & $type(x),xpos = 3)   
     
proc typeTest3*[T](x:T): string =   $type(x)
     
macro echoType*(x: typed): untyped = 
  ## echoType
  ## by @yardanico
  ## 
  let impl = x.symbol.getImpl()
  # we're called on some type
  if impl.kind == nnkTypeDef:
    echo "type ", toStrLit(impl)
  # we're called on a variable
  else:
    echo "type ", impl.getTypeInst(), " = ", toStrLit(impl.getTypeImpl())

 
     
template withFile*(f,fn, mode, actions: untyped): untyped =
  ## withFile
  ## 
  ## easy file handling template , which is using fileStreams
  ## 
  ## f is a file handle
  ## fn is the filename
  ## mode is fmWrite,fmRead,fmReadWrite,fmAppend or fmReadWriteExisiting
  ## 
  ## 
  ## Example 1
  ## 
  ##.. code-block:: nim
  ##   let curFile="/data5/notes.txt"    # some file
  ##   withFile(fs, curFile, fmRead):
  ##       var line = ""
  ##       while fs.readLine(line):
  ##           printLn(line,yellowgreen)
  ##           
  ##  Example 2   
  ##    
  ##.. code-block:: nim
  ##   import nimcx
  ##
  ##   let curFile="/data5/notes.txt"    # some file
  ##
  ##   withFile(txt2, curFile, fmRead):
  ##           var aline = ""
  ##           var lc = 0
  ##           var oc = 0
  ##           while txt2.readline(aline):
  ##               try:
  ##                   inc lc
  ##                   var sw = "the"   # find all lines containing : the
  ##                   if aline.contains(sw) == true:
  ##                       inc oc
  ##                       printBiCol(fmtx(["<8",">6","","<7","<6"],"Line :",lc,rightarrow,"Count : ",oc))
  ##                       printHl(aline,sw,green)
  ##                       echo()
  ##               except:
  ##                   break 
  block:
        var f = streamFile(fn,mode)
        if not f.isNil:
            try:
                actions
            finally:
                close(f)
        else:
                echo()
                printLnBiCol("Error : Cannot open file " & fn,red,yellow,":",0,false,{})
                quit()
         
         
         
proc pswwaux*() =
   # pswwaux
   # 
   # utility bash command :  ps -ww aux | sort -nk3 | tail
   # displays output in console
   # 
   const pswwaux = staticExec "ps -ww aux | sort -nk3 | tail "
   printLn("ps -ww aux | sort -nk3 | tail ",yellowgreen)
   echo  pswwaux
   decho(2)
         
     
     
proc fromCString*(p: pointer, len: int): string =
  ## fromCString
  ## 
  ## convert C pointer to Nim string
  ## (code ex nim forum https://forum.nim-lang.org/t/3045 by jangko)
  ## 
  result = newString(len)
  copyMem(result.cstring, p, len)
         
         
proc showPalette*(coltype:string = "white") = 
    ## ::
    ##   showPalette
    ##   
    ##   Displays palette with all coltype as found in  colorNames
    ##   coltype examples : "red","blue","medium","dark","light","pastel" etc..
    ##   
    echo()
    let z = colPaletteLen(coltype)
    for x in 0..<z:
          printLn(fmtx([">3",">4"],$x,rightarrow) & " ABCD 1234567890   " & colPaletteName(coltype,x) , colPalette(coltype,x))
    printLnBiCol("\n" & coltype & "Palette items count   : " & $z)  
    echo()  

    

proc colorio*() =
    ## colorio
    ## 
    ## Displays name,hex code and rgb of colors available in cx.nim
    ## 

    printLn(fmtx(["<20","","<20","",">5","",">5","",">5"],"ColorName in cx", spaces(2) , "HEX Code",spaces(2),"R",spaces(1),"G",spaces(1),"B") ,zippi)
    echo()

    for x in 0..<colorNames.len:
        try:
           let zr = extractRgb(parsecolor(colorNames[x][0]))
           printLn(fmtx(["<20","","<20","",">5","",">5","",">5"],colorNames[x][0], spaces(2) , $(parsecolor(colorNames[x][0])),spaces(2),zr[0],spaces(1),zr[1],spaces(1),zr[2]) ,fgr = colorNames[x][1])
        
        except ValueError:
           printLn(fmtx(["<20","","<20"],colorNames[x][0], spaces(2) , "NIMCX CUSTOM COLOR " ),fgr = colorNames[x][1])
            

proc shift*[T](x: var seq[T], zz: Natural = 0): T =
     ## shift takes a seq and returns the first item, and deletes it from the seq
     ##
     ## build in pop does the same from the other side
     ##
     ##.. code-block:: nim
     ##    var a: seq[float] = @[1.5, 23.3, 3.4]
     ##    echo shift(a)
     ##    echo a
     ##
     ##
     result = x[zz]
     x.delete(zz)

# spellInteger 
proc nonzero(c: string, n: int64, connect=""): string =
  # used by spellInteger
  if n == 0: "" else: connect & c & spellInteger(n)
 
proc lastAnd[T](num:T): string =
  # used by spellInteger
  var num = num
  if "," in num:
    let pos =  num.rfind(",")
    var (pre, last) =
      if pos >= 0: (num[0.. pos-1], num[pos+1.. num.high])
      else: ("", num)
    if " and " notin last:
      last = " and" & last
    num = [pre, ",", last].join()
  return num
 
proc big(e:int, n:int64): string =
  # used by spellInteger
  if e == 0:
    spellInteger(n)
  elif e == 1:
    spellInteger(n) & " thousand"
  else:
    spellInteger(n) & " " & huge[e]
 
iterator base1000Rev(n:int64): int64 =
  # used by spellInteger 
  var n1 = n
  while n1 != 0:
    let r = n1 mod 1000
    n1 = n1 div 1000
    yield r
 
proc spellInteger*(n: int64): string =
  ## spellInteger
  ## 
  ## code adapted from rosettacode and slightly updated to make it actually compile
  ## 

  if n < 0:
    "minus " & spellInteger(-n)
  elif n < 20:
    small[int(n)]
  elif n < 100:
    let a = n div 10
    let b = n mod 10
    tens[int(a)] & nonzero(" ", b)
  elif n < 1000:
    let a = n div 100
    let b = n mod 100
    small[int(a)] & " hundred" & nonzero(" ", b, "")
  else:
    var sq = newSeq[string]()
    var e = 0
    for x in base1000Rev(n):
      if x > 0:
        sq.add big(e, x)
      inc e
    reverse sq
    lastAnd(sq.join(" "))
 
 
proc spellInteger2*(n: string): string =
  ## spellInteger2
  ## 
  ## used in after comma part of a float , we just put out the numbers one by one
  ## 
  ## code adapted from rosettacode and slightly updated to make it actually compile
  ## 
  result = ""
  
  var nn = n
  for x in nn:
     if x == '0':
        result = result & "zero" & spaces(1)
     else:   
        result = result & spellInteger(parseInt($x)) & spaces(1)
  
proc spellFloat*(n:float64,currency:bool = false,sep:string = ".",sepname:string = " dot "):string = 
  ## spellFloat
  ## 
  ## writes out a float number in english with up to 14 positions after the dot
  ## currency denotes spelling of an amount
  ## sep and sepname can be adjusted as needed
  ## default sep = "."
  ## default sepname = " dot "
  ## 
  ##.. code-block:: nim
  ##  import nimcx
  ##  printLn spellFloat(0.00)
  ##  printLn spellFloat(234)
  ##  printLn spellFloat(-2311.345)
  ##  println spellFloat(5212311.00).replace("dot","and") & "hundreds"
  ##  printLn spellFloat(122311.34,true).replace("dot","dollars and") & " cents"
  ##  

  if n == 0.00:
      result = spellInteger(0)
  else:
      #split it into two integer parts  the back part should be spelled differently and there is an issue with 123.00234 !
      var nss = split($n,".")
      if nss[0].len == 0:  nss[0] = $0
      if nss[1].len == 0:  nss[1] = $0
      
      # depending on the situation we might want
      # 250.365
      # two hundred fifty dot three six five
      # two hundred fifty dot three hundred sixty five 
      # but we may also want 
      # two hundred fifty dollars and thirty four cents
      if currency == false:
          result = spellInteger(parseInt(nss[0])) & sepname &  spellInteger2(nss[1])
      else:
          # we assume its a currency float value
          result = spellInteger(parseInt(nss[0])) & sepname &  spellInteger(parseInt(nss[1]))
  
proc returnStat(x:Runningstat,stat : seq[string]):float =
     ## returnStat
     ## 
     ## returns any of following from a runningstat instance
     ## 
     discard

proc showStats*(x:Runningstat,n:int = 3,xpos:int = 1) =
     ## showStats
     ##
     ## quickly display runningStat data
     ## 
     ## adjust decimals default n = 3 as needed
     ##
     ##.. code-block:: nim
     ##     import nimcx
     ##     
     ##     var rsa:Runningstat
     ##     var rsb:Runningstat
     ##     for x in 1.. 100:
     ##        cleanscreen()
     ##        rsa.clear
     ##        rsb.clear
     ##        var a = createSeqint(500,0,100000)
     ##        var b = createSeqint(500,0,100000) 
     ##        rsa.push(a)
     ##        rsb.push(b)
     ##        showStats(rsa,5)
     ##        curup(14)
     ##        showStats(rsb,5,xpos = 40)
     ##        decho(2)
     ##        printLnBiCol("Regression Run  : " & $x)
     ##        showRegression(a,b,xpos = 20)
     ##        sleepy(0.05)
     ##        curup(4)
     ##     
     ##     curdn(6)  
     ##     doFinish()
     ##
     var sep = ":"
     printLnBiCol("Sum     : " & ff(x.sum,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Mean    : " & ff(x.mean,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Var     : " & ff(x.variance,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Var  S  : " & ff(x.varianceS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Kurt    : " & ff(x.kurtosis,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Kurt S  : " & ff(x.kurtosisS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Skew    : " & ff(x.skewness,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Skew S  : " & ff(x.skewnessS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Std     : " & ff(x.standardDeviation,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Std  S  : " & ff(x.standardDeviationS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Min     : " & ff(x.min,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Max     : " & ff(x.max,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLn("S --> sample\n",peru,xpos = xpos)

proc showRegression*(x,y: seq[float | int],n:int = 5,xpos:int = 1) =
     ## showRegression
     ##
     ## quickly display RunningRegress data based on input of two openarray data series
     ## 
     ##.. code-block:: nim
     ##    import nimcx
     ##    var a = @[1,2,3,4,5] 
     ##    var b = @[1,2,3,4,7] 
     ##    showRegression(a,b)
     ##
     ##
     var sep = ":"
     var rr :RunningRegress
     rr.push(x,y)
     printLnBiCol("Intercept     : " & ff(rr.intercept(),n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Slope         : " & ff(rr.slope(),n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Correlation   : " & ff(rr.correlation(),n),yellowgreen,white,sep,xpos = xpos,false,{})
    

proc showRegression*(rr: RunningRegress,n:int = 5,xpos:int = 1) =
     ## showRegression
     ##
     ## Displays RunningRegress data from an already formed RunningRegress
     ## 
  
     let sep = ":"
     printLnBiCol("Intercept     : " & ff(rr.intercept(),n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Slope         : " & ff(rr.slope(),n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol("Correlation   : " & ff(rr.correlation(),n),yellowgreen,white,sep,xpos = xpos,false,{})

template currentFile*: string =
  ## currentFile
  ## 
  ## returns path and current filename
  ## 
  var pos = instantiationInfo()
  pos.filename 
  
  
macro debug*(n: varargs[typed]): untyped =
  ## debug
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
  
  
     
proc dprint*[T](s:T) = 
     ## dprint
     ## 
     ## debug print  show contents of s in repr mode
     ## 
     ## usefull for debugging  (for some reason the  line number maybe off sometimes)
     ##
     echo()
     print("** REPR OUTPTUT *** ",truetomato)
     currentLine()
     echo repr(s) 
     printLn("** END REPR OUTPTUT ****",truetomato)
     echo()
    
template zipWith*[T1,T2](f: untyped; xs:openarray[T1], ys:openarray[T2]): untyped =
  ## zipWith
  ## 
  ## 
  ##.. code-block:: nim
  ##    var s1 = createSeqInt(5)
  ##    var s2 = createSeqInt(5)
  ##    var zs = zipWith(`/`,s1,s2)   # try with +,-,*,/,div...
  ##    echo zs
  ##    
  ##    
  ## original code ex Nim Forum
  ## 
  let n = min(xs.len, ys.len)
  var res = newSeq[type(f(xs[0],ys[0]))](n)
  for i, value in res.mpairs: value = f(xs[i], ys[i])
  res




proc newDir*(dirname:string) =
     ## newDir
     ##
     ## creates a new directory and provides some feedback

     if not existsDir(dirname):
          try:
            createDir(dirname)
            printLn("Directory " & dirname & " created ok",green)
          except OSError:
            printLn(dirname & " creation failed. Check permissions.",red)
     else:
        printLn("Directory " & dirname & " already exists !",red)



proc remDir*(dirname:string) =
     ## remDir
     ##
     ## deletes an existing directory , all subdirectories and files  and provides some feedback
     ##
     ## root and home directory removal is disallowed
     ##

     if dirname == "/home" or dirname == "/" :
        printLn("Directory " & dirname & " removal not allowed !",brightred)

     else:

        if existsDir(dirname):

            try:
                removeDir(dirname)
                printLn("Directory " & dirname & " deleted ok",yellowgreen)
            except OSError:
                printLn("Directory " & dirname & " deletion failed",red)
        else:
            printLn("Directory " & dirname & " does not exists !",red)



proc localTime*() : auto =
  ## localTime
  ## 
  ## quick access to local time for printing
  ## 
  result = now()


proc toDateTime*(date:string = "2000-01-01"): DateTime =
   ## toDateTime
   ## 
   ## converts a date of format yyyy-mm-dd to DateTime
   ## 
   
   var adate = date.split("-")
   let zyear = parseint(adate[0])
   var enzmonth = parseint(adate[1])
   var zmonth : Month
   case enzmonth 
      of   1: zmonth = mJan
      of   2: zmonth = mFeb
      of   3: zmonth = mMar
      of   4: zmonth = mApr
      of   5: zmonth = mMay
      of   6: zmonth = mJun
      of   7: zmonth = mJul 
      of   8: zmonth = mAug 
      of   9: zmonth = mSep 
      of  10: zmonth = mOct 
      of  11: zmonth = mNov 
      of  12: zmonth = mDec 
      else:
         printLnBiCol("Month error : Month = " & adate[1] & " ?? ",red,termwhite,0,false,{})
         printLnBiCol("Exiting now :....")
         quit(0)
   
   var zday = parseint(adate[2])
   result.year = zyear
   result.month = zmonth
   result.monthday = zday
   result
   
   
proc epochSecs*(date:string="2000-01-01"):auto =
   ## epochSecs
   ##
   ## converts a date into secs since unix time 0
   ##
   result  =  toUnix(toTime(toDateTime(date)))

  
proc checkClip*(sel:string = "primary"):string  = 
     ## checkClip
     ## 
     ## returns the newest entry from the Clipboard
     ## needs linux utility xclip installed
     ## 
     ##.. code-block:: nim
     ##     printLnBiCol("Last Clipboard Entry : " & checkClip())
     ##
          
     let (outp, errC) = execCmdEx("xclip -selection $1 -quiet -silent -o" % $sel)
     var rx = ""
     if errC == 0:
         let r = split($outp," ")
         for x in 0..<r.len:
             rx = rx & " " & r[x]
     else:
         rx = "xclip returned errorcode : " & $errC & ". Clipboard not accessed correctly"
     result = rx
       
proc toClip*[T](s:T ) = 
     # toClip
     #
     # send a string to the Clipboard using xclip
     #
     discard execCmd("echo $1 | xclip " % $s)
     


proc tableRune*[T](z:seq[T],fgr:string = truetomato,cols = 6,maxitemwidth:int=5) = 
    ## tableRune
    ##
    ## simple table routine with default 6 cols for displaying various unicode sets
    ## fgr allows color display and fgr = "rand" displays in rand color and maxwidth for displayable items
    ## this can also be used to show items of a sequence
    ##
    ##.. code-block:: nim
    ##      tableRune(cjk(),"rand")
    ##      tableRune(katakana(),yellowgreen)
    ##      tableRune(hiragana())
    ##      tableRune(geoshapes(),randcol())
    ##      tableRune(createSeqint(1000,10000,100000))
    ##      
    ##      
    var c = 0
    for x in 0..<z.len:
      inc c
      if c < cols + 1 : 
          if fgr == "rand":
                printBiCol(fmtx([">" & $6,"",">" & $maxitemwidth ,""] ,$x , " : ",  $z[x] , spaces(1)) ,colLeft=gold,colRight=randcol(),0,false,{}) 
          else:
                printBiCol(fmtx([">" & $6,"",">" & $maxitemwidth ,""] ,$x , " : ",  $z[x] , spaces(1)) ,colLeft=fgr,colRight=gold,0,false,{})     
      else:
           c = 0
           if  c mod 10 == 0: echo() 
     
    decho(2)      
    printLnBiCol("Seq Items  : 0 - " & $(z.len - 1) , colLeft=greenyellow,colRight=gold,3,false,{})  
    printLnBiCol("Item Count : " & $z.len, colLeft=greenyellow,colRight=gold,3,false,{}) 
    discard typeTest2(z)
    decho(2)


proc showSeq*[T](aseq:seq[T],fgr:string = truetomato,cols = 6,maxitemwidth:int=5) =
      ## showSeq
      ## 
      ## display contents of a seq, in case of seq of seq the first item of the sub seqs will be shown
      ## 
      tableRune(aseq)    

proc uniall*(showOrd:bool=true):seq[string] =
     # for testing purpose only
     var gs = newSeq[string]()
     for j in 1..55203: 
     
            # there are more chars up to maybe 120150 some
            # maybe for indian langs,iching, some special arab and koran symbols if installed on the system
            # https://www.w3schools.com/charsets/ref_html_utf8.asp
            # 
            # 
            # tablerune(uniall(),cols=6,maxitemwidth=12)  
            # 
            if showOrd==true: gs.add($j & " : " & $Rune(j))
            else:  gs.add($Rune(j)) 
     result = gs    
    
proc geoshapes*():seq[string] =
     ## geoshapes
     ## 
     ## returns a seq containing geoshapes unicode chars
     ## 
     var gs = newSeq[string]()
     for j in 9632..9727: gs.add($Rune(j))
     result = gs
     
proc hiragana*():seq[string] =
    ## hiragana
    ##
    ## returns a seq containing hiragana unicode chars
    var hir = newSeq[string]()
    # 12353..12436 hiragana
    for j in 12353..12436: hir.add($Rune(j)) 
    result = hir
    
   
proc katakana*():seq[string] =
    ## full width katakana
    ##
    ## returns a seq containing full width katakana unicode chars
    ##
    var kat = newSeq[string]()
    # s U+30A0–U+30FF.
    for j in parsehexint("30A0").. parsehexint("30FF"): kat.add($Rune(j))
    for j in parsehexint("31F0").. parsehexint("31FF"): kat.add($Rune(j))  # Katakana Phonetic Extensions
    result = kat



proc cjk*():seq[string] =
    ## full cjk unicode range returned in a seq
    ##
    var chzh = newSeq[string]()
    #for j in parsehexint("3400").. parsehexint("4DB5"): chzh.add($Rune(j))   # chars
    for j in parsehexint("2E80").. parsehexint("2EFF"): chzh.add($Rune(j))   # CJK Radicals Supplement
    for j in parsehexint("2F00").. parsehexint("2FDF"): chzh.add($Rune(j))   # Kangxi Radicals
    for j in parsehexint("2FF0").. parsehexint("2FFF"): chzh.add($Rune(j))   # Ideographic Description Characters
    for j in parsehexint("3000").. parsehexint("303F"): chzh.add($Rune(j))   # CJK Symbols and Punctuation
    for j in parsehexint("31C0").. parsehexint("31EF"): chzh.add($Rune(j))   # CJK Strokes
    for j in parsehexint("3200").. parsehexint("32FF"): chzh.add($Rune(j))   # Enclosed CJK Letters and Months
    for j in parsehexint("3300").. parsehexint("33FF"): chzh.add($Rune(j))   # CJK Compatibility
    for j in parsehexint("3400").. parsehexint("4DBF"): chzh.add($Rune(j))   # CJK Unified Ideographs Extension A
    for j in parsehexint("4E00").. parsehexint("9FBF"): chzh.add($Rune(j))   # CJK Unified Ideographs
    #for j in parsehexint("F900").. parsehexint("FAFF"): chzh.add($Rune(j))   # CJK Compatibility Ideographs
    for j in parsehexint("FF00").. parsehexint("FF60"): chzh.add($Rune(j))   # Fullwidth Forms of Roman Letters

    result = chzh    



proc iching*():seq[string] =
    ## iching
    ##
    ## returns a seq containing iching unicode chars
    var ich = newSeq[string]()
    for j in 119552..119638: ich.add($Rune(j))
    result = ich



proc apl*():seq[string] =
    ## apl
    ##
    ## returns a seq containing apl language symbols
    ##
    var adx = newSeq[string]()
    # s U+30A0–U+30FF.
    for j in parsehexint("2300").. parsehexint("23FF"): adx.add($Rune(j))
    result = adx

proc getColorName*[T](sc:T):string = 
   ## getColorName
   ## 
   ## this functions returns the colorname based on a color escape sequence
   ## 
   ## usually used with randcol() to see what color was actually returned
   ## 
   ## 
   ##.. code-block:: nim
   ##  import nimcx
   ##  for x in 0.. 10: 
   ##     let acol = randcol()
   ##     let acolname = getColorName(acol)         
   ##     printLn(acolname,acol)  
   ## 
   ##
   result = "unknown color"
   for x in colornames:
       if x[1] == sc:
          result = x[0]

proc getColorConst*[T](sc:T):string = 
   ## getColorConst
   ## 
   ## this functions returns the colorname constant color escape sequence based on a colorname
   ## ready to be used in print routines , it is the reverse of the getColorName function.
   ## usefull if we have colorname strings read in from a file or a sequence
   ## 
   ##.. code-block:: nim
   ##  import nimcx
   ##  var astringseq = split("lightgrey,pastelgreen,pastelpink,lightblue,goldenrod,truetomato,truetomato,white",sep=',')          
   ##  for acolor in astringseq:          
   ##      printLn("good color " & acolor , getColorConst(acolor))    
   ## 
   ##
   result = "unknown color"
   for x in colornames:
       if x[0] == sc:
          result = x[1]
          
          
proc boxChars*():seq[string] =

    ## chars to draw a box
    ##
    ## returns a seq containing unicode box drawing chars
    ##
    var boxy = newSeq[string]()
    # s U+2500–U+257F.
    for j in parsehexint("2500").. parsehexint("257F"):
        boxy.add($RUne(j))
    result = boxy
    

proc optimalbox*(w:int,s:int,tl:int):int =
    ## optimalbox
    ## 
    ## WORK IN PROGRESS
    ## 
    ## attempts to calculates best overall box width to accomodate single cells with total desired width
    ## and a minimum of s desired columns
    ## this function can be used in drawbox to calculate the width parameter
    ## 
    ##.. code-block:: nim
    ##   import nimcx
    ## 
    ##   var postop = 5
    ##   var hy = 27
    ##   var boxwidth = tw 
    ##   var hsec = 9
    ##   var boxsections = 20
    ##   var xpos = 5
    ##   var tl = 8
    ##   cleanscreen()
    ##   decho(postop)
    ##   drawBox(hy=hy, wx = optimalbox(tw - 10 ,boxsections,tl) , hsec = hsec ,vsec = boxsections,frCol = randcol(),brCol = randcol() ,cornerCol = aquamarine,xpos = xpos,blink = true)
    ##   decho(postop)
    ##   showTerminalSize()
    ##   doFinish()
    ##
    #
    result = w
    while result mod s > 0 : 
      if  tl > result div s  and result mod s == 0:
          break
      else:
          result = result - 1
        

proc drawBox*(hy:int = 1, wx:int = 1 , hsec:int = 1 ,vsec:int = 1,frCol:string = yellowgreen,brCol:string = black ,cornerCol:string = truetomato,xpos:int = 1,blink:bool = false) =
     ## drawBox
     ##
     ## WORK IN PROGRESS FOR A BOX DRAWING PROC USING UNICODE BOX CHARS
     ##
     ## Note you must make sure that the terminal is large enough to display the
     ##
     ##      box or it will look messed up
     ##
     ##
     ##.. code-block:: nim
     ##    import nimcx,unicode
     ##    cleanscreen()
     ##    decho(5)
     ##    drawBox(hy=10, wx= 60 , hsec = 5 ,vsec = 5,frCol = randcol(),brCol= black ,cornerCol = truetomato,xpos = 1,blink = false)
     ##    curmove(up=2,bk=11)
     ##    print(widedot & "NIM " & widedot,yellowgreen)
     ##    decho(5)
     ##    showTerminalSize()
     ##    doFinish()
     ##
     ##
     # http://unicode.org/charts/PDF/U2500.pdf
     # almost ok we need to find a way to to make sure that grid size is fine
     # if we use dynamic sizes like width = tw - 1 etc.
     #
     # 
     # brcol does not have any sensible effect
     # 
     #

     var h = hy
     var w = wx
     if h > th: h = th
     if w > tw: w = tw
     curSetx(xpos)
     
     # top
     if blink == true:
           print($Rune(parsehexint("250C")),cornerCol,styled = {styleBlink},substr = $Rune(parsehexint("250C")))
     else:
           print($Rune(parsehexint("250C")),cornerCol,styled = {},substr = $Rune(parsehexint("250C")))

     print(repeat($Rune(parseHexInt("2500")),w - 1) ,fgr = frcol)

     if blink == true:
           printLn($Rune(parsehexint("2510")),cornerCol,styled = {styleBlink},substr = $Rune(parsehexint("2510")))
     else:
           printLn($Rune(parsehexint("2510")),cornerCol,styled = {} ,substr = $Rune(parsehexint("2510")))


     #sides
     for x in 0.. h - 2 :
           print($Rune(parsehexint("2502")),fgr = frcol,xpos=xpos)
           printLn($Rune(parsehexint("2502")),fgr = frcol,xpos=xpos + w )


     # bottom left corner and bottom right
     if blink == true:
           print($Rune(parsehexint("2514")),cornerCol,xpos = xpos,styled = {styleBlink},substr = $Rune(parsehexint("2514")))
     else:
           print($Rune(parsehexint("2514")),fgr = cornercol,xpos=xpos)
           
     # bottom line      
     print(repeat($Rune(parsehexint("2500")),w-1),fgr = frcol)
     
     if blink == true:
           printLn($Rune(parsehexint("2518")),cornerCol,styled = {styleBlink},substr = $Rune(parsehexint("2518")))
     else:
           printLn($Rune(parsehexint("2518")),fgr=cornercol)

     # try to build some dividers
     var vsecwidth = w
     if vsec > 1:
       vsecwidth = w div vsec
       curup(h + 1)
       for x in 1..<vsec:
           print($Rune(parsehexint("252C")),fgr = truetomato,xpos=xpos + vsecwidth * x)
           curdn(1)
           for y in 0.. h - 2 :
               printLn($Rune(parsehexint("2502")),fgr = frcol,xpos=xpos + vsecwidth * x)
           print($Rune(parsehexint("2534")),fgr = truetomato,xpos=xpos + vsecwidth * x)
           curup(h)

     var hsecheight = h
     var hpos = xpos
     var npos = hpos
     if hsec > 1:
       hsecheight = h div hsec
       cursetx(hpos)
       curdn(hsecheight)

       for x in 1..<hsec:
           print($Rune(parsehexint("251C")),fgr = truetomato,xpos=hpos)
           #print a full line right thru the vlines
           print(repeat($Rune(parsehexint("2500")),w - 1),fgr = frcol)
           # now we add the cross points
           for x in 1..<vsec:
               npos = npos + vsecwidth
               cursetx(npos)
               print($Rune(parsehexint("253C")),fgr = truetomato)
           # print the right edge
           npos = npos + vsecwidth + 1
           print($Rune(parsehexint("2524")),fgr = truetomato,xpos = npos - 1)
           curdn(hsecheight)
           npos = hpos




proc randpos*():int =
    ## randpos
    ##
    ## sets cursor to a rand position in the visible terminal window
    ##
    ## returns x position
    ##
    ##.. code-block:: nim
    ##
    ##    while 1 == 1:
    ##       for z in 1.. 50:
    ##          print($z,randcol(),xpos = randpos())
    ##       sleepy(0.0015)
    ##
    curset()
    let x = getRndInt(0, tw - 1)
    let y = getRndInt(0, th - 1)
    curdn(y)
    #print($x & "/" & $y,xpos = x)
    result = x



# string splitters with additional capabilities to original split()

proc fastsplit*(s: string, sep: char): seq[string] =
  ## fastsplit
  ##
  ## code by jehan lifted from Nim Forum
  ##
  ## maybe best results compile prog with : nim cc -d:release --gc:markandsweep
  ##
  ## seperator must be a char type
  ##
  var count = 1
  for ch in s:
    if ch == sep:
        count += 1
  result = newSeq[string](count)
  var fieldNum = 0
  var start = 0
  for i in 0..high(s):
    if s[i] == sep:
       result[fieldNum] = s[start.. i - 1]
       start = i + 1
       fieldNum += 1
  result[fieldNum] = s[start..^1]



proc splitty*(txt:string,sep:string):seq[string] =
   ## splitty
   ##
   ## same as build in split function but this retains the
   ##
   ## separator on the left side of the split
   ##
   ## z = splitty("Nice weather in : Djibouti",":")
   ##
   ## will yield:
   ##
   ## Nice weather in :
   ## Djibouti
   ##
   ## rather than:
   ##
   ## Nice weather in
   ## Djibouti
   ##
   ## with the original split()
   ##
   ##
   var rx = newSeq[string]()
   let z = txt.split(sep)
   for xx in 0..<z.len:
     if z[xx] != txt and z[xx] != nil:
        if xx < z.len-1:
             rx.add(z[xx] & sep)
        else:
             rx.add(z[xx])
   result = rx


proc doFlag*[T](flagcol:string = yellowgreen,flags:int = 1,text:T = "",textcol:string = termwhite) : string {.discardable.} =
  ## doFlag
  ## 
  ##.. code-block:: nim
  ##   import nimcx
  ##   
  ##   # print word Hello : in color dodgerblue followed by 6 little flags in red 
  ##   # and the word alert in color truetomato followed by 6 little flags in red
  ##   
  ##   print("Hello :  " & doflag(red,6,"alert",truetomato) & spaces(1) & doflag(red,6), dodgerblue)
  ##   
  ##   

  result = ""
  for x in 0..<flags: result = result & flagcol & fullflag 
  result = result & spaces(1) & textcol & $text & white
   
  
  
proc showTerminalSize*() =
      ## showTerminalSize
      ##
      ## displays current terminal dimensions
      ##
      ## width is always available via tw
      ##
      ## height is always available via th
      ##
      ##
      cechoLn(yellowgreen,"[Terminal Size] " & lime & " W " & white & $tw & red & " x" & lime & " H " & white & $th)


# Info and handlers procs for quick information

template infoProc*(code: untyped) =
  ## infoProc
  ## 
  ## shows from where a specific function has been called and combined with checkLocals gives
  ## a nice formatted output for debugging
  ##
  ##.. code-block:: nim
  ##    proc test1[T](ff:varargs[T,`$`]) =
  ##      let yu1 = @["test"]
  ##      var yu2 = "sdfsdf"
  ##      var yu3 = parseInt(ff[1]) * 3  # ff[1] has been converted to string we change it back to int and multiply
  ##      print("test output    : ",lime)
  ##      for x in ff: print(x & spaces(1)) # print the passed in varargs
  ##      checklocals()
  ##      
  ##    proc test2(s:string,b:int) : string =   
  ##       var bb = b * getRndInt(10,200)
  ##       result = s & $bb
  ##       checklocals()
  ##      
  ##    infoproc(test1("zz",1234,789.88))
  ##    infoproc:
  ##        printLnBiCol(fmtx(["","",""],"Test2 output  : ",rightarrow & spaces(1),test2("nice",2000)),colLeft = cyan,colRight=gold,":",0,false,{})
  ##    doFinish()
  ##
  ##
  ##     
  try:
      let pos = instantiationInfo()
      code
      printLnBiCol("[infoproc    -->] $1 Line: $2 with: '$3'" % [pos.filename,$pos.line, astToStr(code)],colLeft=gold,colRight=bblack,"]",0,false,{})
  except:
      printLnBiCol("Error: Checking instantiationInfo ",colLeft=red)
      discard

proc `$`(T: typedesc): string = name(T)
template checkLocals*() =
  ## checkLocals
  ## 
  ## check name,type and value of local variables
  ## needs to be called inside a proc calling from toplevel has no effect
  ## best placed at bottom end of a proc to pick up all Variables
  ## 
  echo()
  dlineLn(100)
  for name, value in fieldPairs(locals()): 
      print("[checkLocals -->] ",gold) 
      printLnBiCol(fmtx(["","<20","","","","","<25","","","","",""],"Variable : ",$name,spaces(3),peru,"Type : ",termwhite,$type(value),spaces(1),aqua,"Value : ",termwhite,$value))
  

proc qqTop*() =
  ## qqTop
  ##
  ## prints qqTop in custom color
  ##
  print("qq",cyan)
  print("T",brightgreen)
  print("o",brightred)
  print("p",cyan)

  
#experimental  font code here


# experimental font building  


template cxZero*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 7,coltop,xpos = xpos)
         printLn2(efb2 * 7,col,xpos = xpos)
         loopy(0..2,printLn2(efb2 * 2 & spaces(3) & efb2 * 2 ,col,xpos = xpos))
         printLn2(efb2 * 7,col,xpos = xpos)
         curup(6)         
          
template cx1*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
          let xpos = npos+5
          printLn2(spaces(4) & efb3 * 2 ,coltop,xpos=xpos)
          printLn2(spaces(3) & efb1 & efb2 * 2 ,col,xpos=xpos)
          printLn2(spaces(1) & efb1 & spaces(2) & efb2 * 2 ,col,xpos=xpos)
          printLn2(spaces(4) & efb2 * 2 ,col,xpos=xpos)
          printLn2(spaces(4) & efs2 * 2,col,xpos=xpos)
          printLn2(spaces(4) & efb2 * 2 ,col,xpos=xpos)
          curup(6) 
           
           
template cx2*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4 & spaces(4),coltop,xpos = xpos)
         printLn2(spaces(1) & efs2 & efb1 * 4 & efs2 & spaces(2),col,xpos = xpos)
         printLn2(spaces(6) & efs2 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(2) & efs2 * 3  & efb1 & spaces(3),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1  & spaces(4)  & spaces(2),col,xpos = xpos)
         printLn2(spaces(1) & efb1 * 1 & efb2 * 4  & efb1 * 1 & spaces(2),col,xpos = xpos)
         curup(6) 
 
        
           
            
template cx3*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

        let xpos = npos+5
        printLn2(spaces(1) & efb3 * 6,coltop,xpos=xpos)
        printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
        printLn2(spaces(5) & efb2 * 2,col,xpos=xpos)
        printLn2(spaces(3) & efs2 * 3 & spaces(1),col,xpos=xpos)
        printLn2(spaces(5) & efb2 * 2,col,xpos=xpos)
        printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
        curup(6)      


template cx4*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
        let xpos = npos+5
        printLn2(spaces(5) & efb3 * 1,coltop,xpos=xpos)
        printLn2(spaces(5) & efb2 * 1,col,xpos=xpos)
        printLn2(spaces(3) & efb1 * 1 & spaces(1) & efs2 & spaces(3),col,xpos=xpos)
        printLn2(spaces(1) & efs2 * 1 & spaces(3) & efb2,col,xpos=xpos)
        printLn2(spaces(0) & efs2 * 1 & spaces(1) & efs2 & spaces(1) & efs2 * 4,col,xpos=xpos)
        printLn2(spaces(4) & efb2 * 2,col,xpos=xpos)
        curup(6)               
            
           
              
template cx5*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 5 & spaces(4),coltop,xpos = xpos)
         printLn2(spaces(1) & efs2 & efb1 * 5 & spaces(2),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1 & spaces(7),col,xpos = xpos)
         printLn2(spaces(1) & efb1 & spaces(0) & efs2 * 2 & spaces(1) & efs2 & spaces(3),col,xpos = xpos)
         printLn2(spaces(6) & efb1 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(1) & efb1 * 1 & efb2 * 3  & efb1 & spaces(3),col,xpos = xpos)
         curup(6)               
                            
              
              
              
template cx6*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4 & spaces(4),coltop,xpos = xpos)
         printLn2(spaces(1) & efs2 & efb1 * 4 & spaces(3),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1 & spaces(7),col,xpos = xpos)
         printLn2(spaces(1) & efb2 & spaces(1) & efs2 * 1 & spaces(1) & efs2 & spaces(3),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1 & spaces(4) & efb1 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(2) & efb1 & efb2 * 2  & efb1 & spaces(3),col,xpos = xpos)
         curup(6)               
              
     
              
template cx7*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 7,coltop,xpos = xpos)
         printLn2(efb2 * 7,col,xpos = xpos)
         printLn2(spaces(5) & efs2 * 1  & efb1 ,col,xpos = xpos)
         loopy(0..2,printLn2(spaces(4) & efb2 * 2 ,col,xpos = xpos))
         curup(6)  
 

template cx8*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4 & spaces(4),coltop,xpos = xpos)
         printLn2(spaces(1) & efs2 & efb1 & efb1 * 2  & efb1 & efs2 & spaces(2),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1  & spaces(4) & efs2 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(2) & efb1 &  efs2 * 2  & efb1 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(1) & efs2 * 1  & spaces(4) & efs2 * 1 & spaces(1),col,xpos = xpos)
         printLn2(spaces(2) & efb1 & efb2 * 2  & efb1 & spaces(3),col,xpos = xpos)
         curup(6) 
 
 
 
 
template cx9*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(1) & efb3 * 6,coltop,xpos = xpos)
         printLn2(efs2 & efb1 * 3 & efb2 * 3,col,xpos = xpos)
         printLn2(spaces(0) & efs2 * 1  & spaces(4) & efb2 * 2,col,xpos = xpos)
         printLn2(spaces(1) & efb1 &  efs2 * 3 & efb1 * 2,col,xpos = xpos)
         loopy(0..1,printLn2(spaces(5) & efb2 * 2 ,col,xpos = xpos))
         curup(6)  
 
 
 
proc cx10*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =
     cx1(npos,col,coltop)
     cxzero(npos + 9,col,coltop)
 
 
 
template cxa*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
        let xpos = npos + 5
        printLn2(spaces(4) & efb3 * 2 & spaces(3), coltop,xpos=xpos)
        printLn2(spaces(4) & efb2 * 2,col,xpos=xpos)
        printLn2(spaces(2) & efb2 * 2 & spaces(2) & efb2 * 2,col,xpos=xpos)
        printLn2(spaces(2) & efs2 * 6 ,col,xpos=xpos)
        printLn2(spaces(1) & efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
        printLn2(spaces(1) & efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
        curup(6)
                      
            
template cxb*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 5, coltop,xpos=xpos)
         printLn2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         printLn2(efb2 * 3 & efs2 &  spaces(0) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         printLn2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         curup(6)

template cxc*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

        let xpos = npos+5
        printLn2(spaces(1) & efb3 * 6,coltop,xpos=xpos)
        printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
        printLn2(efb2 * 2,col,xpos=xpos)
        printLn2(efs2 * 2,col,xpos=xpos)
        printLn2(efb2 * 2,col,xpos=xpos)
        printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
        curup(6)
              
              
template cxd*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 5, coltop,xpos=xpos)
         println2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         println2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         println2(efb2 * 2 & spaces(4) & efs2,col,xpos=xpos)
         println2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         println2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         curup(6)

         
  
template cxe*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 7, coltop,xpos=xpos)
         printLn2(efb2 * 7, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 5, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 7, col,xpos=xpos)
         curup(6)  
 
template cxf*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 7, coltop,xpos=xpos)
         printLn2(efb2 * 7, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 5, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         curup(6)  
 

template cxg*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 

        let xpos = npos+5
        printLn2(spaces(1) & efb3 * 6,coltop,xpos=xpos)
        printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
        printLn2(efb2 * 2,col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(2) & efs2 * 3,col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(3) & efb2 * 2,col,xpos=xpos)
        printLn2(spaces(1) & efb2 * 6,col,xpos=xpos)
        curup(6)
             
template cxh*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
        let xpos = npos + 5
        printLn2(efb3 * 2 & spaces(4) & efb3 * 2, coltop,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & efs2 * 4 & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        curup(6)   
 
template cxi*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    

        loopy2(0,2):
           let xpos = xloopy+npos+7
           printLn2(efb3 ,coltop,xpos=xpos)
           loopy(0..4,printLn2(efb2,col,xpos=xpos))
           curup(6)
           
             
template cxj*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    

        loopy2(0,2):
           let xpos = xloopy+npos+5
           printLn2(spaces(2) & efb3 * 2 ,coltop,xpos=xpos)
           loopy(0..2,printLn2(spaces(2) & efb2 * 2,col,xpos=xpos))
           printLn2(efs2 & spaces(1) & efb2 * 2,col,xpos = xpos)
           printLn2(spaces(1) & efb2 & efb2,col,xpos=xpos)
           curup(6) 
           
           
           
template cxk*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
           let xpos = npos+5
           printLn2(efb3 * 2 & spaces(4) & efb3 * 2,coltop,xpos=xpos)
           printLn2(efb2 * 2 & spaces(4) & efb1 * 2,col,xpos=xpos)
           printLn2(efb2 * 2 & spaces(2) & efs2 * 2,col,xpos=xpos)
           printLn2(efb2 * 2 & efs2 * 2,col,xpos=xpos)
           printLn2(efb2 * 2 & spaces(2) & efs2 * 2,col,xpos=xpos)
           printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
           curup(6)          
         
template cxl*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 2, coltop,xpos=xpos)
         printLn2(efb2 * 2, col,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 7, col,xpos=xpos)
         curup(6)
              
template cxm*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
        let xpos = npos + 5
        printLn2(efb3 * 2 & spaces(5) & efb3 * 2, coltop,xpos=xpos)
        printLn2(efb2 * 2 & efs2 & spaces(3) & efs2 & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(1) & efs2 & spaces(1) & efs2 & spaces(1) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(2) & efs2 & spaces(2) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(5) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(5) & efb2 * 2, col,xpos=xpos)
        curup(6) 
        
template cxn*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
        let xpos = npos + 5
        printLn2(efb3 * 2 & spaces(4) & efb3 * 2, coltop,xpos=xpos)
        printLn2(efb2 * 2 & efs2 & spaces(3) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(1) & efs2 & spaces(2) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(2) & efs2 & spaces(1) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(3) & efs2 & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(4) & efb2 * 2, col,xpos=xpos)
        curup(6)  
 
template cxo*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4, coltop,xpos=xpos)
         printLn2(spaces(2) & efb2 * 4, col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(2) & efb2 * 3 & efb2,col,xpos=xpos)
         curup(6) 
          
template cxp*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 5, coltop,xpos=xpos)
         printLn2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2,col,xpos=xpos)
         printLn2(efb2 * 3 & efs2 &  spaces(0) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 2,col,xpos=xpos)
         curup(6)
   
       
 
template cxq*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(2) & efb3 * 4, coltop,xpos=xpos)
         printLn2(spaces(2) & efb2 * 3 & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(3) & efs2 & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(2) & efb2 * 3 & efb2 & "\\",col,xpos=xpos)
         curup(6) 

template cxr*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 5, coltop,xpos=xpos)
         printLn2(efb2 * 4 & spaces(1) & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(3) & efb3 & efb2,col,xpos=xpos)
         printLn2(efb2 * 2 & efs2 * 2 &  spaces(0) & efs2 * 1,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(1) & efs2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(3) & efb2 * 2,col,xpos=xpos)
         curup(6)
 
template cxs*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(spaces(3) & efb3 * 5, coltop,xpos=xpos)
         printLn2(spaces(1) & efb1 & spaces(1) & efb1 * 5,col,xpos=xpos)
         printLn2(efb1 * 1 & spaces(1) & efs2 * 1 ,col,xpos=xpos)
         printLn2(spaces(4) & efb1 & efs2 * 1 ,col,xpos=xpos)
         printLn2(spaces(5) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 5 &  efs2  * 1 & efb1  * 1 ,col,xpos=xpos)
         curup(6)  
  
 
template cxt*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 8, coltop,xpos=xpos)
         printLn2(efb2 * 8,col,xpos=xpos)
         loopy(0..3,printLn2(spaces(3) & efb2 * 2 ,col,xpos=xpos))
         curup(6)   
         
            
         
template cxu*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 2 & spaces(4) & efb3 * 2,coltop,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 6 ,col,xpos=xpos)
         curup(6)         
         

         
template cxv*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 2 & spaces(4) & efb3 * 2,coltop,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efb2 * 2,col,xpos=xpos)
         printLn2(efb2 * 2 & spaces(4) & efs2 * 2,col,xpos=xpos)
         printLn2(spaces(1) & efb2 * 2 & spaces(2) & efb2 * 2,col,xpos=xpos)
         printLn2(spaces(3) & efb2 * 2 ,col,xpos=xpos)
         curup(6)          
         
         
template cxw*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) =
        let xpos = npos + 5
        printLn2(efb3 * 2 & spaces(5) & efb3 * 2, coltop,xpos=xpos)
        printLn2(efb2 * 2 & spaces(5) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(5) & efb2 * 2, col,xpos=xpos)
        printLn2(efb2 * 2 & spaces(2) & efs2 & spaces(2) & efb2 * 2, col,xpos=xpos)
        printLn2(spaces(1) & efb1 * 2 & spaces(0) & efs2 &  spaces(1) & efs2 & spaces(0) & efb1 * 2, col,xpos=xpos)
        printLn2(spaces(2) & efb2 * 2 &  spaces(1) & efb2 * 2, col,xpos=xpos)
        curup(6)          
 
              
template cxx*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
        let xpos = npos+5
        printLn2(spaces(1) & efb3 * 2 & spaces(3) & efb3 * 2 & spaces(1) ,coltop,xpos=xpos)
        printLn2(spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2 & spaces(1) ,col,xpos=xpos)
        printLn2(spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2 & spaces(2) ,col,xpos=xpos)
        printLn2(spaces(4) & efl1 * 2 & spaces(4),col,xpos=xpos)
        printLn2(spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2 & spaces(2) ,col,xpos=xpos)
        printLn2(spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2 & spaces(1) ,col,xpos=xpos)
        curup(6)

            
            
                   
template cxy*(npos:int=0,col: string=rndCol(),coltop:string = rndCol()) = 
        let xpos = npos + 5
        printLn2(spaces(1) & efb3 * 2 & spaces(3) & efb3 * 2, coltop,xpos=xpos)
        printLn2(spaces(1) & efb2 * 2 & spaces(3) & efb2 * 2,col,xpos=xpos)
        printLn2(spaces(2) & efs2 * 2 & spaces(1) & efs2 * 2,col,xpos=xpos)
        printLn2(spaces(4) & efl1 * 2,col,xpos=xpos)
        printLn2(spaces(4) & efl1 * 2,col,xpos=xpos)
        printLn2(spaces(3) & efl1 * 4,col,xpos=xpos)
        curup(6)
             

 
template cxz*(npos:int=0,col:string=rndCol(),coltop:string = rndCol()) = 
      
         let xpos = npos + 5
         printLn2(efb3 * 8, coltop,xpos=xpos)
         printLn2(efb2 * 8,col,xpos=xpos)
         printLn2(spaces(6) & efb2 * 2 ,col,xpos=xpos)
         printLn2(spaces(3) & efb2 * 2 ,col,xpos=xpos)
         printLn2(spaces(0) & efb2 * 2 ,col,xpos=xpos)
         printLn2(efb2 * 8,col,xpos=xpos)    
         curup(6)
 
 
 
template cxpoint*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
           let xpos = npos+5
           printLn2(efb3 * 0 ,coltop,xpos=xpos)
           printLn2(efb2 * 0 ,col,xpos=xpos)
           printLn2(efb2 * 0 ,col,xpos=xpos)
           printLn2(efb2 * 0 ,col,xpos=xpos)
           printLn2(efb3 * 2 ,coltop,xpos=xpos)
           printLn2(efb2 * 2 ,col,xpos=xpos)
           curup(6)   
 
 
 
template cxhyphen*(npos:int = 0,col:string=rndCol(),coltop:string = rndCol()) =    
       
           let xpos = npos+5
           printLn2(efb3 * 0 ,coltop,xpos=xpos)
           printLn2(efb2 * 0 ,col,xpos=xpos)
           printLn2(efb3 * 5 ,coltop,xpos=xpos)
           printLn2(efb2 * 5 ,col,xpos=xpos)
           printLn2(efb2 * 0 ,coltop,xpos=xpos)
           printLn2(efb2 * 0 ,col,xpos=xpos)
           curup(6)    
       
template cxgrid*(npos:int = 0,col:string=rndCol(),coltop:string = lime) =    
           # for testing purpose
           let xpos = npos+5
           let xwd  = 9
           loopy2(0,xwd): 
             print(efb3  ,coltop,xpos=xpos + xloopy)
           echo()
           loopy2(0,5):
               loopy2(0,xwd) :
                  print(efb2 ,rndCol2(col),xpos=xpos + xloopy)
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
        
        npos += 10
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

            
#proc printFontFancy*(s:string,col:string = rndcol(),coltop:string = rndcol(), xpos:int = -10) = 
     
proc printFontFancy*(s:string, coltop1 = rndcol(),xpos:int = -10) = 
     ## printFontFancy
     ## 
     ## display experimental cxfont with every element in rand color
     ## changeing of coltop color possible
     ## 
     ## 
     ## 
     var npos = xpos
     var coltop = rndTrueCol()
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
  

proc doInfo*() =
  ## doInfo
  ##
  ## A more than you want to know information proc
  ##
  ##
  
  let filename= extractFileName(getAppFilename())
  let modTime = getLastModificationTime(filename)
  let sep = ":"
  superHeader("Information for file " & filename & " and System " & spaces(22))
  printLnBiCol("Last compilation on           : " & CompileDate &  " at " & CompileTime,yellowgreen,lightgrey,sep,0,false,{})
  # this only makes sense for non executable files
  #printLnBiCol("Last access time to file      : " & filename & " " & $(fromSeconds(int(getLastAccessTime(filename)))),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Last modificaton time of file : " & filename & " " & $(fromUnix(int(modTime))),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Offset from UTC in hours      : " & cxTimeZone(),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("UTC Time                      : " & $now().utc,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Local Time                    : " & $now().local,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Environment Info              : " & os.getEnv("HOME"),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("TrueColor                     : " & $checktruecolorsupport(),goldenrod,lightgrey,sep,0,false,{})
  printLnBiCol("File exists                   : " & $(existsFile filename),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Dir exists                    : " & $(existsDir "/"),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("AppDir                        : " & getAppDir(),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("App File Name                 : " & getAppFilename(),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("User home  dir                : " & os.getHomeDir(),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Config Dir                    : " & os.getConfigDir(),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Current Dir                   : " & os.getCurrentDir(),yellowgreen,lightgrey,sep,0,false,{})
  let fi = getFileInfo(filename)
  printLnBiCol("File Id                       : " & $(fi.id.device) ,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("File No.                      : " & $(fi.id.file),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Kind                          : " & $(fi.kind),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Size                          : " & $(float(fi.size)/ float(1000)) & " kb",yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("File Permissions              : ",yellowgreen,lightgrey,sep,0,false,{})
  for pp in fi.permissions:
      printLnBiCol("                              : " & $pp,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Link Count                    : " & $(fi.linkCount),yellowgreen,lightgrey,sep,0,false,{})
  # these only make sense for non executable files
  printLnBiCol("Last Access                   : " & $(fi.lastAccessTime),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Last Write                    : " & $(fi.lastWriteTime),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Creation                      : " & $(fi.creationTime),yellowgreen,lightgrey,sep,0,false,{})
  
  when defined windows:
        printLnBiCol("System                        : Windows..... Really ??",red,lightgrey,sep,0,false,{})
  elif defined linux:
        printLnBiCol("System                        : Running on Linux" ,brightcyan,yellowgreen,sep,0,false,{})
  else:
        printLnBiCol("System                        : Interesting Choice" ,yellowgreen,lightgrey,sep,0,false,{})

  when defined x86:
        printLnBiCol("Code specifics                : x86" ,yellowgreen,lightgrey,sep,0,false,{})

  elif defined amd64:
        printLnBiCol("Code specifics                : amd86" ,yellowgreen,lightgrey,sep,0,false,{})
  else:
        printLnBiCol("Code specifics                : generic" ,yellowgreen,lightgrey,sep,0,false,{})

  printLnBiCol("Nim Version                   : " & $NimMajor & "." & $NimMinor & "." & $NimPatch,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Processor count               : " & $cpuInfo.countProcessors(),yellowgreen,lightgrey,sep,0,false,{})
  printBiCol("OS                            : "& hostOS,yellowgreen,lightgrey,sep,0,false,{})
  printBiCol(" | CPU: "& hostCPU,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol(" | cpuEndian: "& $cpuEndian,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("CPU Cores                     : " & $cpuInfo.countProcessors())
  printLnBiCol("Current pid                   : " & $getpid(),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Terminal encoding             : " & $getCurrentEncoding())
  

proc infoLine*() =
    ## infoLine
    ##
    ## prints some info for current application
    ##
    hlineLn()
    print(fmtx(["<14"],"Application:"),yellowgreen)
    print(extractFileName(getAppFilename()),brightblack)
    print(" | ",brightblack)
    print("Nim : ",lime)
    print(NimVersion & " | ",brightblack)
    print("cx : ",peru)
    print(CXLIBVERSION,brightblack)
    print(" | ",brightblack)
    print($someGcc & " | ",brightblack)
    print("Size : " & ff2(float(getfilesize(getAppFilename())) / 1000.0) & " Kb",peru) # appears to be approximate
    print(" | ",brightblack)
    qqTop()


proc doByeBye*() =
  ## doByeBye
  ##
  ## a simple end program routine do give some feedback when exiting
  ##  
  decho(2)  
  print("Exiting now !  ",lime)
  printLn("Bye-Bye from " & extractFileName(getAppFilename()),red)
  printLn(yellowgreen & "Mem -> " &  lightsteelblue & "Used : " & white & ff2(getOccupiedMem()) & lightsteelblue & "  Free : " & white & ff2(getFreeMem()) & lightsteelblue & "  Total : " & white & ff2(getTotalMem() ))
  doFinish()

  
   
proc showCxTrueColorPalette*(min:int=0,max:int = 888,step: int = 12,flag48:bool = false) {.inline.} = 
   ## showCxTrueColorPalette
   ## 
   ## 
   ## Experimental
   ## 
   ## play with truecolors
   ## 
   ## shows truecolors ,in order not run out of memory adjust max and sep carefully 
   ## e.g max 888 step 4 needs abt 4.3 GB free and has  22,179,134 color shades to select from
   ## default has 421,750 palette entries in cxTruecCol 
   ## 
   ## cxTrueCol is a initial empty global defined in cx.nim which will only be filled
   ## with a call to getCxTrueColorSet() ,also see there how the Palette is build up
   ## 
   ## 
   ## press ctrl-c if showTrueColorPalette runs too long ....
   ## 


   var astep = step
   while max mod astep <> 0: astep = astep + 1
   if getcxTrueColorSet(min = min,max = max,step = astep,flag48 = flag48) == true:
      # controll the size of our truecolor cache 
      # default max 888, increase by too much we may have memory issues
      # defaul step 12 , decrease by too much we may have memory issues  tested with steps 4 - 16 ,
      # smaller steps need longer compile time 
      
      let cxtlen = $(cxTruecol.len)
      var testLine = newcxline()
      for lcol in countup(0,cxTruecol.len - 1,2): # note step size 2 so we only select 38 type colors
            var tcol  = color38(cxTrueCol)
            var bcol  = color38(cxTrueCol)
            var dlcol = color38(cxTrueCol)
            var drcol = color38(cxTrueCol)
            testLine.startpos = 5  
            testLine.endpos = 100
            testLine.linecolor        = cxTrueCol[lcol]
            testLine.textbracketcolor = cxTrueCol[bcol]
            testLine.dotleftcolor     = cxTrueCol[dlcol]
            testLine.dotrightcolor    = cxTrueCol[drcol]
            testLine.textpos = 8
            testLine.text = fmtx(["<20","<14",">8",""], "Testing" ,"cxTruecolor : " ,$lcol," of " & cxtlen & spaces(1))
            testLine.textcolor = cxTrueCol[lcol]  # change this to tcol to have text in a random truecolor
            testLine.textstyle = {styleReverse}
            testLine.newline = "\L"                  # need a new line character here or we overwrite 
            printCxLine(testLine)
      
      printLnBicol("\n    Note            : cxTrueColor Value can be used like so : cxTrueCol[value] ",colLeft = truetomato)
      printLnBiCol("\n    Palette Entries : " & ff2(cxTruecol.len),colLeft = truetomato,colRight = lime)   
      

# code below borrowed from distros.nim  and made exportable 
var unameRes, releaseRes: string                      

template unameRelease(cmd, cache): untyped =
  if cache.len == 0:
     cache = (when defined(nimscript): gorge(cmd) else: execProcess(cmd))
  cache

template uname*(): untyped = unameRelease("uname -a", unameRes)
template release*(): untyped = unameRelease("lsb_release -a", releaseRes)
# end of borrow  

proc theEnd*() =
  # moving the end
  loopy2(0,2):
     loopy2(-10,30):
       printfontfancy("THE END",xpos = xloopy)
       sleepy(0.02)
       cleanscreen()
  printfontfancy("qqtop",coltop1 = red,xpos = tw div 3 - 20)     
  decho(10)



proc doFinish*() =
    ## doFinish
    ##
    ## a end of program routine which displays some information
    ##
    ## can be changed to anything desired
    ##
    ## and should be the last line of the application
    ##
    {.gcsafe.}:
        decho(2)
        infoLine()
        printLn(" - " & year(getDateStr()),brightblack)
        print(fmtx(["<14"],"Elapsed    : "),yellowgreen)
        print(fmtx(["<",">5"],ff(epochtime() - cxstart,3)," secs"),goldenrod)
        printLnBiCol("  Compiled on: " & $CompileDate & " at " & $CompileTime)
        if detectOs(OpenSUSE):  # some additional data if on openSuse systems
            let ux1 = uname().split("#")[0].split(" ")
            printLnBiCol("Kernel     :  " &  ux1[2] & "  Computer : " & ux1[1] & "  System : " & ux1[0],yellowgreen,lightslategray,":",0,false,{})
            let rld = release().splitLines()
            let rld3 = rld[2].splitty(":")
            let rld4 = rld3[0] & spaces(2) & strip(rld3[1])
            printBiCol(rld4,yellowgreen,lightslategray,":",0,false,{})
            printLnBiCol(spaces(3) & rld[3],yellowgreen,lightslategray,":",0,false,{})
        echo()
        GC_fullCollect()  # just in case anything hangs around
        quit(0)

        
proc handler*() {.noconv.} =
    ## handler
    ##
    ## exit handler this runs if ctrl-c is pressed
    ##
    ## and provides some feedback upon exit
    ##
    ## just by using this module your project will have an automatic
    ##
    ## exit handler via ctrl-c
    ##
    ## this handler may not work if code compiled into a .dll or .so file
    ##
    ## or under some circumstances like being called during readLineFromStdin
    ##
    ##
    eraseScreen()
    echo()
    hlineLn()
    cechoLn(yellowgreen,"Thank you for using        : " & getAppFilename())
    hlineLn()
    printLnBiCol(fmtx(["<","<11",">9"],"Last compilation on        : " , CompileDate , CompileTime),brightcyan,termwhite,":",0,false,{})
    printLnBiCol(fmtx(["<","<11",">9"],"Exit handler invocation at : " , cxtoday() , getClockStr()),pastelorange,termwhite,":",0,false,{})
    hlineLn()
    printBiCol("Nim Version   : " & NimVersion)
    print(" | ",brightblack)
    printLnBiCol("cx Version     : " & CXLIBVERSION)
    print(fmtx(["<14"],"Elapsed       : "),yellow)
    printLn(fmtx(["<",">5"],epochTime() - cxstart,"secs"),brightblack)
    echo()
    printLn(" Have a Nice Day !",clRainbow)  ## change or add custom messages as required
    decho(2)
    system.addQuitProc(resetAttributes)
    quit(0)



proc doCxEnd*() =
  clearup()
  decho(2)
  doInfo()
  clearup()
  decho(3)
  colorio()
  let smm = "      import nimcx and your terminal comes alive with color...  "
  loopy2(0,6):
        cleanScreen()
        decho(2)
        printNimCx()
        decho(8)
        printMadeWithNim()
        decho(8)
        print(innocent,truetomato)
        for x in 0..<(tw - 3) div runeLen(innocent) div 2: print(innocent,rndCol())
        print(innocent,truetomato)
        sleepy(0.15)
        curup(1)
  echo() 
 
  doFinish()

# putting decho here will put two blank lines before anyting else runs
decho(2)
# putting this here we can stop most programs which use this lib and get the
# automatic exit messages , it may not work in tight loops involving execCMD or
# waiting for readLine() inputs.
setControlCHook(handler)

#uncomment following line to have global support for cxTrueCol inside cx if needed
getcxTrueColorSet()         # preload the cxTrueCol seq in default mode
#checktruecolorsupport()    # comment out if above line uncommented
# this will reset any color changes in the terminal
# so no need for this line in the calling prog
system.addQuitProc(resetAttributes)

when isMainModule:  doCxEnd()
    
   
# END OF CX.NIM #
