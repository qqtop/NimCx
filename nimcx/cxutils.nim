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
##     Latest      : 2019-01-09
##
##     OS          : Linux
##
##     Description : cxutils.nim is a collection of utility procs and templates
##                   
##  

import os,osproc,math,stats,cpuinfo,httpclient,browsers,typeinfo,typetraits,rdstdin
import terminal,strutils,times,random,sequtils,unicode,streams
import cxconsts,cxglobal,cxprint,cxtime,cxhash,macros

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

proc cxVideoInfo*():string = 
   ## cxVideoInfo
   ## 
   ## executes a system command to get video setup information
   ## may show warning on certain systems to run as super user
   ## 
   var (output,error) = execCmdEx("lshw -c video")
   if error <> 0:
     result = $error
   else:  
     result = output   
   

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
           printLnOkMsg("Access granted at : " & cxnow)
           echo()
           result = zz
     else:
           echo()
           let dn = "Access denied at : " & cxnow
           printLnFailMsg(dn)
           printLnErrorMsg(cxpad("Exiting now . Bye Bye.",dn.len))
           quit(1)
    
  
    
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
       printLnErrorMsg("Invalid date received . Required format is yyyy-MM-dd. --> cxUtils : cxDayOfWeek")
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
    ##      var dw = "2015-08-10"
    ##      for x in 1 .. 10:
    ##          dw = getNextMonday(dw)
    ##          decho(5)    
    ##
        
    var ndatestr = ""
    if adate == "" :
        printErrorMsg("Received an invalid date.")
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
    var r = radius * sqrt(getrndfloat(0,1))        # polar
    var theta = getrndfloat(0,1) * 2 * math.Pi     # polar
    var x = r * cos(theta)                         # cartesian
    var y = r * sin(theta)                         # cartesian
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
    ##    for x in 0..10:decho(5)    
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
    point.x = getRandomSignI() * getRndInt(minx,maxx) 
    point.y = getRandomSignI() * getRndInt(miny,maxy)  
    result = point


proc getPointInSphere*():auto =
    ## getPointInSphere
    ## 
    ## returns x,y,x coordinates for a point in sphere with max size  1,1,1
    ## 
    ## https://karthikkaranth.me/blog/generating-random-points-in-a-sphere/#better-choice-of-spherical-coordinates
    ## 
    ## .. code-block:: nim
    ##    # display 100 coordinates of in sphere points
    ##    for x in countup(0,99,1):      
    ##       let b = getPointinSphere()  
    ##       printLnBiCol(fmtx(["",">7","",">7","",">7"],"  x: ",b[0],"  y: ",b[1],"  z: ",b[2]))
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
    ## sets  to a rand position in the visible terminal window
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
    ##    print(getCard(),randCol(),xpos = centerX())  # get card and print in random color at xpos
    ##    doFinish()
    ##
    cards[sample(rxCards)]
    

proc showRandomCard*(xpos:int = centerX()) = 
    ## showRandomCard
    ##
    ## shows a random card at xpos from the cards set in cxconstant.nim, default is centered
    ##
    print(getCard(),randCol(),xpos = xpos)


proc showRuler* (xpos:int=0,xposE:int=0,ypos:int = 0,fgr:string = white,bgr:BackgroundColor = bgBlack, vert:bool = false) =
     ## ruler
     ##
     ## simple terminal ruler indicating dot x positions starts with position 1
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
     if xpos == 0: npos  = 0
     if xposE == 0: nposE = tw - 1
     if vert == false :  # horizontalruler
          for x in npos..nposE:
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
      for xx in 0..<sample(c5): result = result & $Rune(sample(chc))

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
        let nwl = sample(maxws)
        let chc = toSeq(33..126)
        while nw.len < nwl:
          var x = sample(chc)
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
        var zz = sample(toSeq(minwl..maxwl))
        while result.len < zz:
              var hig = sample(rhig)  
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
        while result.len < sample(toSeq(minwl..maxwl)):
              result = result & $Rune(sample(toSeq(parsehexint("30A0")..parsehexint("30FF"))))  
    else:
        printLnErrorMsg("minimum word length larger than maximum word length")
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
     ##..code-block:: nim
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
            printLnFailMsg("newText() ")
            printLnErrorMsg(textgen & " generator proc not available !")
            discard                
                     
                                  
                                  
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
      

proc createSeqAll*(min:int = 0,max:int = 40878):seq[string] =
     # for testing purpose only in the future the unicodedb by nitely is the way to go
     var gs = newSeq[string]()
     for j in min ..< max :        # depending on whats installed  
     
            # there are more chars up to maybe 120150 some
            # maybe for indian langs,iching, some special arab and koran symbols if installed on the system
            # if not installed on your symondaystem you will see the omnious rectangle char  0xFFFD
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
    println2(lefttop & linechar * w & righttop,fgr = fgr,xpos=xpos)
    for x in 0..h:
        println2(vertlinechar & spaces(w) & vertlinechar,fgr = fgr,xpos=xpos)
    printLn2(leftbottom & linechar * w & rightbottom,fgr = fgr,xpos=xpos)
 
    
proc boxy2*(w:int = 20, h:int = 5,fgr=randcol(),xpos:int=1) =
    ## boxy2
    ## 
    ## draws a box with width w , height h , color color at position xpos
    ## 
    ## similar to boxy but with random color for each element rather than each box
    ## 
    println2(lefttop & linechar * w & righttop,fgr = randcol(),xpos=xpos)
    for x in 0..h:
        println2(vertlinechar & spaces(w) & vertlinechar,fgr = randcol(),xpos=xpos)
    printLn2(leftbottom & linechar * w & rightbottom,fgr = randcol(),xpos=xpos)     
    
 
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
      printLnInfoMsg("Item Count ",cxpad($z.len,msg1.len),xpos = 3) 
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
   printLn2(b,col,styled = {styleReverse},substr = bs)       
       

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
      for i in countdown(a.high,0):
         yield a[i] 
     
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
            var f = streamFile(fn,mode)    # streamfile is in cxglobal.nim
            try:
                actions
            except:    
                echo()
                printLnErrorMsg("Cannot open file " & fn)
                quit()
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
       for aline in seqline:
               let zline = aline.split(":")
               try:
                  printLnInfoMsg(cxpad(zline[0],n),fmtx([">15"],strutils.strip(zline[1])),yellowgreen,xpos = xpos)
               except IndexError  as ex:
                  printLnErrorMsg(ex.msg)
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
               printLnInfoMsg2(cxpad(zline[0],n),fmtx([">15"],strutils.strip(zline[1])),yellowgreen,xpos = xpos)
              

proc fullgcstats*(xpos:int = 2):int {.discardable.} =
     let gcs = GC_getStatistics()
     let gcsl = gcs.splitlines()
     for agcl in gcsl:
         let agcls = agcl.split("] ")
         if agcls.len > 1:
           let agcls1 = agcls[1].split(":")
           printLnInfomsg2(agcls[0],cxpad(agcls1[0],20) & cxlpad(agcls1[1],15),xpos = xpos)
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
         printLnInfoMsg("MemCheck",cxpad("GC and System",30),skyblue,xpos = 2)
      else:
         printLnInfoMsg("MemCheck",cxpad("System",30),skyblue,xpos = 2)
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
      printLnBiCol2("Status : GC_FullCollect executed",colLeft=salmon,colRight=pink,xpos=55)
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

 
          
# END OF CXUTILS.NIM #
