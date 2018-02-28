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
##     Latest      : 2018-02-26 re-adjust version
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
##                   Currently the library consists of 
##                   
##                   cx.nim , cxconsts.nim , cxglobal, cxprint , cxfont , cxhash ,
##                   
##                   cxtime , cxtruecolor and cxutils.nim , 
##                   
##                   all files are automatically imported with : import nimcx
##                          
##
##     Usage       : import nimcx
##
##     Project     : `NimCx <https://github.com/qqtop/NimCx>`_
##
##     Docs        : `Documentation <https://qqtop.github.io/cx.html>`_
##
##     Tested      : OpenSuse Tumbleweed (KDE) , Parrotsec (Debian Testing)
##       
##                   Terminal set encoding to UTF-8  
##
##                   with var. terminal font : hack,monospace size 9.0 - 15  
##
##                   xterm,konsole,gnome terminals, mate terminal etc. support truecolor ok
##                   
##                   however for maximum color support use konsole 
##                   
##     Important   : Konsole , which can be installed in gnome,mate etc.and comes standard in KDE environments.
##
##                   If the color effects are not here ... change the terminal.
##                   
##                   Gnome terminals auto adjust colors not in colorNames see cxConsts.nim
##
##                   so a command like : 
##                   
##                   printLn("Nice color 123",newColor(990,9483,88))
##                   
##                   may give you a deep red fontcolor in konsole , but will only show in
##                   
##                   boring white on a gnome based terminal.
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
##                   for printing of multiple columns in the terminal the print2,printLn2,printBiCol2,printLnBiCol2
##                   
##                   routines should be used.  
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

import cxconsts,cxglobal,cxtime,cxprint,cxhash,cxfont,cxtruecolor,cxutils,cxnetwork

import os,osproc,times,random,strutils,strformat,parseutils, parseopt 
import tables,sets,rdstdin,macros
import posix,terminal,math,stats,json,streams,options,memfiles
import sequtils,httpclient,rawsockets,browsers,intsets,algorithm
import unicode,typeinfo,typetraits,cpuinfo,colors,encodings,distros

export cxconsts,cxglobal,cxtime,cxprint,cxhash,cxfont,cxtruecolor,cxutils,cxnetwork

export os,osproc,times,random,strutils,strformat,sequtils,unicode,streams
export terminal,colors,options,json,httpclient,stats,rdstdin,parseopt


# Profiling       
#import nimprof  # nim c -r --profiler:on --stackTrace:on cx

# Profiling with valgrind
#nim c -d:release <source file>
#valgrind --tool=callgrind -v ./<program file> <arguments>
#kcachegrind callgrind.out.<some number>    # or maybe qcachegrind

# Memory usage
# --profiler:off, --stackTrace:on -d:memProfiler  

# for debugging intersperse with dprint(someline)
# or see the stacktrace with writeStackTrace()
# or compile with  --debugger:on 
# or see infoproc() in cxglobal.nim

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
         cxerrormsg:string
     # to be used like so , but not6 in use yet
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
      
     
# type used for cxtimer results
type
    Cxtimerres* = tuple[tname:string,
                        start:float,
                        stop :float,
                        lap  :seq[float]]

    Cxcounter* =  object
             value*: int                        

# used to store all cxtimer results 
var cxtimerresults* =  newSeq[Cxtimerres]() 


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


proc spellInteger*(n: int64): string    # forward declaration
proc doFinish*()                        # forward declaration
  
# char converters
converter toInt(x: char): int = result = ord(x)
converter toChar(x: int): char = result = chr(x)  

proc sampleSeq*[T](x: seq[T], a:int, b: int) : seq[T] = 
     ## sampleSeq
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

     

proc newColor*(r,g,b:int):string = "\x1b[38;2;$1;$2;$3m" % [$r,$g,$b]
##   newColor
##   
##   creates a new color string from r,g,b values passed in
##   colors can be used as foregroundcolor in print,printLn routines
##   and as bgr in cxPrint,cxPrintLn 
##.. code-block:: nim
##   import nimcx
##   printLn("Test for rgb color 12345  " & efb2 * 10,newColor(27354,4763,1089))
##   decho(2)
##   printLn("Test for rgb color 12345  " & efb2 * 10,newColor(73547,4873,4888))
##   decho(2)
##   printLn("Test for rgb color 12345  " & efb2 * 10,newColor(990,483,38),bgblue)
##   decho(2)
##   cxPrintLn("Test cxprintln test 12345 " &  efb2 * 10,fontcolor = colBlue,bgr=newcolor(990,5483,38))
##   cxPrintLn("Test cxprintln test 12345 " &  efb2 * 10,fontcolor = colBlue,bgr=newcolor(9390,5483,38))
##   cxPrintLn("Test cxprintln test 12345 " &  efb2 * 10,fontcolor = colBlue,bgr=newcolor(93900,54830,3800))
##   decho(2)
##   doFinish()
##
proc newColor2*(r,g,b:int):string = "\x1b[48;2;$1;$2;$3m" % [$r,$g,$b]     
##   newColor2
##   
##   creates a new color string from r,g,b values passed in with styleReverse effect for text
##   best used as foregroundcolor in print, printLn routines
##     

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


proc drawRect*(h      :int = 0,
               w      :int = 3,
               frhLine:string = "_",
               frVLine:string = "|",
               frCol  :string = darkgreen,
               dotCol :string = truetomato,
               xpos   :int = 1,
               blink  :bool = false) =
               
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
    ## check bitsets 
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
            printLnErrorMsg(ccurfile & " not found !")
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
        printLnInfoMsg("Info   ","All timers deleted",xpos = xpos)
        
             
    
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
  ##                       printHl(aline,sw,yellowgreen)
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
                printLnErrorMsg("Cannot open file " & fn)
                quit()
         
         
         
proc pswwaux*() =
   # pswwaux
   # 
   # utility bash command :  ps -ww aux | sort -nk3 | tail
   # displays output in console
   # 
   let pswwaux = execCmdEx("ps -ww aux | sort -nk3 | tail ")
   printLn("ps -ww aux | sort -nk3 | tail ",yellowgreen)
   echo  pswwaux.output
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
     ## WIP
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
     printLnBiCol2("Sum     : " & ff(x.sum,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Mean    : " & ff(x.mean,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Var     : " & ff(x.variance,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Var  S  : " & ff(x.varianceS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Kurt    : " & ff(x.kurtosis,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Kurt S  : " & ff(x.kurtosisS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Skew    : " & ff(x.skewness,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Skew S  : " & ff(x.skewnessS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Std     : " & ff(x.standardDeviation,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Std  S  : " & ff(x.standardDeviationS,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Min     : " & ff(x.min,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Max     : " & ff(x.max,n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLn2("S --> sample\n",peru,xpos = xpos)

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
     printLnBiCol2("Intercept     : " & ff(rr.intercept(),n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Slope         : " & ff(rr.slope(),n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Correlation   : " & ff(rr.correlation(),n),yellowgreen,white,sep,xpos = xpos,false,{})
    

proc showRegression*(rr: RunningRegress,n:int = 5,xpos:int = 1) =
     ## showRegression
     ##
     ## Displays RunningRegress data from an already formed RunningRegress
     ## 
  
     let sep = ":"
     printLnBiCol2("Intercept     : " & ff(rr.intercept(),n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Slope         : " & ff(rr.slope(),n),yellowgreen,white,sep,xpos = xpos,false,{})
     printLnBiCol2("Correlation   : " & ff(rr.correlation(),n),yellowgreen,white,sep,xpos = xpos,false,{})

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
     ## debug print shows contents of s in repr mode
     ## 
     ## usefull for debugging  (for some reason the  line number maybe off sometimes)
     ##
     echo()
     print("** REPR OUTPTUT START ***",truetomato)
     currentLine()
     echo repr(s) 
     printLn("** REPR OUTPTUT END   ***",truetomato)
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
            printLnErrorMsg(dirname & " creation failed. Check permissions.")
     else:
        printLnErrorMsg("Directory " & dirname & " already exists !")




proc remDir*(dirname:string):bool {.discardable.} =
     ## remDir
     ##
     ## deletes an existing directory , all subdirectories and files  and provides some feedback
     ##
     ## root and home directory removal is disallowed 
     ## 
     ## this obviously is a dangerous proc handle with care !!
     ##

     if dirname == "/home" or dirname == "/" :
        printLn("Directory " & dirname & " removal not allowed !",brightred)

     else:

        if existsDir(dirname):

            try:
                removeDir(dirname)
                printLnOkMsg("Directory " & dirname & " deleted")
                result = true
            except OSError:
                printLnErrorMsg("Directory " & dirname & " deletion failed")
                result = false
        else:
            printLnErrorMsg("Directory " & dirname & " does not exists !")
            result = false


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
      echo(yellowgreen,"[Terminal Size] " & lime & " W " & white & $tw & red & " x" & lime & " H " & white & $th)



proc cxAlert*(xpos:int = 1) = 
     ## cxAlert
     ## 
     ## issues an alert 
     ## 
     ##      
     print(doflag(red,6,"ALERT ",truetomato) & doflag(red,6),xpos = xpos)
     
  
proc cxAlertLn*(xpos:int = 1) = 
     ## cxAlertLn
     ## 
     ## issues an alert line
     ## 
     ##.. code-block:: nim
     ##   import nimcx 
     ##   # try to change the width of the terminal  window
     ##   while true:
     ##      if tw < 100:
     ##          infoproc(cxAlertLn(2))
     ##          showTerminalSize()      
     ##      else:
     ##          infoproc(printLnOkMsg($(tw),2))
     ##      sleepy(0.5)
     ##      
     ##      
     printLn(doflag(red,6,"ALERT ",truetomato) & doflag(red,6),xpos = xpos)
             

#proc cxHelp*[T](s:varargs[T,`$`]) =
proc cxhelp*(s:openarray[string],xpos :int = 2)=
  ## cxHelp
  ## 
  ## a help generator which can easily be called from within or on app start 
  ## maybe via myapp -h
  ## 
  ## 
  ##
  ##.. code-block:: nim
  ##   cxHelp("Help system for my application",
  ##       "Read the book","use more data",
  ##       cxcodestart,
  ##       "Example 1",
  ##       "abc = @[1,2,3]",
  ##       "    ",
  ##       "xfg = mysupergenerator(abc,3)",
  ##       cxcodeend,
  ##       "this should be help style again",
  ##       cxcodestart,
  ##       "Example 2  ",
  ##       "for x in 0..<n:",
  ##       """   printLn("Something Nice",blue)"""",
  ##       cxcodeend,   
  ##       "Have a nice day")
  ##
  ##
  
  var maxlen = 0
  
  for ss in 0..<s.len:
    # scan for max len which will be the max width of the help
    # but need to limit it to within tw
    if maxlen < s[ss].len: 
           maxlen = s[ss].len
   
  if maxlen > tw - 10 :
        cxAlertLn(2)
        showTerminalSize()      
        printLnErrorMsg("Terminal Size to small for help line width",xpos=xpos)
        cxAlertLn(2)
        echo()
  var cxcodeflag = false 
  var cxcodeendflag = false
  for ss in 0..<s.len:
      var sss = s[ss]
    
      if sss.len < maxlen :  sss = sss & spaces(max(0, maxlen - sss.len)) 
      
      # we can embed a code which is set off from the help msg style
      if sss.contains(cxcodestart) == true: cxcodeflag = true
      if sss.contains(cxcodeend) == true : cxcodeendflag = true
      
      if ss == 0:
        printLnHelpMsg(sss,xpos = xpos)
      
      var bhelptemp = spaces(max(0, maxlen)) # set up a blank line of correct length
      if cxcodeflag == true:
           if sss.contains(cxcodestart) == true :
              printLnBelpMsg(bhelptemp,xpos=xpos)
           elif sss.contains(cxcodeend) == true :
              printLnBelpMsg(bhelptemp,xpos=xpos)
              # reset the flags
              cxcodeflag = false
              cxcodeendflag = false
           else: 
              if cxcodeflag == true:
                 printLnCodeMsg(sss,xpos=xpos)
      
      else:
        if cxcodeendflag == false and ss > 0:
           printLnBelpMsg(sss,xpos=xpos)
  echo()      
       
        
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
      printLnInfoMsg("infoproc"," $1 Line: $2 with: '$3'" % [pos.filename,$pos.line, astToStr(code)])
  except:
      printLnErrorMsg("Checking instantiationInfo ")
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
  
            
proc cxPortCheck*(cmd:string = "lsof -i") =
     ## cxPortCheck
     ## 
     ## runs a linux system command to see what the ports are listening to
     ##
     ## may need sudo  ?
     ## 
     printLnStatusMsg("cxPortCheck")
     if not cmd.startsWith("lsof") :  # do not allow any old command here
        printLnBiCol("cxPortCheck Error: Wrong command --> $1" % cmd,colLeft=red)
        doByeBye()
     let pc = execCmdEx(cmd)  
     let pcl = pc[0].splitLines()
     printLn(pcl[0],yellowgreen,styled={styleUnderscore})
     for x in 1..pcl.len - 1:
        if pcl[x].contains("UDP "):
           var pclt = pcl[x].split(" ")
           echo()
           print(pclt[0] & spaces(1),sandybrown)
           for xx in 1..<pclt.len:
             try:
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
             except:
                 discard
                 
        elif pcl[x].contains("TCP "):
           var pclt = pcl[x].split(" ")
           echo()
           print(pclt[0] & spaces(1),lime)
           for xx in 1..<pclt.len:
             try:
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
               
             except:
                 echo()
                 discard
                 
               
        else:
           echo()
           discard
     printLnStatusMsg("cxPortCheck Finished.")     
     
proc qqTop*() =
  ## qqTop
  ##
  ## prints qqTop in custom color
  ##
  print("qq",cyan)
  print("T",brightgreen)
  print("o",brightred)
  print("p",cyan)

  
    
proc cxBinomialCoeff*(n, k:int): int =
    # cxBinomialCoeff
    # 
    # function returns BinomialCoefficient
    # 
    result = 1
    var kk = k
    if kk < 0 or kk  >  n:  result = 0
    if kk == 0 or kk == n:  result = 1
    kk = min(kk, n - kk) 
    for i in 0..<kk: result = result * (n - i) div (i + 1)
   

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
      

# code below borrowed from distros.nim and made exportable 
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
        
        else:
           var un = execCmdEx("uname -v")
           printLnInfoMsg("uname -v ",un.output)
           
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
    echo()
    printInfoMsg("Nim Version ",NimVersion)
    print(" | ",brightblack)
    printInfoMsg("NimCx Version",CXLIBVERSION,xpos = 25)
    printInfoMsg("Elapsed secs ",fmtx(["<10.3"],epochTime() - cxstart),xpos = 49)
    printLnInfoMsg("Info"," Have a Nice Day !",limegreen,xpos = 78)  ## change or add custom messages as required
    decho(2)
    system.addQuitProc(resetAttributes)
    quit(0)

proc doCxEnd*() =
    ## doCxEnd
    ## 
    ## short testing routine if cx.nim is run as main
    ## 
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
            for x in 0..<(tw - 4) div runeLen(innocent) div 2: print(innocent,rndCol())
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
