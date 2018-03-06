{.deadCodeElim: on , optimization: speed.}

## ::
## 
##     Library     : nimcx.nim
##     
##     Module      : cxglobal.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##   
##     Latest      : 2018-03-06 
##
##     Compiler    : Nim >= 0.18.x dev branch
##
##     OS          : Linux
##
##     Description : provides many basic utility functions required by other modules
## 



import 
          cxconsts,
          terminal,
          strutils,
          parseutils,
          sequtils,
          strmisc,
          random,
          algorithm,
          unicode,
          macros,
          colors,
          streams,
          typeinfo,
          typetraits


 
# forward declarations 
proc ff*(zz:float,n :int = 5):string
proc ff2*(zz:SomeNumber,n:int = 3):string
#proc ff22*(zz:int64,n:int = 3):string


# procs lifted from an early version of terminal.nim 
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

template `*`*(s:string,n:int):string =
    # returns input string  n times mimicking python
    s.repeat(n)    
    
proc cxtoLower*(c: char): char = 
     ## cxtoLower
     ## 
     ## same as toLowerAscii()
     ## 
     result = c
     if c in {'A'..'Z'}: result = chr(ord(c) + (ord('a') - ord('A')))
  
   
converter toTwInt*(x: cushort): int = result = int(x)  
  

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


proc cxpad*(s:string,padlen:int):string =
  ## cxpad
  ## 
  ## pads a string on the right side with spaces to specified width 
  ## 
  result = s
  if s.len < padlen : 
     result = s & spaces(max(0, padlen - s.len)) 

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
    # as we do not want any print commands in this module we change
    case  mi <= ma
        of true : result.add(newSeqWith(n,getRndInt(mi,ma)))
        #of false: printErrorMsg("Wrong parameters for min , max ")
        else: 
             result.add(newSeqWith(n,getRndInt(mi,mi)))
         
     
proc ff*(zz:float,n:int = 5):string =
     ## ff
     ##
     ## formats a float to string with n decimals
     ##
     result = $formatFloat(zz,ffDecimal,precision = n)


proc ff22*(zz:int , n:int = 0):string =
  ## ff22
  ## 
  ## formats a integer into form 12,345,678 that is thousands separators are shown
  ## 
  ## precision is after comma given by n with default set to 0
  ## in context of integer this means display format could even show 
  ## a 0 after comma part if needed
  ## 
  ## ff2i(12345,0)  ==> 12,345     # display an integer with thousands seperator as we know it
  ## ff2i(12345,1)  ==> 12,345.0   # display an integer but like a float with 1 after comma pos
  ## ff2i(12345,2)  ==> 12,345.00  # display an integer but like a float with 2 after comma pos
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

proc typeTest3*[T](x:T): string =   $type(x)
proc ff2*(zz:SomeNumber, n:int = 3):string =
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
  
  if typetest3(zz).startswith("int") == true: 
             result = ff22(parseInt($zz),n)
  elif typetest3(zz).startswith("float") == true:
            if abs(zz) < 1000 == true:   #  number less than 1000 so no 1000 seps needed
                result = ff(float(zz),n)
                
            else: 
                    let c = rpartition($zz,".")
                    var cnew = ""
                    for d in c[2]:
                        if cnew.len < n:
                            cnew = cnew & d
                    # if still not enough
                    while cnew.len < n:
                        cnew = cnew & "0"
                    
                    result = ff22(parseInt(c[0])) & c[1] & cnew
  else:
        result = $zz
         



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
                  #printLn("Error , invalid format string dedected.",red)
                  #printLn("Showing exception thrown : ",peru)
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
    
 
 
# cxLine is a line creation object with several properties more properties will be introduced later
# also see printCxLine in cxprint.nim for usage
type 

     CxLineType*  = enum
        cxHorizontal = "horizontal"        # works ok
        cxVertical   = "vertical"          # not yet implemented
  
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
        showbrackets* : bool                # showbrackets trye or false          default true
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
     result.showbrackets = true
     result.linecolor     = aqua
     result.linechar      = efs2
     result.dotleftcolor  = yellow
     result.dotrightcolor = magenta
     result.newline       = "\L"
        


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


proc doFlag*[T](flagcol:string = yellowgreen,
                flags  :int = 1,
                text   :T = "",
                textcol:string = termwhite) : string {.discardable.} =
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
   

proc getAscii(s:string) : seq[int] =
   ## getAsciicode
   ## 
   ## returns ascii integer codes of every character in a string 
   ## 
   ## in an seq[int] 
   ## 
   result = @[]
   for c in s: 
       result.add(c.int)

  
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


proc curMove*(up:int=0,
              dn:int=0,
              fw:int=0,
              bk:int=0) =
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

 
proc stripper*(str:string): string =
     # stripper
     # strip controlcodes "\ba\x00b\n\rc\fd\xc3"
     result = ""
     for ac in str:
       if ord(ac) in 32..126:
         result.add ac
 
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
         
    
proc fromCString*(p: pointer, len: int): string =
  ## fromCString
  ## 
  ## convert C pointer to Nim string
  ## (code ex nim forum https://forum.nim-lang.org/t/3045 by jangko)
  ## 
  result = newString(len)
  copyMem(result.cstring, p, len)          

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
      ##   # run in terminal with min. 30 rows
      ##   import nimcx,stats
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
                
      
    
template colPaletteIndexer*(colx:seq[string]):auto =  toSeq(colx.low.. colx.high) 

template colPaletteLen*(coltype:string): auto =
         ##  colPaletteLen
         ##  
         ##  returns the len of a colPalette of colors in colorNames
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
         ##     doFinish()
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
         ##    for _ in 0..10:
         ##       printLn(z,colPalette("pastel",getRndInt(0,colPaletteLen("pastel") - 1)),styled={styleReverse})
         ##       print(cleareol)
         ##    doFinish()
         ##    
         ##    
               
         var pal = newseq[(string,string)]()         
         for colx in 0..<colorNames.len:
            if colorNames[colx][0].startswith(coltype) or colorNames[colx][0].contains(coltype):
              pal.add((colorNames[colx][0],colorNames[colx][1]))
              
         if pal.len < 1:
           printLnErrorMsg(colorsPalette)
           printLnBErrorMsg("Desired filter may not be available",red)
           printLnBErrorMsg("        Try:  medium , dark, light, blue, yellow etc.",red)  
           doFinish()   
         pal
  
   
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
   ##    hdx(printLn("Nice things happen randomly",yellowgreen,xpos = 9),width = 35,nxpos = 5)
   ##
   var xpos = nxpos
   var lx = repeat(frm,width div frm.len)
   printLn(lx,xpos = xpos)
   cursetx(xpos + 2)
   code
   printLn(lx,xpos = xpos)
   echo()
    


