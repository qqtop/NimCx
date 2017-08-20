
{.deadCodeElim: on.}
##  {.noforward: on.}   # future feature
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
##     Latest      : 2017-08-20
##
##     Compiler    : Nim >= 0.16
##
##     OS          : Linux
##
##     Description :
##
##                   cxutils.nim is a collection of lesser used simple utility procs and templates
##
##                   moved here to avoid code bloat in cx.nim
##
##
##     Usage       : import cx,cxutils
##
##     Project     : https://github.com/qqtop/NimCx
##
##     Docs        : https://qqtop.github.io/cx.html
##
##     Tested      : OpenSuse Tumbleweed , Ubuntu 16.04 LTS 
##       
import os,osproc,cx,math,stats,cpuinfo,httpclient,browsers


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
  printLnBiCol("Status    : Current ",":",salmon)
  printLn(yellowgreen & "Mem " &  lightsteelblue & "Used  : " & white & ff2(getOccupiedMem()) & lightsteelblue & "  Free : " & white & ff2(getFreeMem()) & lightsteelblue & "  Total : " & white & ff2(getTotalMem() ))
  if stats == true:
    echo GC_getStatistics()
  GC_fullCollect()
  sleepy(0.5)
  printLnBiCol("Status    : GC_FullCollect executed",":",salmon,pink)
  printLn(yellowgreen & "Mem " &  lightsteelblue & "Used  : " & white & ff2(getOccupiedMem()) & lightsteelblue & "  Free : " & white & ff2(getFreeMem()) & lightsteelblue & "  Total : " & white & ff2(getTotalMem() ))
  if stats == true:
     echo GC_getStatistics()


proc showCpuCores*() =
  ## showCpuCores
  ## 
  printLnBiCol("System CPU cores : " & $cpuInfo.countProcessors())
   

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
    ##    import cx,math,strfmt
    ##    # get randompoints in a circle
    ##    var crad:float = 1
    ##    for x in 0.. 100:
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
    ##    for x in 0.. 10:
    ##    var n = getRandomPoint(-500.00,200.0,-100.0,300.00)
    ##    printLnBiCol(fmtx([">4",">5","",">6",">5"],"x:",$n.x,spaces(7),"y:",$n.y),spaces(7))
    ## 

    var point : RpointFloat
    var rx:    float
    var ry:    float
      
      
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
    ##    for x in 0.. 10:
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
    ##    import cx,cxutils
    ##    print(getCard(),randCol(),xpos = centerX())  # get card and print in random color at xpos
    ##    doFinish()
    ##
    cards[rndSample(rxCards)]

proc showRandomCard*(xpos:int = centerX()) = 
    ## showRandomCard
    ##
    ## shows a random card at xpos , default is centered
    ##
    print(getCard(),randCol(),xpos = xpos)


proc showRuler* (xpos:int=0,xposE:int=0,ypos:int = 0,fgr:string = termwhite,bgr:string = termblack , vert:bool = false) =
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

          for x in npos.. nposE:

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

            for x in 0.. ypos:
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



proc doNimUp*(xpos = 5, rev:bool = true) = 
      ## doNimUp
      ## 
      ## A Nim dumbs up logo 
      ## 
      ## 
      cleanScreen()
      decho(2)
      if rev == true:
          
          printLn("        $$$$               ".reversed,randcol(),xpos = xpos)
          printLn("       $$  $               ".reversed,randcol(),xpos = xpos)
          printLn("       $   $$              ".reversed,randcol(),xpos = xpos)
          printLn("       $   $$              ".reversed,randcol(),xpos = xpos)
          printLn("       $$   $$             ".reversed,randcol(),xpos = xpos)
          printLn("        $    $$            ".reversed,randcol(),xpos = xpos)
          printLn("        $$    $$$          ".reversed,randcol(),xpos = xpos)
          printLn("         $$     $$         ".reversed,randcol(),xpos = xpos)
          printLn("         $$      $$        ".reversed,randcol(),xpos = xpos)
          printLn("          $       $$       ".reversed,randcol(),xpos = xpos)
          printLn("    $$$$$$$        $$      ".reversed,randcol(),xpos = xpos)
          printLn("  $$$               $$$$$  ".reversed,randcol(),xpos = xpos)
          printLn(" $$    $$$$            $$$ ".reversed,randcol(),xpos = xpos)
          printLn(" $   $$$  $$$            $$".reversed,randcol(),xpos = xpos)
          printLn(" $$        $$$            $".reversed,randcol(),xpos = xpos)
          printLn("  $$    $$$$$$            $".reversed,randcol(),xpos = xpos)
          printLn("  $$$$$$$    $$           $".reversed,randcol(),xpos = xpos)
          printLn("  $$       $$$$           $".reversed,randcol(),xpos = xpos)
          printLn("   $$$$$$$$$  $$         $$".reversed,randcol(),xpos = xpos)
          printLn("    $        $$$$     $$$$ ".reversed,randcol(),xpos = xpos)
          printLn("    $$    $$$$$$    $$$$$$ ".reversed,randcol(),xpos = xpos)
          printLn("     $$$$$$    $$  $$      ".reversed,randcol(),xpos = xpos)
          printLn("       $     $$$ $$$       ".reversed,randcol(),xpos = xpos)
          printLn("        $$$$$$$$$$         ".reversed,randcol(),xpos = xpos)

      else:
        
          printLn("        $$$$               ",randcol(),xpos=60)
          printLn("       $$  $               ",randcol(),xpos=60)
          printLn("       $   $$              ",randcol(),xpos=60)
          printLn("       $   $$              ",randcol(),xpos=60)
          printLn("       $$   $$             ",randcol(),xpos=60)
          printLn("        $    $$            ",randcol(),xpos=60)
          printLn("        $$    $$$          ",randcol(),xpos=60)
          printLn("         $$     $$         ",randcol(),xpos=60)
          printLn("         $$      $$        ",randcol(),xpos=60)
          printLn("          $       $$       ",randcol(),xpos=60)
          printLn("    $$$$$$$        $$      ",randcol(),xpos=60)
          printLn("  $$$               $$$$$  ",randcol(),xpos=60)
          printLn(" $$    $$$$            $$$ ",randcol(),xpos=60)
          printLn(" $   $$$  $$$            $$",randcol(),xpos=60)
          printLn(" $$        $$$            $",randcol(),xpos=60)
          printLn("  $$    $$$$$$            $",randcol(),xpos=60)
          printLn("  $$$$$$$    $$           $",randcol(),xpos=60)
          printLn("  $$       $$$$           $",randcol(),xpos=60)
          printLn("   $$$$$$$$$  $$         $$",randcol(),xpos=60)
          printLn("    $        $$$$     $$$$ ",randcol(),xpos=60)
          printLn("    $$    $$$$$$    $$$$$$ ",randcol(),xpos=60)
          printLn("     $$$$$$    $$  $$      ",randcol(),xpos=60)
          printLn("       $     $$$ $$$       ",randcol(),xpos=60)
          printLn("        $$$$$$$$$$         ",randcol(),xpos=60)

      curup(15)
      printBigLetters("NIM",fgr=randcol(),xpos = xpos + 33)
      curdn(15)


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
      ##    import cx
      ##    cleanScreen()
      ##    let bb = "NIM the system language for the future, which extends to as far as you need !!"
      ##    superHeaderA(bb,white,red,true,1)
      ##    clearup(3)
      ##    superheader("Ok That's it for Now !",salmon,yellowgreen)
      ##    doFinish()

      for am in 0..<animcount:
          for x in 0.. <1:
            cleanScreen()
            for zz in 0.. bb.len:
                  cleanScreen()
                  superheader($bb[0.. zz],strcol,frmcol)
                  sleep(500)
                  curup(80)
            if anim == true:
                for zz in countdown(bb.len,-1,1):
                      superheader($bb[0.. zz],strcol,frmcol)
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
      let c5 = toSeq(minwl.. maxwl)
      let chc = toSeq(parsehexint("3400").. parsehexint("4DB5"))
      for xx in 0.. <rndSample(c5): result = result & $Rune(rndSample(chc))




proc newWord*(minwl:int=3,maxwl:int = 10 ):string =
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
        let maxws = toSeq(minwl.. maxwl)
        # get a random length for a new word
        let nwl = rndSample(maxws)
        let chc = toSeq(33.. 126)
        while nw.len < nwl:
          var x = rndSample(chc)
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
        let maxws = toSeq(minwl.. maxwl)
        # get a random length for a new word
        let nwl = rndSample(maxws)
        let chc = toSeq(33.. 126)
        while nw.len < nwl:
          var x = rndSample(chc)
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
        let maxws = toSeq(minwl.. maxwl)
        # get a random length for a new word
        let nwl = rndSample(maxws)
        let chc = toSeq(33.. 126)
        while nw.len < nwl:
          var x = rndSample(chc)
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
        var rhig = toSeq(12353.. 12436)  
        var zz = rndSample(toSeq(minwl.. maxwl))
        while result.len < zz:
              var hig = rndSample(rhig)  
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
        while result.len < rndSample(toSeq(minwl.. maxwl)):
              result = result & $Rune(rndSample(toSeq(parsehexint("30A0") .. parsehexint("30FF"))))
       
    else:
         cechoLn(red,"Error : minimum word length larger than maximum word length")
         result = ""


proc getWanIp*():string =
   ## getWanIp
   ##
   ## deprecated as Herokou seems to have stopped this service in April 2017 ,
   ##
   ## will try to find replacement
   ## 
   ## get your wan ip from heroku  
   ##
   ## problems ? check : https://status.heroku.com/
   
   var zcli = newHttpClient(timeout = 5000)
   var z = "Wan Ip not established. "
   try:
      z = zcli.getContent(url = "http://my-ip.heroku.com")
      z = z.replace(sub = "{",by = " ").replace(sub = "}",by = " ").replace(sub = "\"ip\":"," ").replace(sub = '"' ,' ').strip()
   except HttpRequestError:
       printLn("\nIp checking failed due to 404. Heroku does not provide Ip checking anymore !",red)
   except OSError:
       printLn("Ip checking failed. See if Heroku is still here or just to slow to respond",red)
       printLn("Check Heroku Status : https://status.heroku.com",red)
       printLn("Is your internet still working ?",lightseagreen)
       try:
           opendefaultbrowser("https://status.heroku.com")
       except  OSError:
            discard
       discard  
   result = z
   
   
proc getWanIp2*():string =
            ## getWanIp2
            ## 
            ## another get wan ip function calling dyndns
            ## 
            ## 
            ## .. code-block:: nim
            ##    printLnBiCol(getwanip2())
            ## 
            ## Note : very slow so only use if getWanIp does not work , needs curl and awk
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
     printBiCol("Current Wan Ip  : " & getWanIp(),":",yellowgreen,gray)

