
## cxTest.nim
## 
## VERY rough testing for nimcx.nim errors may occur at times ...  
## 
## Status : 2018-10-18  always WIP
## 
## best run in a large console window
## 


import nimcx,cxDemo 
     

superHeader("nimCx Testing ")

let s = "Test color string"
let n = 1234567
let f = 123.4567
let l = @[1234,4567,654]
var testno = newCxcounter()


proc nextTest() =
     testno.add
     decho(3)
     cxPrintLn("nimCx   TEST No. :   " & $testno.value & spaces(1) & red & downarrow, colBeige,darkslategray,xpos = 1)   # random cols
     #cxPrintLn("nimCx   TEST No. :   " & $testno.value, rndCxFgrCol(),rndCxBgrCol(),xpos = 1)   # random cols
     decho(1)

nextTest()
superHeader("Nim Colors ")
sleepy(0.7)
# show a full list of colorNames availabale
showColors()
sleepy(1)
decho(2)

     
nextTest()     
printLn(s  & "white on black)",white,bgblack)

nextTest()
printLn(n,white,bgred,xpos = 20)

nextTest()
printLn(f,white,bgblue,xpos = 50)

nextTest()
printLn($f,rosybrown,styled = {stylereverse},substr = $f)

nextTest()
printLnRainbow(s,{})
printLnRainbow(n,{})
printLnRainbow(f,{stylereverse})
printLn(l,styled={styleUnderscore})
decho(2)

nextTest()
printLn(s,clrainbow,styled = {styleUnderScore,styleBlink,stylereverse},substr = s)
decho(2)

nextTest()
# # change color upon first separator 
printLnBiCol(s,colleft=brightgreen,colRight=brightwhite,sep="c")
printLnBiCol(s,sep="c")  # default colors
printLnBiCol(s,colLeft=red,colRight=goldenrod,sep="c",xpos=5,false,{})
decho(2)

nextTest()
printLn(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),l),greenyellow)      
printLn(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),l),yellow,bgblue)
cxPrintln(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),l),colyellow,darkblue)
nexttest()

printLn("Everyone and the cat likes fresh salmon.",yellowgreen,styled = {styleUnderScore},substr = "the cat")
printLn("123423456576782312345",lightseagreen,styled = {stylereverse},substr = "23")
printLn("The dog blinks . ",rosybrown,styled = {styleUnderScore,styleBlink},substr = "dog")
nextTest() 
# 
# # compare usage to achieve same output
# # difference between print and cecho procs is that cecho accepts varargs too
#                             
# cecho(salmon,"Everyone and the cat likes fresh salmon. ")
# cecho(steelblue,"The dog disagrees here. ")
# cechoLn(greenyellow,"Cannot please everyone. ",pastelpink,"Indeed !")
# 
# # the system echo works too but needs color reset at the end, styleConstants also do not work
# # now better to use the newer styledwrite and resetStyle 
echo(salmon,"Everyone and the cat likes ffresh salmon. ")
# 
echo "int.high - abs(int.low)"
echo(pastelblue," ",int.high)
echo(pastelgreen,int.low)
dlineLn(21,col = lime)
echo(pastelyellow,int.high + int.low)
echo()

print("Everyone and the cat likes fresh salmon. ",salmon)
print("The dog disagrees here. ",steelblue)
printLn("Cannot please everyone.",greenyellow)
decho(2)

dline() # white dashed line
printLn(repeat("✈",tw - 2),yellowgreen)
dline(60,lt = "/+",truetomato) 
printLn("  -->  truetomato",truetomato)
decho(2)

nextTest()
echo() 
superHeader("Sierp Carpet in Multi Color - Sierp Carpet in Multi Color",white,lightblue)
echo()
sierpCarpetDemo(3)
decho(3)
 
nextTest()
printSlimNumber($getClockStr() & "  ",pastelpink,bgblack,xpos=25)
decho(5)

nextTest()
happyEmojis()
decho(5)


nextTest()
var mycol = "green"  
showPalette(mycol)
mycol = "blue"
showPalette(mycol)
mycol = "al"
showPalette(mycol)

nextTest() 
echo colPaletteName("green",5) #show entry 5 of the green palette
println("something blue ", colPalette("blue",5) )  #show entry 5 of the blue palette


nextTest()
# # showing randcol with custom palette selection and full randcol with all colors on the side
for x in 0..<colPaletteLen(mycol):   
   print(rightarrow & "what 12345678909 ",randCol2(mycol))
   println(spaces(5) & rightarrow & "  what 12345678909 ",randCol())
 
nextTest()
# show use of colPalette and colPaletteLen
let z = "The big money waits in the bank" 
for _ in 0..10:
  printLn2(z,colPalette("pastel",getRndInt(0,colPaletteLen("pastel") - 1)),styled={styleReverse})
  print(cleareol)

 
nexttest() 
for x in 0.. 10:
     centerMark()
     echo()
     sleepy(0.1)
     
     
#nextTest()
#flyNimDemo()
 
 
nextTest()
drawRectDemo()
decho(5)  
sleepy(3)


#rulerDemo
nextTest()
showRuler()
decho(10)  

nextTest() 
decho(5)
showTerminalSize()
centerMark()
printLnBiCol(rightarrow & " Terminal Center : " & $(tw div 2))
decho(8)

nextTest() 
colorCJKDemo()   # nimcarpet
decho(28) 


# experimental font tests
   
nextTest()   
printFonttest()
sleepy(5)
decho(10)

nextTest()
printNimcx()

nexttest()
decho(15)
doNimUp()
decho(8)

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
printMadeWithNim()

decho(10)

doFinish()
