import nimcx
#
# cxtruecolorE1.nim
#
# Examples for usage of truecolors with nimcx library
# use konsole as terminal as not all terminal are ready fro truecolor support
# 
# this assumes your terminal is set to white font and black background to start with
# this demos also show how to exceed the named colors in Nim stdlib and run millions of colors
# provided there is enough memory in the system
# 
# 2018-04-14

proc cxSpectrum(colval:int = 255,dval:int = 76 ,adj:int = 1) =
  ## cxspectrum
  ## 
  ## play with truecolors to display palettes of truecolors
  ## the issue here is we do not know the color in the cxtruecol notation  cxtruecol[number here]
  ## so it would be hard to reproduce the colors you see
  ## 
  for colnum in countup(0, dval , 1):
    for colnum2 in countup(0, dval , 1):
      for colnum3 in countup(0, dval , 1):
         
         var r = colval * adj - ((colnum * colval * adj)  div (dval * adj))
         var g = (colnum2 * colval * adj * 2) div (dval * adj)
         var b = (colnum3 * colval * adj) div (dval * adj)
         if g > colval * adj : g = (colval * adj * 2) - g * adj * 2 
         # we show three columns 
         print(fmtx(["<0","<45",""],
                        "\x1b[38;2;$1;$2;$3m" % [$r,$g,$b],
                        " cxTrueColor dval = $4  RGB $1 $2 $3 " %  [$r,$g,$b,$colnum],
                        ""),styled = {styleReverse,styleBright})
         print(fmtx(["<0","<35",""],
                        "\x1b[38;2;$1;$2;$3m" % [$r,$g,$b],
                        " cxTrueColor RGB $1 $2 $3 " %  [$r,$g,$b],
                        ""),styled = {},xpos = 50)
         printLn(fmtx(["<0","<35",""],
                        "\x1b[48;2;$1;$2;$3m" % [$r,$g,$b],
                        " cxTrueColor RGB $1 $2 $3 " %  [$r,$g,$b],
                        ""),styled = {styleDim,styleReverse},xpos = 89)                 
  
proc playSpectrum() =
   decho(2)
   cxspectrum(colval = 255,dval = 76,adj = 6)        # orig test parameter 255,76,2
   print cleareol
   #decho(2)
   #cxspectrum(colval = 255,dval = 15,adj = 8)       
   #getcxtruecolorset(0,1200,12,false)               # do not set max to high as it eats all memory default in cx is 0,888,12,false           
   #cxspectrum(colval = 1800,dval = 1216,adj = 152)  # change dval for more in between shades

####################################################################################################################################

## playRGB
## 
## shows var outcome of color backgrounds 
## note : colored fonts on only appear if flag38 is false 
## 
## 


proc cxRGB(r:int,g:int,b:int,flag38:bool=true) : string =
     if flag38 == true: result = "\x1b[38;2;$1;$2;$3m" % [$r,$g,$b]
     else : result = "\x1b[48;2;$1;$2;$3m" % [$r,$g,$b]   
   
proc playRGB(r:int,g:int,b:int,flag38:bool=true) =
   println("cxTrueColor RGB  " & $r & " " & $g & " " & $b & " flag38 =  false  styled = styleDim,styleReverse",cxRGB(r,g,b,false),styled={styleDim,styleReverse},xpos= 35) 
   println("cxTrueColor RGB  " & $r & " " & $g & " " & $b & " flag38 =  " & $flag38 & " styled = styleDim,styleReverse  ",cxRGB(r,g,b),styled={styleDim,styleReverse},xpos= 35) 
   println("cxTrueColor RGB  " & $r & " " & $g & " " & $b & " flag38 =  false  styled = styleReverse         ",cxRGB(r,g,b,false),styled={styleReverse},xpos= 35) 
   println("cxTrueColor RGB  " & $r & " " & $g & " " & $b & " flag38 =  " & $flag38 & " styled = styleReverse           ",cxRGB(r,g,b),styled={styleReverse},xpos= 35) 
   println("cxTrueColor RGB  " & $r & " " & $g & " " & $b & " flag38 =  false                                ",cxRGB(r,g,b,false),styled={},xpos= 35) 
   println("cxTrueColor RGB  " & $r & " " & $g & " " & $b & " flag38 =  " & $flag38 & "                      ",cxRGB(r,g,b),styled={},xpos= 35) 

#######################################################################################################################################    

# Examples for the cxPrint and cxPrintLn function in cx.nim
# 
# Fontcolors can be drawn from cxColorNames , a seq specified in cxconsts.nim
# Example to specify a fontcolor:
# 
# a) a random color as string   :  fontcolor = cxcolornames[rndSample(txcol)][0]
# b) a random color as constant :  fontcolor = cxcolornames[rndSample(txcol)][1]
# c) directly named as string   :  fontcolor = "coldarkslategray"    # a color in cxColorNames string field
# d) directly named as const    :  fontcolor = coldarkslategray      # a color in cxColorNames constant field

# Backgroundcolors can be drawn from cxTrueColor palette which is by default available with 421,875 colors
# larger color palettes can be generated with getcxTrueColorSet() 
# all palette colors in cxTrueColorSet can be shown with showCxTrueColorPalette()  
# Backgroundcolors can also be drawn from the colorNames seq  specified in cxconsts.nim

# Example to specify a Backgroundcolor :
#  a) a random background color from cxtruecolor seq  :  bgr = rndtruecol2() 
#  b) a color from the cxTrueColorSet                 :  bgr = cxTrueCol[65451])
#  c) a specified color from colorName seq            :  bgr = darkgreen

proc playCxPrint() =    
  for x in 0..30:    
    cxPrint("Colored Font , Same Back     ", fontcolor = cxcolornames[rndSample(txcol)][0], bgr = darkslategray,xpos = 2)  
    cxPrint("Colored Font , Colored Back  ", fontcolor = cxcolornames[rndSample(txcol)][0], bgr = rndtruecol2(),xpos = 35) 
    cxPrintLn("Same Font  , Colored Back  Background Palette Length : $1 " % ff2(cxtrueCol.len) , fontcolor = "colcoral" , bgr = rndtruecol2(),xpos = 72)    
  echo()
  cxPrintln("All available Font Colors in cxColorNames",colWhite,darkSlategray)
  echo()
  for x in txcol:
     cxPrintLn(fmtx(["<90"],"Font : $1 "% [cxcolornames[x][0]]),
               fontcolor = cxcolornames[x][0],
               bgr       = black,
               xpos      = 1)
     
     # 
     cxPrintLn(fmtx(["<60"],"Back0 : " & $402261 & " Palette Length : $1" % [ff2(cxtrueCol.len)]),
               fontcolor = cxcolornames[x][0],
               bgr       = cxTruecol[402260],
               xpos      = 1)
     for n in 1..24:   
        # play with different m values and multiplication factors etc.   
        var m = n * 76
        cxPrintLn(fmtx(["<4","<10","<22","<33"],"Back" ,$n  , "cxTrueCol[" & $(402260 + m) & "]" , " Palette Length : $1" % [ff2(cxtrueCol.len)]),
               fontcolor = cxcolornames[x][0],
               bgr       = cxTruecol[402260 + m],
               xpos      = 1)          
     echo()          
#      print cleareol
#      echo()
  
  echo()  
  # fontcolor ex the cxcolornames set
  # background color ex the colorNames set
  # the ugly side here is we need to specify "coldarkslategray"  instead  of coldarkslategray  only  this needs to change
  cxPrintLn("Standard Test 1  fontcolor = coldarkslategray  background = beige        styled  = styleReverse" ,fontcolor = "coldarkslategray",bgr = beige)
  cxPrintLn("Standard Test 2  fontcolor = colcoral          background = darkgreen    styled  = styleReverse" ,fontcolor = "colcoral",        bgr = darkgreen)
  cxPrintLn("Standard Test 3  fontcolor = coldarkslategray  background = beige        styled  = styleBright " ,fontcolor = "coldarkslategray",bgr = beige,styled = {styleBright})
  # no style given makes bgr the fgr
  cxPrintLn("Standard Test 4  fontcolor = coldarkslategray  background = beige        styled  = {}          " ,fontcolor = "coldarkslategray",bgr = beige,styled = {})
  cxPrintLn("Standard Test 5  fontcolor = coldarkslategray  background = beige                              " ,fontcolor = "coldarkslategray",bgr = beige)
  cxPrintLn("Standard Test 6  fontcolor = coldarkslategray  background = beige        styled  = styleReverse,styleBright" ,fontcolor = "coldarkslategray",bgr = beige,styled = {stylereverse,styleBright})
  echo()
  # test with our fmt function
  cxPrintLn(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "greenyellow" & "  " & rightarrow, fontcolor = "coldarkblue",bgr = greenyellow,styled={styleReverse})       
  # here also note that if styled = {} the styleReverse does not kick in and bgr will bve the setForegroundColor
  cxPrintLn(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " no style specified                 ", fontcolor = "coldarkblue",bgr = lightblue,styled={})       
  # here we just set styleBright which seems to trigger a  operation which makes foregroundcolor the bgr color and bgr color the fontcolor
  # this is a bit hairy ...  
  cxPrintLn(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " styled  = styleBright              ", fontcolor = "coldarkblue",bgr = lightblue,styled={styleBright})       
  # here styleReverse and styleBright are set which gives the expected result
  cxPrintLn(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " styled  = styleReverse,styleBright ", fontcolor = "coldarkblue",bgr = lightblue,styled={styleReverse,styleBright})       
  # here styleReverse and styleDim are set which gives the expected result
  cxPrintLn(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " styled  = styleDim                 ", fontcolor = "coldarkblue",bgr = lightblue,styled={styleDim})       
  cxPrintLn(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " styled  = styleReverse,styleDim    ", fontcolor = "coldarkblue",bgr = lightblue,styled={styleReverse,styleDim})       
  
  echo()
  
  # test for printTrue should be same as above we just add an echo
  # test with our fmt function
  cxPrint(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "greenyellow" & "  " & rightarrow, fontcolor = "coldarkblue",bgr = greenyellow,styled={styleReverse})       
  echo()
  # here also note that if styled = {} the styleReverse does not kick in and bgr will bve the setForegroundColor
  cxPrint(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " no style specified                 ", fontcolor = "coldarkblue",bgr = lightblue,styled={})       
  echo()
  # here we just set styleBright which seems to trigger a  operation which makes foregroundcolor the bgr color and bgr color the fontcolor
  # this is a bit hairy ...  
  cxPrint(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " styled  = styleBright              ", fontcolor = "coldarkblue",bgr = lightblue,styled={styleBright})       
  echo()
  # here styleReverse and styleBright are set which gives the expected result
  cxPrint(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " styled  = styleReverse,styleBright ", fontcolor = "coldarkblue",bgr = lightblue,styled={styleReverse,styleBright})       
  echo()
  # here styleReverse and styleDim are set which gives the expected result
  cxPrint(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " styled  = styleDim                 ", fontcolor = "coldarkblue",bgr = lightblue,styled={styleDim})       
  echo()
  cxPrint(fmtx(["<40",">20"],"TrueFontColor :  fontcolor = coldarkblue ", "Backcolor : ") & "lightblue" & "  " & rightarrow & " styled  = styleReverse,styleDim    ", fontcolor = "coldarkblue",bgr = lightblue,styled={styleReverse,styleDim})       
  echo()
  echo()
  # 2 printtrue statements and a printlntrue
  printLn("Passing fontcolor as string")
  cxPrint("Nice cxPrint statement ",fontcolor = "colgoldenrod",bgr = darkslategray)
  cxPrint(" Another , cxPrint statement ",fontcolor = "colyellowgreen",bgr = darkslategray,xpos = 30,styled = {stylereverse})
  cxPrintLn(" cxPrintLn statement",fontcolor = "colPink",bgr = darkblue,xpos = 65)
  
  # experiment with cxPrintLn
  printLn("Passing fontcolor as const")
  cxPrint("Nice cxPrint statement ",fontcolor = colgoldenrod,bgr = darkslategray)
  cxPrint(" Another , cxPrint statement ",fontcolor = colyellowgreen,bgr = darkslategray,xpos = 30,styled = {stylereverse})
  cxPrintLn(" cxPrintLn statement",fontcolor = colPink,bgr = darkblue,xpos = 65)
  
  decho(2)
  cxPrintLn("----->  end of playcxPrint",bgr = rndcol())      # this ok with default fontcolor colWhite and bgr drawn from colorNames
  
############################################################################################################################### 

# another demo fontcolornames and backgroundcolor values

proc playWildColors() = 
  
   for x in txcol:
     for bcolno in countup(0,cxTrueCol.len - 1,76): # change step size for more or less granularity  ---> less is more
        cxprintln("TESTING  FontColor = $1   Bgr Color = cxTrueCol[$2]"  % [cxColorNames[x][0],$bcolno],cxColorNames[x][0],cxTrueCol[bcolno])

###############################################################################################################################

# show a color gradient on a line
# still needs more work

proc playGradient() =
     var npos = 1
     for x in countup(0,cxTrueCol.len,152):
       inc npos
       cxPrint(" ",colWhite,cxTrueCol[1 + x],xpos = npos)
       if npos  > tw - 2: 
          echo()
          npos = 1
        
################################################################################################################################     
proc RGBcx(r:int,g:int,b:int) : int =
    result = -1
    for x in 0..<cxTrueCol.len:
       var pattern = $r & ";" & $g & ";" & $b & ";"
       printLnBiCol("Checking pattern : " & pattern & cxtruecol[x])
       if cxtruecol[x].contains(pattern) == true:
          result = x
          break
             
             
proc playFindRGB(r:int,g:int,b:int) =
     var ok = RGBcx(r,g,b)
     if ok > -1:
        printLn("RGB : " & $r & ";" & $g & ";" & $b & ";" & " in cxTrueCol. Result  : " & $ok)
     else:
        printLn("RGB : " & $r & ";" & $g & ";" & $b & ";" & " in cxTrueCol. Result  : not found")
        
     printLn(rightarrow & "  " & $ok)
################################################################################################################################
# select one or more items to play with  . Had enough ?  Ctrl-C
# playSpectrum()
# decho(2)
# color vals ex http://www.colorhexa.com/color-names
# playRGB(93,138,168,true)  # french blue
# playRGB(15,77,146,true)   # yale blue
# playRGB(115,134,120,true) # xanadu
# playRGB(0,115,207,true)   # true blue
# decho(2)
playCxPrint()
# decho(2)
#showCxTrueColorPalette(min = 0,max = 888,step = 14,true)   # default step = 12  reduce for more colors increase for less step = 4 needs about 4GB free mem
# decho(2)
# playWildColors()
# playGradient()
decho(2)
#playFindRGB(888,0,852)

doFinish()
