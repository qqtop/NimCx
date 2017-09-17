
## cxTest.nim
## 
## rough testing for cx.nim 
## 
## best run in a large console window


import cx,cxDemo,sequtils,times,unicode,cxutils

superHeader("Testing print and echo procs from cx.nim and run demos")

let s = "Test color string"
let n = 1234567
let f = 123.4567
let l = @[1234,4567,654]


# background colors for print and println are standard terminal colors
# to use other colors use styled = {stylereverse}

printLn(s,white,brightblack)
printLn(n,white,red,xpos = 20)
printLn(f,white,blue,xpos = 50)
printLn($f,rosybrown,styled = {stylereverse},substr = $f)
decho(2)

printLn(s,lime)
printLn(n,brightgreen)
printLn(f,greenyellow)
printLn(l,rosybrown)
decho(2)

printLnRainbow(s,{})
printLnRainbow(n,{})
printLnRainbow(f,{})
printLnrainbow(l,{styleUnderscore})
decho(2)


printLn(s,clrainbow,styled = {styleUnderScore,styleBlink},substr = s)
decho(2)

# change color upon first separator 
printLnBiCol(s,colleft=brightgreen,colRight=brightwhite,sep="c")
printLnBiCol(s,sep="c")  # default colors
decho(2)

# all in one color
printLn(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),l),greenyellow)      
# all in one color with new background 
print(fmtx(["","","","","","",""],s,spaces(1),n,spaces(1),f,spaces(1),l),brightyellow,brightblue)
echo()

printLn(s,clrainbow,brightyellow)  
printLn(s,lime)
decho(1)

print(s,black,brightmagenta)
printLn(s &  " ---> this is white at position x = 45",xpos = 45)


printLn("Everyone and the cat likes fresh salmon.",yellowgreen,styled = {styleUnderScore},substr = "the cat")
decho(2)

print("123423456576782312345",lightseagreen,styled = {stylereverse},substr = "23")
echo()
printLn("The dog blinks . ",rosybrown,styled = {styleUnderScore,styleBlink},substr = "dog")


# compare usage to achieve same output
# difference between print and cecho procs is that cecho accepts varargs too
                            
cecho(salmon,"Everyone and the cat likes fresh salmon. ")
cecho(steelblue,"The dog disagrees here. ")
cechoLn(greenyellow,"Cannot please everyone. ",pastelpink,"Indeed !")

# the system echo works too but needs color reset at the end, styleConstants also do not work
# similar to the just introduced styledwrite and resetStyle 
echo(salmon,"Everyone and the cat likes fresh salmon. ",steelblue,"The dog disagrees here. ",greenyellow,"Cannot please everyone.",termwhite,"")

echo(pastelpink,"Yippie ",lightblue,"Wow!",termwhite,"")
echo()

echo(pastelblue," ",int.high)
echo(pastelgreen,int.low)
dlineLn(21,col = lime)
echo(pastelyellow,int.high + abs(int.low))
echo()

print("Everyone and the cat likes fresh salmon. ",salmon)
print("The dog disagrees here. ",steelblue)
printLn("Cannot please everyone.",greenyellow)
decho(2)

dline() # white dashed line
printLn(repeat("✈",tw),yellowgreen)
dline(60,lt = "/+",truetomato) 
printLn("  -->  truetomato",truetomato)
decho(2)

echo() 
superHeader("Sierp Carpet in Multi Color - Sierp Carpet in Multi Color",clrainbow,lightsteelblue)
echo()
sierpCarpetDemo(3)
decho(3)


printSlimNumber($getClockStr() & "  ",pastelpink,black,xpos=25)
decho(5)

printBigNumber($getClockStr(),fgr=salmon,xpos=10)
decho(5)

superHeader("Nim Colors ")
# show a full list of colorNames availabale
showColors()
decho(2)


var mycol = "green"  

showPalette(mycol)

echo colPaletteName("green",5) #show entry 5 of the green palette
println("something blue ", colPalette("blue",5) )  #show entry 5 of the blue palette

decho(2)
# showing randcol with custom palette selection and full randcol with all colors
for x in 0.. <colPaletteLen(mycol):   
  print(rightarrow & "what 12345678909 ",randCol2(mycol))
  println("  what 12345678909 ",randCol())
  
  

for x in 0.. 10:
    centerMark()
    echo()
    sleepy(0.1)

flyNimDemo()

decho(3)
ndLineDemo()

decho(2)
sleepy(3.5)
   
movNimDemo()   

clearUp(18)
curSet()
drawRectDemo()

decho(5)  
sleepy(3)

widedotfieldDemo()

sleepy(1)
decho(3)


decho(3)
randomCardsClockDemo() 
decho(2)


#testing bigblock characters
cxYourNimDemo()
sleepy(2)
decho(10)


# testing emojis

printLn(heart & " Nim " & heart,red)    
print(smile,randcol())  
print(copyright,randcol())
print(trademark,randcol())  
print(roof,lime)
print(snowflake,randcol())  
print(music,lime)
print(xmark,randcol())  
print(check,randcol())
print(scissors,randcol())  
print(darkstar,randcol())
print(star,randcol())  
print(umbrella,randcol())
print(flag,randcol())  
print(skull,randcol())
print(heart,red)  

println(sun,randcol())
print(innocent,randcol())
print(lol,randcol())
print(smiley,randcol())
print(tongue,randcol())
print(blush,randcol())
print(sad,randcol())
print(cry,randcol())
print(rage,randcol())
print(cat,randcol())
print(kitty,randcol())
print(monkey,randcol())
printLn(cow,randcol())

happyemojis()
sleepy(2)

colorCJKDemo()
decho(5)    

bigPanelDemo()
sleepy(2)

#rulerDemo
cleanScreen()
rulerDemo()
  

decho(15)
var twc = tw div 2
showTerminalSize()
printLnBiCol("Terminal Center : " & $twc)



# show sierpcarpetdemo2

cleanscreen()
decho(2)
for x in 1.. 100:
        curset()
        decho(2)
        sierpCarpetDemo2(2,10," " & $Rune(9961) & " "," " & $Rune(9924) & " ")
        sleepy(0.02)
decho(5)


# here showing iching
rainbow2Demo()
decho(5)
sleepy(2)


# experimental font tests
   
animNimcx()   
decho(8) 
printMini()
decho(10)
sleepy(1) 

cxy(0)
cxp(10)
cxx(20)   
cxa(30)
cxx(40)
cxb(50)
cxd(60)
cxl(70)
cxc(80)
cxm(90)
cxi(100)
cxn(106)
cxr(116)
decho(10)
cxo(0)
cxy(10)
cxq(20)
cxe(30)
cxf(40)
cxg(50)
cxh(60)
cxj(71)
cxt(80)
cxz(90)
cxu(100)
cxv(110)
decho(10)
cxw(0)
cxk(10)
cxe(20)
cxk(30)
cxs(40)
cxpoint(60)
cxhyphen(70)
decho(10)

loopy2(0,20):
    cleanscreen()
    cx1(1)
    cx2(10)
    cx3(20)
    cx4(30)
    cx5(40)
    cx6(50)
    cx7(60)
    cx8(70)
    cx9(80)
    cxzero(90)
    cxpoint(100)
    cxhyphen(110)
    decho(10)
    loopy2(0,6):
       cxgrid(10 * xloopy,col = "blue",coltop=red)
       cxgrid(10 * xloopy + 60,col = "light",coltop=blue)
    sleepy(0.5)

decho(10)
cleanscreen()
printNimcx()
decho(10)
printMadeWithNim()

decho(10)
doFinish()
