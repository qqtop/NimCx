# cxtest.nim
# rough and ready testing of some of available functions in nimcx library
# see docs for more examples 
#
# Latest      : 2019-06-06   
 
import nimcx

var testno = newCxcounter()

let s = "nimcx Testing "
let n = 1234567890
let f = 123.4567890
let l = @[1234,4567,890]


proc nextTest() =
     testno.add
     decho(3)
     cxPrintLn( 1,orange,darkslategraybg,cxBright,"nimCx   TEST No. :   " & $testno.value & spaces(1) & red & downarrow & spaces(2))   # random cols
     decho(1)

# testing the help generator proc
nextTest()
cxHelp(["Help system for " & extractFileName(getAppFilename()),
    "",
    "1) Read the book",
    "2) use more data",
    "3) have a beer",
    cxcodestart,
    "Example 1",
    "",
    "let abc = @[1,2,3]",
    "    ",
    "var xfg = mysupergenerator(abc,3)",
    cxcodeend,
    "this should be help style again",
    cxcodestart,
    "Example 2  ",
    "",
    "for x in 0..<n:",
    """   printLn("Something Nice  ",blue)"""",
    "",
    cxcodeend,
    "Have a nice day"])


# print and printLn test
nexttest()
print("This is " & NIMVERSION)
print("",xpos=30)
print("This nimcx " & CXLIBVERSION)
print("\L" * 2)
printLn(" white on black ",white,blackbg)
printLn(" black on white ",black,whitebg)
printLn(" white on trueblue pos: 50 ",white,truebluebg,xpos = 50)
printLn(l,styled={styleUnderscore})

#printLnRainbow test
nextTest()
printRainbow(s,{})
echo()
printLnRainbow(n,{})
printLnRainbow(f,{stylereverse})
decho()

# change color upon first separator 
nextTest()
printLnBiCol(s,colleft=brightgreen,colRight=brightwhite,sep="c")
printLnBiCol(s,sep="c")  # default colors
printLnBiCol(s,colLeft=red,colRight=goldenrod,sep="c",xpos=5,false,{})
decho()
printLn(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),l),greenyellow)      
printLn(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),l),yellow,yalebluebg)
cxPrintLn(0,colyellow,darkbluebg,fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),l))

nexttest()
dline(60,lt = "/+",truetomato) 

# SierpCarpet
nextTest()


#### sierpcarpet 
proc `^`*(base: int, exp: int): int =
  var (base, exp) = (base, exp)
  result = 1
 
  while exp != 0:
    if (exp and 1) != 0: result *= base
    exp = exp shr 1
    base *= base
 
proc inCarpet(x:int, y:int): bool =
  var x = x
  var y = y
  while true:
    if x == 0 or y == 0: return true
    if x mod 3 == 1 and y mod 3 == 1: return false
 
    x = x div 3
    y = y div 3
 
 
proc sierpCarpetDemo*(n:int=2,sp:string=spaces(2),starcol:string=trueblue,xpos:int = 1) =
  ## sierpCarpetDemo
  ## 
  ## draws the carpet in color
  ## 
  for i in 0 ..< (3^n):
    curSetx(xpos)
    for j in 0 ..< (3^n):
      if inCarpet(i, j):
        print("* ",starcol,styled={styleBright})
      else:
          #print(spaces(2),rndcol(),styled = {styleReverse,styleUnderscore})
          #print(efr2 * 2,rndcol(),styled = {styleUnderscore})
          #print(efr2 * 2,rndcol(),styled = {})
          print(sp,rndcol(),styled = {styleBright,styleReverse,styleUnderscore})     
    echo()

echo() 
superHeader("Sierpinski's Carpet in Color  ",white,lightblue)
echo()
sierpCarpetDemo(3,starcol=trueblue)
curup(27)
sierpCarpetDemo(3,sample(ejm3),tomato,xpos = 60)
curup(27)
sierpCarpetDemo(2,innocent,gold,xpos = 120)
sierpCarpetDemo(2,smiley,silver,xpos = 120)
sierpCarpetDemo(2,spaces(2),sienna,xpos = 120)
curup(27)
sierpCarpetDemo(2,innocent,pastelGreen,xpos = 140)
sierpCarpetDemo(2,smiley,truetomato,xpos = 140)
sierpCarpetDemo(2,spaces(2),royalblue,xpos = 140)
decho(2)

# cardsDemo
nextTest()

proc randomCardsDemo() =
   ## randomCards
   ## 
   ## Demo for colorful cards deck ...
   decho(2)
   for z in 0 ..< 12:
      curSetx(2) 
      for zz in 0 ..< 12:
          print(cards[sample(rxCards)] & " ",rndCol(),styled={styleBright})
      echo()
      
randomCardsDemo() 

# variouse print tests
nextTest()
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

doNimUp()     


# ruler demo
nexttest()
decho(8)
proc rulerDemo*(xpos:int = 0,ypos:int = 6) =
    decho(2)
    printLn("cxRuler")
    echo()
    var ahcol1 = trueblue
    showRuler(fgr=trueblue) # bottom
    decho(2)
    printLn("cxRuler 22-55")
    echo()
    showruler(xpos =22,xposE = 55,fgr=pastelgreen)
    decho(2)
rulerdemo()   

# Emojis and symbols test
nexttest()  
  
proc happyEmojis*() =
    ## happyEmojis
    ## 
    ## playing with var. emojis lists available
    ## 
  
    cursetx(2)
    for x in 0..7:
        print(sample(ejm3) & spaces(1),randcol())
    echo() 
    cursetx(2)   
    for x in 0..7:
         print(sample(ejm3),randcol())   
         printLn(sample(ejm3),randcol(),xpos=23)
         cursetx(2)
          
    for x in 0..7:
        print(sample(ejm3) & spaces(1),randcol())     
    curup(5)
    cxprint(6,white ,yalebluebg,cxBright," NIMCX " & CXLIBVERSION & " ")
    curdn(7)

happyEmojis() 
 
# showPalette 
nextTest()
var mycol = "green"  
showPalette(mycol)
mycol = "blue"
showPalette(mycol)
mycol = "al"
showPalette(mycol) 
 
# showing randcol from custom palette pastel on left side
nextTest()
mycol = "pastel"
for x in 0 ..< colPaletteLen(mycol):   
   print(rightarrow & "what 12345678909 ",randCol2(mycol))
   println(spaces(5) & rightarrow & "  this 12345678909 ",randCol())
  
nextTest()
import cxfont


# this test will need a zoomed out terminal to accomodate all letters
# nextTest()
# decho(5)    
# dotMatrixTyper("NIMCX - FONT",xpos = 1)
# decho(10)
# dotMatrixTyper("dotmatrix",xpos = 6)
# decho(12)
# 
# decho(5)    
# dotMatrixTyper("NIMIFICATION",xpos = 1)
# decho(15)
# dotMatrixTyper(" of  the  world ",xpos = 6)
# decho(12)
# 

nextTest()

printNimcx()
decho(8)
printMadeWithNim()
decho(8)
printSlimNumber($getClockStr() & "  ",pastelpink,blackbg,xpos=60)
decho(5)
         
doFinish()