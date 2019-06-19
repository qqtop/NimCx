{.deadCodeElim: on, optimization: speed.}

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
##     Latest      : 2019-06-19 
##
##     Compiler    : Nim >= 0.19.x dev branch
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
          math,
          random,
          algorithm,
          unicode,
          macros,
          colors,
          json,
          streams,
          typeinfo,
          typetraits
from times import getTime, toUnix, nanosecond 

# forward declarations
proc ff*(zz: float, n: int = 5): string
proc ff2*(zz: SomeNumber, n: int = 3): string

# procs lifted from an early version of terminal.nim
proc styledEchoProcessArg(s: string) = write stdout, s
proc styledEchoProcessArg(style: Style) = setStyle({style})
proc styledEchoProcessArg(style: set[Style]) = setStyle style
proc styledEchoProcessArg(color: ForegroundColor) = setForegroundColor color
proc styledEchoProcessArg(color: BackgroundColor) = setBackgroundColor color

# macros

macro styledEchoPrint*(m: varargs[untyped]): untyped =
          ## partially lifted from an earler macro in terminal.nim and removed new line 
          ## improvements suggested by araq to avoid the now deprecated callsite()
          ## maybe fails again ??? 2019-05-26  args not processed as before ???
          result = newNimNode(nnkStmtList)
          for i in countup(0, m.len - 1): result.add(newCall(bindSym"styledEchoProcessArg", m[i]))
          result.add(newCall(bindSym"write", bindSym"stdout", newStrLitNode("")))
          result.add(newCall(bindSym"resetAttributes"))

macro procName*(x: untyped): untyped =
          ## procName 
          ## prints the name of the proc if annoited with pragma {.procName.}
          ## 
          ## Example
          ##.. code-block:: nim
          ##   proc yippi(s:string) : string  {.procName.}  = 
          ##       result = s & "007"
          ##       
          ##   printLn(yippi("Mouse"))     
          ##   
          ##   
          
          let name = $name(x)
          let node = nnkCommand.newTree(newIdentNode("printLnBiCol"), newLit("Processed by proc : " & name))
          insert(body(x), 0, node)
          result = x

macro toEnum*(words: static[string]): untyped =
      ## toEnum
      ## 
      ## lifted from nim-blog
      ##  
      ## Example 
      ##.. code-block:: nim 
      ##   type
      ##      Color = toEnum("Red Green Blue Indigo")
      ##    
      result = newTree(nnkEnumTy, newEmptyNode())
      for w in strutils.splitWhitespace(words): result.add ident(w)          
          
macro cxgetType*(s: typed): untyped = 
          ## cxgetType
          ## 
          ## answers what type is it question
          ## in newer nim versions just use type(s)  
          result = getType(s)
      
                  
proc tupleTypes*(atuple: tuple): seq[string] =
          ## tupletypes
          ## 
          ## returns the field types of a tuple in a seq[string]
          ##
          result = newSeq[string]()
          for field in fields(atuple):
                    result.add($type(field))

template unidecodeU*(ustring: untyped): untyped =
         ## unidecodeU
         ## 
         ## decode \u escaped strings like "\u96e8\u3002"
         ## based on code by yglukhov ex Nim Forum
         ## 
         ##.. code-block:: nim
         ##   printLn(unidecodeU("\u5f9e\u6e05\u6668\u958b\u59cb\u4e00\u76f4\u4e0b\u96e8\u3002" & spaces(2) & "\u96e8\u3002"),yellowgreen)
         ##
         parseJson("\"" & ustring & "\"").getStr()
         #escapeJson(ustring)   # this works but adds quotation marks


template `*`*(s: string, n: int): untyped =
          ## returns input string  n times mimicking python
          s.repeat(n)


template toki*(s: untyped): untyped =
          ## toki
          ## 
          ## tokenizes input string and returns token in a seq[string]
          ##
          ##.. code-block:: nim 
          ##   var b = "酢の一種"  
          ##   let s = &"a + b = 12 3.5% & {b}"
          ##   echo toki(s)
          ##
          toSeq(s.tokenize).filterIt(not it.isSep).mapIt(it.token)

proc newLine*(n: int = 1): string =
          ## issues n newLines , default = 1
          result = "\n" * n

proc cxtoLower*(c: char): char =
          ## cxtoLower
          ## 
          ## same as toLowerAscii()
          ##
          result = c
          if c in {'A'..'Z'}: result = chr(ord(c) + (ord('a') - ord('A')))


converter toTwInt*(x: cushort): int = result = int(x)

proc isNumeric*(s: string): bool = s.allCharsInSet({'0'..'9'})

proc getTerminalWidth*(): int =
          ## getTerminalWidth
          ##
          ## get linux terminal width in columns
          ## a terminalwidth function is now incorporated in Nim dev after 2016-09-02
          ## which maybe is slightly slower than the one presented here
          ##
          result = 0
          type WinSize = object
                    row, col, xpixel, ypixel: cushort
          const TIOCGWINSZ = 0x5413
          proc ioctl(fd: cint, request: culong, argp: pointer)
                    {.importc, header: "<sys/ioctl.h>".}
          var size: WinSize
          ioctl(0, TIOCGWINSZ, addr size)
          result = toTwInt(size.col)


template tw*: int = getTerminalWidth() ## tw , a global where latest terminal width is always available

proc getTerminalHeight*(): int =
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


template th*: int = getTerminalheight() ## th , a global where latest terminal height is always available

proc remapIntToFloat*(s: seq[int]): seq[float] =
     ## remapIntToFloat
     ## 
     s.map do (x: int) -> float: x.float

proc remapFloatToInt*(s: seq[float]): seq[int] =
     ## remapFloatToInt
     ## 
     s.map do (x: float) -> int: round(x).int    
    
proc remapToString*[T](s: seq[T]): seq[string] =
     ## remapToString
     ## 
     s.map do (x: T) -> string: $x    
  
  
proc fwriteUnlocked(buf: pointer, size, n: int, f: File): int {.importc: "fwrite_unlocked", noDecl.}
proc fastWrite*(f: File, s: string) =
  ## fastWrite
  ## 
  ## good for logging or vast file writes
  ## 
  ## based on code ex https://hookrace.net/blog/writing-an-async-logger-in-nim/
  ## 
  ##.. code-block:: nim
  ##  var fft:File
  ##  discard open(fft,"fast.txt",fmReadWrite)
  ##  fastWrite(fft,"test " * 100)
  ##  fft.close()  
  ## 
  ## 
  if fwriteUnlocked(cstring(s), 1, s.len, f) != s.len:
      raise newException(IOError, "cannot write string to file" )  
  
    
func cxpad*(s: string, padlen: int, paddy: string = spaces(1)): string =
          ## cxpad
          ## 
          ## pads a string on the right side with spaces to specified width 
          ##
          result = s
          if s.len < padlen:
              result = s & (paddy * (max(0, padlen - s.len)))

func cxpdx*(padLen: int, s: string, paddy: string = spaces(1)): string =
          ## pdx 
          ## 
          ## same as cxpad but with padding char count in front
          cxpad(s, padLen, paddy)

func cxlpad*(s: string, padlen: int, paddy: string = spaces(1)): string =
          ## cxlpad
          ## 
          ## pads a string on the left side with spaces to specified width 
          ##
          result = s
          if s.len < padlen:
              result = (paddy * (max(0, padlen - s.len))) & s

func cxlpdx*(padLen: int, s: string, paddy: string = spaces(1)): string =
          ## cxlpdx 
          ## 
          ## same as cxpad but with padding char count in front
          cxlpad(s, padLen, paddy)

proc waitOn*(alen: int = 1) =
          ## waiton
          ## 
          ## stops program to wait for one or more keypresses. default = 1
          ##
          discard readBuffer(stdin, cast[pointer](newString(1)), alen)

proc rndSample*[T](asq: seq[T]): T =
          ## rndSample  
          ## returns one rand sample from a sequence
          ## 
          randomize()
          result = sample(asq)

proc rndRGB*(): auto =
          ## rndRGB
          ## 
          ## returns a random RGB value from colors available in colorNames 
          ## see cxconsts.nim for available values
          ##
          var cln = newSeq[int]()
          for x in 0..<colorNames.len: cln.add(x)
          try:
             let argb = extractRgb(parsecolor(colorNames[sample(cln)][0])) #rndsample
             let resrgb = rgb(argb.r, argb.g, argb.b)
             result = resrgb
          except ValueError:
             discard   

proc sum*[T](aseq: seq[T]): T = foldl(aseq, a + b)
          ## sum
          ##
          ## returns sum of float or int seqs
          ## 
          ## same effect as math.sum
          ##

proc product*[T](aseq: seq[T]): T = foldl(aseq, a * b)
          ## product
          ##
          ## returns product of float or int seqs 
          ##
          ## if a seq contains a 0 element than result will be 0
          ##


template doSomething*(secs: int, body: untyped) =
          ## doSomething
          ## 
          ## execute some code for a certain amount of seconds
          ## 
          ##.. code-block:: nim
          ##    doSomething(10,myproc())  # executes my proc for ten secs   , obviously this will fail if your proc uses sleep...
          ##
          let mytime = now()  #getTime().getLocalTime()
          while toTime(now()) < toTime(mytime) + secs.seconds:
                    body



proc isBlank*(val: string): bool {.inline.} =
          ## isBlank
          ## 
          ## returns true if a string is blank
          ##
          return val == ""


proc isEmpty*(val: string): bool {.inline.} =
          ## isEmpty
          ## 
          ## returns true if a string is empty if spaces are removed
          ##
          return strutils.strip(val) == ""



proc getRndInt*(mi: int = 0, ma: int = int.high): int {.noInit, inline.} =
          ## getRndInt
          ##
          var maa = ma
          if maa <= mi: maa = mi + 1
          result = rand(mi..maa)



proc getRndBool*(): bool =
          ## getRndBool
          ##
          if getRndInt(0, 1) == 0:
                    result = false
          else:
                    result = true

proc getRandomSignI*(): int =
          ## getRandomSignI
          ## 
          ## returns -1 or 1 integer  to have a rand positive or negative multiplier
          ##
          result = 1
          if 0 == getRndInt(0, 1): result = -1


proc getRandomSignF*(): float =
          ## getRandomSignF
          ## 
          ## returns -1.0 or 1.0 float  to have a rand positive or negative multiplier
          ##
          result = 1.0
          if 0 == getRndInt(0, 1): result = -1.0


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


proc reverseText*(text: string): string =
          ## reverseText
          ## 
          ## reverses words in a sentence
          ##
          for line in text.splitLines: result = line.split(" ").reversed.join(spaces(1))

proc reverseString*(text: string): string =
          ## reverseString
          ## 
          ## reverses chars in a word   
          ## 
          ## 
          ##.. code-block:: nim
          ## 
          ##    var s = "A text to reverse could be this example 12345.0"
          ##    echo "Original      : " & s  
          ##    echo "reverseText   : " & reverseText(s)
          ##    echo "reverseString : " & reverseString(s)
          ##    # check if back to original is correct
          ##    assert s == reverseString(reverseString(s))
          ##
          result = ""
          for x in reverseMe(text): result = result & x



# Convenience procs for rand data creation and handling
proc createSeqBool*(n: int = 10): seq[bool] {.inline.} =
          # createSeqBool
          # 
          # returns a seq of rand bools
          #
          result = newSeq[bool]()
          for x in 0..<n: result.add(getRndBool())

proc createSeqBinary*(n: int = 10): seq[int] {.inline.} =
          ## createSeqBinary
          ## 
          ## returns a seq of integers between 0 and 1
          ## 
          result = newSeq[int]()
          let b = createSeqBool(n)
          for x in b:
                if $x == "false": result.add(0)
                if $x == "true": result.add(1)


proc createSeqInt*(n: int = 10, mi: int = 0, ma: int = 1000): seq[int] {.inline.} =
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
          result = newSeq[int]() # faster
          # as we do not want any print commands in this module we change
          case mi <= ma
             of true: result.add(newSeqWith(n, getRndInt(mi, ma)))
             else: result.add(newSeqWith(n, getRndInt(mi, mi)))


proc ff*(zz: float, n: int = 5): string =
          ## ff
          ##
          ## formats a float to string with n decimals
          ## if thousands seperators are requirewd use f2
          ## 
          result = $formatFloat(zz, ffDecimal, precision = n)


proc ff22(zz: int): string =
          ## ff22
          ## 
          ## formats a number real or integer into string form 12,345,678 with thousands separators shown
          ## 
          ## to format an integer with decimals use ff2(myint) 
          ## 
          ## internal proc used by ff2  
          ##    
          var sc = 0
          var nz = ""
          var zrs = ""
          let zs = split($zz, ".")
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
                    nz = strutils.strip(nz, true, false, {','})
          elif nz.startswith("-,") == true:
                    nz = nz.multiReplace(("-,", "-"))

          result = nz

       
         
proc ff2*(zz: SomeNumber, n: int = 3):string =
          ## ff2
          ## 
          ## format int or float to string showing thousand separator and desired decimal places
          ## 
          ## TODO: better accomodate ints or floats represented with e notation like 1.23456e-05
          ##       currently nothing will be done to automatically converted numbers containg e
          ##
          ## ff2(12345,0)   ==> 12,345     # display an integer with thousands seperator as we know it
          ## 
          ## ff2(12345,1)   ==> 12,345.0   # display an integer but like a float with 1 decimal place
          ## 
          ## ff2(12345,2)   ==> 12,345.00  # display an integer but like a float with 2 decimal places
          ## 
          ## ff2(12.6789,2) ==> 12.67      # display the float with decimal places
          ## 
          ## ff2(12.3,4)    ==> 12.3000    # display the float with 4 decimal places
          ## 
          ## precision after comma is given by n with default set to 3
          ## 
          ##.. code-block:: nim
          ##    import nimcx
          ##    
          ##    # floats example
          ##    for x in 1 .. 2000:
          ##       # generate some positve and negative rand float
          ##       var z = getrandfloat() * 2345243.132310 * getRandomSignF()
          ##       printLnBiCol(fmtx(["",">6","",">20"],"NZ ",$x," : ",ff2(z)))
          ##  
          ##
     
          result = $zz 
          when zz is SomeSignedInt:
                  let rresult = ff22(zz)     
                  if n == 0:
                       result = rresult 
                  if n > 0 :
                       result = rresult & "." & "0" * n
                      
          else:   # so must be some float
              
                if not result.contains("e"):
                  let c = rpartition($zz, ".")
                  var cnew = ""
                  
                  for d in c[2]:
                            if d in ['0','1','2','3','4','5','6','7','8','9']:
                               cnew = cnew & d
                            else:  
                               if c[2].len < n: 
                                 cnew = cnew & "0"
                            if cnew.len == n:
                               break
                  while cnew.len < n : # needed in case an integer was passed in with n > 0
                        cnew = cnew & "0" 
            
                  if n == 0:
                        result = ff22(parseInt(c[0]))
                  else:
                        try:
                           result = ff22(parseInt(c[0])) & c[1] & cnew
                        except:  # if there is nil ? we might get here
                            discard

proc getRandomFloat*():float = rand(1.0) * getRandomSignF()
          ## getRandomFloat
          ##
          ## convenience proc so we do not need to import rand in calling prog
          ##
          ## to get positive or negative rand floats multiply with getRandomSignF
          ## 
               

proc getRndFloat*():float = rand(1.0) * getRandomSignF()                
          ## getRndFloat
          ##
          ## same as getrandFloat()

proc createSeqFloat*(n: int = 10, prec: int = 3): seq[float] =
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
          ##    # create a seq with 50 rand floats formatted
          ##    echo createSeqFloat(50,3)
          ##
          var ffnz = prec
          if ffnz > 16: ffnz = 16
          result = newSeq[float]()
          for wd in 0..<n:
                    var x = 0
                    while x < prec:
                              let afloat = parseFloat(ff2(getRndFloat(), prec))
                              if ($afloat).len > prec + 2:
                                        x = x - 1
                                        if x < 0: x = 0
                              else:
                                        inc x
                                        result.add(afloat)

                              if result.len == n: break

                    if result.len == n: break

         
   

proc seqLeft*[T](it: seq[T], n: int): seq[T] =
          ## seqLeft
          ## 
          ## returns a new seq with n left end elements of the original seq
          try:
                    result = it
                    if it.len >= n: result = it[0..<n]
          except RangeError:
                    discard


proc seqRight*[T](it: seq[T], n: int): seq[T] =
          ## seqRight
          ## 
          ## returns a new seq with n right end elements of the original seq
          ## 
          ## 

          try:
                result = it
                if n <= it.len: result = it[it.len - n..<it.len]
          except RangeError:
                discard


proc cxIsDigit*(s:string,sep:char = '.'):bool =
   ## cxIsDigit
   ## 
   ## checks if a string consists of elements in a digitset 
   ## that is numbers 0..9 and separators like '.' or ','
   ## default sep = '.'
   ## 
   ## 
   result = false
   for x in 0..<s.len:
      if s[x] in {'0','1','2','3','4','5','6','7','8','9',sep} :
         result = true
      else:
         result = false
         break 
      

proc fmtengine[T](a: string, astring: T): string =
          ## fmtengine - used internally
          ## ::
          ## simple string formater to right or left align within given param
          ## also can take care of floating point precision
          ## called by fmtx to process alignment requests
          ##
          var okstring = $astring
          var op = ""
          var dg = "0"
          var pad = okstring.len
          var dotflag = false
          var textflag = false
          var df = ""

          if a.startswith("<") or a.startswith(">"):
                    textflag = false
          elif a.len > 0 and isDigit(a[0]):
                    textflag = false
          else: textflag = true

          for x in a:

                    if isDigit(x) and dotflag == false:
                              dg = dg & $x

                    elif isDigit(x) and dotflag == true:
                              df = df & $x

                    elif $x == "<" or $x == ">":
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
                    if strutils.strip(df,true, true).len == 0: df = "0"
                    # in case of any edge cases throwing an error
                    try:
                              okstring = ff2(parseFloat(okstring), parseInt(
                                                  df))
                    except ValueError:
                              #printLn("Error , invalid format string dedected.",red)
                              #printLn("Showing exception thrown : ",peru)
                              echo()
                              raise

          var alx = spaces(max(0, pad - okstring.len))

          case op
                    of "<": okstring = okstring & alx
                    of ">": okstring = alx & okstring
                    else: discard

          # this cuts the okstring to size for display , not wider than dg parameter passed in
          # if the format string is "" no op no width than this will not be attempted
          if okstring.len > parseInt(dg) and parseInt(dg) > 0:
                    var dps = ""
                    for x in 0..<parseInt(dg):
                           dps = dps & okstring[x]
                    okstring = dps
          result = okstring



proc fmtx*[T](fmts: openarray[string], fstrings: varargs[T, `$`]): string =
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
         ##    echo fmtx(["","","<8.3",""," High : ","<8","","","","","","","",""],lime,"Open : ",unquote("1234.5986"),yellow,"",3456.67,red,downarrow,white," Change:",unquote("-1.34 - 0.45%"),"  Range : ",lime,@[123,456,789])
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

         result = ""
         # if formatstrings count not same as vararg count we bail out some error about fmts will be shown
         doassert(fmts.len == fstrings.len)
         # now iterate and generate the desired output
         for cc in 0 ..< fmts.len:
                   result = result & fmtengine(fmts[cc], fstrings[cc])



proc showRune*(s: string): string {.discardable.} =
         ## showRune
         ## ::
         ##   utility proc to show a single unicode char given in hex representation
         ##   note that not all unicode chars may be available on all systems
         ##
         ## Example
         ## 
         ##.. code-block :: nim
         ##      for x in 10 .. 55203: printLnBiCol($x & " : " & showRune(toHex(x)))
         ##      print(showRune("2191"),lime)
         ##      print(showRune("2193"),red)
         ##
         ##
         result = $Rune(parseHexInt(s))




proc unquote*(s: string): string =
          ## unquote
          ##
          ## remove any double quotes from a string
          ## 
          result = s.multiReplace(($'"', ""))


proc cleanScreen*() =
         ## cleanScreen
         ##
         ## very fast clear screen proc with escape seqs
         ##
         ## similar to terminal.eraseScreen() but cleans the terminal window more completely at times
         ##
         write(stdout, "\e[H\e[J")



proc centerX*(): int = tw div 2 + 2
         ## centerX
         ##
         ## returns an int with best terminal center position
         ##

proc centerPos*(astring: string) =
         ## centerpos
         ##
         ## tries to move so that string is centered when printing
         ##
         ##.. code-block:: nim
         ##    var s = "Hello I am centered"
         ##    centerPos(s)
         ##    printLn(s,gray)
         ##
         ##
         setCursorXPos(stdout, centerX() - astring.len div 2 - 2)


template colPaletteName*(coltype: string, n: int): auto =
         
          ## colPaletteName
          ##
          ## returns the actual name of the palette entry n
          ## eg. "mediumslateblue"
          ## see example at colPalette
          ##
          var ts = newseq[string]()
          # build the custom palette tss
          for colx in 0..<colorNames.len:
             if colorNames[colx][0].startswith(coltype) or colorNames[colx][0].contains(coltype):
                ts.add(colorNames[colx][0])

          # simple error handling to avoid indexerrors if n too large we try 0
          # if this fails too something will error out
          var m = n
          if m > colPaletteLen(coltype): m = 0
          ts[m]


template aPaletteSample*(coltype: string): int =
          ## aPaletteSample
          ## 
          ##  returns a rand entry (int) from a palette
          ##  see example at colPalette
          ##
          var coltypen = coltype.toLowerAscii()
          var b = newSeq[int]()
          for x in 0..<colPaletteLen(coltypen): b.add(x)
          rand(b)            

template paletix*(pl: string): untyped =
          ## paletix
          ## 
          ## returns a random color from colorNames containing the string pl
          ## 
          ## so paletix("pastel") filters on all colorNames having the string "pastel"
          ## 
          ## if filter not available then the first available color will be used
          ## 
          ##.. code-block:: nim
          ##   loopy2(1,10):
          ##      printLn(cxpad(" Hello from NimCx !  " & $xloopy,25),paletix("pastel"),styled={styleReverse,styleItalic,styleBright})

          colPalette(pl, getRndInt(0, colPaletteLen(pl) - 1))


template randCol2*(coltype: string): auto =
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
          if coltypen == "black": # no black
                    coltypen = "darkgray"
          var ts = newSeq[string]()
          for x in 0..<colorNames.len:
                    if colorNames[x][0].startswith(coltypen) or colorNames[x][
                                        0].contains(coltypen):
                              ts.add(colorNames[x][1])
          if ts.len == 0: ts.add(colorNames[getRndInt(0, colorNames.len - 1)][
                              1]) # incase of no suitable string we return standard randcol
          ts[sample(colPaletteIndexer(ts))] #rndsample


template randCol*(): string = sample(colorNames)[1]
        ## randCol
        ##
        ## get a randcolor from colorNames , no filter is applied 
        ##
        ##.. code-block:: nim
        ##    # print a string 6 times in a rand color selected from colorNames
        ##    loopy(0..5,printLn("Hello Random Color",randCol()))
        ##



template rndCol*(r: int = getRndInt(0, 254), g: int = getRndInt(0, 254),b: int = getRndInt(0, 254)): string = "\x1b[38;2;" & $r & ";" & $b & ";" & $g & "m"
        ## rndCol
        ## 
        ## return a randcolor from the whole rgb spectrum in the ranges of RGB [0..254]
        ## expect this colors maybe a bit more drab than the colors returned from randCol()
        ## 
        ##.. code-block:: nim
        ##    # print a string 6 times in a rand color selected from rgb spectrum
        ##    loopy(0..5,printLn("Hello Random Color",rndCol()))
        ##
    
    
    
    
# cxLine is a line creation object with several properties 
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
                              result[fieldNum] = s[start .. i - 1]
                              start = i + 1
                              fieldNum += 1
          result[fieldNum] = s[start..^1]



proc splitty*(txt: string, sep: string): seq[string] =
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
                 if z[xx] != txt and z[xx] != "":
                         if xx < z.len-1:
                               rx.add(z[xx] & sep)
                         else:
                               rx.add(z[xx])
          result = rx


proc doFlag*[T](flagcol: string = yellowgreen,
                flags: int = 1,
                text: T = "",
                textcol: string = termwhite): string {.discardable.} =
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


proc getAscii*(s: string): seq[int] =
          ## getAsciicode
          ## 
          ## returns a seq[int]  with ascii integer codes of every character in a string 
          ##
          result = @[]
          for c in s:
                    result.add(c.int)


# simple navigation mostly mirrors terminal.nim functions

template curUp*(x: int = 1) =
         ## curUp
         ##
         ## mirrors terminal Up
         cursorUp(stdout, x)


template curDn*(x: int = 1) =
         ## curDn
         ##
         ## mirrors terminal Down
         cursorDown(stdout, x)


template curBk*(x: int = 1) =
         ## curBkn
         ##
         ## mirrors terminal Backward
         cursorBackward(stdout, x)


proc curFw*(x: int = 1): auto {.discardable.} =
         ## curFw
         ##
         ## mirrors terminal Forward
         cursorForward(stdout, x)
         result = " " * x

template curSetx*(x: int) =
         ## curSetx
         ##
         ## mirrors terminal setCursorXPos
         setCursorXPos(stdout, x)

template cxPos*(x): string = "\e[" & $(x + 1) & "G"
         ## cxPos
         ##
         ## mirrors terminal setCursorXPos
         ##

template curSet*(x: int = 0, y: int = 0) =
         ## curSet
         ##
         ## mirrors terminal setCursorPos at x,y position
         ##
         ##
         setCursorPos(x, y)

            

template clearup*(x: int = 80) =
         ## clearup
         ##
         ## a convenience proc to clear monitor x rows
         ##
         erasescreen(stdout)
         curup(x)


proc curMove*(up: int = 0,
              dn: int = 0,
              fw: int = 0,
              bk: int = 0) =
         ## curMove
         ##
         ## conveniently move the  to where you need it
         ##
         ## relative of current postion , which you app need to track itself
         ##
         ## setting  off terminal will wrap output to next line
         ##
         curup(up)
         curdn(dn)
         curfw(fw)
         curbk(bk)

         
         
template curOn* = 
     ## curOn
     ## 
     ##  on , mirrors function showCursor from terminal.nim
     ## 
     showCursor()
     

template curOff* =
     ## curOff
     ## 
     ##  off , mirrors function hideCursor from terminal.nim
     ## 
     hideCursor()
                

proc stripper*(str: string): string =
     # stripper
     # strip controlcodes "\ba\x00b\n\rc\fd\xc3"
     result = ""
     for ac in str:
         if ord(ac) in 32..126: result.add ac
          

template `<>`* (a, b: untyped): untyped =
      ## unequal operator 
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

template loopy*[T](ite: T, st: untyped) =
         ## loopy
         ##
         ## the lazy programmer's quick simple for-loop template
         ##
         ##.. code-block:: nim
         ##       loopy(0..<10,printLn("The house is in the back.",randcol()))
         ##
         for x in ite: st


template loopy2*(mi: int = 0, ma: int = 5, st: untyped) =
         ## loopy2
         ##
         ## the advanced version of loopy the simple for-loop template
         ## which also injects the loop counter xloopy if loopy2() was called with parameters
         ## if called without parameters xloopy will not be injected .
         ## 
         ##.. code-block:: nim
         ##   loopy2(1,10):
         ##     block:
         ##        printLnBiCol(xloopy , "  The house is in the back.",randcol(),randcol(),":",0,false,{})
         ##        printLn("Some integer : " & $getRndInt())
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

proc streamFile*(filename: string, mode: FileMode): FileStream = newFileStream(filename, mode)
     ## streamFile
     ##
     ## creates a new filestream opened with the desired filemode
     ##
     ##

proc uniform*(a, b: float): float {.inline.} =
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


proc sampleSeq*[T](x: seq[T], a: int, b: int): seq[T] =
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
     result = x[a..b]


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



template colPaletteIndexer*(colx: seq[string]): auto = toSeq(colx.low .. colx.high)

template colPaletteLen*(coltype: string): auto =
          ##  colPaletteLen
          ##  
          ##  returns the len of a colPalette of colors in colorNames
          ##
          var ts = newseq[string]()
          for x in 0..<colorNames.len:
                    if colorNames[x][0].startswith(coltype) or colorNames[x][
                                        0].contains(coltype):
                              ts.add(colorNames[x][1])
          colPaletteIndexer(ts).len


template colPalette*(coltype: string, n: int): auto =
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
         ##     decho()
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
                    if colorNames[colx][0].startswith(coltype) or colorNames[
                                        colx][0].contains(coltype):
                              ts.add(colorNames[colx][1])
         if m > colPaletteLen(coltype): m = 0
         ts[m]


template colorsPalette*(coltype: string): auto =
         ## ::
         ##   colorsPalette
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

         var pal = newseq[(string, string)]()
         for colx in 0..<colorNames.len:
                    if colorNames[colx][0].startswith(coltype) or colorNames[
                                        colx][0].contains(coltype):
                              pal.add((colorNames[colx][0], colorNames[colx][
                                                  1]))

         if pal.len < 1:
                    printLnErrorMsg(colorsPalette)
                    printLnBErrorMsg("Desired filter may not be available",
                                        red)
                    printLnBErrorMsg(
                                        "        Try:  medium , dark, light, blue, yellow etc.",
                                        red)
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

template upperCase*(s: string): string = toUpperAscii(s)
         ## upperCase
         ## 
         ## upper cases a string
         ##

template lowerCase*(s: string): string = toLowerAscii(s)
         ## lowerCase
         ## 
         ## lower cases a string
         ##

template currentLine*() =
          ## currentLine
          ## 
          ## simple template to return line number , maybe usefull for debugging
          ## 
          var pos: tuple[filename: string, line: int, column: int] = ("", -1,-1)
          pos = instantiationInfo()
          printLnInfoMsg("CurrentLine"," File: " & pos.filename & "  Line:" & $(pos.line) & " Column:" & $(pos.column), truetomato, xpos = 1)
          

template hdx*(code: typed, frm: string = "+", width: int = tw, nxpos: int = 0): void =
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
          var lx = repeat(frm, width div frm.len)
          printLn(lx, xpos = xpos)
          cursetx(xpos + 2)
          code
          printLn(lx, xpos = xpos)
          echo()



# end of cxglobal.nim
