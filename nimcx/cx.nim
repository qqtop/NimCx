#Compiler options
{.deadCodeElim: on, optimization: speed.}
#{.push raises: [Defect].}  #--> TODO :for very strict error handling
#{.passC: "-msse -msse2 -msse3 -mssse3 -march=native -mtune=native -flto".}
#{.passL: "-msse -msse2 -msse3 -mssse3 -flto".}
#{.passC: "-march=native -O3"}
#{.noforward: on.}   # future feature
#{.push inline, noinit, checks: off.}

# check memory usage and other issues via -g -d:UseMalloc and Valgrind
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
##     ProjectStart: 2015-06-20
##   
##     Latest      : 2021-06-23
##
##     Compiler    : latest stable or devel branch
##
##     OS          : Linux
##
##     Description :
##
##                   nimcx.nim is a collection of simple procs and templates
##
##                   for easy colored display in a linux terminal and also contains
##                   
##                   a wide selection of utility routines and useable snippets for
##
##                   your projects and experimentations. 
##                   
##                   Currently the library consists of 
##                   
##                   cx.nim , cxconsts.nim , cxglobal, cxprint.nim , cxhash ,
##                   
##                   cxtime , cxstats  , cxfont , cxfontconsts
##                   
##                   except cxfont ,cxfontconsts and cxzenity all files are automatically
##
##                   imported with : import nimcx
##
##                   if you need cxzenity it can be imported with
## 
##                   import nimcx/cxzenity
##
##     Usage       : import nimcx
##
##     Project     : [NimCx](https://github.com/qqtop/NimCx)
##
##     Docs        : [Documentation](https://qqtop.github.io/cx.html)
##
##     Tested      : Debian , Parrot (Debian Testing)
##       
##                   Terminal set encoding to UTF-8  
##
##                   with var. terminal font : hack,monospace size 9.0 - 15  
##
##                   xterm,konsole,gnome terminals, mate terminal etc. support truecolor ok
##                   
##                   however for maximum color support use konsole 
##                   
##     Important   : If the color effects are not here ... change the terminal.
##                   
##                   Gnome terminals auto adjust colors not in colorNames see cxConsts.nim
##
##                   so a command like : 
##                   
##                   printLn("Nice color 123",newColor(990,9483,88))
##                   
##                   may give you a deep red fontcolor in konsole , but may only show in
##                   
##                   boring white on a gnome based terminal.
##                   
##                   a bash script to show colors
##
##                   for i in {0..255}; do     printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"; done
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
##                   for printing of multiple columns in the terminal the print,printLn,printBiCol,printLnBiCol
##                   
##                   routines should be used for other printjobs see cxprint,cxprintLn  
##                   
##                   Due to the flurry of updates in the development branch occasional carnage may occur.
##
##                   Nimcx compiles with --gc:arc and --gc:orc
##
##                   Nimcx brings in most of the stdlib modules for convenience at the cost 
##                   
##                   of slightly longercompile times
##
##
##                   if you have cloned nimcx lib somewhere you can try one of this compile commands
##
##                   nim c --cc:clang -d:danger --gc:arc -r cx.nim      (may need sudo apt install libomp-dev)
##
##                   
##                   for a 386 compile on a 86_64 machine try
##
##                   nim c --cincludes:/usr/include/x86_64-linux-gnu --os:linux --cpu:i386 --passC:-m32 --passL:-m32  --gc:arc -d:release -r cx.nim
##                   and see it die with 
##                   /usr/include/x86_64-linux-gnu/gnu/stubs.h:7:11: fatal error: gnu/stubs-32.h: No such file or directory
##                   If this or similar is the case you need to find any missing xxx-32.h files and put them 
##                   into the include path
##                   Compiling on a pure i386 or  arm machine is totally fine.
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
##                   Deprecating/removing unused or unnecessary code due to improvements in stdlib
##
##                   cxfont.nim and cxfontconsts.nim are available for import , but not longer
##                   imported in nimcx to avoid code bloat 
##
##                   cxzenity.nim is available but not imported with nimcx it utilises
##
##                   the OS zenity install do show graphical messageboxes etc 
##
##
##     Compile ideas :
##
##                    nim c --gc:orc  --threads:on -d:ssl -d:release --stackTrace:on --lineTrace:on -f -r  cx.nim
##
##                    nim c -d:threads:on -d:ssl -d:danger --gc:arc -d:useMalloc -r -f cx
##
##     Fast         : nim c --gc:arc --threads:on -d:ssl --stackTrace:off -d:release --d:nimdrnim --passC:-flto -f -r cx
##
##                    nim c -d:danger --panics:on  --threads:on   --passC:"-flto -fopt-info-missed" -r -f cx
##
##     Hardcore     : nim c --gc:arc --debuginfo -d:useMalloc cx.nim && valgrind -s --leak-check=full ./cx
##
##    Debug with gdb: nim c --gc:arc --opt:none --debugger:native  disables optimizations and enables debug symbols                            
##

import
        cxversion,cxconsts, cxglobal, cxtime, cxprint, cxhash, cxnetwork, cxstats
import 
        std/[os, osproc, exitprocs, times, random, strutils,strmisc, strformat, strscans, parseutils,
        sequtils, parseopt,tables, sets, macros,posix,posix_utils, htmlparser, terminal,
        logic, math, stats, json, streams, options, memfiles, monotimes,
        httpclient, nativesockets, browsers, intsets, algorithm, net,
        unicode, typeinfo, typetraits, cpuinfo, colors, encodings, distros,
        rdstdin, sugar , enumerate, wordwrap]
        

export
        cxversion,cxconsts, cxglobal, cxtime, cxprint, cxhash, cxnetwork, cxstats,
        os, osproc, exitprocs, times, random, strutils, strmisc,strformat, strscans, parseutils,
        sequtils, parseopt,tables, sets, macros,posix, posix_utils,htmlparser,terminal,
        logic, math, stats, json, streams, options, memfiles, monotimes,
        httpclient, nativesockets, browsers, intsets, algorithm, net,
        typeinfo, typetraits, cpuinfo, colors, encodings, distros,
        rdstdin, sugar , enumerate,wordwrap

        
export unicode except strip, split, splitWhitespace

when defined(nimHasUsed): {.used.}

# Profiling       
#import nimprof  # nim c -r --profiler:on --stackTrace:on cx

# Profiling with valgrind
# nim c -d:release <source file>
# valgrind --tool=callgrind -v ./<program file> <arguments>
# kcachegrind callgrind.out.<some number>    # or maybe qcachegrind

# Running with perf
# nim c --passC:"-Og -ggdb -g3 -fno-omit-frame-pointer" cx.nim
# perf report -i cx

# Memory usage
# --profiler:off, --stackTrace:on -d:memProfiler  

# for debugging intersperse with dprint(someline)
# or see the stacktrace with writeStackTrace()
# or compile with  --debugger:on 
# or see infoproc() in cxglobal.nim
# or try compilation with and without var debug options
# nim c --threads:on -d:ssl --gc:arc -r cx



discard setLocale(LC_ALL, "") # init utf8 

when defined(macosx):
        {.warning: " \u2691 NimCx is only tested on Linux ! Your mileage may vary".}

when defined(windows):
        {.hint: "Time to switch to Linux !".}
        {.hint: "NimCx compiles on windows but not all functions are available ".}

when defined(posix):

        {.hint: "\x1b[38;2;154;205;50m ╭──────────────────────── NIMCX ─────────────────────────────────────╮ " .}
    
        {.hint: "\x1b[38;2;154;205;50m \u2691  NimCx  V. " & CXLIBVERSION &
                "  :" & "\x1b[38;2;255;215;0m Officially made for Linux only." & 
                spaces(15) & "\x1b[38;2;154;205;50m \u2691 ".}
                
        {.hint: "\x1b[38;2;154;205;50m \u2691  Compiling        :" &
                "\x1b[38;2;255;100;0m Please wait , Nim will be right back ! \xE2\x9A\xAB" &
                " " & "\xE2\x9A\xAB" & spaces(2) & "\x1b[38;2;154;205;50m \u2691 ".}
         
        {.hint: "\x1b[38;2;154;205;50m ╰───────────────────────── CX ───────────────────────────────────────╯ " .}

        {.hints: on.}  # turn on off as per requirement

let cxstart* = epochTime()   # simple execution timing with one line see doFinish()
let cxstartgTime = getTime() 
let cxstartmTime* = getMonoTime()

randomize()                # seed rand number generator
enableTrueColors()         # enable truecolorsupport


type
     Benchmarkres* = tuple[bname, cpu, epoch, gett, repeats: string]

# used to store all benchmarkresults
var benchmarkresults* = newSeq[Benchmarkres]()
# global used to store tmpfilenames , all tmpfilenames will be deleted if progs exit
var cxtmpfilenames* = newSeq[string]()

proc newCxCounter*(): ref(Cxcounter) =
    ## newCxcounter
    ## 
    ## set up a new cxcounter
    ## 
    ## simple counter with add,dec and reset procs
    ## 
    ##.. code-block:: nim
    ##   var counter1 = newCxcounter()
    ##   counter1.add   # add 1
    ##   counter1.dec   # dec 1
    ##   counter1.reset # set to 0
    ##   echo counter1.value # show current value
    ##
    result = (ref CxCounter)(value: 0)

proc add*(co: ref Cxcounter) = inc co.value 
proc dec*(co: ref Cxcounter) = dec co.value
proc reset*(co: ref CxCounter) = co.value = 0

proc spellInteger*(n: int64): string # forward declaration
proc doFinish*() # forward declaration
  
# char converters
converter toInt*(x: char): int = result = ord(x)
converter toChar*(x: int): char = result = chr(x)

# convenience templates 
template cxflat*:untyped       = pastelorange & "→" & termwhite 
template cxSingleUp*:untyped   = greenyellow & "↑" & termwhite
template cxSingleDown*:untyped = truetomato & "↓" & termwhite
template cxDoubleUp*:untyped   = lime & "↑↑" & termwhite
template cxDoubleDown*:untyped = red & "↓↓" & termwhite
template cx45Up*:untyped       = cyan & "→↑" & termwhite
template cx45Down*:untyped     = yellow & "→↓" & termwhite
template cxrv*(s:untyped):string = 
    ## cxrv 
    ##
    ## color reverser
    ##
    ##  Example:
    ##  .. code-block:: nim
    ##    cxprintln(0,"Nice number ",white,redbg,78.cxrv," test finished !  ",truetomato,"Good test .".cxrv, yellowgreen,"OK".cxrv ) 
    "\e[7m$1\e[m " % $s   # color reverser


template cxRegion*(name, body: untyped) = 
   ## cxRegion
   # idea is that we can use ide code folding 
   # in large files and do not loose our way 
   # and see what is going on
   echo()
   cxprintLn(0,styleUnderscore,yellowgreen,"cxRegion : ",pink,name & spaces(2))
   echo()
   body


template cxBlockRegion*(name, body: untyped) = 
   ## cxBlockRegion
   # idea is that we can use ide code folding 
   # in large files and do not loose our way 
   # and see what is going on and each region is inside a block
   echo()
   cxprintLn(0,styleUnderscore,yellowgreen,"cxRegion : ",pink,name & spaces(2))
   echo()
   block:
      body



template `as`*[T, U](x: T, _: typedesc[U]): U = U(x)
    ##  as  a type change template 
    ##
    ##  .. code-block:: nim
    ##    for x in 33..126:
    ##      echo(fmtx(["<3","","","",""],x,spaces(2),x as char,spaces(2),ff2(x as float,3)))
    ##

template toCxOpenarray*(aseq:seq[untyped]):untyped=
     ## toCxOpenarray
     ##
     ## used to pass seqs to procs expecting
     ## an openarray type as input, passing a seq would work too
     ## but openarray is faster
     ##
     aseq.toOpenarray(0,aseq.len - 1)
         
         
proc newColor*(r, g, b: int): string =
    ##   newColor
    ##   
    ##   creates a new color string from r,g,b values. Passed in colors can be used as 
    ##   foregroundcolor in print,printLn routines and as bgr in cxPrint,cxprintLn .
    ##   
    ##   Example
    ##   
    ##   .. code-block:: nim
    ##     import nimcx
    ##     printLn("Test for rgb color 12345  " & efb2 * 10,newColor(27354,4763,1089))
    ##     decho()
    ##     printLn("Test for rgb color 12345  " & efb2 * 10,newColor(73547,4873,4888))
    ##     decho()
    ##     printLn("Test for rgb color 12345  " & efb2 * 10,newColor(990,483,38),bgblue)
    ##     decho()
    ##     # or save it
    ##     let mymystiquecolor = newColor2(93547,84873,77888)
    ##     printLn("Here we go",mymystiquecolor)
    ##     doFinish()
    ##
    ##
    try:
      result = "\x1b[38;2;$1;$2;$3m" % [$r, $g, $b]
    except ValueError:
        cxprintLn(1,red, "Description: Wrong color value")
 


func newColor2*(r, g, b: int): string = "\x1b[48;2;$1;$2;$3m" % [$r, $g, $b]
    ##   newColor2
    ##   
    ##   creates a new color string from r,g,b values passed in with styleReverse effect for text
    ##   best used as backgroundcolor in print, printLn etc. routines
    ##
    
template hextoRGB*(hexstring:untyped):untyped = 
    # hextoRGB
    # convert a hex color string to rgb color string
    # this function is for foreground color use
    #
    let b = extractRGB(parseColor(hexstring))
    let cxb = newcolor(b.r,b.g,b.b)
    cxb
    

template hextoRGBbg*(hexstring:untyped):untyped = 
    # hextoRGBbg
    # convert a hex color string to rgb color string
    # this function is for background color use
    #
    #.. code-block:: nim
    #   cxprintLn(1,hextoRGB("#F9DB6D"),hextoRGBbg("#464d77"),"  yellow on new blue test  ")  
    #
    let b = extractRGB(parseColor(hexstring))
    let cxb = newcolor2(b.r,b.g,b.b)
    cxb   
    
func checkColor*(colname: string): bool =
    ## checkColor
    ##
    ## returns true if colname is a known color name in colorNames constants.nim 
    ## 
    ##
    result = false
    for x in colorNames:
        if x[0] == colname or x[1] == colname:
           result = true

proc showColors*() =
    ## showColors
    ##
    ## display all colorNames in color !
    ##
    for x in colorNames:
       if x[0].endswith("bg") == false:
          print(fmtx(["<22"], x[0]) & "▒".repeat(10) & spaces(2) & "⌘".repeat(10) & spaces(2) & "ABCD abcd 1234567890 --> ", x[1], getBg(bgDefault), xpos = 3)
          print(fmtx(["<23"], spaces(2) & x[0]), x[1], styled = {styleReverse}) 
          print(spaces(2))
          print(fmtx(["<23"], spaces(2) & x[0]), x[1],yalebluebg)
          print("  ||| ",x[1], getBg(bgDefault))
          printLn(fmtx(["<23"], spaces(2) & x[0]), x[1],darkslategraybg,styled={styleBright})
          echo() 
    echo()

proc makeColor*(r:int=getrndint(0,2550),g:int=getrndint(0,2550),b:int=getrndint(1000,2550),xpos:int=1) =
    ## makeColor
    ## 
    ## a utility function to show random effect of rgb changes
    ## see makeColorTest or makeGreyScaleTest for example use
    ## 
    let nc = newcolor(r,g,b)
    print(cxlpad($r & " " & $g & " " & $b,15) & " " & efb2 * 20,nc,xpos=xpos)
    echo()

 
proc makeColorTest*() = 
    ## makeColorTest
    ## 
    ## testing makeColor proc need to be run in a KDE konsole
    ## to see all the colors
    ## 
    loopy2(0,30):
          makecolor()
          curup(1)     
          makecolor(xpos = 40)       
          curup(1)
          makecolor(xpos = 80)   
      
 
proc makeGreyScaleTest*(astart:int = 0, aend:int = 255 ,astep:int = 5) =
    ## makeGreyScaleTest
    ## 
    ## shows a greyscale table with desired params 
    ## 
    ## 
    decho(2)
    for x in countup(astart,aend - 100,astep):
       makecolor(x,x,x)
       curup(1)     
       makecolor(x+50,x+50,x+50,xpos = 40) 
       curup(1)                        
       makecolor(x+100,x+100,x+100,xpos = 80)
     
          
# Misc. routines

proc setTerminalTitle*(s:string) = 
    ## Adjust terminal title during long processes 
    # 
    # may not work on every terminal 
    #
    let b = "echo -e '\\033]2;$1\\007'" % s
    echo b
    discard execCmd(b)

proc cxcolor*[T](apal:T):string = 
     ## cxcolor
     ##
     ## returns a color from a cxpal , which can be used in cxprintLn
     ## and other print routines
     ##
     ##.. code-block:: nim
     ##
     ##   cxprintln(3,cxcolor(cxredpal[8]),cxcolorBg(cxgreypal[6]),"NimCx Pallet") 
     ##
     result = hexToRgb(apal)

proc cxcolorBg*[T](apal:T):string = 
     ## cxcolorBg
     ##
     ## returns a color from a cxpal to be used as background color in cxprintLn
     ## and other print routines
     ##
     ##.. code-block:: nim
     ##
     ##   cxprintln(3,cxcolor(cxyellowpal[x]),cxcolorBg(cxbluepal[5]),"NimCx Pallet") 
     ##
     result = hexToRgbBg(apal)


proc showCxPallets*() = 
    # showCxPallets
    # shows use of cxpals defined in cxconsts.nim
    decho(2)
    let spaltxt = smiley & "NimCx   "
    var xpos = 2
    var x1 = 0
    for pxl in 0 ..< cxpals.len:
      let spaltxt2 = cxpalnames[pxl]
      for x in 0 ..< cxpals[pxl].len:
         inc x1 
         if x == 4:
             cxprintLn(xpos - 1,black,hextoRGBbg(cxpals[pxl][(cxpals[pxl].len-1) - x]),cxpad(spaltxt2,12) & $(cxpals[pxl].len-x-1))
         else:     
             cxprintLn(xpos,hextoRGB(cxpals[pxl][x]),hextoRGBbg(cxpals[pxl][(cxpals[pxl].len-1) - x]),cxpad(spaltxt,12) & $(cxpals[pxl].len-x-1))
             
      curup(9)
      xpos = xpos+14

    decho(10)
    
    # show some examples
        
    for x in 0..<cxbluepal.len - 1:
        cxprintln(3,cxcolor(cxbluepal[x]),cxcolorBg(cxpurplepal[7]),"NimCx Pal    Blue on Purple " & smiley)
    for x in 0..<cxtealpal.len - 1:
        cxprintln(3,cxcolor(cxtealpal[x]),cxcolorBg(cxorangepal[4]),"NimCx Pal    Teal on Orange " & smiley)
    curup(16)
    for x in 0..<cxbluepal.len - 1:
        cxprintln(36,cxcolor(cxyellowpal[x]),cxcolorBg(cxindigopal[8]),"NimCx Pal    Yellow on Indigo " & smiley)
    for x in 0..<cxtealpal.len - 1:
        cxprintln(36,cxcolor(cxredpal[x]),cxcolorBg(cxgreypal[6]),"NimCx Pal    Red on Grey      " & smiley)
    curup(16)
    for x in 0..<cxbluepal.len - 1:
        cxprintln(72,cxcolor(cxorangepal[x]),cxcolorBg(cxtealpal[6]),"NimCx Pal   Orange on Teal   " & smiley)
    for x in 0..<cxtealpal.len - 1:
        cxprintln(72,cxcolor(cxyellowpal[x]),cxcolorBg(cxbluepal[5]),"NimCx Pal   Purple on Blue   " & smiley)
    curup(16)
    for x in 0..<cxbluepal.len - 1:
        cxprintln(107,cxcolor(cxorangepal[x]),cxcolorBg(cxbluepal[8]),"NimCx Pal   Orange on Blue   " & smiley)
    for x in 0..<cxtealpal.len - 1:
        cxprintln(107,cxcolor(cxgreypal[x]),cxcolorBg(cxredpal[5]),"NimCx Pal   Grey on Red      " & smiley)
    


proc nimcat*(curFile: string, countphrase: seq[string] = @[]) =
    ## nimcat
    ## 
    ## A simple file lister which shows all rows and some stats.
    ## It also allows counting of tokens.
    ## A file name without extension will be assuemed to be .nim 
    ## Countphrase is case sensitive
    ## This proc uses memfiles for speed
    ##  
    ##  
    ##.. code-block:: nim
    ## 
    ##   nimcat("notes.txt")                   # show all lines
    ##   nimcat("bigdatafile.csv")
    ##   nimcat("/data5/notes.txt",countphrase = @["nice" , "hanya", "88"]) # also count how often a token appears in the file
    ##
    var ccurFile = curFile
    #echo countphrase.len
    let (dir, name, ext) = splitFile(ccurFile)
    if ext == "": ccurFile = ccurFile & ".nim"
    if not fileExists(ccurfile):
            echo()
            cxprintLn(2,white,bgred,ccurfile & " not found !")
            echo()
            discard
    else:
            echo()
            dlineLn()
            echo()
            var phraseinline = newSeqWith(countphrase.len, newSeq[int](0)) # holds the line numbers where a phrase to be counted was found
            var c = 1
            for line in lines(memfiles.open(ccurFile)):
                echo yellowgreen, strutils.align($c, 6), termwhite,":", spaces(1), wrapWords($line, maxLineWidth = tw - 8, splitLongWords = false, newLine = "\x0D\x0A" & spaces(8))
                if ($line).len > 0:
                   var lc = 0
                   for mc in 0 ..< countphrase.len:
                        lc = ($line).count(countphrase[mc])
                        if lc > 0: phraseinline[mc].add(c)
                inc c
            echo()
            printLnBiCol(" File       : " & ccurFile)
            printLnBiCol(" Lines Shown: " & ff2(c - 1,0))
            var maxphrasewidth = 0
            for x in countphrase:
                if x.len > maxphrasewidth: maxphrasewidth = x.len
            if countphrase.len > 0:
                printLn("\n PhraseCount Stats :    \n", gold, styled = {styleUnderScore})
                for x in 0 ..< countphrase.len:
                    printLnBiCol(fmtx([""], "Phrase    : " & countphrase[x]), xpos = 3)
                    printLnBiCol("Occurence : Line No.", colLeft = lightblue, colRight = yellow, sep = ":", 3, false, {})
                    showseq(phraseinline[x])


template repeats(count: int, statements: untyped) =
        # used by benchmark
        for i in 0 ..< count:
            statements


template benchmark*(benchmarkName: string, repeatcount: int = 1, code: typed) =
        ## benchmark
        ## 
        ## a quick benchmark template showing cpu and epoch times with
        ## repeat looping param suitable for quick in-program timing of procs 
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

        var zbres: Benchmarkres
        let t0 = epochTime()
        let t1 = cpuTime()
        let t2 = getTime()
        repeats(repeatcount):
                code
        let elapsed = epochTime() - t0
        let elapsed1 = cpuTime() - t1
        let elapsed2 = getTime() - t2
        zbres.epoch = ff(elapsed, 4)
        zbres.cpu = ff(elapsed1, 4)
        zbres.gett =  $elapsed2
        zbres.bname = benchmarkName
        zbres.repeats = $repeatcount
        benchmarkresults.add(zbres)


template benchmark*(benchmarkName: string, code: typed) =
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
        ##        var s = createSeqFloat(10,9)
        ##        var cc = newCxCounter()
        ##        s.sort(system.cmp,order = Descending)
        ##        for x in s:
        ##            cc.add 
        ##            cxprintLn(0,fmtx(["",">4","<6","","<f15.7"],yellowgreen,cc.value," :",beige,$x))
        ##
        ##    var bx = newCxCounter()
        ##    benchmark("doit",10000):
        ##            doit()
        ##            bx.add
        ##            cxprintLn(3,fmtx(["","","","",">8"],greenyellow, " " , uparrow , " Run " , bx.value))
        ##            echo()
        ##    showBench() 
       
        var zbres: Benchmarkres
        let t0 = epochTime()
        let t1 = cpuTime()
        let t2 = getTime()
        let repeatcount = 1
        repeats(repeatcount):
                code
        let elapsed = epochTime() - t0
        let elapsed1 = cpuTime() - t1
        let elapsed3 = getTime() - t2
        zbres.epoch = ff(elapsed, 4)
        zbres.cpu = ff(elapsed1, 4)
        zbres.gett = $elapsed3
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
        var minepoch = 1000000000.000000000

        if benchmarkresults.len == 0:
              cxprintLn(0,red,"Benchmark results emtpy. Nothing to show")
        else:  
            
          # lets find shortest time of all results to compare % wise
          for x in benchmarkresults:
              if  parseFloat(x.epoch) < minepoch:
                  minepoch =  parseFloat(x.epoch) 
              
          for x in benchmarkresults:
              var aa11 = spaces(1) & dodgerblue & "[" & salmon & x.bname & dodgerblue & "]"
              if len(aa11) > bnamesize: bnamesize = len(aa11)
              if bnamesize < 13: bnamesize = 13
              if len(x.epoch) > epochsize: epochsize = len(x.epoch) - bnamesize + 50
              if len(x.cpu) > cpusize: cpusize = len(x.cpu) + 26
              if len(x.repeats) > repeatsize: repeatsize = len(x.repeats)                        
          
            
          for x in benchmarkresults:
              echo()
              let tit = fmtx(["", "<$1" % $(bnamesize - len(gold) * 3), "", "<28", "<45",">10"], spaces(2),
                        "BenchMark", spaces(4), "Timing", "Cycles : $1" % x.repeats,"NimCx ")


              if parseInt(x.repeats) > 0:
                 cxprintLn(0,skyblue,darkslategraybg,styleUnderScore,tit)
                 echo()
              else:
                 cxprintLn(0, red, styleUnderScore,tit)

              let aa1 = spaces(1) & gold & "[" & salmon & x.bname & gold & "]"
              let bb1 = cornflowerblue & "Epoch Time : " & oldlace & x.epoch & " secs"
              let cc1 = cornflowerblue & "Cpu Time   : " & oldlace & x.cpu & " secs"
              let cgt = cornflowerblue & "Get Time   : " & oldlace & x.gett 
              var dd1 = ""
              var ee1 = ""

              if parseFloat(x.epoch) > 0.00:
                 dd1 = "Cycles/sec : " & ff2(parsefloat(x.repeats)/parsefloat(x.epoch))
              else:
                 dd1 = "Cycles/sec : Inf"
                 dd1 = strutils.strip(dd1)
                    
              if parseFloat(x.cpu) > 0.00:
                 ee1 = "Cycles/sec : " & ff2(parsefloat(x.repeats)/parsefloat(x.cpu))
              else:
                 ee1 = "Cycles/sec : Inf"
                 ee1 = strutils.strip(ee1)        
                            
              
              cxprint(1,fmtx(["<$1" % $bnamesize, "", "<70", "<90"],aa1, spaces(3), bb1,dd1))
              cxprintLn(1,fmtx(["<$1" % $bnamesize, "", "<70", "<50"],aa1, spaces(3), cc1, ee1))
              cxprintLn(1,fmtx(["<$1" % $bnamesize, "", ""],aa1, spaces(3), cgt)) 
                            
              if dd1.contains("Inf") or ee1.contains("Inf"):
                 cxprintLn(2,goldenrod,darkslategraybg,"Inf - To measure something increase the loop count.")
              else:
                 var pctdiff = (parsefloat(x.epoch) - minepoch) / minepoch * 100.00
                 if pctdiff > 0.00:
                     cxprintLn(1,fmtx(["<$1" % $bnamesize, "", ""],aa1, spaces(3), "Delta Time :" & spaces(1) & ff2(pctdiff,5) & & " % slower")) 
                 else:
                     cxprintLn(1,fmtx(["<$1" % $bnamesize, "", ""],aa1, spaces(3), "Delta Time :" & spaces(1) & ff2(pctdiff,5) & " % fastest")) 
        echo()
        benchmarkresults = @[]
        cxprintLn(2,goldenrod,"Benchmark finished. Results cleared.")
        echo()


proc showPalette*(coltype:string = "white" ) =
     ## ::
     ##   showPalette
     ##   
     ##   Displays palette with all coltype as found in colorNames
     ##   coltype examples : "red","blue","medium","dark","light","pastel" etc..
     ##
     echo()
     var n = 0
     let z = colPaletteLen(coltype)
     for x in 0 ..< z:
        if not colPaletteName(coltype, x).endswith("bg") :
           inc n 
           printLn(fmtx([">3", ">4"],$n,rightarrow) & " ABCD 1234567890   " & colPaletteName(coltype, x), colPalette(coltype, x))
     echo()      
     printLnBiCol(" Items in Palette " & coltype & " : " & $n)
     echo()


proc colorio*() =
    ## colorio
    ## 
    ## Displays name,hex code and rgb of colors available in cx.nim
    ##
    cxprintLn(0,gold,truebluebg,fmtx(["<20", "", "<20", "", ">5", "", ">5", "", ">6"],
                    "Colornames in nimcx", spaces(2), "HEX Code", spaces(2),
                    "R", spaces(1), "G", spaces(1), "B"))
    echo()
    for x in 0 ..< colorNames.len:
            try:
                    let zr = extractRgb(parsecolor(colorNames[x][0]))
                    cxprintLn(1,colorNames[x][1],fmtx(["<20", "", "<20", "", ">5", "", ">5",
                              "", ">5"], colorNames[x][0], spaces(2), $(
                              parsecolor(colorNames[x][0])), spaces(2),
                              zr[0], spaces(1), zr[1], spaces(1),zr[2]))
            except ValueError:
                    if colorNames[x][0].endswith("bg"):
                        cxprintLn(1,colorNames[x][1],fmtx(["<20", "", "<20",""], colorNames[x][0],
                        spaces(2), "NIMCX BACKGROUND COLOR " ,spaces(19)))
                    else:    
                        cxprintLn(1,colorNames[x][1],fmtx(["<20", "", "<20",""], colorNames[x][0],
                        spaces(2), "NIMCX CUSTOM COLOR " ,spaces(19)))
    echo()
    cxprintLn(1,gold,darkslategraybg,"Colorio   -   A NimCx color view utility  ")
    echo()
   

    
proc showHexColors*[T](hcolors:seq[T]) =
  ## showHexColors
  ##
  ## pass in a seq of hexcolors like: 
  ## myhexcols = @["#F5F5F5","#FFFF00","#9ACD32"]
  ##
  for x in 0 ..< hcolors.len:
    var hxb = hcolors[x]
    cxprintln(0,hextorgb(hxb),fmtx(["","","<9",""],spaces(3),$hcolors[x],spaces(3)," nimcx hex color test "))
 
 
template cxfg*(body:untyped):untyped =
  ## cxfg
  ##
  ## to set foreground colors from cxpallets see consts.nim
  
  ##.. code-block:: nim
  ##   cxfg(cxorangepal[3])
  ## 
  hextorgb(body)
  
template cxbg*(body:untyped):untyped =
  ## cxbg
  ##
  ## used to set background colors from cxpallets see consts.nim
  ##.. code-block:: nim
  ##   cxbg(cxbluepal[3])
  ##
  hextorgbbg(body)   
   
    
# spellInteger
proc nonzero(c: string, n: int64, connect = ""): string =
        # used by spellInteger
        if n == 0: "" else: connect & c & spellInteger(n)        

proc lastAnd[T](num: T): string =
        # used by spellInteger
        var num = num
        if "," in num:
            let pos = num.rfind(",")
            var (pre, last) =
                if pos >= 0: (num[0 ..< pos], num[pos + 1 .. num.high])
                else: ("", num)
            if " and " notin last:
                last = " and" & last
            num = [pre, ",", last].join()
        return num

proc big(e: int, n: int64): string =
        # used by spellInteger
        if e == 0:
             spellInteger(n)
        elif e == 1:
             spellInteger(n) & " thousand"
        else:
             spellInteger(n) & spaces(1) & huge[e]

iterator base1000Rev(n: int64): int64 =
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
                tens[int(a)] & nonzero(spaces(1), b)
        elif n < 1000:
                let a = n div 100
                let b = n mod 100
                small[int(a)] & " hundred" & nonzero(spaces(1), b, "")
        else:
                var sq = newSeq[string]()
                var e = 0
                for x in base1000Rev(n):
                        if x > 0:
                                sq.add big(e, x)
                        inc e
                reverse sq
                lastAnd(sq.join(spaces(1)))


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


proc spellFloat*(n: float64, currency: bool = false, sep: string = ".", sepname: string = " dot "): string =
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
        ##  printLn spellFloat(5212311.00).replace("dot","and") & "hundreds"
        ##  printLn spellFloat(122311.34,true).replace("dot","dollars and") & " cents"
        ##

        if n == 0.00:
                result = spellInteger(0)
        else:
                #split it into two integer parts  the back part should be spelled differently and there is an issue with 123.00234 !
                var nss = split($n, ".")
                if nss[0].len == 0: nss[0] = $0
                if nss[1].len == 0: nss[1] = $0

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


template zipWith*[T1, T2](f: untyped; xs: openarray[T1], ys: openarray[T2]): untyped =
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
      var res = newSeq[type(f(xs[0], ys[0]))](n)
      for i, value in res.mpairs: value = f(xs[i], ys[i])
      res


proc newDir*(dirname: string) =
     ## newDir
     ##
     ## creates a new directory and provides some feedback
     if not dirExists(dirname):
         try:
             createDir(dirname)
             cxprintLn(0,green,"Directory " & dirname & " created ok")
         except OSError:
             cxprintLn(2,white,bgred,dirname & " creation failed. Check permissions.")
     else:
         cxprintLn(2,white,bgred,"Directory " & dirname & " already exists !")

proc remDir*(dirname: string): bool {.discardable.} =
    ## remDir
    ##
    ## deletes an existing directory , all subdirectories and files and provides some feedback
    ##
    ## root and home directory removal is disallowed 
    ## 
    ## this obviously is a dangerous proc handle with care !!
    ##

    if dirname == "/home" or dirname == "/":
        printLn("Directory " & dirname & " removal not allowed !",brightred)
    else:
        if dirExists(dirname):
            try:
                 removeDir(dirname)
                 cxprintLn(2,yaleblue,limegreenbg,"Directory " & dirname & " deleted")
                 result = true
            except OSError:
                 cxprintLn(2,white,bgred,"Directory " & dirname & " deletion failed")
                 cxprintLn(2,white,bgred,"System    " & getCurrentExceptionMsg())
                 result = false
        else:
            cxprintLn(2,white,bgred,"Directory " & dirname & " does not exists !")
            result = false


proc checkClip*(sel: string = "primary"): string =
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
         let r = split($outp, " ")
         for x in 0..<r.len: rx = rx & " " & r[x]
    else:
         rx = "xclip returned errorcode : " & $errC & ". Clipboard not accessed correctly."
    result = rx


proc toClip*[T](s: T) =
    ## toClip
    ##
    ## send a string to the Clipboard using xclip
    ## only error messages will shown if any.
    ## required xclip to be installed
    ## 
    ##
    let res = execCmd("echo $1 | xclip " % $s)
    if res <> 0: cxprintLn(2,white,bgred,"xclip output : " & $res & " but expected 0")


proc getColorName*[T](sc: T): string =
     ## getColorName
     ## 
     ## this functions returns the colorname based on a color escape sequence
     ## 
     ## usually used with randcol() to see what color was actually returned
     ## 
     ## referenced colornames defined in cxconstants.nim 
     ##
     ##.. code-block:: nim
     ##  import nimcx
     ##  for x in 0 ..< 10: 
     ##     let acol = randcol()
     ##     let acolname = getColorName(acol)         
     ##     printLn(acolname,acol)  
     ## 
     ##
     result = "unknown color"
     for x in colornames:
        if x[1] == sc: result = x[0]


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
     cxprintLn(2,yaleblue,yellowgreenbg," Terminal Size ", styleReverse," W" & spaces(1) & $tw & " x" & " H " & $th & spaces(1))


proc cxAlert*(xpos: int = 1) =
     ## cxAlert
     ## 
     ## issues an alert 
     ## 
     ## also available printAlertMsg see cxprint.nim
     ## 
     ##
     print(doflag(red, 6, "ALERT ", truetomato) & doflag(red, 6),xpos = xpos)


proc cxAlertLn*(xpos: int = 1) =
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
     printLn(doflag(red, 6, "ALERT ", truetomato) & doflag(red, 6),xpos = xpos)

 
proc cxHelp*(s: openarray[string], xpos: int = 2) =
     ## cxHelp
     ## 
     ## a help generator which can easily be called from within or on app start  
     ## with ability to include code blocks
     ## 
     ##
     ##.. code-block:: nim
     ##    cxHelp(["Help system for " & extractFileName(getAppFilename()),
     ##         "",
     ##        "1) Read the book",
     ##        "2) use more data",
     ##        "3) have a beer",
     ##        cxcodestart,
     ##        "Example 1",
     ##        "",
     ##        "let abc = @[1,2,3]",
     ##        "    ",
     ##        "var xfg = mysupergenerator(abc,3)",
     ##        cxcodeend,
     ##        "this should be help style again",
     ##        cxcodestart,
     ##        "Example 2  ",
     ##        "",
     ##        "for x in 0..<n:",
     ##        """   printLn("Something Nice  ",blue)"""",
     ##        cxcodeend,
     ##        "Have a nice day"])

     var maxlen = 0
     for ss in 0..<s.len:
          # scan for max len which will be the max width of the help
          # but need to limit it to within tw
          if maxlen < s[ss].len:  maxlen = s[ss].len
     if maxlen > tw - 10:
               cxAlertLn(2)
               showTerminalSize()
               cxprintLn(xpos,white,bgred,"Terminal Size to small for help line width")
               cxAlertLn(2)
               echo()

     var cxcodeflag = false
     var cxcodeendflag = false
     for ss in 0..<s.len:
               var sss = s[ss]
               if sss.len < maxlen: sss = sss & spaces(max(0,  maxlen - sss.len))
               # we can embed a code which is set off from the help msg style
               if sss.contains(cxcodestart) == true: cxcodeflag = true
               if sss.contains(cxcodeend) == true: cxcodeendflag = true
               if ss == 0:
                       printLnHelpMsg(sss, xpos = xpos)
               var bhelptemp = spaces(max(0, maxlen)) # set up a blank line of correct length
               if cxcodeflag == true:
                       if sss.contains(cxcodestart) == true:
                               printLnBelpMsg(bhelptemp, xpos = xpos)
                       elif sss.contains(cxcodeend) == true:
                               printLnBelpMsg(bhelptemp, xpos = xpos)
                               # reset the flags
                               cxcodeflag = false
                               cxcodeendflag = false
                       else:
                               if cxcodeflag == true:
                                       printLnCodeMsg(sss, xpos = xpos)
               else:
                      if cxcodeendflag == false and ss > 0:
                               printLnBelpMsg(sss, xpos = xpos)
     printLnEelpMsg(cxpad("",maxlen),xpos = xpos)                          
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
            cxprintLn(2,yaleblue,goldenrodbg," Infoproc ",getFg(fgDefault),getbg(bgDefault), " $1 Line: $2 with: '$3'" % [pos.filename, $pos.line, astToStr(code)])
        except:
            cxprintLn(2,white,bgred,"Checking instantiationInfo ")
            discard


template checkLocals*() =
        ## checkLocals
        ## 
        ## check name,type and value of local variables
        ## needs to be called inside a proc calling from toplevel has no effect
        ## best placed at bottom end of a proc to pick up all Variables
        ##
        echo()
        dlineLn(tw() - 1)
        cxprintLn(0,gold,"[checkLocals -->] ")
        for name, value in fieldPairs(locals()):
            printLnBiCol(fmtx(["", "<20", "", "", "", "", "<25", "", "", "", "", ""],
                         "Variable : ", $name, spaces(3), peru, "Type : ", termwhite,
                         $type(value), spaces(1), aqua, "Value : ", termwhite,$value))
        dlineLn(tw() - 1)

proc qqTop*() =
     ## qqTop
     ##
     ## prints qqTop in custom color
     ##
     cxwrite(cyan,"qq",greenyellow ,"T",brightred ,"o",gold,"p")


proc tmpFilename*(): string =
     # tmpFilename
     # 
     # creates a new tmpfilename
     # a file eventually created with this name will be automatically 
     # erased upon exit if doFinish() , doByeBye() are called or upon exit via Ctrl-C  .
     # a filename will look like so: /tmp/1520316200.579602-qcvcglawvo.tmp  
     #
     let tfn = getTempDir() & $epochTime() & "-" & newword(5) & ".tmp"
     cxTmpFileNames.add(tfn) # add filename to seq
     result = tfn


proc tmpFilename*(filename: string): string =
     # tmpFilename
     # 
     # creates a new tmpfilename with a specified name
     # a file eventually created with this name will be automatically 
     # erased upon exit if doFinish() , doByeBye() are called or upon exit via Ctrl-C  .
     # a filename will look like so: /tmp/filename.tmp  
     #
     let tfn = getTempDir() & $epochTime() & "-" & filename & ".tmp"
     cxTmpFileNames.add(tfn) # add filename to a global seq
     result = tfn


proc rmTmpFilenames*() =
     # rmTmpFilenames
     # 
     # this will remove all temporary files created with the tmpFilename function
     # and is automatically called by exit handlers doFinish(),doByeBye()
     # and if Ctrl-C is pressed . 
     #
     for fn in cxTmpFileNames:
          try:
              removeFile(fn)
          except:
              cxprintLn(2,white,truetomatobg,fn & "could not be deleted.")

func cxBell*() =
     ## cxBell
     ##
     ## ring system bell
     ##   
     discard execCmd("tput bel")     # ring the system bell on linux

     
proc cxSound*(soundfile:string = "/usr/share/sounds/purple/receive.wav") =
     ## cxSound
     ##
     ## play a sound file with aplay , default is receive.wav ,
     ## if file and aplay is avaialble
     ##
     if fileExists(soundfile): discard execCmd("aplay -q " & soundfile)

            

proc doInfo*() =
    ## doInfo
    ##
    ## A more than you want to know information proc
    ## 
    ##
    try:
        let filename = extractFileName(getAppFilename())
        let modTime = getLastModificationTime(filename)
        let fi = getFileInfo(filename)
        let sep = ":"
        superHeader("Information for file " & filename & " and System " & spaces(22))
        printLnBiCol("Last compilation on           : " & CompileDate & " at " & CompileTime & " UTC", yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Last modificaton time of file : " & filename & " " & $modTime, yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Offset from UTC in hours      : " & cxTimeZone(long), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Local Time                    : " & $now().local,yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("UTC Time                      : " & $now().utc, yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Environment Info              : " & os.getEnv("HOME"),yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("File exists                   : " & $(fileExists filename), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Dir exists                    : " & $(dirExists "/home"),yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("AppDir                        : " & getAppDir(),yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("App File Name                 : " & getAppFilename(),yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("User home  dir                : " & os.getHomeDir(),yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Config Dir                    : " & os.getConfigDir(), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Current Dir                   : " & os.getCurrentDir(), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("File Id.                      : " & $(fi.id.device), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("File No.                      : " & $(fi.id.file), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Kind                          : " & $(fi.kind),yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Size                          : " & $(float(fi.size) / float(1000)) & " kb", yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("File Permissions              : ", yellowgreen, lightgrey, sep, 0, false, {})
        for pp in fi.permissions:
                printLnBiCol("                              : " & $pp, yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Link Count                    : " & $(fi.linkCount), yellowgreen, lightgrey, sep, 0, false, {})
        # these only make sense for non executable files
        printLnBiCol("Last Access                   : " & $(fi.lastAccessTime), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Last Write                    : " & $(fi.lastWriteTime), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Creation                      : " & $(fi.creationTime), yellowgreen, lightgrey, sep, 0, false, {})
    
        when defined windows:
                printLnBiCol("System                        : Running on Windows", red, lightgrey, sep, 0, false, {})
        elif defined linux:
                printLnBiCol("System                        : Running on Linux", brightcyan, yellowgreen, sep, 0, false, {})
        else:
                printLnBiCol("System                        : Interesting Choice", yellowgreen, lightgrey, sep, 0, false, {})
    
        when defined x86:
                printLnBiCol("Code specifics                : x86", yellowgreen, lightgrey, sep, 0, false, {})
    
        elif defined amd64:
                printLnBiCol("Code specifics                : amd86",yellowgreen, lightgrey, sep, 0, false, {})
        else:
                printLnBiCol("Code specifics                : generic",yellowgreen, lightgrey, sep, 0, false, {})
    
        printLnBiCol("Nim Version                   : " & $NimMajor & "." & $NimMinor & "." & $NimPatch, yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Processor thread count        : " & $cpuInfo.countProcessors(), yellowgreen, lightgrey, sep, 0, false, {})
        printBiCol("OS                            : " & hostOS, yellowgreen,lightgrey, sep, 0, false, {})  
        printBiCol(" | CPU: " & hostCPU, yellowgreen, lightgrey, sep, 0,false, {})
        printLnBiCol(" | cpuEndian: " & $cpuEndian, yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("CPU Cores                     : " & $cpuInfo.countProcessors())
        printLnBiCol("Current pid                   : " & $getpid(), yellowgreen, lightgrey, sep, 0, false, {})
        printLnBiCol("Terminal encoding             : " & $getCurrentEncoding())
        printLnBiCol("Compiler used                 : " & getCurrentCompilerExe())
        printLnBiCol("NimCx Version                 : " & CXLIBVERSION)
    except:
        discard
        
proc infoLine*(xpos:int = 0) =
     ## infoLine
     ##
     ## prints some info for current application
     ##
     hlineLn()
     echo()
     printBiCol(fmtx(["<14"], "Application:"), colLeft = yellowgreen,xpos = xpos)
     printBiCol(extractFileName(getAppFilename()), colLeft = skyblue)
     printBiCol("|",colLeft = brightblack)    
     printBiCol("Pid : " & $getCurrentProcessId())
     printBiCol("|", colLeft = brightblack)
     printBiCol("Nim : ", colLeft = greenyellow)
     printBiCol(NimVersion & " |", colLeft = brightblack)
     printBiCol("nimcx : ", colLeft = peru)
     printBiCol(CXLIBVERSION, colLeft = brightblack)
     printBiCol("|", colLeft = brightblack)
     printBiCol("Size: " & formatSize(getFileSize(getAppFilename())),colLeft=peru,colRight=brightblack)
     #printBiCol("|", colLeft = brightblack)
     
proc printTest*(astring:string="") =
     ## printTest
     ## 
     ## prints TEST,the current filename and an optional string
     ## 

     printLn("")
     printLn("""  ___  ___  __  ___ """,truetomato,styled={styleBright})
     printLn("""   |  |___ [__   |  """,lavender,styled={styleBright})
     printLn("""   |  |___ ___]  |  """,palegreen,styled={styleBright})
     printLn("")
     printLn("   " & extractFileName(getAppFilename()),truetomato)
     if astring != "":
         echo(spaces(2),skyblue,rightarrow,white,astring)
     decho(2)
 
# code below borrowed from distros.nim and made exportable
# there is now a new posix_utils module which also can give 
# uname -a results
var unameRes, releaseRes: string

template unameRelease(cmd, cache): untyped =
        if cache.len == 0:
             cache = (when defined(nimscript): gorge(cmd) else: execProcess(cmd))
        cache

template uname*(): untyped = unameRelease("uname -a", unameRes)
template release*(): untyped = unameRelease("lsb_release -a", releaseRes)
# end of borrow

proc cxhostnamectl*() =
     ## cxhostnamectl
     ##
     ## wrapper to display hostnamectl output
     ##
     ## hostnamectl is available on many systems
     ##
     let hcl = execCmdEx("hostnamectl")
     let hcls = hcl.output.splitLines()
     echo()
     for x in 0 ..< hcls.len:
         printLnBiCol(hcls[x])
     echo()

proc doByeBye*(xpos:int = 1) =
     ## doByeBye
     ##
     ## a simple end program routine do give some feedback when exiting
     #decho()
     #hlineLn(40)
     rmTmpFilenames()
     cxprintLn(xpos,pastelBlue ,extractFileName(getAppFilename())," ",
             pastelgreen,ff2(epochtime() - cxstart) ," secs ",gold ," Bye-Bye " )
     addExitproc(resetAttributes)
     echo()
     curon()
     quit(0)        

proc doFinish*() =
     ## doFinish
     ## 
     ## use cxFinish() name doFinish will be deprecated soon
     ##
     ## a end of program routine which displays some information
     ##
     ## can be changed to anything desired , like your info
     ##
     ## this should be the last line of the application.
     ##
     {.gcsafe.}:
        decho()
        infoLine()
        echo()
        printBiCol(fmtx(["<14"], "Elapsed    :"), colLeft=yellowgreen)
        printBiCol(fmtx(["<", ">5"], ff(epochtime() - cxstart, 3), " secs"), colLeft=goldenrod)
        printLn(" -> " & $cxHRTimer(cxstartgTime,getTime())) # displays micro,milli,nanoseconds
        printBiCol("Compile UTC:  " & CompileDate & spaces(1) & CompileTime & spaces(1) & "in " & cxTimeZone() &  " | ")
        printLnBiCol(execCmdEx("gcc --version")[0].splitLines()[0] ,colLeft = peru, colright = brightblack,sep = spaces(1))
        if detectOs(OpenSUSE) or detectOs(Parrot): # some additional data if on openSuse or parrotOs systems
            let ux1 = uname().split("#")[0].split(" ")
            printLnBiCol("Kernel     :  " & ux1[2] & " | Computer: " & ux1[1] & " | Os: " & ux1[0] & " | CPU Threads: " & $(
                            osproc.countProcessors()), yellowgreen, lightslategray, ":", 0, false, {})
            let rld = release().splitLines()
            let rld3 = rld[2].splitty(":")
            let rld4 = rld3[0] & spaces(2) & strutils.strip(rld3[1])
            printBiCol(rld4, yellowgreen, lightslategray, ":", 0,false, {})
            printBiCol(spaces(2) & "Release: " & strutils.strip((
                            split(rld[3], ":")[1])), yellowgreen,
                            lightslategray, ":", 0, false, {})
            printBiCol("  NimCx by   : ",colLeft=yellowgreen)                
            qqTop()  # put your own name/linelogo here
            printLnBiCol(" - " & year(getDateStr()), colLeft = lightslategray)
            echo()
        else:
            let un = execCmdEx("uname -v")
            cxprintLn(2,white,"uname -v ", un.output)
        rmTmpFilenames()
        GC_fullCollect() # just in case anything hangs around
        curon()
        quit(0)

proc cxFinish*() = doFinish()

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
    rmTmpFilenames()      # clean up if possible
    echo()
    hlineLn()
    printLnBiCol(fmtx(["<", "<11", ">9"], "  Exit handler invocation at : ",
                    cxtoday, getClockStr()), pastelorange, termwhite,":", 0, false, {styleBright})
    cxprintLn(0,greenyellow,cxbright,"  Thank you for using        : " & getAppFilename())
    printLnBiCol(fmtx(["<", "<11", ">9",""], "  Last compilation on        : ",
                    CompileDate, CompileTime," UTC"), brightcyan, termwhite, ":", 0, false, {styleBright})
    hlineLn()
    #echo()
    cxprint(2,yaleblue,greenyellowbg,cxbright,"Nim Version ", NimVersion,spaces(1))
    cxprint(23,yaleblue,pastelyellowbg,cxbright,"NimCx Version ", CXLIBVERSION,spaces(1))
    cxprint(45,yaleblue,pastelorangebg,cxbright,"Elapsed secs ", fmtx(["<10.3"], epochTime() - cxstart))
    cxprintLn(2,yaleblue,pastelgreenbg,cxbright," Have a Nice Day !") ## change or add custom messages as required
    decho()
    addExitproc(resetAttributes)
    curon()  # turn cursor on in case it was off
    quit(0)

proc doCxEnd*() =
    ## doCxEnd
    ## 
    ## short testing routine of cx.nim if run as main
    ##
    clearup()
    decho()
    print(nimcxl & "  V. " & CXLIBVERSION,randcol(),styled={styleBright}) 
    print(spaces(3))
    qqtop()
    printLn("  -  " & year(getDateStr()))
    doInfo()   # available on a nim development system with nim compiler, nimcx source
    echo()
    try:
      cxhostnamectl() 
    except OSError:
      discard    
    let pr = getProgramResult()
    curup(2)
    if pr == 0:
       printLnBiCol("Program Result  : " & "Ok",xpos=2)
    else:
       printLnBiCol("Program Result  : " & "Fail",colRight = red,xpos=2) 
    decho(2) 
    curon()  
       
# putting this here we can stop most programs which use this lib and get the
# automatic exit messages , it may not work in tight loops involving execCMD or
# waiting for readLine() inputs.
setControlCHook(handler)

# this will reset any color changes in the terminal
# so no need for this line in the calling prog
addExitproc(resetAttributes)


when isMainModule: 
    decho(2)
    # various end scenarios
    #colorio()
    #doCxEnd() 
    showColors()
    #printLnBiCol("Occupied Memory : " & formatSize getOccupiedMem())
    doFinish()

# END OF CX.NIM #
