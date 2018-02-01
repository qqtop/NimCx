import nimcx

## small rough demos repository for var. procs in cx.nim
## this file is imported by cxTest.nim to actually run the demos
## may and will change anytime and errors may happen anytime

## 2018-02-01  - WIP 


proc flyNimDemo*(astring:string = "  Fly Nim",col:string = red,tx:float = 0.04) =

      ## flyNim
      ## 
      ## small animation demo
      ## 
      ## .. code-block:: nim
      ##    flyNimDemo(col = brightred)  
      ##    flyNimDemo(" Have a nice day !", col = hotpink,tx = 0.1)   
      ## 

      var twc = tw div 2
      var asc = astring.len div 2
      var sn  = tw - astring.len  
      for x in 0.. twc - asc:
        hline(x,yellowgreen)
        if x < twc - asc :
              print("✈\L",brightyellow,styled = {styleBlink})
                           
        else:
              print(astring,truetomato,centered = true)
              hlineln(sn - x - 1,salmon)
        sleepy(tx)
        curup(1) 
        
      echo()
      


proc randomCardsDemo*() =
   ## randomCards
   ## 
   ## Demo for colorful cards deck ...
   decho(2)
   for z in 0..<th - 3:
      for zz in 0..<tw div 2 - 1:
          print cards[rndSample(rxCards)],randCol()
      writeLine(stdout,"") 
  
  
proc happyEmojis*() =
  ## happyEmojis
  ## 
  ## lists implemented emojis if available in your system
  ## 
  
  decho(2)
  cechoLn(lime & emojis[7] & yellowgreen & " Happy Emojis " & lime & emojis[7])
  echo()
  for x in 0..<emojis.len:
      var ejs = fmtx(["<4","",""],$x," : ",emojis[x])
      printLnBiCol(ejs,colleft=white,colRight=randcol())
  decho(2)



#### sierpcarpet small snippet borrowed from somewhere and colorized

proc `^`*(base: int, exp: int): int =
  var (base, exp) = (base, exp)
  result = 1
 
  while exp != 0:
    if (exp and 1) != 0:
      result *= base
    exp = exp shr 1
    base *= base
 
proc inCarpet(x:int, y:int): bool =
  var x = x
  var y = y
  while true:
    if x == 0 or y == 0:
      return true
    if x mod 3 == 1 and y mod 3 == 1:
      return false
 
    x = x div 3
    y = y div 3
 
 
proc sierpCarpetDemo*(n:int=2,xpos:int = 1) =
  ## sierpCarpetDemo
  ## 
  ## draws the carpet in color
  ## 
  for i in 0..<(3^n):
    cursetx(xpos)
    for j in 0..<(3^n):
      if inCarpet(i, j):
        print("* ",skyblue)
      else:
          print("  ",randcol(),styled = {stylereverse,styleunderscore,styleblink})
     
    echo()

    

proc sierpCarpetDemo2*(n:int=2,xpos:int = 1,sa:string = "* ",sb:string = spaces(2)) =
  ## sierpCarpetDemo2
  ## 
  ## draws the carpet in color and allowing change of characters 
  ## 
 
  for i in 0..<(3^n):
    
    cursetx(xpos)
    var npos = xpos
    for j in 0..<(3^n):
      inc npos
      if inCarpet(i, j):
          # print(sa,randcol())
          #cxprint(sa,cxcolornames[rndSample(txcol)][1],xpos = npos)
          cxprint(sa,colRed,xpos = npos)
      else:
          #print(sb,randcol(),styled = {stylereverse,styleunderscore})
          print(sb,truetomato,styled = {stylereverse,styleunderscore})
          #  cxprint(sb,cxcolornames[rndSample(txcol)][1],rndtruecol2(),xpos = npos)
    echo()

    
proc allRuneTest() =
    # shows 58000 unicode chars in color with their ord numbers
     tableRune(uniall(true),fgr="rand",cols = 8)
     decho(2)


proc drawRectDemo*() =
  ## drawRectDemo
  ## 
  ## examples of using drawRect
  ## 
  drawRect(15,24,frhLine = "+",frvLine = wideDot , frCol = randCol(),xpos = 8)
  curup(12)
  drawRect(9,20,frhLine = "=",frvLine = wideDot , frCol = randCol(),xpos = 10,blink = true)
  curup(12)
  drawRect(9,20,frhLine = "=",frvLine = wideDot , frCol = randCol(),xpos = 35,blink = true)
  curup(10)
  drawRect(6,14,frhLine = "~",frvLine = "$" , frCol = randCol(),xpos = 70,blink = true)
 

proc colorCJKDemo*() =   
    ## colorCJKDemo            
    ## carpet with CJK characters
    ##
    decho(2)
    printFont("NIM  CARPET",xpos = 8) 
    decho(7)
    for y in 0.. 25:
       curSetx(15)
       for x in 0..52:
           #print(newWordCJK(1,1),randcol())
           cxprint(newWordCJK(1,1),rndCxFgrCol(),xpos = 15 + x * 2 )
       echo()
    echo()   
    printFont("--NIM",randcol(),xpos = 0)  
    printFont("0.17.3--",randcol(),xpos = 47)
    sleepy(1) 
    decho(3)
    
    
proc printFontTest*() =
    printFontFancy("Random--" & newWord(3,6),randcol2("rod"),xpos = 0)
    decho(10)
    printFont("nimcx",randcol2("blue"),xpos = 30)
    decho(10)
    printFont("You like it ")
    printFont("now.",red,xpos=80)
    decho(10)
    printFontFancy("You like it ")
    printFont("now.",red,xpos = 80)
    decho(10)
    printFontFancy("1234567890.0")
    decho(10)
        
     
proc rulerDemo*(xpos:int = 0,ypos:int = 12) =
  
    var avcol1 = rndcol()
    var ahcol1 = rndcol()
    for nxpos in countup(0,tw-3): 
      cleanscreen() 
      showRuler(fgr=ahcol1) # top
      decho(3)
      showRuler(xpos = nxpos   ,ypos = ypos,fgr = avcol1,vert = true)   # left
      curup(ypos)
      showRuler(xpos = tw - 3 ,ypos = ypos,fgr = avcol1,vert = true)   # right
      curup(3)
      showRuler(fgr=ahcol1) # bottom
      curup(ypos + 3)
      sleepy(0.03)
      
      
    for nxpos in countdown(tw - 3 , 0): 
      cleanscreen() 
      showRuler(fgr=ahcol1) # top
      decho(3)
      showRuler(xpos = nxpos   ,ypos = ypos,fgr = avcol1,vert = true)   # left
      curup(ypos)
      showRuler(xpos = tw - 3 ,ypos = ypos,fgr = avcol1,vert = true)   # right
      curup(3)
      showRuler(fgr=ahcol1) # bottom
      curup(ypos + 3)
      sleepy(0.03)
   
   
proc animNimcx*() =                  
        # experimental font demo      
        for nn in 0.. 2:            
           loopy2(0,15):
                cleanscreen()
                cxn(xloopy,dodgerblue,coltop=red)
                cxi(xloopy+9,lime,coltop=red)
                cxm(xloopy+16,gold,coltop=red)
                cxc(xloopy+27,pink,coltop=red)
                cxx(xloopy+35,coltop=red) 
                sleepy(0.05)

proc printMini*() =
  # experimental font demo  
  loopy2(0,8):
        cleanscreen()
        cxm(xloopy,randcol(),coltop=red)
        cxi(xloopy+9,dodgerblue,coltop=red)
        cxn(xloopy+15,gold,coltop=red)
        cxi(xloopy+23,dodgerblue,coltop=red)  
        sleepy(0.15)   
        


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
          printLn("     $$$$$$    $$  $$      ",randcol(),/media/lxuser/nimcxindex theindex.htmlxpos=60)
          printLn("       $     $$$ $$$       ",randcol(),xpos=60)
          printLn("        $$$$$$$$$$         ",randcol(),xpos=60)

      curup(15)
      printFont("NIM",randcol(),xpos = xpos + 33)
      curdn(15)
