import cx,os,osproc

# cpcx.nim
# 
# status : ok
# 
# copied all nimcx files for the NimCx/nimcx directory from NmCxDevel  to  NimCx
# 
# and executes the push to github
#
# removed cxutils.nim
# 
# tested ok  2019-10-01

let mntpoint = "/data5/"

template withcd(newdir: string, statements: untyped) =
  let olddir = os.getCurrentDir()
  os.setCurrentDir(newdir)
  statements
  os.setCurrentDir(olddir)
 
  
  
# main modules
let cxmoduleset = @["cx.nim","cxconsts.nim","cxglobal.nim","cxprint.nim","cxtime.nim","cxnetwork.nim","cxhash.nim",
                   "cxstats.nim","cxtest.nim","cxfont.nim","cxfontconsts.nim"]  
  
for mymodule in cxmoduleset:
   if sameFilecontent(mymodule,mntpoint & "NimStuff/NimCx/nimcx/" & mymodule) == false:     
      copyfile(mymodule,mntpoint & "NimStuff/NimCx/nimcx/" & mymodule)
      var stm = "Copied    : " & mymodule & " to " & mntpoint & """NimStuff/NimCx/nimcx/""" & mymodule
      printLnStatusMsg(stm)
   else:
      printLnStatusMsg("Unchanged : " & mymodule)
   

#let cxexamplemodulesset = newseq[string]()
# 
# for mymodule in cxexamplemodulesset:
#    if sameFilecontent(mymodule,mntpoint & "NimStuff/NimCx/nimcx/examples/" & mymodule) == false:     
#       copyfile(mymodule,mntpoint & "NimStuff/NimCx/nimcx/examples/" & mymodule)
#       var stm =        "Copied    : " & mymodule & " to " & mntpoint & """NimStuff/NimCx/nimcx/examples/""" & mymodule
#       printLnStatusMsg(stm)
#    else:
#       printLnStatusMsg("Unchanged : " & mymodule)


printLn " Please await docx execution :"  
echo()
withcd(mntpoint & "NimStuff/NimCx"):
   var (output,err) = execCMDEx("./docx")
   echo output
   if $err <> "0":
      echo err
   
printLn("Please wait a moment , trying to use nimble to install")
sleepy(5)
(output,err) = execCMDEx("nimble install nimcx -y")
echo output
if $err <> "0":  echo err
      
doFinish()
