import nimcx

## cxnetwork.nim
## network info wan,local and more
## linux only tested on debian,opensuse and mint
## still to implement wifi neighbourhood
## 2018-02-23

printLnInfoMsg("cxnetwork  ","Network Information Center")
decho()

var maxpadlen = 0
proc getmaxpadlen(s:string) :int  {.discardable.} =
     for ss in 0..<s.len:
        # scan for max len which will be the max width of the help
        # but need to limit it to within tw
        if maxpadlen < s.len: 
               maxpadlen = s.len
     result = maxpadlen
 
  
proc cxpad(s:string,padlen:int):string =
  result = s
  if s.len < padlen : 
     result = s & spaces(max(0, padlen - s.len)) 
     
    
proc iproute():string =
 result = execCmdEx("ip route show all").output

 
proc iproutedev():string =
  # just get the device name
  var r1 = execCmdEx("ip route show all").output
  var r2 = r1.splitty("dev")
  var r3 = r2[1]
  var r4 = r3.split(" ")
  result = r4[1]

proc neighbours():string =   
   result = execCmdEx("ip n show dev " & iproutedev()).output
  

let wanip = getwanip()
var jj = getIpInfo(wanip)

var xpadlen = 0    # left
var ypadlen = 0    # right side of the getipinfo data width , used for nicer formatting here throughout
for x,y in mpairs(jj):
    xpadlen = getmaxpadlen(x)

# running this 2 times for left and right side    
for x,y in mpairs(jj):
    ypadlen = getmaxpadlen(jj[x].getstr)    

decho(2)
printLnInfoMsg("Provider   " , cxpad("Internet Data",ypadlen),palegreen) 
for x,y in mpairs(jj):
    printLnInfoMsg(cxpad(x,xpadlen),cxpad(jj[x].getstr,ypadlen))
 

let lp = localIp()
let lr = localRouterIp().strip()
let ipd = iproutedev()


decho(2)
printLnInfoMsg("Connections" , cxpad("Network TCP/UDP Connections",ypadlen))
cxPortCheck()

decho(2)
printLnInfoMsg("Network    " , cxpad("Local Network Neighbourhood",ypadlen))
echo neighbours()

decho(2)
printLnInfoMsg("IP Data    " , cxpad("IP Address Informatiom",ypadlen))
printLnInfoMsg("WANIP      " , cxpad(wanip,ypadlen),palegreen)
printLnInfoMsg("Local Ip   " , cxpad(lp,ypadlen),thistle)
printLnInfoMsg("Router     " , cxpad(lr,ypadlen),snow)
printLnInfoMsg("Device     " , cxpad(ipd,ypadlen),skyblue)
echo()

infoline()
echo()
quit 0
