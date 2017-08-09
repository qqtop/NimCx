import os,nimcx

# nimcat   
# a cat for nim :)
# usage : nimcat test4 test1     # shows 2 nim files 
# all other file types need the full filename like e.g. notes.txt


var pc = paramcount()
if pc > 0:
    for x in 0.. <pc:
      nimcat(paramStr(x + 1))
hlineLn()      
printLnBiCol("Files Shown: " & $pc,":",peru)
echo()
#doFinish()
