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
##     Latest      : 2018-08-01
##
##     Compiler    : Nim >= 0.18.x dev branch
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
##                   cxtime , cxtruecolor , cxstats and cxutils.nim , 
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
##                   terminal x-axis position starts with 1 (mostly)
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
##                                      
##     Latest      : Restructuring and cleanup to adjust to the newest nim release.
##                  
##
##     Funding     : Here are three excellent reasons :
##     
##                   You are happy              ==> send BTC to : 194KWgEcRXHGW5YzH1nGqN75WbfzTs92Xk
##                   
##                   You are not happy          ==> send BTC to : 194KWgEcRXHGW5YzH1nGqN75WbfzTs92Xk
##                 
##                   You are in any other state ==> send BTC to : 194KWgEcRXHGW5YzH1nGqN75WbfzTs92Xk
##                                       
##                   
##                        

import cxconsts,cxglobal,cxtime,cxprint,cxhash,cxfont,cxtruecolor,cxutils,cxnetwork,cxstats

import os,osproc,times,random,strutils,strformat,parseutils,parseopt 
import tables,sets,rdstdin,macros
import posix,terminal,math,stats,json,streams,options,memfiles
import sequtils,httpclient,rawsockets,browsers,intsets,algorithm
import unicode,typeinfo,typetraits,cpuinfo,colors,encodings,distros

export cxconsts,cxglobal,cxtime,cxprint,cxhash,cxfont,cxtruecolor,cxutils,cxnetwork,cxstats

export os,osproc,times,random,strutils,strformat,parseutils,parseopt 
export tables,sets,rdstdin,macros
export posix,terminal,math,stats,json,streams,options,memfiles
export sequtils,httpclient,rawsockets,browsers,intsets,algorithm
export unicode,typeinfo,typetraits,cpuinfo,colors,encodings,distros



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
  {.hint    : "\x1b[38;2;154;205;50m \u2691  NimCx      :" & "\x1b[38;2;255;215;0m Officially works on Linux only." & spaces(13) & "\x1b[38;2;154;205;50m \u2691".}
  {.hint    : "\x1b[38;2;154;205;50m \u2691  Compiling  :" & "\x1b[38;2;255;100;0m Please wait , Nim will be right back ! \xE2\x9A\xAB" & " " & "\xE2\x9A\xAB" & spaces(2) & "\x1b[38;2;154;205;50m \u2691".} 
  {.hints: off.}   # turn on off as per requirement
  
  
const CXLIBVERSION* = "0.9.9"

let cxstart* = epochTime()  # simple execution timing with one line see doFinish()
randomize()                 # seed rand number generator 

type
     NimCxError* = object of Exception  
         cxerrormsg:string
     # experimental    
     # to be used like so , but not in use yet
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
    Benchmarkres* = tuple[bname,cpu,epoch,repeats:string]
    
# used to store all benchmarkresults   
var benchmarkresults* =  newSeq[Benchmarkres]()
# global used to store tmpfilenames , all tmpfilenames will be deleted if progs exit
var cxtmpfilenames* =  newSeq[string]()

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
converter toInt*(x: char): int = result = ord(x)
converter toChar*(x: int): char = result = chr(x)  


proc newColor*(r,g,b:int):string = 
    ##   newColor
    ##   
    ##   creates a new color string from r,g,b values passed in colors can be used as 
    ##   foregroundcolor in print,printLn routines and as bgr in cxPrint,cxPrintLn .
    ##   
    ##   Example
    ##   
    ##   .. code-block:: nim
    ##     import nimcx
    ##     printLn("Test for rgb color 12345  " & efb2 * 10,newColor(27354,4763,1089))
    ##     decho(2)
    ##     printLn("Test for rgb color 12345  " & efb2 * 10,newColor(73547,4873,4888))
    ##     decho(2)
    ##     printLn("Test for rgb color 12345  " & efb2 * 10,newColor(990,483,38),bgblue)
    ##     decho(2)
    ##     cxPrintLn("Test cxprintln test 12345 " &  efb2 * 10,fontcolor = colBlue,bgr=newcolor(990,5483,38))
    ##     cxPrintLn("Test cxprintln test 12345 " &  efb2 * 10,fontcolor = colBlue,bgr=newcolor(9390,5483,38))
    ##     cxPrintLn("Test cxprintln test 12345 " &  efb2 * 10,fontcolor = colBlue,bgr=newcolor(93900,54830,3800))
    ##     decho(2)
    ##     # or save it
    ##     let mymystiquecolor = newColor2(93547,84873,77888)
    ##     printLn("Here we go",mymystiquecolor)
    ##     doFinish()
    ##
    ##
    result = "\x1b[38;2;$1;$2;$3m" % [$r,$g,$b]
    
    
proc newColor2*(r,g,b:int):string = "\x1b[48;2;$1;$2;$3m" % [$r,$g,$b]     
    ##   newColor2
    ##   
    ##   creates a new color string from r,g,b values passed in with styleReverse effect for text
    ##   best used as foregroundcolor in print, printLn routines
    ##     

proc checkColor*(colname: string): bool =
     ## checkColor
     ##
     ## returns true if colname is a known color name in colorNames constants.nim 
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

     
# Misc. routines
     

proc nimcat*(curFile:string,countphrase : varargs[string,`$`] = "")=
    ## nimcat
    ## 
    ## A simple file lister which shows all rows and some stats.
    ## It also allows counting of tokens.
    ## A file name without extension will be assuemed to be .nim 
    ## Countphrase is case sensitive
    ## This proc uses memslices and memfiles for speed
    ##  
    ##  
    ##.. code-block:: nim
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
                    printLnBiCol(fmtx(["<" & $maxphrasewidth,"",""],countphrase[x]," : " & rightarrow & " Count: ",phraseinline[x].len),xpos = 4)
                    printLnBiCol("Occurence : Line No." ,colLeft = truetomato ,colRight = yellow ,sep = ":",4,false,{})
                    showseq(phraseinline[x])
                    
  
template repeats(count: int, statements: untyped) =
  for i in 0..<count:
      statements

   
template benchmark*(benchmarkName: string, repeatcount:int = 1,code: typed) =
  ## benchmark
  ## 
  ## a quick benchmark template showing cpu and epoch times with repeat looping param
  ## suitable for quick in-program timing of procs 
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
  repeats(repeatcount):
        code
  let elapsed = epochTime() - t0
  let elapsed1 = cpuTime() - t1
  zbres.epoch = ff(elapsed,4)  
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
  let elapsed = epochTime() - t0
  let elapsed1 = cpuTime() - t1
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
 for x in benchmarkresults:
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
  ## code adapted from rosettacode and updated to make it actually compile
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
  ## code adapted from rosettacode and updated 
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
          result = spellInteger(parseInt(nss[0])) & sepname & spellInteger2(nss[1])
      else:
          # we assume its a currency float value
          result = spellInteger(parseInt(nss[0])) & sepname & spellInteger(parseInt(nss[1]))

template currentFile*: string =
  ## currentFile
  ## 
  ## returns path and current filename
  ## 
  var pos = instantiationInfo()
  pos.filename 
  
  
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
     ## requires xclip to be installed
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
     ## toClip
     ##
     ## send a string to the Clipboard using xclip
     ## only error messages will shown if any.
     ## required xclip to be installed
     ## 
     ##
     let res = execCmd("echo $1 | xclip " % $s)
     if res <> 0 :
            printLnErrorMsg("xclip output : " & $res & " but expected 0")

    
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
      printLnInfoMsg("Terminal Size","W" & spaces(1) & $tw & " x" & " H" & spaces(1) & $th)


proc cxAlert*(xpos:int = 1) = 
     ## cxAlert
     ## 
     ## issues an alert 
     ## 
     ## also available printAlertMsg see cxprint.nim
     ## 
     ##      
     print(doflag(red,6,"ALERT ",truetomato) & doflag(red,6),xpos = xpos)
     
  
proc cxAlertLn*(xpos:int = 1) = 
     ## cxAlertLn
     ## 
     ## issues an alert line
     ## 
     ## ## also available printLnAlertMsg see cxprint.nim
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
  

     
proc qqTop*() =
  ## qqTop
  ##
  ## prints qqTop in custom color
  ##
  print("qq",cyan)
  print("T",brightgreen)
  print("o",brightred)
  print("p",cyan)

        
proc tmpFilename*(): string = 
  # tmpFilename
  # 
  # creates a new tmpfilename
  # a file eventually created with this name will be automatically 
  # erased upon exit if doFinish() , doByeBye() are called or upon exit via Ctrl-C  .
  # a filename will look like so: /tmp/1520316200.579602-qcvcglawvo.tmp  
  # 
  let tfn = getTempDir() & $epochTime() & "-" & newword(5) & ".tmp"
  cxTmpFileNames.add(tfn)  # add filename to seq 
  result = tfn
  

proc rmTmpFilenames*() = 
    # rmTmpFilenames
    # 
    # this will remove all temporary files created with the tmpFilename function
    # and is automatically called by exit handlers doFinish(),doByeBye() and if Ctrl-C
    # is pressed . 
    # 
    for fn in cxTmpFileNames:
       try:
           removeFile(fn)
       except:
           printLnAlertMsg(fn & "could not be deleted.")
        
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
  printLnBiCol("Last compilation on           : " & CompileDate & " at " & CompileTime,yellowgreen,lightgrey,sep,0,false,{})
  # this only makes sense for non executable files
  #printLnBiCol("Last access time to file      : " & filename & " " & $(fromSeconds(int(getLastAccessTime(filename)))),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Last modificaton time of file : " & filename & " " & $modTime,yellowgreen,lightgrey,sep,0,false,{})
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
  printLnBiCol("Size                          : " & $(float(fi.size) / float(1000)) & " kb",yellowgreen,lightgrey,sep,0,false,{})
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
  printBiCol("OS                            : " & hostOS,yellowgreen,lightgrey,sep,0,false,{})
  printBiCol(" | CPU: " & hostCPU,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol(" | cpuEndian: " & $cpuEndian,yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("CPU Cores                     : " & $cpuInfo.countProcessors())
  printLnBiCol("Current pid                   : " & $getpid(),yellowgreen,lightgrey,sep,0,false,{})
  printLnBiCol("Terminal encoding             : " & $getCurrentEncoding())
  

proc infoLine*() =
    ## infoLine
    ##
    ## prints some info for current application
    ##
    hlineLn()
    echo()
    print(fmtx(["<14"],"Application:"),yellowgreen)
    print(extractFileName(getAppFilename()),skyblue)
    print(" | ",brightblack)
    print("Nim : ",greenyellow)
    print(NimVersion & " | ",brightblack)
    print("nimcx : ",peru)
    print(CXLIBVERSION,brightblack)
    print(" | ",brightblack)
    print($someGcc & " | ",brightblack)
    print("Size: " & brightblack & formatSize(getFileSize(getAppFilename())),peru)
    print(" | ",brightblack)
    qqTop()


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
  # animated the end
  loopy2(0,2):
     loopy2(-10,30):
       printfontfancy("THE END",xpos = xloopy)
       sleepy(0.02)
       cleanscreen()
  printfontfancy("qqtop",coltop1 = red,xpos = tw div 3 - 20)     
  decho(10)

template doByeBye*() =
  ## doByeBye
  ##
  ## a simple end program routine do give some feedback when exiting
  ##  
  decho(2)
  rmTmpFilenames()
  print("Exiting now !  ",lime)
  printLn("Bye-Bye from " & extractFileName(getAppFilename()),red)
  printLn(yellowgreen & "Mem -> " & lightsteelblue & "Used : " & white & ff2(getOccupiedMem()) & lightsteelblue & "  Free : " & white & ff2(getFreeMem()) & lightsteelblue & "  Total : " & white & ff2(getTotalMem() ))
  #doFinish()

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
        printLnBiCol("  Compiled on: " & $CompileDate & spaces(1) & $CompileTime & spaces(1) & cxTimeZone())
        if detectOs(OpenSUSE) or detectOs(Parrot):  # some additional data if on openSuse or parrotOs systems
            let ux1 = uname().split("#")[0].split(" ")
            printLnBiCol("Kernel     :  " & ux1[2] & " | Computer: " & ux1[1] & " | Os: " & ux1[0] & " | CPU Cores: " & $(osproc.countProcessors()),yellowgreen,lightslategray,":",0,false,{})
            let rld = release().splitLines()
            let rld3 = rld[2].splitty(":")
            let rld4 = rld3[0] & spaces(2) & strip(rld3[1])
            printBiCol(rld4,yellowgreen,lightslategray,":",0,false,{})
            printLnBiCol(spaces(2) & "Release: " & strip((split(rld[3],":")[1])),yellowgreen,lightslategray,":",0,false,{})
            echo()
        
        else:
           var un = execCmdEx("uname -v")
           printLnInfoMsg("uname -v ",un.output)
        
        rmTmpFilenames()
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
    rmTmpFilenames()  # clean up if possible
    echo()
    hlineLn()
    cechoLn(yellowgreen,"Thank you for using        : " & getAppFilename())
    hlineLn()
    printLnBiCol(fmtx(["<","<11",">9"],"Last compilation on        : " , CompileDate , CompileTime),brightcyan,termwhite,":",0,false,{})
    printLnBiCol(fmtx(["<","<11",">9"]," Exit handler invocation at : " , cxtoday() , getClockStr()),pastelorange,termwhite,":",0,false,{})
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

if getcxTrueColorSetFlag == true:   # defined in cxglobal
   getcxTrueColorSet()       # preload the cxTrueCol seq in default mode if getcxTrueColorSetFlag == true  --> default == false
checktruecolorsupport()      # comment out if above line uncommented

# this will reset any color changes in the terminal
# so no need for this line in the calling prog
system.addQuitProc(resetAttributes)

when isMainModule:  doCxEnd()
   
# END OF CX.NIM #
