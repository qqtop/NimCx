{.deadCodeElim: on, optimization: speed.}
# {.experimental: "codeReordering".}  # does this have any effect forward declarations are still needed
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
##     Latest      : 2019-11-07
##
##     Compiler    : Nim >= 1.0.0 or 1.1.1 
##
##     OS          : Linux
##
##     Description : provides many basic utility functions of the library
##


import
          cxconsts,
          cxtime,
          cxprint,
          cxhash,
          terminal,
          strutils,
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
          os,
          osproc,
          cpuinfo,
          rdstdin,
          times,
          unicode
          
{.hint: "\x1b[38;2;154;205;50m ╭──────────────────────── NIMCX ─────────────────────────────────────╮ " .}
    
{.hint: "\x1b[38;2;154;205;50m \u2691  NimCx     " & "\x1b[38;2;255;215;0m Officially made for Linux only." & 
                spaces(23) & "\x1b[38;2;154;205;50m \u2691 ".}
                
{.hint: "\x1b[38;2;154;205;50m \u2691  Compiling " &
        "\x1b[38;2;255;100;0m cxglobal.nim \xE2\x9A\xAB" &
        " " & "\xE2\x9A\xAB" & spaces(36) & "\x1b[38;2;154;205;50m \u2691 ".}
         
{.hint: "\x1b[38;2;154;205;50m ╰──────────────────────── CXGLOBAL ──────────────────────────────────╯ " .}


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

template tw*: int = terminalWidth() ## tw , a global where latest terminal width is always available

template th*: int = terminalHeight() ## th , a global where latest terminal height is always available

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
          ## pads a string on the right side with spaces to specified padlen 
          ##
          result = s
          if s.len < padlen:
              result = s & (paddy * (max(0, padlen - s.len)))

func cxpdx*(padLen: int, s: string, paddy: string = spaces(1)): string =
          ## pdx 
          ## 
          ## same as cxpad but with padding char count in front
          ##
          cxpad(s, padLen, paddy)

func cxLpad*(s: string, padlen: int, paddy: string = spaces(1)): string =
          ## cxlpad
          ## 
          ## pads a string on the left side with spaces to specified padlen
          ##
          result = s
          if s.len < padlen:
              result = (paddy * (max(0, padlen - s.len))) & s

func cxLpdx*(padLen: int, s: string, paddy: string = spaces(1)): string =
          ## cxlpdx 
          ## 
          ## same as cxpad but with padding char count in front
          ##
          cxLpad(s, padLen, paddy)


func cxLpadN*(s: string, padlen: int, paddy: string = "0"): string =
          ## cxlpadN
          ##
          ## left pad for numbers
          ##
          ## pads a string on the left side with "0" default or string to specified padlen
          ##
          result = s
          if result.startsWith("-") == false:
            if s.len < padlen:
              result = (paddy * (max(0, padlen - s.len))) & s
          else:
              result.removePrefix("-")
              result = (paddy * (max(0, padlen - s.len))) & result
              result = "-" & result


func cxLpadN*(s: SomeNumber, padlen: int, paddy: string = "0"): string =
          ## cxlpadN
          ##
          ## left pad for numbers
          ##
          ## pads a number on the left side with "0" default or string to specified padlen
          ##
          result = $s
          if result.startsWith("-") == false:
            if result.len < padlen:
              result = (paddy * (max(0, padlen - result.len))) & result
          else:
              result.removePrefix("-")
              result = (paddy * (max(0, padlen - result.len - 1))) & result
              result = "-" & result

              

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
          let mytime = now()  
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
          for i, x in xs: result[xs.high - i] = x

proc reverse*[T](s: var seq[T]) =
  ## reverse
  ##
  ## in place reverse sequence
  ## 
  for i in 0 .. (s.high - 1) shr 1: swap(s[i], s[s.high - i])

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
          ## if thousands seperators are requirewd use ff2
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

          for x in 0 ..< zrv.len:
                    zrs = zrs & $zrv[x]

          for x in 0 ..< zrs.len:
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
          when zz is SomeSignedInt == false:
             result = zz.formatFloat()   # cannot use $ as it introduces rounding errors
                       
          when zz is SomeSignedInt:
                  let rresult = ff22(zz)     
                  if n == 0:
                       result = rresult 
                  if n > 0 :
                       result = rresult & "." & "0" * n
                  result.removeSuffix(".") 
                      
          else:   # so must be some float
              
                if not result.contains("e"):
                  let c = rpartition(result, ".")
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
                           if c[0] == "-0":
                                result = "-" & ff22(parseInt(c[0])) & c[1] & cnew
                           else:     
                                result = ff22(parseInt(c[0])) & c[1] & cnew
                        except:  # if there is nil ? we might get here
                            discard
                else:
                    # we have a scientific format containg e+ or e-
                    # we just format according to desired decimals n
                    result = zz.formatFloat(ffScientific, n)
                            

proc ff2Eu*(zzz: SomeNumber, n: int = 3):string =
     ## ff2Eu
     ##
     ## convert a number into EU locale formatted string
     ## 1234567.123   -->  1.234.567,123
     ## set after comma positions with n , default is 3
     ##
     ##.. code-block:: nim
     ##    echo ff2Eu(1234567.123)
     ##
     
     var z = ff2(zzz,n) 
     var zz = z.replace(",",".").splitty(".")
     if zz.len > 0:
        for x in 0 ..< zz.len - 1: result = result & zz[x]
        result.removeSuffix(".")    
        result = result & "," & zz[zz.high]
     else:
         result = z   



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
      

proc fmtEngine[T](a: string, astring: T): string =
          ## fmtEngine - used internally
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
                    # like 1,234.56  instead of 1234.56 other EU-locale not supported
               
                    # if df is nil we make it zero so no valueerror occurs
                    if strutils.strip(df,true, true).len == 0: df = "0"
                    # in case of any edge cases throwing an error
                    try:
                          okstring = ff2(parseFloat(okstring), parseInt(df))
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
             if colorNames[x][0].startswith(coltypen) or colorNames[x][0].contains(coltypen):
                 ts.add(colorNames[x][1])
          if ts.len == 0: ts.add(colorNames[getRndInt(0, colorNames.len - 1)][1]) # if no suitable string return a randcol
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
          for c in s: result.add(c.int)


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
         for xloopy {.inject.} in mi ..< ma: st


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

# code from former cxutils.nim here below

# type used in getRandomPoint
type
    RpointInt*   = tuple[x, y : int]
    RpointFloat* = tuple[x, y : float]

 
proc fibi*(n: int): uint64 =
  # ex nim forum super fast fibonacci 
  if n > 1 and n != 30: return fibi(n - 1) + fibi(n - 2)
  if n <= 1: return 1
  let x {.global.}: auto = fibi(29) + fibi(28)
  return x 
       
       
proc pswwaux*() =
   ## pswwaux
   ## 
   ## utility bash command :  ps -ww aux | sort -nk3 | tail
   ## displays output in console
   ## 
   let pswwaux = execCmdEx("ps -ww aux | sort -nk3 | tail ")
   printLn("ps -ww aux | sort -nk3 | tail ",yellowgreen)
   echo  pswwaux.output
   decho()
                
proc cxCpuInfo*():string = 
   ## cxCpuInfo
   ## 
   ## executes a system command to get cpu information
   ## 
   var (output,error) = execCmdEx("cat /proc/cpuinfo | grep name |cut -f2 -d:")
   if error <> 0:
     result = $error
   else:  
     result = output

proc cpuInfo*():seq[string] {.discardable.} =
   # cpuInfo
   # requires lscpu available on system
  
   try:
       result = execProcess("lscpu").splitLines()
   except:
       printLnErrorMsg("lscpu command my not be available on this system") 
       result = @["lscpu command my not be available on this system"]

proc showCpuInfo*() =
   echo()
   printLn("CPU Information" & spaces(40) , skyblue,yalebluebg)
   try:
      #let lscp = execProcess("lscpu")
      #let lscp1 = lscp.splitLines()
      for x in cpuInfo():
          if not x.startswith("Flags:"): printLnBiCol(x)
   except:
       printLnErrorMsg("lscpu command my not be available on this system") 
   echo()   
         

proc cxVideoInfo*():string = 
   ## cxVideoInfo
   ## 
   ## executes a system command to get video setup information
   ## may show warning on certain systems to run as super user
   ##
   ## lshw needs to be installed on your system
   ## see lshw man pages for much more
   ##
   var (output,error) = execCmdEx("lshw -c video")
   if error <> 0: result = $error
   else: result = output   
   

proc showCpuCores*() =
    ## showCpuCores
    ## 
    printLnBiCol("System CPU cores : " & $cpuInfo.countProcessors())
   

proc getAmzDateString*():string =
    ## getAmzDateString
    ## 
    ## get current GMT date time in amazon format  
    ## 
    return format(utc(getTime()), iso_8601_aws) 
    

proc getUserName*():string =
     # just a simple user name prompt 
     result = readLineFromStdin(" Enter your user name    : ")
        

proc getPassword*(ahash:int64 = 0i64):string =
     ## getPassword
     ## 
     ## convenience function, prompts user for a password
     ## to be checked against a passwordhash which could come 
     ## from a security database or other source
     ## 
     #  using a hash to confirm the password
     #  this is a skeleton password function        
     result = ""
     curfw(1)
     let zz = readPasswordFromStdin("Enter Password : ")
     if verifyHash(zz,ahash) :
           curup(1)
           print(cleareol)
           # following could also be send to a logger
           cxprintLn(1,white,darkslategraybg,"Access granted at : " , limegreen,truebluebg, cxnow)
           echo()
           result = zz
     else:
           curup(1)
           let dn = "Access denied at : " & cxnow
           cxprintln(1,yellow,redbg,dn)
           cxprintln(1,pastelWhite,yalebluebg,cxpad("Exiting now . Bye Bye.",dn.len))
           decho(2)
           quit(1)
    

proc cxInput*(prompt: string,promptColor:string=greenYellow,xpos:int = 0,
               allowBlank:bool = false): string =
               
     ## cxInput
     ##
     ## simple input function with desired color and position
     ## if allowBlank is false then an alert message will be shown
     ## and function will wait for input again 
     ##
     ## allowBlank if set to true will allow "" as result
     ##
     ## result is a string for further processing as needed.
     ##
     ##.. code-block:: nim    
     ##   cleanScreen()
     ##   curset(1,5)
     ##   var name = cxInput("Enter your name : ",yellowgreen,xpos=1)
     ##   curset(30,5)
     ##   var age = cxInput("Enter your age : ",yellowgreen,xpos=30)
     ##   curset(60,5)
     ##   var wallet = cxInput("Enter your Bitcoin wallet No : ",yellowgreen,xpos=60)
     ##   decho(2)
     ##   cxprintLn 1,satBlue,styleReverse,"Results "
     ##   cxprintln 1,yellowgreen,"Replies given : " ,termwhite, name,"  ",age," ",wallet
      
     while (cxprint(xpos,promptColor,prompt);result = stdin.readLine();result.len == 0):
            if allowBlank == false:
               cxprintLn(xpos,truetomato ,"No Input. Try again.")
               curup(2)
             
     echo clearLine;curup()

    
proc cxDayOfWeek*(datestr:string):string = 
    ## cxDayOfWeek
    ## 
    ## returns day of week from a date in format yyyy-MM-dd
    ## 
    ##.. code-block:: nim    
    ##    echo cxDayOfWeek(cxtoday())
    ##    echo getNextMonday("2017-07-15"),"  ",cxDayOfWeek(getNextMonday("2017-07-15"))

    if datestr.len==10:
       result = $(getDayOfWeek(parseInt(day(datestr)),parseInt(month(datestr)).Month,parseInt(year(datestr))))      
    else:
       cxprintln(5,white,bgred,"Invalid date received . Required format is yyyy-MM-dd. --> cxUtils : cxDayOfWeek")
       result=""
       

proc getNextMonday*(adate:string):string =
    ## getNextMonday
    ##
    ##.. code-block:: nim
    ##    echo  getNextMonday(getDateStr())
    ##
    ##
    ##.. code-block:: nim
    ##      import nimcx
    ##      # get next 10 mondays
    ##      var dw = getdatestr()
    ##      echo dw
    ##      for x in 1..10:
    ##         dw = getnextmonday(dw)
    ##         echo dw
    ##         dw = plusDays(dw,1)
    ##
        
    var ndatestr = ""
    if adate == "" :
        cxprintln(2,black,redbg,"Received an invalid date.")
    else:
        if validdate(adate) == true:
            var z = cxdayofweek(adate)
            if z == "Monday":
                # so the datestr points to a monday we need to add a
                # day to get the next one calculated
                ndatestr = plusDays(adate,1)
            ndatestr = adate
            for x in 0..<7:
                if validdate(ndatestr) == true:
                    z =  cxDayOfWeek(ndatestr)
                if strutils.strip(z) != "Monday":
                    ndatestr = plusDays(ndatestr,1)
                else:
                    result = ndatestr

   
proc getRandomPointInCircle*(radius:float = 1.0) : seq[float] =
    ## getRandomPointInCircle
    ##
    ## based on answers found in
    ##
    ## http://stackoverflow.com/questions/5837572/generate-a-random-point-within-a-circle-uniformly
    ##
    ##
    ##
    ## .. code-block:: nim
    ##    import nimcx
    ##    # get randompoints in a circle
    ##    var crad:float = 2.1
    ##    for x in 0..100:
    ##        var k = getRandomPointInCircle(crad)
    ##        assert k[0] <= crad and k[1] <= crad
    ##        if k[0] <= crad and k[1] <= crad:
    ##            printLnBiCol(fmtx([">25","<6",">10"],ff2(k[0])," :",ff2(k[1])))
    ##        else:
    ##            printLnBiCol(fmtx([">25","<6",">10"],ff2(k[0])," :",ff2(k[1])),colLeft=red,colRight=red)
    ##
    ##
    let r = radius * sqrt(abs(getrndfloat()))      # polar
    let theta = getrndfloat() * 2 * math.Pi        # polar
    let x = r * cos(theta)                         # cartesian
    let y = r * sin(theta)                         # cartesian
    var z = newSeq[float]()   
    z.add(x)
    z.add(y)
    return z


proc getRandomPoint*(minx:float = -500.0,maxx:float = 500.0,miny:float = -500.0,maxy:float = 500.0) : RpointFloat =
    ## getRandomPoint
    ##
    ## generate a random x,y float point pair and return it as RpointFloat
    ## 
    ## minx  min x  value
    ## maxx  max x  value
    ## miny  min y  value
    ## maxy  max y  value
    ##
    ## .. code-block:: nim
    ##
    ##  for x in 1..10:
    ##      let n = getRandomPoint(-500.00,200.0,-100.0,300.00)
    ##      cxwriteln(fmtx(["",">3","",">4","",">7.2","","",">4","",">7.2"],
    ##      "point ",$x,
    ##      yellowgreen," x:",termwhite,ff2(n.x,4),
    ##      spaces(3),
    ##      yellowgreen," y:",termwhite,ff2(n.y,4)))
    ##  decho(2)
    ##  

    var point : RpointFloat
    var rx    : float
    var ry    : float
      
    if minx < 0.0:   rx = minx - 1.0 
    else        :    rx = minx + 1.0  
    if maxy < 0.0:   rx = maxx - 1.0 
    else        :    rx = maxx + 1.0 
    if miny < 0.0:   ry = miny - 1.0 
    else        :    ry = miny + 1.0  
    if maxy < 0.0:   ry = maxy - 1.0 
    else        :    ry = maxy + 1.0         
        
    var mpl = abs(maxx) * 1000     
    while rx < minx or rx > maxx:
       rx =  getRandomSignF() * mpl * getRandomFloat()  
       
    mpl = abs(maxy) * 1000   
    while ry < miny or ry > maxy:  
          ry =  getRandomSignF() * mpl * getRandomFloat()
        
    point.x = rx
    point.y = ry  
    result =  point
      
  
proc getRandomPoint*(minx:int = -500 ,maxx:int = 500 ,miny:int = -500 ,maxy:int = 500 ) : RpointInt =
    ## getRandomPoint 
    ##
    ## generate a random x,y int point pair and return it as RpointInt
    ## 
    ## min    x or y value
    ## max    x or y value
    ##
    ## .. code-block:: nim
    ##    for x in 0..10:
    ##        var n = getRandomPoint(-500,500,-500,200)
    ##        cxwriteln(fmtx([">4",">5","",">6",">5"],"x:",$n.x,spaces(7),"y:",$n.y),spaces(7))
    ## 
    var point : RpointInt
    point.x = getRandomSignI() * getRndInt(minx,maxx) 
    point.y = getRandomSignI() * getRndInt(miny,maxy)  
    result = point


proc getPointInSphere*():auto =
    ## getPointInSphere
    ## 
    ## returns x,y,z coordinates for a point in sphere with max size  1,1,1
    ## 
    ## https://karthikkaranth.me/blog/generating-random-points-in-a-sphere/#better-choice-of-spherical-coordinates
    ## 
    ## .. code-block:: nim
    ##    # display 100 coordinates of in sphere points
    ##    for x in countup(0,99,1):      
    ##       let b = getPointinSphere()  
    ##       cxwriteln(fmtx(["","","",">7","","","",">7","","","",">7"],limegreen, "  x: ",white, b[0],limegreen,"  y: ",white,b[1],limegreen,"  z: ",white,b[2]))
    ##       
    ##       
    let u = rand(1.0);
    let v = rand(1.0);
    let theta = u * 2.0 * PI;
    let phi = arccos(2.0 * v - 1.0);
    let r = cbrt(rand(1.0));
    let sinTheta = sin(theta);
    let cosTheta = cos(theta);
    let sinPhi = sin(phi);
    let cosPhi = cos(phi);
    let x = r * sinPhi * cosTheta;
    let y = r * sinPhi * sinTheta;
    let z = r * cosPhi;
    result = @[x,y,z]
    
        
proc randpos*():int =
    ## randpos
    ##
    ## sets to a random position in the visible terminal window
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
    result = x

template getCard* :auto =
    ## getCard
    ##
    ## gets a random card from the Cards seq
    ##
    ## .. code-block:: nim
    ##    import nimcx
    ##    printLn(getCard(),randCol(),xpos = centerX())  # get card and print in random color at xpos
    ##    doFinish()
    ##
    cards[sample(rxCards)]
    

proc showRandomCard*(xpos:int = centerX()) = 
    ## showRandomCard
    ##
    ## shows a random card at xpos from the cards set in cxconstant.nim, default is centered
    ##
    print(getCard(),randCol(),xpos = xpos)


proc showRuler* (xpos:int=0,xposE:int=0,ypos:int = 0,fgr:string = white,bgr:string = getBg(bgDefault), vert:bool = false) =
     ## ruler
     ##
     ## simple terminal ruler indicating dot x positions starts with position 1
     ##
     ## horizontal --> vert = false
     ## 
     ## for vertical   --> vert = true
     ##
     ##
     ## .. code-block::nim
     ##   # this will show a full terminal width ruler
     ##   showRuler(fgr=pastelblue)
     ##   decho(3)
     ##   # this will show a specified position only
     ##   showRuler(xpos =22,xposE = 55,fgr=pastelgreen)
     ##   decho(3)
     ##   # this will show a full terminal width ruler starting at a certain position
     ##   showRuler(xpos = 75,fgr=pastelblue)
     ##
     echo()
     var fflag:bool = false
     var npos  = xpos
     var nposE = xposE
     if xpos == 0: npos  = 0
     if xposE == 0: nposE = tw - 3
     if vert == false :  # horizontalruler
          for x in npos .. nposE:
            if x == 0:
                curup(1)
                print(".",lime,bgr,xpos = 0)
                curdn(1)
                print(1,fgr,bgr,xpos = 0)
                curup(1)
                fflag = true

            elif x mod 5 > 0 and fflag == false:
                curup(1)
                print(".",goldenrod,bgr,xpos = x)
                curdn(1)

            elif x mod 5 == 0:
                if fflag == false:
                  curup(1)
                print(".",lime,bgr,xpos = x)
                curdn(1)
                print(x,fgr,bgr,xpos = x)
                curup(1)
                fflag = true

            else:
                fflag = true
                print(".",truetomato,bgr,xpos = x)

     else : # vertical ruler

            if  ypos >= th : curset()
            else: curup(ypos + 2)

            for x in 0..ypos:
                  if x == 0: printLn(".",lime,bgr,xpos = xpos + 3)
                  elif x mod 2 == 0:
                         print(x,fgr,bgr,xpos = xpos)
                         printLn(".",fgr,bgr,xpos = xpos + 3)
                  else: printLn(".",truetomato,bgr,xpos = xpos + 3)
     decho(3)


proc centerMark*(showpos :bool = false) =
     ## centerMark
     ##
     ## draws a red dot in the middle of the screen xpos only
     ## and also can show pos
     ##
     centerPos(".")
     print(".",truetomato)
     if showpos == true:  print "x" & $(tw/2)


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
      print(cleareol)
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
        ##.. code-block:: nim
        ##    import nimcx
        ##
        ##    superheader("Ok That's it for Now !",skyblue,lightslategray)
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

# Unicode random word creators

proc newWordCJK*(minwl:int = 3 ,maxwl:int = 10):string =
      ## newWordCJK
      ##
      ## creates a new random string consisting of n chars default = max 10
      ##
      ## with chars from the cjk unicode set
      ##
      ## http://unicode-table.com/en/#cjk-unified-ideographs
      ##
      ## requires unicode
      ##
      ## .. code-block:: nim
      ##    # create a string of chinese or CJK chars with length 20 
      ##    echo newWordCJK(20,20)
      ##
      result = ""
      if minwl <= maxwl:
         let c5 = toSeq(minwl..maxwl)
         let chc = toSeq(parsehexint("3400")..parsehexint("4DB5"))
         for xx in 0..<sample(c5): result = result & $Rune(sample(chc))
      else:
        cxprintln(2,black,redbg,"Error : minimum word length larger than maximum word length")
        result = ""

        
proc newWord*(minwl:int=3,maxwl:int = 10):string =
    ## newWord
    ##
    ## creates a new lower case random word with chars from Letters set
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##

    if minwl <= maxwl:
        var nw = ""
        # words with length range 3 to maxwl
        let maxws = toSeq(minwl..maxwl)
        # get a random length for a new word
        let nwl = sample(maxws)
        let chc = toSeq(33..126)
        while nw.len < nwl:
           var x = sample(chc)
           if char(x) in Letters:
              nw = nw & $char(x)
        result = normalize(nw)   # return in lower case , cleaned up
    else:
        cxprintln(2,black,redbg,"Error : minimum word length larger than maximum word length")
        result = ""


proc newWord2*(minwl:int=3,maxwl:int = 10 ):string =
    ## newWord2
    ##
    ## creates a new lower case random word with chars from IdentChars set
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##
    if minwl <= maxwl:
        var nw = ""
        # words with length range 3 to maxwl
        let maxws = toSeq(minwl..maxwl)
        # get a random length for a new word
        let nwl = sample(maxws)
        let chc = toSeq(33..126)
        while nw.len < nwl:
          var x = sample(chc)
          if char(x) in IdentChars:
              nw = nw & $char(x)
        result = normalize(nw)   # return in lower case , cleaned up
    else:
         cxprintln(2,black,redbg,"Error : minimum word length larger than maximum word length")
         result = ""


proc newWord3*(minwl:int=3,maxwl:int = 10 ,nflag:bool = true):string =
    ## newWord3
    ##
    ## creates a new lower case random word with chars from AllChars set if nflag = true
    ##
    ## creates a new anycase word with chars from AllChars set if nflag = false
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##
    if minwl <= maxwl:
        var nw = ""
        # words with length range 3 to maxwl
        let maxws = toSeq(minwl..maxwl)
        # get a random length for a new word
        let nwl = sample(maxws)
        let chc = toSeq(33..126)
        while nw.len < nwl:
          var x = sample(chc)
          if char(x) in AllChars:
              nw = nw & $char(x)
        if nflag == true:
           result = normalize(nw)   # return in lower case , cleaned up
        else :
           result = nw
    else:
         cxprintln(2,black,redbg,"Error : minimum word length larger than maximum word length")
         result = ""


proc newHiragana*(minwl:int=3,maxwl:int = 10 ):string =
    ## newHiragana
    ##
    ## creates a random hiragana word without meaning from the hiragana unicode set
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##
    if minwl <= maxwl:
        result = ""
        var rhig = toSeq(12353..12436)  
        var zz = sample(toSeq(minwl..maxwl))
        while result.len < zz:
              var hig = sample(rhig)  
              result = result & $Rune(hig)
       
    else:
         cxprintln(2,black,redbg,"Error : minimum word length larger than maximum word length")
         result = ""


proc newKatakana*(minwl:int=3,maxwl:int = 10 ):string =
    ## newKatakana
    ##
    ## creates a random katakana word without meaning from the katakana unicode set
    ##
    ## default min word length minwl = 3
    ##
    ## default max word length maxwl = 10
    ##
    if minwl <= maxwl:
        result  = ""
        while result.len < sample(toSeq(minwl..maxwl)):
              result = result & $Rune(sample(toSeq(parsehexint("30A0")..parsehexint("30FF"))))  
    else:
        cxprintln(2,black,redbg,"Error : minimum word length larger than maximum word length")
        result = ""

proc newText*(textLen:int = 1000,textgen:string = "newWord"):string = 
     ## newText
     ## 
     ## creates random text made up of random chars from 
     ## 
     ## var. newWord procs 
     ## 
     ## textgen can be one of :
     ## 
     ##  newWord
     ##  newWord2
     ##  newWord3 
     ##  newHiragana
     ##  newKatakana
     ##  newWordCJK
     ##  
     ##.. code-block:: nim
     ##  printLn(newText(10000,"newHiragana"),rndcol)
     ##    
     ##
     
     var tres = ""
     case toLowerAscii(textgen) 
       of "newword":
             tres = ""
             while result.len < textLen:
                if tres.len < 100: # line length
                       tres = tres & " " & newWord()
                else:
                       result = result & newline() & tres
                       tres = ""
       of "newword2":
             tres = ""
             while result.len < textLen:
                if tres.len < 100: # line length
                       tres = tres & " " & newWord2()
                else:
                       result = result & newline() & tres
                       tres = ""
       
       of "newword3":
             tres = ""
             while result.len < textLen:
                if tres.len < 100: # line length
                       tres = tres & " " & newWord3()
                else:
                       result = result & newline() & tres
                       tres = ""
                       
       of "newhiragana":
             tres = ""
             while result.len < textLen:
                if tres.len < 100: # line length
                       tres = tres & " " & newHiragana()
                else:
                       result = result & newline() & tres
                       tres = ""
       
       of "newkatakana":
             tres = ""
             while result.len < textLen:
                if tres.len < 100: # line length
                       tres = tres & " " & newKatakana()
                else:
                       result = result & newline() & tres
                       tres = ""
                       
       of "newwordcjk":
             tres = ""
             while result.len < textLen:
                if tres.len < 100: # line length
                       tres = tres & " " & newWordCJK()
                else:
                       result = result & newline() & tres
                       tres = ""     
       else:
            decho()
            cxprintLn(2,black,redbg,"newText() ")
            cxprintLn(2,black,redbg,"Error : " & textgen & " generator proc not available !")
            discard                
                     
proc rndStr*(n:int = 20): string =
  ## rndStr
  ## 
  ## random string with len n between 0 and hex 4DB5
  ## 
 
  for _ in 0 ..< n:
    let s = sample([1,2,3])
    case s 
      of 1 : add(result, char(rand(int('0') ..< parsehexint("4DB5"))))
      of 2 : add(result,newWordCJK(1,1))
      of 3 : add(result, char(rand(int('0') ..< int('z'))))
      else: add(result,'0')    
      
      

proc createRandomDataFile*(filename:string = "randomdata.dat") =
    ## createRandomDataFile
    ## 
    ## this will create a file with given filename and size 1 MB
    ## filled with strong random data
    ## 
    ## .. code-block:: nim
    ##    
    ##    createRandomDataFile("niip2.wsx")
    ##    var bc = 0
    ##    var b = @[100,200,300,700,800,3000]
    ##    withFile(fs,"niip2.wsx",fmRead):
    ##      var line =""
    ##      while fs.readLine(line):
    ##         inc bc
    ##         if bc in b:
    ##           printLn($bc & rightarrow & spaces(3) & wrapwords(line.replace(" ",""),(tw - 5)),yellowgreen)
    ##    echo bc     
    ##
    discard  execCmd("dd if=/dev/urandom of=$1 bs=1M count=1" % filename)
      
                                    
proc cxBinomialCoeff*(n, k:int): int =
    # cxBinomialCoeff
    # 
    # function returns BinomialCoefficient
    # 
    result = 1
    var kk = k
    if kk < 0 or kk  >  n: result = 0
    if kk == 0 or kk == n: result = 1
    kk = min(kk, n - kk) 
    for i in 0..<kk: result = result * (n - i) div (i + 1)
 
 
template bitCheck*(a, b: untyped): bool =
    ## bitCheck
    ## 
    ## check bitsets 
    ##  
    (a and (1 shl b)) != 0    
      

proc createSeqAll*(min:int = 0,max:int = 40878):seq[string] =
     # for testing purpose only in the future the unicodedb by nitely is the way to go
     var gs = newSeq[string]()
     for j in min ..< max :        # depending on whats installed  
     
            # there are more chars up to maybe 120150 some
            # maybe for indian langs,iching, some special arab and koran symbols if installed on the system
            # if not installed on your system you will see the omnious rectangle char  0xFFFD
            # https://www.w3schools.com/charsets/ref_html_utf8.asp
            # tablerune(createSeqAll(),cols=6,maxitemwidth=12)  
            # 
            gs.add($Rune(j)) 
     result = gs    
   
    
proc createSeqGeoshapes*():seq[string] =
     ## createSeqGeoshapes
     ## 
     ## returns a seq containing geoshapes unicode chars
     ## 
     var gs = newSeq[string]()
     for j in 9632..9727: gs.add($Rune(j))
     result = gs
     
proc createSeqHiragana*():seq[string] =
    ## hiragana
    ##
    ## returns a seq containing hiragana unicode chars
    var hir = newSeq[string]()
    for j in 12353..12436: hir.add($Rune(j)) 
    result = hir
    
   
proc createSeqKatakana*():seq[string] =
    ## full width katakana
    ##
    ## returns a seq containing full width katakana unicode chars
    ##
    var kat = newSeq[string]()
    # s U+30A0–U+30FF.
    for j in parsehexint("30A0")..parsehexint("30FF"): kat.add($Rune(j))
    for j in parsehexint("31F0")..parsehexint("31FF"): kat.add($Rune(j))  # Katakana Phonetic Extensions
    result = kat

proc createSeqCJK*():seq[string] =
    ## full cjk unicode range returned in a seq
    ##
    ##.. code-block:: nim
    ##   import nimcx    
    ##   var b = createSeqCJK()   
    ##   var col = 0
    ##   for x in 0 ..< b.len:
    ##      printbicol(fmtx(["<6","",""],$x," : ", b[x]))
    ##      inc col 
    ##      if col > 10:
    ##         col = 0
    ##         echo()
    ##   echo()
    ##  
    
    # just iter of the chars if no seq required
    #var col = 0
    #for num in 0x2E80..0xFF60:
    #  printbicol(fmtx(["<6","","<4"],$num," : ", fmt"{toUTF8(Rune(num))}"),colRight=pink)
    #  inc col 
    #  if col > 10:
    #    col = 0
    #    echo()
    
    var chzh = newSeq[string]()
    #for j in parsehexint("3400").. parsehexint("4DB5"): chzh.add($Rune(j))   # chars
    for j in parsehexint("2E80") .. parsehexint("2EFF"): chzh.add($Rune(j))   # CJK Radicals Supplement
    for j in parsehexint("2F00") .. parsehexint("2FDF"): chzh.add($Rune(j))   # Kangxi Radicals
    for j in parsehexint("2FF0") .. parsehexint("2FFF"): chzh.add($Rune(j))   # Ideographic Description Characters
    for j in parsehexint("3000") .. parsehexint("303F"): chzh.add($Rune(j))   # CJK Symbols and Punctuation
    for j in parsehexint("31C0") .. parsehexint("31EF"): chzh.add($Rune(j))   # CJK Strokes
    for j in parsehexint("3200") .. parsehexint("32FF"): chzh.add($Rune(j))   # Enclosed CJK Letters and Months
    for j in parsehexint("3300") .. parsehexint("33FF"): chzh.add($Rune(j))   # CJK Compatibility
    for j in parsehexint("3400") .. parsehexint("4DBF"): chzh.add($Rune(j))   # CJK Unified Ideographs Extension A
    for j in parsehexint("4E00") .. parsehexint("9FBF"): chzh.add($Rune(j))   # CJK Unified Ideographs
    #for j in parsehexint("F900").. parsehexint("FAFF"): chzh.add($Rune(j))   # CJK Compatibility Ideographs
    for j in parsehexint("FF00").. parsehexint("FF60"): chzh.add($Rune(j))   # Fullwidth Forms of Roman Letters
    result = chzh    
    

proc createSeqFractur*():seq[string] =
    ## createSeqFracture
    ## Fractur chars returned in a seq
    var fra = newSeq[string]()
    for j in parsehexint("1D56C") .. parsehexint("1D59F"): fra.add($Rune(j)) 
    result = fra                 


proc createSeqIching*():seq[string] =
    ## createSeqIching
    ##
    ## returns a seq containing iching unicode chars
    var ich = newSeq[string]()
    for j in 119552..119638: ich.add($Rune(j))
    result = ich


proc createSeqApl*():seq[string] =
    ## createSeqApl
    ##
    ## returns a seq containing apl language symbols
    ##
    var adx = newSeq[string]()
    # s U+30A0–U+30FF.
    for j in parsehexint("2300").. parsehexint("23FF"): adx.add($Rune(j))
    result = adx
    
          
proc createSeqBoxChars*():seq[string] =

    ## chars to draw a box
    ##
    ## returns a seq containing unicode box drawing chars
    ##
    var boxy = newSeq[string]()
    # s U+2500–U+257F.
    for j in parsehexint("2500").. parsehexint("257F"):
        boxy.add($RUne(j))
    result = boxy
    
    
proc boxy*(w:int = 20, h:int = 5,fgr=randcol(),xpos:int=1) =
    ## boxy
    ## 
    ## draws a box with width w , height h , color color at position xpos
    ## 
    printLn(lefttop & linechar * w & righttop,fgr = fgr,xpos=xpos)
    for x in 0..h:
        printLn(vertlinechar & spaces(w) & vertlinechar,fgr = fgr,xpos=xpos)
    printLn(leftbottom & linechar * w & rightbottom,fgr = fgr,xpos=xpos)
 
    
proc boxy2*(w:int = 20, h:int = 5,fgr=randcol(),xpos:int=1) =
    ## boxy2
    ## 
    ## draws a box with width w , height h , color color at position xpos
    ## 
    ## similar to boxy but with random color for each element rather than each box
    ## 
    printLn(lefttop & linechar * w & righttop,fgr = randcol(),xpos=xpos)
    for x in 0..h:
        printLn(vertlinechar & spaces(w) & vertlinechar,fgr = randcol(),xpos=xpos)
    printLn(leftbottom & linechar * w & rightbottom,fgr = randcol(),xpos=xpos)     
    
 
proc spiralBoxy*(w:int = 20, h:int = 20,xpos:int = 1) =
     ## spiralBoxy
     var ww = w
     var hh = h
     var xxpos = xpos
     for x in countdown(h,h div 2):
       boxy(ww,hh,randcol(),xxpos)
       dec ww
       dec ww
       dec hh
       dec hh
       inc xxpos
       curup(hh + 4) 
 
 
proc spiralBoxy2*(w:int = 20, h:int = 20,xpos:int = 1) =
     ## spiralBoxy2   uses boxy2
     var ww = w
     var hh = h
     var xxpos = xpos
     for x in countdown(h,h div 2):
       boxy2(ww,hh,randcol(),xxpos)
       dec ww
       dec ww
       dec hh
       dec hh
       inc xxpos
       curup(hh + 4)
       
    
    
proc showSeq*[T](z:seq[T],fgr:string = truetomato,cols = 6,maxitemwidth:int=5,displayflag : bool = true):string {.discardable.} = 
    ## showSeq
    ##
    ## simple table routine with default 6 cols for displaying various unicode sets
    ## fgr allows color display and fgr = "rand" displays in rand color and maxwidth for displayable items
    ## this can also be used to show items of a sequence
    ## displayflag == true means to show the output
    ## displayflag == false means do not show output , but return it as a string
    ##
    ##.. code-block:: nim
    ##      showSeq(createSeqCJK(),"rand")
    ##      showSeq(createSeqKatakana(),yellowgreen)
    ##      showSeq(createSeqCJK(),"rand")
    ##      showSeq(createSeqGeoshapes(),randcol())
    ##      showSeq(createSeqint(1000,10000,100000))
    ##      
    ## 
    runnableExamples:
        showSeq(createSeqCJK(),"rand")
        
    result = ""
    var c = 0
    for x in 0 ..< z.len:
      result = result & $z[x] & spaces(1)
      if displayflag == true:
        
        if c < cols: 
            if fgr == "rand":
                  printBiCol(fmtx([">" & $6,"",">" & $maxitemwidth ,""] ,$x , " : ",  $z[x] , spaces(1)) ,colLeft=gold,colRight=randcol(),0,false,{}) 
            else:
                  printBiCol(fmtx([">" & $6,"",">" & $maxitemwidth ,""] ,$x , " : ",  $z[x] , spaces(1)) ,colLeft=fgr,colRight=gold,0,false,{})     
            inc c
        else:
             c = 0
             echo()
             if fgr == "rand":
                  printBiCol(fmtx([">" & $6,"",">" & $maxitemwidth ,""] ,$x , " : ",  $z[x] , spaces(1)) ,colLeft=gold,colRight=randcol(),0,false,{}) 
             else:
                  printBiCol(fmtx([">" & $6,"",">" & $maxitemwidth ,""] ,$x , " : ",  $z[x] , spaces(1)) ,colLeft=fgr,colRight=gold,0,false,{})     
             inc c     
    
    if displayflag == true:
      decho()      
      let msg1 = "0 - " & $(z.len - 1) & spaces(3)
      cxprintLn(3,limegreen,darkslategraybg," Item Count : ",cxpad($z.len,msg1.len)) 
      decho()          
 

       
proc seqHighLite*[T](b:seq[T],b1:seq[T],col:string=gold) =
   ## seqHighLite
   ## 
   ## displays the passed in seq with highlighting of subsequence
   ## 
   ##.. code-block:: nim
   ##   import nimcx
   ##   var b = createSeqInt(30,1,10)
   ##   seqHighLite(b,@[5])   # subseq will be highlighted if found
   ## 
   ## 
   var bs:string = $b1
   bs = bs.replace("@[","")
   bs.removesuffix(']')
   printLn(b,col,styled = {styleReverse},substr = bs)       
       

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
 
iterator reverseIter*[T](a: openArray[T]): T =
      ## reverse iterator  
      ##
      ##.. code-block:: nim
      ##   
      ##   let a = createseqfloat(10)
      ##   for b in reverse(a): echo b
      ##
      for i in countdown(a.high,0): yield a[i] 
     
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
      block:
            var f = streamfile(fn,mode)    # streamfile is in cxglobal.nim
            try:
                actions
            except:    
                echo()
                echo getCurrentExceptionMsg()                
                cxprintLn(2,white,bgred,"Error : Cannot open file " & fn & ". Please check ! ")
                echo()
                discard
            finally:
                close(f)
                            
                        
proc checkMemFull*(xpos:int = 2) =
       ## checkMemFull
       ## 
       ## full 45 lines output of system memory status
       ## 
       var seqline = newSeq[string]()
       let n = "HardwareCorrupted ".len
       withFile(f,"/proc/meminfo",fmRead):
              seqline = f.readAll().splitLines()
       for aline in 0 ..< seqline.len - 1:  # note omitting last as usually empty
               let zline = seqline[aline].split(":")
               try:
                  if zline.len > 0: 
                      cxprintLn(xpos,yellowgreen,cxpad(zline[0],n),fmtx([">15"],strutils.strip(zline[1])))
               except IndexError:
                      discard
 

proc checkMem*(xpos:int=2) = 
       ## checkMem
       ## 
       ## reads meminfo to give memory status for memtotal,memfree and memavailable
       ## maybe usefull during debugging of a function to see how memory is consumed 
       ## 
       
       var seqline = newSeq[string]()
       let n = "MemAvailable ".len
       withFile(f,"/proc/meminfo",fmRead):
            seqline = f.readAll().splitLines()
       for aline in seqline:
            if aline.startswith("Mem"):
               let zline = aline.split(":")
               cxprintLn(xpos,yellowgreen,cxpad(zline[0],n),fmtx([">15"],strutils.strip(zline[1])))
              

proc fullGcStats*(xpos:int = 2):int {.discardable.} =
     let gcs = GC_getStatistics()
     let gcsl = gcs.splitlines()
     for agcl in gcsl:
         let agcls = agcl.split("] ")
         if agcls.len > 1:
           let agcls1 = agcls[1].split(":")
           cxprintln(xpos,agcls[0],cxpad(agcls1[0],20) & cxlpad(agcls1[1],15))
     result = gcsl.len  
     
proc memCheck*(stats:bool = false) =
      ## memCheck
      ## 
      ## memCheck shows memory before and after a GC_FullCollect run
      ## 
      ## set stats to true for full GC_getStatistics
      ## @[1, 2, 4, 8, 16, 32]
      echo()
      if stats == true:
         cxprintln(2,skyblue,"MemCheck",cxpad("GC and System",30))
      else:
         cxprintln(2,skyblue,"MemCheck",cxpad("System",30))
      printLnBiCol("Status : Current ",colLeft=salmon,xpos = 2)
      var b = 0
      if stats == true:
          b = fullgcstats(2)
      checkmem()
      GC_fullCollect()
      sleepy(0.5)
      if stats == true:
          curup(b + 3)
      else:
          curup(b + 4)
      printLnBiCol("Status : GC_FullCollect executed",colLeft=salmon,colRight=pink,xpos=55)
      if stats == true:
          fullgcstats(xpos=55)
      checkmem(xpos=55)
      echo()
              
     
proc distanceTo*(origin:(float,float),dest:(float,float)):float =
        ## distanceTo
        ## 
        ## calculates distance on the great circle using haversine formular
        ## 
        ## input is 2 tuples of (longitude,latitude)      
        ## 
        ## Example
        ## 
        ## also see https://github.com/qqtop/Nim-Snippets/blob/master/geodistance.nim
        ## 
        ##.. code-block:: nim
        ##  import nimcx 
        ##  echo "Hongkong - London"
        ##  echo distanceto((114.109497,22.396427),(-0.126236,51.500153)) , " km"
        ##  echo distanceto((114.109497,22.396427),(-0.126236,51.500153)) / 1.609345 ," miles"
        ##  decho()

        let r = 6371.0    # mean Earth radius in kilometers  6371.0
        let lam_1 = degtorad(origin[0])
        let lam_2 = degtorad(dest[0])
        let phi_1 = degtorad(origin[1])
        let phi_2 = degtorad(dest[1])
        let h = (sin((phi_2 - phi_1) / 2) ^ 2 + cos(phi_1) * cos(phi_2) * sin((lam_2 - lam_1) / 2) ^ 2)
        return 2 * r * arcsin(sqrt(h))

proc getEmojisSmall*(): seq[string] =
       ## getEmojisSmall
       ## 
       ## a seq with 246 emojis will be returned 
       ## 
       ## for easy use in your text strings
       ## 
       var emojisSmall = newSeq[string]()
       for x in 0..<ejm4.len: emojisSmall.add($Rune(ejm4[x]))
       result = emojisSmall
 
proc showEmojisSmall*() = 
       ## showEmojisSmall
       ## 
       ## show a table of small emojis
       ## 
       ## Example
       ## 
       ##.. code-block:: nim
       ##   showEmojisSmall()
       ##   let es = getemojisSmall()
       ##   loopy(0..10,printLn((es[197] & es[244] & es[231] ) * 20,rndcol))
       ## 
       ## 
       showSeq(getEmojisSmall(),rndcol,maxitemwidth=4)      

 
proc genMacAddress*(): string =
   ## generates a random MacAddress
   ## 
   ##.. code-block:: nim
   ##   loopy(1..10,echo genMacAddress())
   ## 
   randomize()
   let m = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
   [sample(m) & sample(m), sample(m) & sample(m), sample(m) & sample(m),sample(m) & sample(m), sample(m) & sample(m), sample(m) & sample(m)].join(":")

proc quickPw*():string =   
   ## quickPw
   ## 
   ## quick strong password generator
   ##  
   for i in 1..100: result.add(rand(33..128).char)

proc quickLargeInt*():string =   
  ## quickLargeInt
  ## 
  ## returns a random large int string
  ##  
  ##
  result =  repeat($rand(int.high div 2..int.high), 2)   
      
   
proc quickBinaryString*(width:int=10):string =
     ## quickBinaryString
     ## 
     ## returns a random binary string with desired width
     ## 
     for x in 0..<width: result.add($rand(0..1))
   
 
iterator span*(s: string; first: int, last: BackwardsIndex): char =
     ## span
     ## 
     ## iterator for strings
     ## 
     ##.. code-block:: nim 
     ##
     ##   let s = ".something"
     ##   for c in s.span(1, ^1):
     ##       print c 
     ##   echo()
     ##       
     for i in first .. s.len - last.int: yield s[i]


proc checkPrime*(a: int): bool =
     ## checkPrime
     ## 
     ## within maxinteger range
     ## 
     ## checks an int for primeness and returns true or false
     ## 
     if a == 2: return true
     if a < 2 or a mod 2 == 0: return false
     for i in countup(3, sqrt(a.float).int, 2):
       if a mod i == 0:
         return false
     return true
  
iterator primey*(s:int = 0,e:int):int =
     ## primey
     ## 
     ## yields prime numbers from s to e within maxinteger range
     ## 
     ##.. code-block:: nim
     ##   var cp = 0
     ##   for xxx in primey(s=100_000_000,e=100_005_000):
     ##      inc cp 
     ##      echo xxx
     ##   echo cp," primes found" 
     ## 
     for i in s .. e: 
        if checkprime(i): yield i 
  
proc getPrimeSeq*(x,y:int):seq[int]=
     ## getPrimeSeq
     ## 
     ## returns all primes from x to y in a seq[int]
     ## 
     ##.. code-block:: nim
     ## showSeq(getPrimeSeq(5000,10000))
     ## 
     ## 
     for p in primey(x,y): result.add(p)  


             
# END OF CXGLOBAL.NIM #
