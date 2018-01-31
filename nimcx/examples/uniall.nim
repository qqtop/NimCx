import nimcx
# uniall.nim
# show 55203 unicode characters in color
# set your terminal to width = 130

var c = newcxcounter()
var y = newcxcounter()
for z in  uniall():
   var zz = z.split(':')
   c.add
   for x in countup(0,zz.len - 2,2):
      if c.value > 10:
            printLnbicol(zz[x]  & zz[x+1] & spaces(1),colleft=randcol(),colRight=randcol())
            c.reset
            y.add
      else:
            printbicol(zz[x]  & zz[x+1] & spaces(1),colleft=randcol(),colRight=randcol())
      if y.value == th:
            sleepy(0.05)
            cleanscreen()
            y.reset
            
echo()            
showTerminalSize()            
doFinish()            
