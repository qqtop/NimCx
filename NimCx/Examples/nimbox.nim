
import cx

# testbox.nim
# 
# testing the drawBox proc 
# 
# filling in of box data should be easier ... but figuring out the right coordinates is hard :(
# 


var postop = 5  # some vertical space from top
let xpos = 10


proc vertfiller(d:int = 0 ,f:int = 0,b:int = 0)  =
   curset()
   curmove(dn = d + postop + 1,fw = f + xpos)
   print(widedot & "NIM " & widedot,randcol())


let boxwidth = 110
let boxsections = 10

let y = 3   # usually the first desired print position counted from the left frame  
let step = boxwidth div boxsections + y

   
proc mynimbox() =

        cleanscreen()
        
        decho(postop)
        
        drawBox(hy=10, wx= boxwidth , hsec = 5 ,vsec = boxsections,frCol = randcol(),brCol= black ,cornerCol = truetomato,xpos = xpos,blink = false)

        for x in countup(0,9,2) :  vertfiller(x,y)

        for x in countup(0,9,2) :  vertfiller(x, 14 )
        
        for m in 2 .. 9:
              for x in countup(0,9,2) :  vertfiller(x, m * (step - y) + y) 
              
        sleepy(0.5)
        
for m in 0 .. 5: mynimbox()

decho(5)

showTerminalSize()

doFinish()
