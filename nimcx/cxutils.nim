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
##     Latest      : 2018-02-27
##
##     Compiler    : Nim >= 0.17.x dev branch
##
##     OS          : Linux
##
##     Description :
##
##                   cxutils.nim is a collection of lesser used simple utility procs and templates
##
##                   
##
##     Usage       : import nimcx
##
##     Project     : https://github.com/qqtop/NimCx
##
##     Docs        : https://qqtop.github.io/cxutils.html   
##
##     Tested      : OpenSuse Tumbleweed ,Debian Testing
##  

import os,osproc,math,stats,cpuinfo,httpclient,browsers
import terminal,strutils,times,random,sequtils,unicode
import cxconsts,cxglobal,cxprint,cxtime

# type used in getRandomPoint
type
    RpointInt*   = tuple[x, y : int]
    RpointFloat* = tuple[x, y : float]


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
    return format(getGMTime(getTime()), iso_8601_aws) 
    
proc dayofweek*(datestr:string):string = 
    ## dayofweek
    ## 
    ## returns day of week from a date in format yyyy-MM-dd
    ## 
    ##.. code-block:: nim    
    ##    echo getNextMonday("2017-07-15"),"  ",dayofweek(getNextMonday("2017-07-15"))
    ##    echo getFirstMondayYear("2018"),"  ",dayofweek(getFirstMondayYear("2018"))
    ##    echo getFirstMondayYearMonth("2018-2"),"  ",dayofweek(getFirstMondayYearMonth("2018-2"))
    
    result =  $(getdayofweek(parseInt(day(datestr)),parseInt(month(datestr)),parseInt(year(datestr))))      

proc getFirstMondayYear*(ayear:string):string =
    ## getFirstMondayYear
    ##
    ## returns date of first monday of any given year
    ##
    ##.. code-block:: nim
    ##    echo  getFirstMondayYear("2015")
    ##
    ##
 
    for x in 0.. 7:
       var datestr = ayear & "-01-0" & $x
       if validdate(datestr) == true:
          if $(getdayofweek(parseInt(day(datestr)),parseInt(month(datestr)),parseInt(year(datestr)))) == "Monday":
             result = datestr


proc getFirstMondayYearMonth*(aym:string):string =
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
    var amx = aym
    for x in 0.. 7:
       if aym.len < 7:
          let yr = year(amx)
          let mo = month(aym)  # this also fixes wrong months
          amx = yr & "-" & mo
       var datestr = amx & "-0" & $x
       if validdate(datestr) == true:
          if $(getdayofweek(parseInt(day(datestr)),parseInt(month(datestr)),parseInt(year(datestr)))) == "Monday":
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
           
            var z = $(getdayofweek(parseInt(day(adate)),parseInt(month(adate)),parseInt(year(adate))))
            
            if z == "Monday":
                # so the datestr points to a monday we need to add a
                # day to get the next one calculated
                ndatestr = plusDays(adate,1)

            else:
                ndatestr = adate

            for x in 0..<7:
                if validdate(ndatestr) == true:
                    z =  $(getDayOfWeek(parseInt(day(ndatestr)),parseInt(month(ndatestr)),parseInt(year(ndatestr))))
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
     ## available for horizontal --> vert = false
     ##           for vertical   --> vert = true
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
      ##    superHeaderA(bb,white,red,true,1)
      ##    clearup(3)
      ##    superheader("Ok That's it for Now !",salmon,yellowgreen)
      ##    doFinish()

      for am in 0..<animcount:
          for x in 0..<1:
            cleanScreen()
            for zz in 0..bb.len:
                  cleanScreen()
                  superheader($bb[0..zz],strcol,frmcol)
                  sleep(500)
                  curup(80)
            if anim == true:
                for zz in countdown(bb.len,-1,1):
                      superheader($bb[0..zz],strcol,frmcol)
                      sleep(100)
                      cleanScreen()
            else:
                cleanScreen()
            sleep(500)

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
      ##    # create a string of chinese or CJK chars
      ##    # with max length 20 and show it in green
      ##    msgg() do : echo newWordCJK(20,20)
      # set the char set
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
         cechoLn(red,"Error : minimum word length larger than maximum word length")
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
         cechoLn(red,"Error : minimum word length larger than maximum word length")
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
         cechoLn(red,"Error : minimum word length larger than maximum word length")
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
         cechoLn(red,"Error : minimum word length larger than maximum word length")
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
         cechoLn(red,"Error : minimum word length larger than maximum word length")
         result = ""


proc getWanIp2*():string =
            ## getWanIp
            ## 
            ## .. code-block:: nim
            ##    printLnBiCol(getwanip2())
            ## 
            ## Note : very slow  needs curl and awk
            ## 
            ## 
            let (outp, errC) = execCMDEx("""curl -s http://checkip.dyndns.org/ | awk -F'[a-zA-Z<>/ :]+' '{printf "External IP: %s\n", $2}'""")
            if errC == 0:
                result =  $outp
            else:
                result = "External IP errorcode : " & $errC & ". IP not established"



proc showWanIp*() =
     ## showWanIp
     ##
     ## show your current wan ip  , this service currently slow
     ##
     printBiCol("Current Wan Ip  : " & getWanIp2(),colLeft=yellowgreen,colRight=gray)



          
proc clearScreen*():int {.discardable.} =
     ## clearScreen
     ## 
     ## slow clear screen proc using call to Os
     ## 
     execShellCmd("clear")
   
   
   
   
   
# END OF CXUTILS.NIM #
