import cx,cxutils

## cardDealerDemo.nim
## 
## a demo program for cx drawbox and getCard procs
## 
## best in standard full size terminal monospace 9 font
## 

cleanscreen()
decho(2)
printBigLetters("#####CARD # DEALER",xpos= 10,fun = true)
decho(8)
var xxpos = 10

proc lb(xpos:int) = 
  var nxpos = xpos
  for x in 0.. 28:
     drawBox(2,3,frCol = randcol(),cornerCol = randcol(),xpos = nxpos)
     curup(2)
     print(getCard(),randCol(),xpos = nxpos + 1)  # get card and print in random color at xpos
     curup(1)
     nxpos = nxpos + 4

for z in 0.. 1000:
  for y in 0.. 8:
    lb(xxpos)
    decho(3)
    
  sleepy(0.01)  
  curset()
  printSlimNumber($z & ":1000" ,randcol())
  decho(7)
     
decho(28)
doFinish()
