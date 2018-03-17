{.deadCodeElim: on , optimization: speed.}
#  {.noforward: on.}   # future feature
## ::
##     Library     : nimcx.nim
##     
##     Module      : cxutils.nim
##
##     Status      : stable
##
##     License     : MIT opensource
##
##     Version     : 0.9.9
##
##     ProjectStart: 2015-06-20
##   
##     Latest      : 2018-03-17
##
##     OS          : Linux
##
##     Description : cxutils.nim is a collection of utility procs and templates
##                   
##  

import os,osproc,math,stats,cpuinfo,httpclient,browsers,typeinfo,typetraits
import terminal,strutils,times,random,sequtils,unicode
import cxconsts,cxglobal,cxprint,cxtime

# type used in getRandomPoint
type
    RpointInt*   = tuple[x, y : int]
    RpointFloat* = tuple[x, y : float]

 
proc `$`*[T](some:typedesc[T]): string = name(T)
proc typeTest*[T](x:T):  T {.discardable.} =
     # used to determine the field types 
     printLnBiCol("Type     : " & $type(x))
     printLnBiCol("Value    : " & $x)
     
proc typeTest2*[T](x:T): T {.discardable.}  =
     # same as typetest but without showing values (which may be huge in case of seqs)
     printLnBiCol("Type       : " & $type(x),xpos = 3)   
     
proc typeTest3*[T](x:T): string =   $type(x)
proc fibonacci*(n: int):float =  
    ## fibonacci
    ## 
    ## calculate fibonacci values
    ##
    ## .. code-block:: nim
    ## 
    ##    for x in 0..20: quickList(x,fibonacci(x))
    ## 
    if n < 2: 
       result = float(n)
    else: 
       result = fibonacci(n-1) + fibonacci(n-2)
       
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
                
       

proc memCheck*(stats:bool = false) =
  ## memCheck
  ## 
  ## memCheck shows memory before and after a GC_FullCollect run
  ## 
  ## set stats to true for full GC_getStatistics
  ## 
  echo()
  printLn("MemCheck            ",yellowgreen,styled = {styleUnderscore},substr = "MemCheck            ")
  echo()
  printLnBiCol("Status    : Current ",colLeft=salmon)
  printLn(yellowgreen & "Mem " &  lightsteelblue & "Used  : " & white & ff2(getOccupiedMem()) & lightsteelblue & "  Free : " & white & ff2(getFreeMem()) & lightsteelblue & "  Total : " & white & ff2(getTotalMem() ))
  if stats == true:
    echo GC_getStatistics()
  GC_fullCollect()
  sleepy(0.5)
  printLnBiCol("Status    : GC_FullCollect executed",colLeft=salmon,colRight=pink)
  printLn(yellowgreen & "Mem " &  lightsteelblue & "Used  : " & white & ff2(getOccupiedMem()) & lightsteelblue & "  Free : " & white & ff2(getFreeMem()) & lightsteelblue & "  Total : " & white & ff2(getTotalMem() ))
  if stats == true:
     echo GC_getStatistics()


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
    
proc cxdayofweek*(datestr:string):string = 
    ## dayofweek
    ## 
    ## returns day of week from a date in format yyyy-MM-dd
    ## 
    ##.. code-block:: nim    
    ##    echo getNextMonday("2017-07-15"),"  ",dayofweek(getNextMonday("2017-07-15"))
    ##    echo getFirstMondayYear("2018"),"  ",dayofweek(getFirstMondayYear("2018"))
    ##    echo getFirstMondayYearMonth("2018-2"),"  ",dayofweek(getFirstMondayYearMonth("2018-2"))
    
    result =  $(getDayOfWeek(parseInt(day(datestr)),parseInt(month(datestr)),parseInt(year(datestr))))      

proc getFirstMondayYear*[T](ayear:T):string =
    ## getFirstMondayYear
    ##
    ## returns date of first monday of any given year
    ##
    ##.. code-block:: nim
    ##    echo  getFirstMondayYear("2015")
    ##
    ##
    
    for x in 0.. 7:
       var datestr = $ayear & "-01-0" & $x
       if validdate(datestr) == true:
          #if $(getdayofweek(parseInt(day(datestr)),parseInt(month(datestr)),parseInt(year(datestr)))) == "Monday":
          if cxdayofweek(datestr) == "Monday":   
             result = datestr


proc getFirstMondayYearMonth*[T](aym:T):string =
    ## getFirstMondayYearMonth
    ##
    ## returns date of first monday in given year and month
    ##
    ##.. code-block:: nim
    ##    echo  getFirstMondayYearMonth("2015-12")
    ##    echo  getFirstMondayYearMonth("2015-06")
    ##    echo  getFirstMondayYearMonth("2015-2")
    ##
    ## in case of invalid dates nil will be returned

    #var n:WeekDay
    var amx = $aym
    for x in 0 .. 7:
       if amx.len < 7:
          let yr = year(amx)
          let mo = month(amx)  # this also fixes wrong months
          amx = yr & "-" & mo
       var datestr = amx & "-0" & $x
       if validdate(datestr) == true:
          if cxdayofweek(datestr) == "Monday":
            result = datestr



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
    ##      var dw = "2015-08-10"
    ##      for x in 1.. 10:
    ##          dw = getNextMonday(dw)
    ##          echo dw
    ##
    ##
    ## in case of invalid dates nil will be returned
    ##

    
    var ndatestr = ""
    if isNil(adate) == true :
       print("Error received a date with value : nil",red)
    else:

        if validdate(adate) == true:
           
            var z = cxdayofweek(adate)
            
            if z == "Monday":
                # so the datestr points to a monday we need to add a
                # day to get the next one calculated
                ndatestr = plusDays(adate,1)

            else:
                ndatestr = adate

            for x in 0..<7:
                if validdate(ndatestr) == true:
                    z =  cxDayOfWeek(ndatestr)
                if z.strip() != "Monday":
                    ndatestr = plusDays(ndatestr,1)
                else:
                    result = ndatestr


   
proc getRandomPointInCircle*(radius:float) : seq[float] =
    ## getRandomPointInCircle
    ##
    ## based on answers found in
    ##
    ## http://stackoverflow.com/questions/5837572/generate-a-random-point-within-a-circle-uniformly
    ##
    ##
    ##
    ## .. code-block:: nim
    ##    import nimcx,math,strfmt
    ##    # get randompoints in a circle
    ##    var crad:float = 1
    ##    for x in 0..100:
    ##       var k = getRandomPointInCircle(crad)
    ##       assert k[0] <= crad and k[1] <= crad
    ##       printLnBiCol(fmtx([">25","<6",">25"],ff2(k[0])," :",ff2(k[1])))
    ##    doFinish()
    ##
    ##

    let t = 2 * math.Pi * getRandomFloat()
    let u = getRandomFloat() + getRandomFloat()
    var r = 0.00
    if u > 1 :
      r = 2-u
    else:
      r = u
    var z = newSeq[float]()
    z.add(radius * r * math.cos(t))
    z.add(radius * r * math.sin(t))
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
    ##    for x in 0..10:
    ##    var n = getRandomPoint(-500.00,200.0,-100.0,300.00)
    ##    printLnBiCol(fmtx([">4",">5","",">6",">5"],"x:",$n.x,spaces(7),"y:",$n.y),spaces(7))
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
    ##    var n = getRandomPoint(-500,500,-500,200)
    ##    printLnBiCol(fmtx([">4",">5","",">6",">5"],"x:",$n.x,spaces(7),"y:",$n.y),spaces(7))
    ## 
  
    var point : RpointInt
        
    point.x =  getRandomSignI() * getRndInt(minx,maxx) 
    point.y =  getRandomSignI() * getRndInt(miny,maxy)  
    result =  point

    
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

template getCard* :auto =
    ## getCard
    ##
    ## gets a random card from the Cards seq
    ##
    ## .. code-block:: nim
    ##    import nimcx
    ##    print(getCard(),randCol(),xpos = centerX())  # get card and print in random color at xpos
    ##    doFinish()
    ##
    cards[rand(rxCards)]
    

proc showRandomCard*(xpos:int = centerX()) = 
    ## showRandomCard
    ##
    ## shows a random card at xpos , default is centered
    ##
    print(getCard(),randCol(),xpos = xpos)


proc showRuler* (xpos:int=0,xposE:int=0,ypos:int = 0,fgr:string = white,bgr:BackgroundColor = bgBlack, vert:bool = false) =
     ## ruler
     ##
     ## simple terminal ruler indicating dot x positions to give a feedback
     ##
     ## horizontal --> vert = false
     ## 
     ## for vertical   --> vert = true
     ##
     ## see cxDemo and cxTest for more usage examples
     ##
     ## .. code-block::nim
     ##   # this will show a full terminal width ruler
     ##   ruler(fgr=pastelblue)
     ##   decho(3)
     ##   # this will show a specified position only
     ##   ruler(xpos =22,xposE = 55,fgr=pastelgreen)
     ##   decho(3)
     ##   # this will show a full terminal width ruler starting at a certain position
     ##   ruler(xpos = 75,fgr=pastelblue)
     echo()
     var fflag:bool = false
     var npos  = xpos
     var nposE = xposE
     if xpos ==  0: npos  = 1
     if xposE == 0: nposE = tw - 1

     if vert == false :  # horizontalruler

          for x in npos..nposE:

            if x == 1:
                curup(1)
                print(".",lime,bgr,xpos = 1)
                curdn(1)
                print(x,fgr,bgr,xpos = 1)
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


proc superHeaderA*(bb:string = "",strcol:string = white,frmcol:string = green,anim:bool = true,animcount:int = 1) =
      ## superHeaderA
      ##
      ## attempt of an animated superheader , some defaults are given
      ##
      ## parameters for animated superheaderA :
      ##
      ## headerstring, txt color, frame color, left/right animation : true/false ,animcount
      ##
      ## Example :
      ##
      ## .. code-block:: nim
      ##    import nimcx
      ##    cleanScreen()
      ##    let bb = "NIM the system language for the future, which extends to as far as you need !!"
      ##    superHeaderA(bb,white,red,true,3)
      ##    clearup(3)
      ##    superheader("Ok That's it for Now !",salmon,yellowgreen)
      ##    doFinish()

      for am in 0..<animcount:
          for x in 0..<1:
            cleanScreen()
            for zz in 0..bb.len:
                  cleanScreen()
                  superheader($bb[0..zz],strcol,frmcol)
                  sleepy(0.05)
                  curup(80)
            if anim == true:
                for zz in countdown(bb.len,-1,1):
                      superheader($bb[0..zz],strcol,frmcol)
                      sleepy(0.05)
                      cleanScreen()
            else:
                cleanScreen()
            

      echo()

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
      
      result = ""
      let c5 = toSeq(minwl..maxwl)
      let chc = toSeq(parsehexint("3400")..parsehexint("4DB5"))
      for xx in 0..<rand(c5): result = result & $Rune(rand(chc))




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
        let nwl = rand(maxws)
        let chc = toSeq(33..126)
        while nw.len < nwl:
          var x = rand(chc)
          if char(x) in Letters:
              nw = nw & $char(x)
        result = normalize(nw)   # return in lower case , cleaned up

    else:
         printLnErrorMsg("minimum word length larger than maximum word length")
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
        let nwl = rand(maxws)
        let chc = toSeq(33..126)
        while nw.len < nwl:
          var x = rand(chc)
          if char(x) in IdentChars:
              nw = nw & $char(x)
        result = normalize(nw)   # return in lower case , cleaned up

    else:
         printLnErrorMsg("minimum word length larger than maximum word length")
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
        let nwl = rand(maxws)
        let chc = toSeq(33..126)
        while nw.len < nwl:
          var x = rand(chc)
          if char(x) in AllChars:
              nw = nw & $char(x)
        if nflag == true:
           result = normalize(nw)   # return in lower case , cleaned up
        else :
           result = nw

    else:
         printLnErrorMsg("minimum word length larger than maximum word length")
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
        var zz = rand(toSeq(minwl..maxwl))
        while result.len < zz:
              var hig = rand(rhig)  
              result = result & $Rune(hig)
       
    else:
         printLnErrorMsg("minimum word length larger than maximum word length")
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
        while result.len < rand(toSeq(minwl..maxwl)):
              result = result & $Rune(rand(toSeq(parsehexint("30A0")..parsehexint("30FF"))))
       
    else:
         printLnErrorMsg("minimum word length larger than maximum word length")
         result = ""



proc drawRect*(h     :int = 0,
              w      :int = 3,
              frhLine:string = "_",
              frVLine:string = "|",
              frCol  :string = darkgreen,
              dotCol :string = truetomato,
              xpos   :int = 1,
              blink  :bool = false,
              dottype:string = ".") =
               
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
      printDotPos(xpos,dotCol,blink,dottype)
      print2(frhLine.repeat(w - dottype.len),frcol)
      printDotPos(xpos + w - dottype.len,dotCol,blink,dottype)
      writeLine(stdout,"")
      # sidelines
      for x in 2.. h:
         print2(frVLine,frcol,xpos = xpos) # left
         print2(frVLine,frcol,xpos = xpos + w - (dottype.len div 2) - 1)  # right
         writeLine(stdout,"")
      # bottom line
      printDotPos(xpos,dotCol,blink,dottype)
      print2(frhLine.repeat(w - dottype.len),frcol)
      printDotPos(xpos + w - dottype.len,dotCol,blink,dottype)
      writeLine(stdout,"")

         
    
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
 
template bitCheck*(a, b: untyped): bool =
    ## bitCheck
    ## 
    ## check bitsets 
    ##  
    (a and (1 shl b)) != 0   
         
         
proc clearScreen*():int {.discardable.} =
     ## clearScreen
     ## 
     ## slow clear screen proc using call to Os
     ## 
     execShellCmd("clear")
   

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
    # 12353..12436 hiragana
    for j in 12353..12436: hir.add($Rune(j)) 
    result = hir
    
   
proc createSeqKatakana*():seq[string] =
    ## full width katakana
    ##
    ## returns a seq containing full width katakana unicode chars
    ##
    var kat = newSeq[string]()
    # s U+30A0–U+30FF.
    for j in parsehexint("30A0").. parsehexint("30FF"): kat.add($Rune(j))
    for j in parsehexint("31F0").. parsehexint("31FF"): kat.add($Rune(j))  # Katakana Phonetic Extensions
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
    let msg1 = "0 - " & $(z.len - 1) & spaces(3)
    printLnInfoMsg("Item Count ",cxpad($z.len,msg1.len),xpos = 3) 
    #discard typeTest2(z)
    decho(2)          

    

proc showSeq*[T](aseq:seq[T],fgr:string = truetomato,cols = 6,maxitemwidth:int=5) =
      ## showSeq
      ## 
      ## display contents of a seq, in case of seq of seq the first item of the sub seqs will be shown
      ## 
      tableRune(aseq)    
        
        
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
        var f = streamFile(fn,mode)    # streamfile is in cxglobal.nim
        if not f.isNil:
            try:
                actions
            finally:
                close(f)
        else:
                echo()
                printLnErrorMsg("Cannot open file " & fn)
                quit()
         

 
 
 
# END OF CXUTILS.NIM #
