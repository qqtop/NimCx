import nimcx

## cardDealerDemo.nim
## 
## a demo program for cx drawbox and getCard procs
## 
## best in standard full size terminal monospace 9 font
## 

cleanscreen()
decho(2)
printLnInfoMsg("DEMO","CARD DEALER",xpos= 80)
decho(8)
var xxpos = 10

proc lb(xpos:int) = 
  var nxpos = xpos
  for x in 0.. 28:
     drawRect(h = 2,w = 3,frCol = randcol(),dotCol = randcol(),xpos = nxpos)
     curup(2)
     print(getCard(),randCol(),xpos = nxpos + 1)  # get card and print in random color at xpos
     curup(1)
     nxpos = nxpos + 4
let max =300
for z in 0..max:
  for y in 0.. 8:
    lb(xxpos)
    decho(3)
    
  sleepy(0.001)  
  curset()
  printSlimNumber($z & ":" & fmt"{max}" ,randcol())
  decho(7)
     
decho(28)
doFinish()
